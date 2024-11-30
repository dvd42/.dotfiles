local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local buttonhl = function(shortcut, text, command, hl)
    local button = dashboard.button(shortcut, text, command)
    button.opts.hl_shortcut = hl
    return button
end

dashboard.section.header.opts.hl = "Function"

-- Set header
dashboard.section.header.val = {
[[                                                                                                                        ]],
	[[                                                                       .:=:                                             ]],
	[[                                                  ......::::::::::. .:::@.                                              ]],
	[[                                        ...:::::::.......     .. @=:.  =:                                               ]],
	[[                                 ..::::....                    . ..:: :=                                                ]],
	[[                           ..::::..                          .   :#@  *                                                 ]],
	[[                      .:::::..                               .   =@+ .+                                                 ]],
	[[                  .::::.                 .. .............      .. #+ :=                                                 ]],
	[[              .::::.        .....::::::::::::::::::.....::::::.=- =# .*:............::                                  ]],
	[[            :-:..    ...:::....                                -- =@ .+  ---------:  *.                                 ]],
	[[         :::. ...:-=-*:    .                                   +: +*  @: -@@@@@@@@. +.                                  ]],
	[[       :-:...::.:-:. .-:::::-.                         :=     .@. @+ .#*  +@@@@@@: =:                                   ]],
	[[     :+=:..   .:...=*: ..::. :-                       --=-    -= :@- +-:= :@@@@@+ := .-+:.:::::::.:=+=:.:::::::.:*-     ]],
	[[    .:.     ::..:*@@*@#: :*@-. ::................:: .=.  *:  .@. ## :@  +. *@@@@: #    :=. -==== .=: .=: :====  =:      ]],
	[[          :*: :#=:*@-.-@+. :#@-..::::::::::::::: -#-- .= .#  *. =@: #:  := :@@@= -:     .*  #@@: *:   .@ .@@@: --       ]],
	[[           .:-..  *@-  .=@=. :@@@+-------------: :#: -@@- :+=. =@: =-    # .@@@: #       -: +@@. @.   .@  #@@. @.       ]],
	[[              :=. *@-    .+@=. :@*:              :..+@=*@: :. +@: -+     @. @@@ .@      .-. +@@. @    .@  #@@. @.       ]],
	[[               *: *@=      :*@-..-@+:             -@*. :@#. :@*::..::::::- .@@@..=::::::... +@@ .@.   .@  #@@. @.       ]],
	[[               +: *@=        :#@- .=@=.         .+@-    -@+-@+  *@*=-::::::+@@@+:::::::-=@: +@@  :::::::  @@@. @        ]],
	[[               +: *@=          :##:..=@=. ..   -@@-      =@@=   =@@@@@@@@@@@@@@@@@@@@@@@@@: +@@=---=======@@@  @        ]],
	[[               +: *@=           =@@- .*@#=+=..+@+##:     =@@:   *+-::..::..+@@@=..:::::-+@: *@@-::--::-::=@@@ .@        ]],
	[[               +: *@=         :@#:..=@+:    :@@:  -@@:  -@@@#.  ...:::..:+ :@@#  +:.::::... #@# .=:::::= .@@@ .@        ]],
	[[               =: +@=      .-@*:..=@+:    .=@=.     -@@=@@::@+  +:      .@ :@@# .#      .=. @@* .#    .@ .@@# .@        ]],
	[[               =: +@=    .-@+: .=@+.     :@@:         -@@@. =@= -=      -= =@@@ .@       #. @@* :+    .@ .@@@ .@        ]],
	[[               =- +@+  .=@+: :=@=.     .=@=.           @@@@-:#@: +:     #. #@@@: #.      *  @@* :+    .@ .@@# :@        ]],
	[[               =- +@+.=@=..:+@#:      :@@=.            @@+-@@@@#. @.   := :@@@@= --      *  @@+ :=    .@ .@@* :#        ]],
	[[               == +@@@=. :=*++++++*+##@#+==++++=       =@#. :*@@+ :*   @. *@@@@@. @.    .+ .@@+ :*    :* :@@# .@        ]],
	[[             .-: .*@+. .:::::::::. -@@- ::::::::....:: .@@=  .:*@- -- =: -@@@@@@= :=   .=. +@@@: --  .=. =@@@= :-       ]],
	[[           .-:..=@@@= --..   .=#. :#*. -=.....       :+ -@@= .. :#: ++= :@@@@@@@@: -: :+. ::::::. :===. .:::::. -=.     ]],
	[[         .-: :+@-.++: =-      ::::....+:              :- =@@- -=. : .@. ::::::::::  @::::::::::::::::::::::::::::::     ]],
	[[       :-. :+@-.. ..:-:           ..:-                 =: *@@- =*-.  :*:...........::                                   ]],
	[[     :-..:#@:..=+.::.                                  .# :@@@. *.:-. =-                                                ]],
	[[   :=. :@#:..:.==.                                      +: *@@+ :=  :-:@.                                               ]],
	[[   .-: ::.::.                                           -- +@@@: #.   :+@                                               ]],
	[[     .=:::.                                             -- =@@@= =-     :=                                              ]],
	[[       ..                                               +: *@@@= -=                                                     ]],
	[[                                                        @  #@@@= =-                                                     ]],
	[[                                                       :#..::::..@.                                                     ]],
	[[                                                        .....:::::                                                      ]],
	[[                                                                                                                        ]],
}

user_config = require("nvim-possession.config")

local last_session = function()
    local sessions_path = user_config.sessions.sessions_path

    local latest_file = nil
    local latest_mod_time = nil

    -- Iterate over each file in the sessions directory
    for file in vim.fs.dir(sessions_path) do
        local filepath = sessions_path .. file -- construct full file path
        local attr = vim.loop.fs_stat(filepath) -- retrieve file stats
   
        if attr then
            -- Check modification time and replace if this file is newer
            if not latest_mod_time or attr.mtime.sec > latest_mod_time then
                latest_mod_time = attr.mtime.sec
                latest_file = filepath
            end
        end
    end

    -- Return the path of the latest modified session file
    return latest_file
end

-- -- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New File" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find File", ":Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent Files"   , ":Telescope oldfiles<CR>"),
}
local session = last_session()
local filename = vim.api.nvim_call_function('fnamemodify', {session, ':t'})
table.insert(dashboard.section.buttons.val, dashboard.button("s", string.format("📌 %s", filename), ":LoadSession " .. filename .. "<CR>"))


vim.api.nvim_create_user_command(
    'LoadSession',
    function(opts)

    local sessions_path = user_config.sessions.sessions_path
    if not sessions_path:sub(-1) == "/" then
        sessions_path = sessions_path .. "/"
    end
    vim.cmd(string.format("silent! source %s%s", sessions_path, opts.args))
    vim.g[user_config.sessions.sessions_variable] = vim.fs.basename(opts.args)

    end,
    { nargs = 1 }
)

local fortune = require("alpha.fortune") 
dashboard.section.footer.val = fortune()

-- -- -- Send config to alpha
alpha.setup(dashboard.opts)
