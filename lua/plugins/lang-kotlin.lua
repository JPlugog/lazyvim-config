-- Kotlin: el extra "lang.kotlin" ya configura kotlin_language_server + treesitter.
-- Aquí agregamos DAP para Kotlin/Android.
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.kotlin = {
        {
          type = "kotlin",
          request = "launch",
          name = "Launch Kotlin",
          projectRoot = "${workspaceFolder}",
          mainClass = "",
        },
      }
    end,
  },
}
