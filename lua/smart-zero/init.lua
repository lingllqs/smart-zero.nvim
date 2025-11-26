-- lua/cycle-zero/init.lua
local M = {}

-- 存储每行的关键位置
local position_cache = {}

-- 获取当前行的三个关键位置：行首(0)、第一个非空字符(^)、行尾($)
local function get_line_positions(line_num)
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
    if not line then
        -- 空行时，三个位置都为1（1-indexed）
        return {1, 1, #line + 1}
    end

    -- 位置1：行首（始终是1）
    local pos1 = 1

    -- 位置2：第一个非空字符
    local pos2 = 1
    for i = 1, #line do
        if line:sub(i, i) ~= ' ' and line:sub(i, i) ~= '\t' then
            pos2 = i
            break
        end
    end

    -- 位置3：行尾
    local pos3 = #line + 1  -- Vim中行尾位置是字符串长度+1

    return {pos1, pos2, pos3}
end

-- 获取当前行的三个位置
local function get_current_line_positions()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    if not position_cache[current_line] then
        position_cache[current_line] = get_line_positions(current_line)
    end
    return position_cache[current_line]
end

-- 清除位置缓存
local function clear_cache()
    position_cache = {}
end

-- 获取下一个位置
local function get_next_position(positions, current_col)
    -- current_col 是0-indexed的，需要转换为1-indexed
    local col_1indexed = current_col + 1

    -- 检查当前位置是否正好在三个位置之一
    for i, pos in ipairs(positions) do
        if pos == col_1indexed then
            -- 返回下一个位置，循环到第一个
            local next_idx = (i % 3) + 1
            return positions[next_idx]
        end
    end

    -- 如果不在三个位置上，找到最近的下一个位置
    -- 首先按顺序排列三个位置
    table.sort(positions)
    
    for i, pos in ipairs(positions) do
        if pos > col_1indexed then
            return pos
        end
    end

    -- 如果所有位置都在当前列之前，返回第一个位置
    table.sort(positions)  -- 重新排序
    return positions[1]
end

-- 主要功能函数：实现0、^、$之间的循环跳转
function M.cycle_zero()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_col = vim.api.nvim_win_get_cursor(0)[2]

    local positions = get_current_line_positions()
    -- 重新排序以确保顺序是：行首、第一个非空字符、行尾
    local sorted_positions = {positions[1], positions[2], positions[3]}
    table.sort(sorted_positions)
    
    local next_pos = get_next_position(sorted_positions, current_col)

    -- 移动光标到下一个位置（需要转换为0-indexed）
    vim.api.nvim_win_set_cursor(0, {current_line, next_pos - 1})
end

-- 设置插件配置
function M.setup(opts)
    opts = opts or {}
    
    -- 清除缓存的选项
    local clear_cache_on = opts.clear_cache_on or {"BufEnter", "BufWritePost"}
    
    -- 设置按键映射
    vim.keymap.set("n", "0", M.cycle_zero, {desc = "Cycle between 0, ^, and $ positions"})
    vim.keymap.set("x", "0", M.cycle_zero, {desc = "Cycle between 0, ^, and $ positions"})
    vim.keymap.set("o", "0", M.cycle_zero, {desc = "Cycle between 0, ^, and $ positions"})
    
    -- 设置清除缓存的自动命令
    for _, event in ipairs(clear_cache_on) do
        vim.api.nvim_create_autocmd(event, {
            callback = clear_cache,
        })
    end
end

return M
