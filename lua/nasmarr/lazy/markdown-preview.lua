return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_theme = "dark"
    end,
    keys = {
        { "<leader>mb", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Toggle markdown preview in browser" },
    },
}
