return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {},
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.90,
				preview = {
					layout = "horizontal",
				},
			},
			fzf_colors = {
				true,
				bg = "-1",
				gutter = "-1",
			},
			keymap = {
				fzf = { ["ctrl-q"] = "select-all+accept" },
			},
		})
		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>pf", fzf.git_files, { desc = "Find Git Files" })
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fG", function()
			require("fzf-lua").live_grep({
				rg_opts = "--hidden --glob '!.git/*' --column --line-number --no-heading --color=always -e",
			})
		end, { desc = "Live Grep includes hidden files" })
		vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fs", function()
			fzf.grep({ search = vim.fn.input("Grep For > ") })
		end, { desc = "FZF grep with input" })
        -- find files relative to current buffer (search in lib folder...)
		vim.keymap.set("n", "<leader>fl", function()
			fzf.files({ cwd = vim.fn.expand("%:p:h"), prompt = "Find Lib Files> " })
		end, { desc = "Find Files relative to current buffer" })

        -- find text in current buffer (search in lib folder...)
		vim.keymap.set("n", "<leader>ft", function()
			fzf.live_grep({ cwd = vim.fn.expand("%:p:h"), prompt = "Live Grep Libs> " })
		end, { desc = "Live Grep relative to current buffer" })
	end,
}
