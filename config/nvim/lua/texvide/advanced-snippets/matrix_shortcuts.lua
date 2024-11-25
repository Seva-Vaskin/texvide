-- Define the environments where '\\' and '&' should be appended/inserted
local target_envs = { 'pmatrix', 'cases', 'align', 'gather', 'bmatrix', 'Bmatrix', 'vmatrix', 'Vmatrix', 'array', 'matrix' }

-- Helper function to check if inside a specific environment
local function is_inside_target_env(target_envs)
    -- Use vimtex's get_inner function to get the innermost environment
    local env = vim.fn['vimtex#env#get_inner']()

    if type(env) ~= 'table' then
        return false
    end

    local name = env.name

    if not name then
        return false
    end

    -- Check if the current environment is in the target list
    for _, target in ipairs(target_envs) do
        if name == target then
            return true
        end
    end

    return false
end

-- Create an autocommand for LaTeX filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        -- Function to handle the Enter key
        local function append_backslash_and_newline()
            -- Schedule the buffer modifications to avoid E565 errors
            vim.schedule(function()
                -- Check if inside any of the target environments
                local inside_target_env = is_inside_target_env(target_envs)

                if not inside_target_env then
                    -- If not inside a target environment, perform a normal Enter
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', true)
                    return
                end

                -- Get the current cursor position
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                -- Get the content of the current line up to the cursor position
                local line_before_cursor = vim.api.nvim_get_current_line():sub(1, col)
                local line_after_cursor = vim.api.nvim_get_current_line():sub(col + 1)
                -- Trim trailing whitespace
                local trimmed_line = line_before_cursor:match("^(.-)%s*$")

                -- Check if the trimmed line already ends with '\\'
                if not trimmed_line:match("\\\\$") then
                    -- Append ' \\' to the trimmed line
                    vim.api.nvim_set_current_line(trimmed_line .. " \\\\" .. line_after_cursor)
                    -- Move the cursor to the end of the modified line
                    vim.api.nvim_win_set_cursor(0, { row, #trimmed_line + 3 }) -- +3 accounts for ' \\'
                end

                -- Insert a newline with proper indentation
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', true)
            end)
            -- Return an empty string to prevent the default behavior
            return ''
        end

        -- Function to handle the Tab key
        local function insert_ampersand()
            -- Schedule the buffer modifications to avoid E565 errors
            vim.schedule(function()
                -- Check if inside any of the target environments
                local inside_target_env = is_inside_target_env(target_envs)

                local _, col = unpack(vim.api.nvim_win_get_cursor(0))
                local line = vim.api.nvim_get_current_line()

                if not inside_target_env then
                    -- If not inside a target environment, perform a normal Tab
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
                    return
                end

                -- Insert a space if the cursor is not at the end of a word
                if not line:sub(col, col):match('%s') then
                    vim.api.nvim_feedkeys(" ", 'i', true)
                end

                -- Emulate typing '&' in insert mode to allow external plugins to process it
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("&", true, false, true), 'n', true)
            end)
            -- Return an empty string to prevent the default behavior
            return ''
        end

        -- Map the <CR> key in insert mode to the custom function
        vim.keymap.set('i', '<CR>', append_backslash_and_newline, {
            noremap = true,
            silent = true,
            buffer = true,
        })

        -- Map the <Tab> key in insert mode to the custom function
        vim.keymap.set('i', '<Tab>', insert_ampersand, {
            noremap = true,
            silent = true,
            buffer = true,
        })
    end
})
