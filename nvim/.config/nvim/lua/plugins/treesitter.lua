return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    opts = { ensure_installed = {} },
    opts_extend = { 'ensure_installed' },
    config = function(_, opts)
      local treesitter = require('nvim-treesitter')
      local installed = treesitter.get_installed()
      local missing = vim.tbl_filter(function(parser)
        return not vim.list_contains(installed, parser)
      end, opts.ensure_installed)

      if #missing > 0 then
        local ok, installed_missing = pcall(function()
          return treesitter.install(missing):wait(300000)
        end)
        if not ok or not installed_missing then
          vim.notify('Failed to install Tree-sitter parsers: ' .. table.concat(missing, ', '), vim.log.levels.ERROR)
        end
      end

      local group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = opts.ensure_installed,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
