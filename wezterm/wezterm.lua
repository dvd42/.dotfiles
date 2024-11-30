local wezterm = require 'wezterm'
local act = wezterm.action

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
local scheme = wezterm.get_builtin_color_schemes()['Dawn (terminal.sexy)']
scheme.background = '#18191a'

config.color_schemes = {
  ['Dawn'] = scheme
}
config.color_scheme = 'Dawn'

config.keys = {
}
config.font = wezterm.font "FiraMono Nerd font", {weight="Light", stretch="Normal", style="Normal"}
config.colors = {cursor_bg = 'rgba(100, 100, 100, 0)', cursor_fg = 'rgba(100, 100, 100, 0)'}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.periodic_save()

local resurrect_event_listeners = {
  "resurrect.error",
  "resurrect.save_state.finished",
}

local is_periodic_save = false
wezterm.on("resurrect.periodic_save", function()
  is_periodic_save = true
end)
for _, event in ipairs(resurrect_event_listeners) do
  wezterm.on(event, function(...)
    if event == "resurrect.save_state.finished" and is_periodic_save then
      is_periodic_save = false
      return
    end
    local args = { ... }
    local msg = event
    for _, v in ipairs(args) do
      msg = msg .. " " .. tostring(v)
    end
    wezterm.gui.gui_windows()[1]:toast_notification("Wezterm - resurrect", msg, nil, 4000)
  end)
end

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = wezterm.action.Multiple({
      wezterm.action_callback(function(win, pane)
	resurrect.fuzzy_load(win, pane, function(id, label)
	  id = string.match(id, "([^/]+)$")
	  id = string.match(id, "(.+)%..+$")
	  local state = resurrect.load_state(id, "workspace")
	  resurrect.workspace_state.restore_workspace(state, {
	    relative = true,
	    restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	  })
	end)
      end),
    }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.Multiple({
    wezterm.action_callback(function(win, pane)
        resurrect.save_state(resurrect.workspace_state.get_workspace_state())
    end),
    }),
  },
  -- splitting
  {
    mods   = "LEADER",
    key    = "p",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "v",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },  
  {
    mods = 'LEADER',
    key = 'z',
    action = wezterm.action.TogglePaneZoomState
  },
  {
    mods = "LEADER",
    key = "Space",
    action = wezterm.action.RotatePanes "Clockwise"
  },
  {
    key = 'y',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode
  },
  {
    key = 'f',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = '/',
    mods = 'LEADER',
    action = wezterm.action.Search { CaseSensitiveString = '' },
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
        local pos = pane:get_cursor_position()
        local dims = pane:get_dimensions()
        local move_viewport_to_scrollback = string.rep('\r\n', pos.y - dims.physical_top)
        pane:inject_output(move_viewport_to_scrollback)
        pane:send_text('\x0c') -- CTRL-L

    end)
  },
  -- Prompt for a name to use for a new workspace and switch to it.
  {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {
    key = 'm',
    mods = 'CTRL|SHIFT',
    action = act.SwitchToWorkspace {
      name = 'monitoring',
      spawn = {
        args = { '/opt/homebrew/bin/htop' },
      },
    },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  {
    key = 'q',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },

}
config.skip_close_confirmation_for_processes_named = {}

local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local updated_keys = {
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
}

for _, key in ipairs(updated_keys) do
  table.insert(config.keys, key)
end

if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    search = wezterm.gui.default_key_tables().search_mode
    table.insert(copy_mode,
      { 
          key = 'q', 
          mods = 'NONE', 
          action = act.Multiple {
              { CopyMode = 'Close'},
              act.ClearSelection,
              { CopyMode = 'MoveToScrollbackBottom'},
          },
     })

     table.insert(search,
     { 
          key = 'Enter', 
          mods = 'NONE',
          action = act.Multiple {
              { CopyMode = 'ClearPattern'},
              { CopyMode = 'Close'},
         }
    })

end

config.key_tables = {
  copy_mode = copy_mode,
  search_mode = search,
}

config.scrollback_lines = 10000
config.enable_scroll_bar = true


return config
