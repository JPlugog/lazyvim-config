return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          style = "float",
          border = "rounded",
        },
      },
      explorer = {
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
