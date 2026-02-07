local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.mouse = 'a'
opt.undofile = true
opt.swapfile = false
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.termguicolors = true
opt.smartindent = true
opt.autoindent = true
vim.cmd("filetype plugin indent on")

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
    callback = function()
        if vim.bo.modified and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! wa")
        end
    end
})

local session_file = vim.fn.stdpath("config") .. "/session.vim"
local session_views_file = vim.fn.stdpath("data") .. "/session_views.lua"

local function run_in_system_term(raw_compile_cmd, mode_word)
    vim.cmd("silent! wa")
    local file_path = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local file_name_only = vim.fn.expand("%:t:r")
    local expanded_cmd = raw_compile_cmd:gsub("%%%%:t:r", file_name_only):gsub("%%%%", file_path)
    
    local bash_logic = string.format(
        "cd '%s' && echo 'g++ %s' && %s && ./'%s'; echo 'Press any key to exit!'; read -n 1",
        dir, mode_word, expanded_cmd, file_name_only
    )
    
    local system_cmd = string.format(
        "gnome-terminal --geometry=80x24-0+0 --title='Nvim Runner' -- bash -c %q &", 
        bash_logic
    )
    os.execute(system_cmd)
end

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
end

map({'n', 'i', 'v'}, '<F4>', function()
    if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
    local ok, comment = pcall(require, "Comment.api")
    if not ok then return end

    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' or mode == 'V' or mode == '\22' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
        comment.toggle.linewise(vim.fn.visualmode())
    else
        comment.toggle.linewise.current()
    end
end)

map({'n', 'i', 'v'}, '<F5>', '<esc>ggVG"+y')

map({'n', 'i', 'v'}, '<F6>', function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then 
        vim.lsp.buf.format() 
    else
        local curr_view = vim.fn.winsaveview()
        vim.cmd("normal! gg=G")
        vim.fn.winrestview(curr_view)
    end
end)

map({'n', 'i', 'v'}, '<F8>', function()
    local cmd = 'g++ -std=c++23 -Wshadow -Wall -o "%%:t:r" "%%" -O2 -Wno-unused-result'
    run_in_system_term(cmd, "-std=c++23 -Wshadow -Wall -o %%:t:r %% -O2 -Wno-unused-result optimized")
end)

map({'n', 'i', 'v'}, '<F9>', function()
    local cmd = 'g++ -std=c++23 -Wshadow -Wall -o "%%:t:r" "%%" -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG'
    run_in_system_term(cmd, "-std=c++23 -Wshadow -Wall -o %%:t:r %% -O2 -Wno-unused-result sanitized")
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "oskarnurm/koda.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme koda")
            vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then return end
            configs.setup({
                ensure_installed = { "cpp", "c", "lua", "vim", "vimdoc" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    { 
        'akinsho/bufferline.nvim', 
        dependencies = 'nvim-tree/nvim-web-devicons', 
        opts = { options = { show_close_icon = true, mouse_enabled = true } } 
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    { 
        'numToStr/Comment.nvim', 
        opts = {
            mappings = {
                basic = true,
                extra = false,
            },
        } 
    },
    { 
        'neovim/nvim-lspconfig', 
        config = function()
            if vim.lsp.config then
                vim.lsp.config('clangd', { cmd = { "clangd" } })
                vim.lsp.enable('clangd')
            else
                local ok, lspconfig = pcall(require, "lspconfig")
                if ok then lspconfig.clangd.setup({}) end
            end
        end 
    },
})

vim.cmd("syntax on")

vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertLeave"}, {
    callback = function()
        if vim.fn.expand("%") ~= "" then
            vim.b.last_view = vim.fn.winsaveview()
        end
    end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        if vim.b.last_view then
            vim.fn.winrestview(vim.b.last_view)
        end
    end
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        -- 1. Get all buffers currently shown in any window
        local visible_bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            visible_bufs[vim.api.nvim_win_get_buf(win)] = true
        end

        -- 2. Wipe any buffer that isn't currently visible so it's not saved to session
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if not visible_bufs[bufnr] and vim.api.nvim_buf_is_loaded(bufnr) then
                vim.cmd("silent! bwipeout " .. bufnr)
            end
        end

        -- 3. Save session now that the buffer list is clean
        vim.cmd("mksession! " .. session_file)
        
        local views = {}
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
                views[vim.api.nvim_buf_get_name(bufnr)] = vim.fn.winsaveview()
            end
        end
        local f = io.open(session_views_file, "w")
        if f then
            f:write("return " .. vim.inspect(views))
            f:close()
        end
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        if vim.fn.argc() == 0 and vim.fn.filereadable(session_file) == 1 then
            vim.cmd("silent! source " .. session_file)
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(bufnr)
                if vim.api.nvim_buf_is_loaded(bufnr) and name ~= "" then
                    vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd("silent! e!")
                    end)
                end
            end
        end
        if vim.fn.filereadable(session_views_file) == 1 then
            local ok, views = pcall(dofile, session_views_file)
            if ok and type(views) == "table" then
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    local name = vim.api.nvim_buf_get_name(bufnr)
                    if name ~= "" and views[name] then
                        vim.api.nvim_buf_call(bufnr, function()
                            vim.fn.winrestview(views[name])
                        end)
                    end
                end
            end
        end
    end
})
