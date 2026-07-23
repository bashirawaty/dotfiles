return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "bash", "python", "yaml",
        "dockerfile", "terraform", "json",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
