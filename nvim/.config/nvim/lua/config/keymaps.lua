local builtin = require("telescope.builtin")

-- Telescope
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Neo-tree
vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal left<CR>", { desc = "Neo-tree reveal" })
vim.keymap.set("n", "<C-S-e>", ":Neotree filesystem close left<CR>", { desc = "Neo-tree close" })

-- Lsp-config (dans lsp-config a la fin)

-- Conform pour auto formating (dans conform.lua)

-- Completions nvim (dans completions.lua)
