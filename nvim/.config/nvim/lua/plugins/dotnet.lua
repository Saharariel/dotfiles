return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    config = function()
      require("roslyn").setup({
        -- This will automatically download the Roslyn LSP if not found
        args = {
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        },
      })
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local dotnet = require("easy-dotnet")
      dotnet.setup()

      -- Keybindings for your Jellyfin workflow
      vim.keymap.set("n", "<leader>db", function()
        dotnet.build()
      end, { desc = ".NET Build" })
      vim.keymap.set("n", "<leader>dr", function()
        dotnet.run()
      end, { desc = ".NET Run" })
      vim.keymap.set("n", "<leader>dt", function()
        dotnet.test()
      end, { desc = ".NET Test" })
    end,
  },
}
