-- Debugging: el extra "dap.core" ya instala nvim-dap + nvim-dap-ui + mason-nvim-dap.
-- Aquí personalizamos la UI, keymaps y signos visuales.
return {
  -- DAP UI: layout y comportamiento
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.35 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
  },
  -- DAP: signos visuales y keymaps adicionales
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last Debug Session" },
      { "<leader>dR", function() require("dap").restart() end, desc = "Restart Debug Session" },
    },
    config = function()
      -- Signos visuales para breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◈", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })

      -- Highlight para la línea donde se detuvo el debugger
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#304030" })
    end,
  },
  -- Virtual text para ver valores inline durante debug
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = { commented = true },
  },
}
