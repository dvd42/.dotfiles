require("gitlinker").setup({
  router = {
    -- Force GitHub "default_branch" router to always use main
    default_branch = {
      ["^github%.com"] = "https://github.com/{_A.ORG}/{_A.REPO}/blob/main/{_A.FILE}"
        .. "#L{_A.LSTART}"
        .. "{_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or ''}",
    },
  },
})
