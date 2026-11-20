return {
    {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- NOTE: the `main` branch no longer accepts ensure_installed/highlight/indent
        -- in setup(); parsers are installed explicitly and highlighting is started
        -- per-buffer via a FileType autocmd below.
        local ts = require("nvim-treesitter")
        ts.setup({})

        local parsers = {
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "markdown", "markdown_inline",
            "angular", "c_sharp", "css", "html", "diff", "java",
        }

        -- Installing parsers on `main` requires the tree-sitter CLI (pacman -S tree-sitter-cli)
        if vim.fn.executable("tree-sitter") == 1 then
            ts.install(parsers)
        else
            vim.schedule(function()
                vim.notify("tree-sitter CLI not found; run `sudo pacman -S tree-sitter-cli` to install parsers",
                    vim.log.levels.WARN, { title = "Treesitter" })
            end)
        end

        local max_filesize = 100 * 1024 -- 100 KB

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("nasmarr_treesitter", { clear = true }),
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
                if not lang or lang == "html" then
                    return
                end

                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        {title = "Treesitter"}
                    )
                    return
                end

                -- Start highlighting (silently skip if no parser is available)
                if pcall(vim.treesitter.start, buf, lang) then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        -- Register templ filetype with treesitter
        vim.treesitter.language.register("templ", "templ")
    end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                multiwindow = false, -- Enable multiwindow support.
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    }
}
