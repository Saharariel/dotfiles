return {
  {
    -- PyCharm-style "N usages" hint above functions, from LSP references.
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = {
      vt_position = 'above',
      request_pending_text = false, -- don't flash "loading..." while counting
      text_format = function(symbol)
        local n = symbol.references
        if not n then return '' end
        if n == 0 then return 'no usages' end
        return n == 1 and '1 usage' or (n .. ' usages')
      end,
    },
    config = function(_, opts)
      require('symbol-usage').setup(opts)
      -- The plugin waits a hardcoded 500ms after every LspAttach before counting, which is
      -- pure delay once the server is warm. attach_buffer is idempotent, so attaching right
      -- away is safe: the delayed call becomes a no-op. pcall keeps the default behavior if
      -- this internal module ever changes.
      local function attach(buf)
        pcall(require('symbol-usage.buf').attach_buffer, buf)
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('SymbolUsageFastAttach', { clear = true }),
        callback = function(args) attach(args.buf) end,
      })
    end,
  },
}
