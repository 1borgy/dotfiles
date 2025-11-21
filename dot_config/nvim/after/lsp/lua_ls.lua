return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      semantic = { enable = false },
      -- prefer stylua
      format = { enable = false },
      completion = { callSnippet = "Replace" },
      doc = { privateName = { "^_" } },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
}
