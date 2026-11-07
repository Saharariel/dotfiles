return {
  {
    -- Format on save. Language files add their formatters to formatters_by_ft;
    -- anything without one falls back to its language server's formatter.
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        -- Prettier only runs when the project has it in node_modules.
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
      default_format_opts = { lsp_format = 'fallback' },
      format_on_save = { timeout_ms = 1000 },
    },
    keys = {
      { '<leader>F', function() require('conform').format({ async = true }) end, mode = { 'n', 'x' }, desc = 'Format' },
    },
  },
}
