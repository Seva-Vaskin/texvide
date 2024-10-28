require('texvide.plugins')

local function is_colorscheme_exists(colorscheme)
    local paths = vim.api.nvim_get_runtime_file("colors/" .. colorscheme .. ".vim", false)
    return #paths > 0
end

local colorscheme = "catppuccin-frappe"
if is_colorscheme_exists(colorscheme) then
  vim.cmd("colorscheme " .. colorscheme)
end
