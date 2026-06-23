-- Swift: el extra "lang.swift" ya configura sourcekit-lsp + treesitter.
-- Aquí agregamos DAP con codelldb para iOS/macOS.
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      -- codelldb se instala via mason (incluido en dap.core extra)
      dap.configurations.swift = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch Swift",
          program = "${workspaceFolder}/.build/debug/${workspaceFolderBasename}",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
}
