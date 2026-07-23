return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "bashls",
        "pyright",
        "yamlls",
        "dockerls",
        "terraformls",
        "tsserver",
      },
    })

    local lspconfig = require("lspconfig")

    for _, server in ipairs({
      "lua_ls", "bashls", "pyright", "yamlls",
      "dockerls", "terraformls", "tsserver"
    }) do
      lspconfig[server].setup({})
    end
  end,
}
