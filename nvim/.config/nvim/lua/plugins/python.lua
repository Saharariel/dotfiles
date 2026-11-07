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
                -- A type after every assignment is noise; keep argument names and return types.
                inlayHints = { variableTypes = false },
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
    opts_extend = { 'ensure_installed' },
  },
  {
    'stevearc/conform.nvim',
    -- Ruff formats with the project's own ruff config (Black-compatible by default).
    opts = { formatters_by_ft = { python = { 'ruff_format' } } },
  },
  {
    -- Debug adapter; runs the project's .venv / $VIRTUAL_ENV interpreter.
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'mfussenegger/nvim-dap-python',
        config = function()
          -- Mason's debugpy adapter; the debuggee still runs in the project's venv.
          local ok, pkg = pcall(function() return require('mason-registry').get_package('debugpy') end)
          if ok and not pkg:is_installed() and not pkg:is_installing() then
            pkg:install()
          end
          require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/bin/debugpy-adapter')
        end,
      },
    },
  },
  {
    'nvim-neotest/neotest',
    dependencies = { 'nvim-neotest/neotest-python' },
    opts = {
      adapters = {
        ['neotest-python'] = { runner = 'pytest', dap = { justMyCode = false } },
      },
    },
  },
  {
    -- Pick the interpreter (venv) basedpyright and the debugger use.
    'linux-cultist/venv-selector.nvim',
    ft = 'python',
    opts = { options = { picker = 'snacks' } },
    keys = { { '<leader>v', '<cmd>VenvSelect<cr>', desc = 'Select Python Venv' } },
  },
}
