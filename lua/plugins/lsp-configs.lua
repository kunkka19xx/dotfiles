return {
    {
        "williamboman/mason.nvim",
        -- version = "v1.11.0",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            -- manually install packages that do not exist in this list please
            ensure_installed = { "zls", "gopls", "ts_ls" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            -- lua
            vim.lsp.config["lua_ls"] = {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            -- apple development
            local default_inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]

            vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
                if err then
                    local msg = err.message or ""
                    if string.match(msg, "inlay hints failed") or err.code == -32802 or err.code == -32001 then
                        return
                    end
                end

                if default_inlay_hint_handler then
                    return default_inlay_hint_handler(err, result, ctx, config)
                end
            end

            local is_mac = vim.fn.has("mac") == 1
            if is_mac then
                vim.lsp.config["swift_mesonls"] = { -- sourcekit doesn't work, so it's a fake name
                    capabilities = capabilities,
                    root_dir = require("lspconfig.util").root_pattern(
                        "Package.swift",
                        "Project.swift",
                        ".git",
                        "*.xcodeproj",
                        "*.xcworkspace"
                    ),
                    cmd = { "xcrun", "--find", "sourcekit-lsp" },
                    on_attach = function(client, bufnr)
                        if vim.lsp.inlay_hint then
                            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                        end
                        client.server_capabilities.inlayHintProvider = false
                    end,
                }
            end
            -- apple development

            vim.lsp.config["rust_analyzer"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["ts_ls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["eslint"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["zls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["yamlls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["tailwindcss"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["gopls"] = {
                capabilities = capabilities,
            }

            -- nix
            vim.lsp.config["nil_ls"] = {
                capabilities = capabilities,
            }

            -- protocol buffer
            vim.lsp.config["buf_ls"] = {
                capabilities = capabilities,
            }

            -- docker compose
            vim.lsp.config["docker_compose_language_service"] = {
                capabilities = capabilities,
            }

            -- cobol
            vim.lsp.config["cobol_ls"] = {
                capabilities = capabilities,
            }

            -- svelte
            vim.lsp.config["svelte"] = {
                capabilities = capabilities,
            }
            -- python
            vim.lsp.config["pyright"] = {
                capabilities = capabilities,
            }

            -- bash
            vim.lsp.config["bashls"] = {
                capabilities = capabilities,
            }

            -- protocol buffer
            vim.lsp.config["buf_language_server"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["asm_lsp"] = {
                capabilities = capabilities,
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "proto",
                callback = function()
                    vim.lsp.enable("buf_language_server")
                end,
            })

            vim.lsp.enable({
                "ts_ls",
                "eslint",
                "zls",
                "yamlls",
                "tailwindcss",
                "gopls",
                "nil_ls",
                "buf_ls",
                "docker_compose_language_service",
                "cobol_ls",
                "svelte",
                "pyright",
                "bashls",
                "asm_lsp",
                "rust_analyzer",
                "sourcekit",
            })
            -- lsp kepmap setting
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
            -- list all methods in a file
            -- working with go confirmed, don't know about other, keep changing as necessary
            vim.keymap.set("n", "<leader>fm", function()
                local filetype = vim.bo.filetype
                local symbols_map = {
                    python = "function",
                    javascript = "function",
                    typescript = "function",
                    java = "class",
                    lua = "function",
                    go = { "method", "struct", "interface" },
                }
                local symbols = symbols_map[filetype] or "function"
                require("fzf-lua").lsp_document_symbols({ symbols = symbols })
            end, {})
        end,
    },
}
