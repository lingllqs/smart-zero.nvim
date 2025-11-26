if vim.g.loaded_smartzero then
  return
end
vim.g.loaded_smartzero = true

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if not vim.g.smartzero_setup_called then
      require("smart-zero").setup()
    end
  end,
})
