require("minuet").setup({
  provider = "openai",
  n_completions = 3,
  cmp = {
    enable_auto_complete = false,
  },
  provider_options = {
    openai = {
      model = "gpt-4.1",
      optional = {
        max_completion_tokens = 128,
      },
    },
  },
})

