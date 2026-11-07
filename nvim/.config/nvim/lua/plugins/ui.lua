return {
  {
    'folke/which-key.nvim',
    lazy = false,
    opts = {
      -- popup that shows what my leader keys do
      spec = {
        { '<leader>t', group = 'Tests' },
        { '<leader>x', group = 'Debug' },
      },
    },
  },
  {
    -- Status bar: mode, git branch, diagnostics, file, LSP, position.
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { globalstatus = true },
      sections = {
        lualine_x = {
          {
            function()
              local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
              return table.concat(names, ' ')
            end,
          },
          'filetype',
        },
      },
    },
  },
  {
    -- Breadcrumbs: file › class › function in the winbar, clickable.
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
