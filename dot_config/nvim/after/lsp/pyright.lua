return {
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff
    },
    python = {
      analysis = {
        indexing = true,
        autoSearchPaths = true,
        -- diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
