return {
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
			})
		end,
	},

	-- Plugin pour auto-fermer tags HTML/JSX
	{
		"windwp/nvim-ts-autotag",
		after = "nvim-treesitter", -- chargé après Treesitter
	},

	-- ts_context_commentstring
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = false,
		config = function()
			vim.g.skip_ts_context_commentstring_module = true
			require("ts_context_commentstring").setup({
				enable = true,
				enable_autocmd = false,
			})
		end,
	},
}
