return {
  {
    -- PyCharm-style "N usages" hint above functions, from LSP references.
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = function()
      -- Test functions and Go's main are entry points, never called from code; skip them.
      local function not_entry_point(data)
        local name = data.symbol.name
        if name:match('^test') or name:match('^Test') or name:match('^Benchmark') then return false end
        return not (name == 'main' and vim.bo[data.bufnr].filetype == 'go')
      end
      local kind = vim.lsp.protocol.SymbolKind

      return {
        kinds_filter = { [kind.Function] = { not_entry_point }, [kind.Method] = { not_entry_point } },
        vt_position = 'above',
        request_pending_text = false, -- don't flash "loading..." while counting
        text_format = function(symbol)
          local n = symbol.references
          if not n then return '' end
          if n == 0 then return 'no usages' end
          return n == 1 and '1 usage' or (n .. ' usages')
        end,
      }
    end,
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
