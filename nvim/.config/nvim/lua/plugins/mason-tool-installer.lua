return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- LSP
			"lua-language-server",
			"typescript-language-server",
			"html-lsp",
			"css-lsp",
			"clangd",
			"pyright",
			"bash-language-server",
			"json-lsp",
			"yaml-language-server",
			"marksman",

			-- Formatters
			"stylua", -- Lua
			"prettier", -- JS/TS/HTML/CSS/JSON/YAML/Markdown
			"black", -- Python
			"shfmt", -- Bash/Shell
			"clang-format", -- C/C++
			"taplo",
			-- "gofumpt", -- Go
			-- "goimports", -- Go
			"rustfmt", -- Rust

			-- Linters
			"eslint_d", -- JS/TS (plus rapide que eslint)
			"flake8", -- Python
			"shellcheck", -- Bash/Shell
			"markdownlint", -- Markdown
			"yamllint", -- YAML
			"hadolint", -- Dockerfile
			"jsonlint", -- JSON
		},
		auto_update = true,
		run_on_start = true,
	},
}
