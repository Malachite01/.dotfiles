return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Définir les linters par type de fichier
		-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
		lint.linters_by_ft = {
			-- JavaScript / TypeScript
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			vue = { "eslint_d" },

			-- Python
			python = { "flake8" },

			-- Bash / Shell
			sh = { "shellcheck" },
			bash = { "shellcheck" },

			-- Markdown
			markdown = { "markdownlint" },

			-- YAML
			yaml = { "yamllint" },

			-- JSON
			json = { "jsonlint" },

			-- Docker
			dockerfile = { "hadolint" },
		}

		-- Créer un autocommand pour lancer les linters
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Ne lancer que si le fichier existe
				if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
					lint.try_lint()
				end
			end,
		})

		-- Commande pour lancer manuellement le linting
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
