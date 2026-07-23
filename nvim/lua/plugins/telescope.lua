return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--glob", "!**/.git/*",
          "--glob", "!**/node_modules/*",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },

        -- Cross‑platform path handling
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
  end,
}
