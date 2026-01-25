return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		-- Définir les formateurs par type de fichier
		formatters_by_ft = {
			-- Lua
			lua = { "stylua" },

			-- JavaScript / TypeScript / JSON / HTML / CSS / Markdown
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			less = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			["markdown. mdx"] = { "prettier" },
			graphql = { "prettier" },
			handlebars = { "prettier" },

			-- Python
			python = { "black" },

			-- Bash / Shell
			sh = { "shfmt" },
			bash = { "shfmt" },

			-- C / C++
			c = { "clang-format" },
			cpp = { "clang-format" },

			-- Go
			-- go = { "gofmt", "goimports" },

			-- Rust
			rust = { "rustfmt" },

			-- Autres
			toml = { "taplo" },
			xml = { "xmlformatter" },
		},

		-- Format automatique à la sauvegarde
		format_on_save = function(bufnr)
			-- Désactiver pour certains types de fichiers si nécessaire
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,

		-- Configuration des formateurs
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" },
			},
		},
	},
}
