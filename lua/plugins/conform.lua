return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				fish = { "fish_indent" },
				json = { "prettierd", "prettier", stop_after_first = true },
				kotlin = { "ktlint" },
				lua = { "stylua" },
				sh = { "shfmt" },
				sql = { "sqlfluff" },
				tex = { "latexindent" },
				toml = { "taplo" },
				yaml = { "prettierd" },
				zig = { "zigfmt" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
