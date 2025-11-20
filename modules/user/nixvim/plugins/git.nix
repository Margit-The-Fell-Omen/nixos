{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.gitsigns = {
            enable = true;
            lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            settings = {
                signs = {
                    add = {text = "+";};
                    change = {text = "~";};
                    delete = {text = "_";};
                    topdelete = {text = "‾";};
                    changeddelete = {text = "~";};
                };
                on_attach = ''
                    function(bufnr)
                        local gs = package.loaded.gitsigns

                        local function map(mode, l, r, desc)
                            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                        end

                        -- Navigation
                        map("n", "]h", gs.next_hunk, "Next [h]unk")
                        map("n", "[h", gs.prev_hunk, "Previous [h]unk")

                        -- Actions
                        map("n", "<leader>hs", gs.stage_hunk, "[S]tage [h]unk")
                        map("n", "<leader>hr", gs.reset_hunk, "[R]eset [h]unk")
                        map("v", "<leader>hs", function()
                            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                        end, "[S]tage [h]unk")
                        map("v", "<leader>hr", function()
                            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                        end, "[R]eset [h]unk")

                        map("n", "<leader>hS", gs.stage_buffer, "[S]tage buffer")
                        map("n", "<leader>hR", gs.reset_buffer, "[R]eset buffer")

                        map("n", "<leader>hu", gs.undo_stage_hunk, "[U]ndo stage [h]unk")

                        map("n", "<leader>hp", gs.preview_hunk, "[P]review hunk")

                        map("n", "<leader>hb", function()
                            gs.blame_line({ full = true })
                        end, "[B]lame line")
                        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line [b]lame")

                        map("n", "<leader>hd", gs.diffthis, "[D]iff this")
                        map("n", "<leader>hD", function()
                            gs.diffthis("~")
                        end, "[D]iff this ~")

                        -- Text object
                        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
                    end
                '';
            };
        };

        plugins.lazygit = {
            enable = true;
        };

        keymaps = [
            {
                mode = "n";
                key = "<leader>lg";
                action = "<CMD>LazyGit<CR>";
                options.desc = "[L]azy[G]it";
            }
        ];
    };
}
