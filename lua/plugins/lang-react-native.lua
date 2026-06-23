-- React Native: el extra "lang.typescript" ya configura tsserver + eslint + prettier.
-- Aquí agregamos soporte específico para RN.
return {
  -- Syntax highlighting para JSX/TSX mejorado
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "tsx", "javascript", "typescript", "css", "json" } },
  },
  -- Emmet para JSX
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
}
