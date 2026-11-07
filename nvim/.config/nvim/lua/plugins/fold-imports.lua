return {
  {
    -- Auto-folds import blocks on open (like PyCharm / VS Code), via treesitter.
    'dmtrKovalenko/fold-imports.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    -- fold-imports finds imports with treesitter, so each language needs its parser.
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'typescript', 'tsx', 'javascript', 'go', 'rust', 'c', 'cpp' } },
    -- Every spec adding parsers must declare this; lazy only extends lists at levels that see it.
    opts_extend = { 'ensure_installed' },
  },
}
