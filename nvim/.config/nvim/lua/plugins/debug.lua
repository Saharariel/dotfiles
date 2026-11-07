return {
  {
    -- Debugger. Language files add their adapters (see python.lua).
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'igorlfs/nvim-dap-view', opts = { auto_toggle = true } }, -- panels for scopes, watches, stack
    },
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<S-F5>', function() require('dap').terminate() end, desc = 'Debug: Stop' },
      { '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<S-F11>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>xb', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      {
        '<leader>xB',
        function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end,
        desc = 'Conditional Breakpoint',
      },
      { '<leader>xc', function() require('dap').continue() end, desc = 'Start/Continue' },
      { '<leader>xl', function() require('dap').run_last() end, desc = 'Run Last' },
      { '<leader>xv', '<cmd>DapViewToggle<cr>', desc = 'Toggle Debug View' },
      { '<leader>xq', function() require('dap').terminate() end, desc = 'Stop' },
    },
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'Visual' })
    end,
  },
}
