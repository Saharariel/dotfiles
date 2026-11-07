return {
  {
    -- Test runner. Language files register adapters as opts.adapters[<module>] = <config>.
    'nvim-neotest/neotest',
    dependencies = { 'nvim-neotest/nvim-nio', 'nvim-lua/plenary.nvim' },
    opts = { adapters = {} },
    config = function(_, opts)
      local adapters = {}
      for name, adapter_opts in pairs(opts.adapters) do
        table.insert(adapters, require(name)(adapter_opts))
      end
      require('neotest').setup(vim.tbl_extend('force', opts, { adapters = adapters }))
    end,
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end, desc = 'Run Nearest Test' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run File' },
      { '<leader>ta', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run All' },
      { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run Last' },
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug Nearest Test' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle Summary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Show Output' },
      { '<leader>tq', function() require('neotest').run.stop() end, desc = 'Stop' },
    },
  },
}
