local M = {}

function M.setup()
    local first = 1
    local head = vim.fn.getline('.') - vim.fn.substitute(vim.fn.getline('.'), '^\\s*', '', 'G') + 1
    local before = vim.fn.col('.')
    vim.fn.execute(before == first and first ~= head and 'norm! ^' or 'norm! $')
    local after = vim.fn.col('.')
    if before == after then
        vim.fn.execute('norm! 0')
    end
end

return M
