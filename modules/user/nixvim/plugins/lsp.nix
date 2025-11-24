{
    config,
    lib,
    nixvimLib,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.lsp = {
            enable = true;
            servers = {
                nixd.enable = true;
                rust_analyzer = {
                    enable = true;
                    settings = {
                        check.command = "clippy";
                        checkOnSave = true;
                    };
                    # dismiss warnings
                    installCargo = false;
                    installRustc = false;
                    installRustfmt = false;
                };
                tinymist = {
                    enable = true;
                    settings = {
                        formatterMode = "typstyle";
                        exportPdf = "onSave";
                    };
                    onAttach.function = ''
                        vim.keymap.set("n", "<leader>tp", function()
                        	client:exec_cmd({
                        		title = "pin",
                        		command = "tinymist.pinMain",
                        		arguments = { vim.api.nvim_buf_get_name(0) },
                        	}, { bufnr = bufnr })
                        end, { desc = "[T]inymist [P]in", noremap = true })

                        vim.keymap.set("n", "<leader>tu", function()
                        	client:exec_cmd({
                        		title = "unpin",
                        		command = "tinymist.pinMain",
                        		arguments = { vim.v.null },
                        	}, { bufnr = bufnr })
                        end, { desc = "[T]inymist [U]npin", noremap = true })
                    '';
                };
            };
        };
        lsp = {
            servers = {
                nixd.enable = true;
                rust_analyzer.enable = true;
                tinymist.enable = true;
            };
            keymaps = [
                {
                    mode = "n";
                    key = "gR";
                    action = "<CMD>Telescope lsp_references<CR>";
                    options.desc = "[G]o to LSP [r]eferences";
                }
                {
                    mode = "n";
                    key = "gD";
                    lspBufAction = "declaration";
                    options.desc = "[G]o to LSP [d]eclaration";
                }
                {
                    mode = "n";
                    key = "gd";
                    action = "<CMD>Telescope lsp_definitions<CR>";
                    options.desc = "[G]o to LSP [d]efinitions";
                }
                {
                    mode = "n";
                    key = "gt";
                    action = "<CMD>Telescope lsp_type_definitions<CR>";
                    options.desc = "[G]o to LSP [t]ype definitions";
                }
                {
                    mode = ["n" "v"];
                    key = "ca";
                    lspBufAction = "code_action";
                    options.desc = "See available [c]ode [a]ctions";
                }
                {
                    mode = "n";
                    key = "<leader>rn";
                    lspBufAction = "rename";
                    options.desc = "[R]e[n]me";
                }
                {
                    mode = "n";
                    key = "<leader>D";
                    action = "<CMD>Telescope diagnostics bufnr=0<CR>";
                    options.desc = "Show buffer [d]iagnostics";
                }
                {
                    mode = "n";
                    key = "<leader>d";
                    action = nixvimLib.nixvim.mkRaw "vim.diagnostic.open_float";
                    options.desc = "Show buffer [d]iagnostics";
                }
                {
                    mode = "n";
                    key = "<leader>[d";
                    action = nixvimLib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1, float = true }) end";
                    options.desc = "Go to previous [d]iagnostic";
                }
                {
                    mode = "n";
                    key = "<leader>]d";
                    action = nixvimLib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1, float = true }) end";
                    options.desc = "Go to next [d]iagnostic";
                }
                {
                    mode = "n";
                    key = "K";
                    lspBufAction = "hover";
                    options.desc = "Show documentatin for what is under cursor";
                }
            ];
        };

        plugins.lspkind.enable = true;
    };
}
