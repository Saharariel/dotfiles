return {
  -- Install colorschemes
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },

  {
    "LazyVim/LazyVim",
    opts = function()
      local hostname = vim.fn.hostname()
      local colorscheme = "rose-pine" -- default for work and everything else

      if hostname == "LAP221.local" then
        colorscheme = "kanagawa-dragon"
      end

      return {
        colorscheme = colorscheme,
      }
    end,
  },
}
