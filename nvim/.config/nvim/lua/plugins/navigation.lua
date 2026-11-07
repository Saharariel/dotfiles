return {
  {
    'stevearc/oil.nvim',
    opts = { view_options = { show_hidden = true } },
    keys = { { '<leader>e', '<cmd>Oil<cr>', desc = 'File Browser' } },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep() end,  desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>w', function() Snacks.picker.grep_word() end, desc = 'Search Word', mode = { 'n', 'x' } },
      { '<leader>/', function() Snacks.picker.lines() end, desc = 'Search Lines in File' },
      { '<leader>o', function() Snacks.picker.recent() end, desc = 'Recent Files' },
      { '<leader>r', function() Snacks.picker.resume() end, desc = 'Resume Last Picker' },
      -- LSP
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
      { 'grr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'Find Usages' },
      { 'gri', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
      { 'grt', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto Type Definition' },
      { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'File Structure' },
      { '<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Search Symbols' },
      -- Problems
      { '<leader>d', function() Snacks.picker.diagnostics() end, desc = 'Problems (Project)' },
      { '<leader>D', function() Snacks.picker.diagnostics_buffer() end, desc = 'Problems (File)' },
      -- Vim helpers
      { '<leader>u', function() Snacks.picker.undo() end, desc = 'Undo History' },
      { '<leader>k', function() Snacks.picker.keymaps() end, desc = 'Search Keymaps' },
      { '<leader>h', function() Snacks.picker.help() end, desc = 'Search Help' },
      { '<leader>c', function() Snacks.picker.commands() end, desc = 'Commands' },
    },
  },
}

