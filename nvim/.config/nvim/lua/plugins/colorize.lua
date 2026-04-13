return {
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*", -- tous les filetypes
			}, {
				RGB = true, -- #RGB
				RRGGBB = true, -- #RRGGBB
				RRGGBBAA = true, -- #RRGGBBAA
				names = true, -- Blue, Red, etc
				rgb_fn = true, -- rgb() / rgba()
				hsl_fn = true, -- hsl() / hsla()
				css = true, -- tout CSS
				css_fn = true, -- toutes les fonctions CSS
				mode = "background", -- fond coloré (le plus lisible)
			})
		end,
	},
}
