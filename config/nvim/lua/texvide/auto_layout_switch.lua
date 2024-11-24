-- -- Function to switch to a specific layout
-- local function switch_layout(layout)
--     vim.fn.system("xkb-switch -s " .. layout)
-- end

-- -- Function to get the current keyboard layout
-- local function check_layout()
--     return vim.fn.system("xkb-switch -p"):gsub("%s+", "")
-- end

-- -- Function to check if we are in a LaTeX math zone
-- local function is_in_mathzone()
--     return vim.fn["vimtex#syntax#in_mathzone"]()
-- end

-- -- Variable to store the last used keyboard layout outside of math mode
-- local remembered_layout = check_layout()
-- -- Variable to store the previous math zone status
-- local previous_zone = is_in_mathzone()

-- -- Function to check and switch layouts based on math zone
-- local function check_and_switch_layout()
--     local in_mathzone = is_in_mathzone()

--     if in_mathzone ~= previous_zone then
--         if in_mathzone == 1 then
--             -- Entered math zone
--             if check_layout() ~= "us" then
--                 switch_layout("us")
--                 vim.notify("Switched to US layout", vim.log.levels.INFO)
--             end
--         else
--             -- Exited math zone
--             if check_layout() == "us" then
--                 switch_layout(remembered_layout)
--                 vim.notify("Switched to remembered layout: " .. remembered_layout, vim.log.levels.INFO)
--             end
--         end
--     end
--     if in_mathzone == 0 then
--         -- Not in math zone, update remembered_layout
--         remembered_layout = check_layout()
--     end
--     previous_zone = in_mathzone
-- end

-- -- Auto command to check layout when editing .tex files only
-- vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMoved", "CursorMovedI", "TextChangedI", "TextChanged" }, {
--     pattern = "*.tex", -- Restrict to .tex files
--     callback = function()
--         check_and_switch_layout()
--     end,
-- })

