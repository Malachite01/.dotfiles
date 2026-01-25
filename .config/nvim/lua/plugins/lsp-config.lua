return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- Installation automatique des LSP pour les nouveaux langages
			automatic_installation = true,
		},
	},

	{
		"folke/neodev.nvim",
		opts = {},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local servers = {
				lua_ls = {
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				ts_ls = { capabilities = capabilities },
				html = { capabilities = capabilities },
				cssls = { capabilities = capabilities },
				clangd = { capabilities = capabilities },
				pyright = {
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				},
				bashls = { capabilities = capabilities },
				jsonls = { capabilities = capabilities },
				yamlls = { capabilities = capabilities },
				marksman = { capabilities = capabilities },
			}

			for name, opts in pairs(servers) do
				vim.lsp.config(name, opts)
			end

			vim.lsp.enable(vim.tbl_keys(servers))

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})
		end,
	},
}
