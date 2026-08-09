return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = { preset = 'default' },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { 'saghen/blink.cmp' },
    opts = { servers = {} },
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = require('blink.cmp').get_lsp_capabilities(server_opts.capabilities)
        vim.lsp.config(server, server_opts)
      end
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    lazy = false,
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = {
      ensure_installed = {},
      automatic_enable = {},
    },
    opts_extend = { 'ensure_installed', 'automatic_enable' },
  },
}
