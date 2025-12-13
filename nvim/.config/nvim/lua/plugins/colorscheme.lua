return {
  -- Install colorschemes
  { "rose-pine/neovim", name = "rose-pine" },
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to use one
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
