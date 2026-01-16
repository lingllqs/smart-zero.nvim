local M = {}

local core = require("smart-zero.core")

local default_config = {
	keymap = "0",
	modes = { "n", "o", "x" },
}

function M.setup(opts)
	M.opts = vim.tbl_extend("force", default_config, opts or {})

	vim.keymap.set(M.opts.modes, M.opts.keymap, core.smart_move, { desc = "smart-zero" })
end

M.smart_move = core.smart_move

return M
