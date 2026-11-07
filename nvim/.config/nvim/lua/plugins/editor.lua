return {
  {
    -- Auto-close brackets and quotes.
    'nvim-mini/mini.pairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    -- Sticky lines: keep the enclosing class/function header pinned while scrolling.
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { max_lines = 3 },
  },
  {
    -- Highlight TODO/FIXME/HACK comments and list them in the picker.
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    keys = {
      { '<leader>T', function() Snacks.picker.todo_comments() end, desc = 'TODOs' },
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
    },
  },
  {
    -- Project-wide search and replace with a live preview.
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    opts = {},
    keys = {
      {
        '<leader>R',
        function()
          local grug = require('grug-far')
          grug.open({ prefills = { search = vim.fn.expand('<cword>') } })
        end,
        desc = 'Replace in Files',
      },
      {
        '<leader>R',
        function() require('grug-far').with_visual_selection() end,
        mode = 'x',
        desc = 'Replace Selection in Files',
      },
    },
  },
  {
    -- Per-project sessions: reopen the files and layout you left.
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      { '<leader>p', function() require('persistence').load() end, desc = 'Restore Session' },
    },
  },
}
