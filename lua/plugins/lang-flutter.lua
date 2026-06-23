-- Flutter/Dart con FVM
-- dartls via lspconfig (para LSP: gd, gD, format, etc.)
-- flutter-tools solo para debugger y comandos :Flutter*
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          cmd = { vim.fn.expand("~/fvm/default/bin/dart"), "language-server", "--protocol=lsp" },
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
              updateImportsOnRename = true,
              analysisExcludedFolders = {
                vim.fn.expand("~/fvm/versions"),
              },
            },
          },
        },
      },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    opts = {
      fvm = true,
      debugger = { enabled = true, run_via_dap = true },
      dev_log = { enabled = true, open_cmd = "tabedit" },
      widget_guides = { enabled = true },
      lsp = {
        -- NO dejar que flutter-tools maneje el LSP
        enabled = false,
      },
    },
  },
}
