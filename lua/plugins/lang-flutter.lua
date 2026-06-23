-- Flutter/Dart: el extra "lang.dart" ya configura flutter-tools + LSP.
-- Aquí habilitamos FVM para que detecte el SDK del proyecto automáticamente.
return {
  {
    "akinsho/flutter-tools.nvim",
    opts = {
      fvm = true, -- detecta .fvmrc / .fvm/ del proyecto y usa ese SDK
      debugger = { enabled = true, run_via_dap = true },
      dev_log = { enabled = true, open_cmd = "tabedit" },
      widget_guides = { enabled = true },
    },
  },
}
