return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true, -- Utilise treesitter pour mieux comprendre le contexte
			ts_config = {
				lua = { "string" }, -- Ne pas ajouter de paires dans les strings lua
				javascript = { "template_string" },
			},
		})

		-- Intégration avec nvim-cmp
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
