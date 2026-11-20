return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
}
