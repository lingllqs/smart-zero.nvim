local M = {}

function M.smart_move()
	local win = 0

	-- 光标位置（row: 1-based, col: 0-based byte）
	local row, col = unpack(vim.api.nvim_win_get_cursor(win))
	local line = vim.api.nvim_get_current_line() -- 获取行内容

	-- 当前显示列（1-based）
	local vcol = vim.fn.wincol()

	-- 行显示宽度（$ 的真实位置）
	local width = vim.fn.strdisplaywidth(line) -- cell width

	-- 第一个非空白字符（byte index, 0-based）
	local indent = vim.fn.match(line, "\\S")
	if indent < 0 then
		indent = 0
	end

	local target_col

	if vcol == 1 then -- 当前光标在第一列
		if indent > 0 then
			target_col = indent
		else
			target_col = #line
		end
	elseif vcol < width then
        if vcol < indent then
            target_col = indent
        else
            target_col = #line
        end
	else
		target_col = 0
	end

	vim.api.nvim_win_set_cursor(win, { row, target_col })
end

return M
