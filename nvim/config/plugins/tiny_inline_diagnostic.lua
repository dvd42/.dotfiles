require("tiny-inline-diagnostic").setup({
  preset = "classic",
  transparent_bg = true,

  options = {
    show_source = { enabled = true },

    format = function(diag)
      local code = diag.code

      if not code and diag.user_data then
        if diag.user_data.lsp and diag.user_data.lsp.code then
          code = diag.user_data.lsp.code
        elseif diag.user_data.code then
          code = diag.user_data.code
        end
      end

      if code and diag.source then
        return string.format("%s [%s/%s]", diag.message, diag.source, code)
      elseif code then
        return string.format("%s [%s]", diag.message, code)
      elseif diag.source then
        return string.format("%s [%s]", diag.message, diag.source)
      else
        return diag.message
      end
    end,
  },
  hi = {
    background = "None",
  },
})
