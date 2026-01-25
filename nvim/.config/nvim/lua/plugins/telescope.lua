return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",

			-- FZF (rapide)
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

			-- UI Select (pour vim.ui.select / input)
			"nvim-telescope/telescope-ui-select.nvim",
		},

		config = function()
			local telescope = require("telescope")
			local themes = require("telescope.themes")


			-- Configuration globale
			telescope.setup({
				defaults = {
					prompt_prefix = " ",
					path_display = { "smart" },
				},

				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},

					["ui-select"] = themes.get_dropdown({
						previewer = false,
						initial_mode = "normal",
						layout_config = {
							width = 0.5,
							height = 0.4,
						},
					}),
				},
			})

			-- Charger les extensions
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
}
