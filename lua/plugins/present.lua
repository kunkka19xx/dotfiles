-- My own plugin: https://github.com/kunkka19xx/present.nvim
-- (developed locally at ~/Documents/git/present.nvim)
return {
    "kunkka19xx/present.nvim",
    -- dir = vim.fn.expand("~/Documents/git/present.nvim"), -- use the local checkout
    -- dev = true,
    lazy = true,
    cmd = "PresentStart",
    ft = "markdown",
    dependencies = {
        "MeanderingProgrammer/render-markdown.nvim", -- tables + callout boxes
    },
    config = function()
        require("present").setup {
            spotlight = true, -- dim already-revealed chunks (try it, remove if you dislike)
        }
    end,
}
