local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting

local sources = {
	formatting.eslint,
	formatting.autopep8,
	formatting.stylua,
	formatting.clang_format,
	formatting.prettierd,
	-- formatting.latexindent,
}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = sources,

	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})

local callback = function()
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end
