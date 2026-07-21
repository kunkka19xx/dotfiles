local is_mac = vim.fn.has("mac") == 1
return {
    "wojciech-kulik/xcodebuild.nvim",
    enabled = is_mac,
    dependencies = {
        "ibhagwan/fzf-lua",
        "MunifTanjim/nui.nvim",
        -- "nvim-tree/nvim-tree.lua",
        "stevearc/oil.nvim",
    },
    config = function()
        require("xcodebuild").setup({
            show_build_progress_bar = true,
            logs = {
                auto_open_on_success_tests = false,
                auto_open_on_failed_tests = false,
                auto_open_on_success_build = false,
                auto_open_on_failed_build = true,
                auto_focus = false,
                auto_close_on_app_launch = true,
            },
            code_coverage = {
                enabled = true,
            },
            project_manager = {
                should_update_project = function(path)
                    -- Only manage files that live next to an .xcodeproj.
                    -- Walk up from the file; if we find a sibling *.xcodeproj
                    -- before leaving the repo, accept. Otherwise skip.
                    local dir = path:match("(.*/)")
                    while dir and #dir > 1 do
                        if vim.fn.glob(dir .. "*.xcodeproj") ~= "" then
                            -- still skip SPM/build noise inside the iOS tree
                            if path:match("/%.build/") then return false end
                            if path:match("/DerivedData/") then return false end
                            if path:match("/%.swiftpm/") then return false end
                            return true
                        end
                        dir = dir:match("(.*/)[^/]+/$")
                    end
                    return false
                end,
            },
        })

        vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
        vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
        vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
        vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
        vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
        vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device/Simulator" })
        vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectProject<cr>", { desc = "Select Project/Workspace" })
    end,
}
