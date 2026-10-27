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
    dependencies = {
      'saghen/blink.cmp',
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
    },
    opts = {
      servers = {
        vtsls = {}, -- JavaScript, TypeScript, JSX, and TSX.
        gopls = {},
        rust_analyzer = {},
        clangd = {}, -- C and C++.
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = require('blink.cmp').get_lsp_capabilities(server_opts.capabilities)
        vim.lsp.config(server, server_opts)
      end

      -- Use the merged server map, including language-specific plugin specs.
      local servers = vim.tbl_keys(opts.servers)
      table.sort(servers)
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_enable = servers,
      })
    end,
  },
}
