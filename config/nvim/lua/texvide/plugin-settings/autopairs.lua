local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
    check_ts = true, -- Enable treesitter integration (if available)
    fast_wrap = {},
})

-- Add a custom rule for `$`
npairs.add_rules({
    Rule("$", "$", { "tex", "markdown", "latex" }) -- Adjust for specific filetypes if needed
        :with_pair(function(opts)
            local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
            return prev_char:match("%w") ~= nil -- Ensure it's only paired after a word character
        end)
        :with_move(function(opts)
            return opts.prev_char:match(".%$") ~= nil
        end)
        :use_key("$") -- Make `$` behave predictably
})

