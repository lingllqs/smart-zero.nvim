function smart_move()
  local win = 0 -- 当前窗口
  local row, col = unpack(vim.api.nvim_win_get_cursor(win)) -- 行，列
  local line = vim.api.nvim_get_current_line() -- 当前行文本内容

  local line_len = #line -- 当前行长度
  local first_col = 0 -- 行首
  local last_col = math.max(line_len - 1, 0) -- 行末

  -- 第一个非空白字符（0-based）
  local indent = vim.fn.match(line, "\\S") -- 第一个非空字符下标，没有找到返回-1
  if indent == -1 then
    indent = first_col
  end

  local target_col

  if col == first_col then -- 当前光标位于行首 → 跳到 ^（或 $）
    target_col = (indent > first_col) and indent or last_col

  elseif col < last_col then -- 当前光标位于中间 → 跳到 $
    target_col = last_col

  else -- 当前光标在行末 → 回到 0
    target_col = first_col
  end

  -- 设置光标位置
  vim.api.nvim_win_set_cursor(win, { row, target_col })
end
