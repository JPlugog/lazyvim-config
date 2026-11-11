-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
local map = LazyVim.safe_keymap_set

-- Recargar rápido sin cerrar Neovim
map("n", "<leader>R", function()
  vim.cmd("source %")
  vim.notify("Configuración recargada", vim.log.levels.INFO)
end, { desc = "Reload Current File" })

-------------------------------------------------------------------------------
-- 1. NAVEGACIÓN Y VENTANAS
-------------------------------------------------------------------------------
map("n", "[", ":wincmd h<CR>", { desc = "Go to left window" })
map("n", "]", ":wincmd l<CR>", { desc = "Go to right window" })
map("n", "{", ":BufferLineCyclePrev<CR>", { desc = "Go to previous tab" })
map("n", "}", ":BufferLineCycleNext<CR>", { desc = "Go to next tab" })
map("n", "U", ":redo<CR>", { desc = "Redo" })

map("n", "<C-S-Up>", ":resize -2<CR>", { desc = "Resize up" })
map("n", "<C-S-Down>", ":resize +2<CR>", { desc = "Resize down" })
map("n", "<C-S-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
map("n", "<C-S-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
map("n", "gD", ":lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })

-- Salir de modo terminal con doble Escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-------------------------------------------------------------------------------
-- SECCIÓN DE TERMINAL
-------------------------------------------------------------------------------

-- 1. Comando de Recarga (Para aplicar cambios sin cerrar Neovim)
map("n", "<leader>r", function()
  vim.cmd("source %")
  vim.notify("Configuración recargada", vim.log.levels.INFO)
end, { desc = "Reload Current File" })

-- 2. Registro del grupo en Which-Key
wk.add({
  { "<leader>t", group = "terminal" },
})

-- Terminales flotantes múltiples (lógica en lua/config/terminals.lua).
-- Nota: los mapeos <leader> NO se registran en modo terminal para que el
-- espacio no tenga retraso al escribir en la shell. Dentro de una terminal usa
-- <C-/> o <S-Esc> para ocultarla, o <Esc><Esc> y luego <leader>t...
local terms = require("config.terminals")

vim.keymap.set("n", "<leader>tt", terms.toggle, { desc = "Toggle Last Terminal" })
vim.keymap.set({ "n", "t" }, "<S-Esc>", terms.toggle, { desc = "Toggle Last Terminal" })
vim.keymap.set({ "n", "t" }, "<c-/>", terms.toggle, { desc = "Toggle Last Terminal" })
vim.keymap.set({ "n", "t" }, "<c-_>", terms.toggle, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>tn", terms.new, { desc = "New Terminal (next free slot)" })
vim.keymap.set("n", "<leader>tl", terms.pick, { desc = "Terminal List" })
vim.keymap.set("n", "<leader>tk", terms.kill, { desc = "Kill Terminal" })
for i = 1, terms.max do
  vim.keymap.set("n", "<leader>t" .. i, function()
    terms.show(i)
  end, { desc = "Terminal " .. i })
end
