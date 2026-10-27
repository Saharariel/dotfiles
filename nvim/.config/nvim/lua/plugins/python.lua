return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              -- Ruff owns import sorting and overlapping lint diagnostics.
              disableOrganizeImports = true,
              analysis = {
                diagnosticSeverityOverrides = {
                  reportUnusedImport = 'none',
                  reportUnusedVariable = 'none',
                },
              },
            },
          },
        },
        ruff = {
          on_attach = function(client)
            -- BasedPyright provides richer type-aware hover information.
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'python' } },
  },
}
