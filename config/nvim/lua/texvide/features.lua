-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local last_position = vim.fn.line("'\"")
        if last_position > 0 and last_position <= vim.fn.line("$") then
            vim.cmd("normal! g`\"")
        end
    end,
})
