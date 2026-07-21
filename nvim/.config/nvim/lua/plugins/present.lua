-- My own plugin: https://github.com/kunkka19xx/present.nvim
-- (developed locally at ~/Documents/git/present.nvim)
return {
    "kunkka19xx/present.nvim",
    lazy = true,
    cmd = "PresentStart",
    ft = "markdown",
    config = function()
        require("present").setup {}
    end,
}
