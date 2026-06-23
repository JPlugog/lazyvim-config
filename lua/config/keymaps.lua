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

local term_count = 0

-- 3. Nueva Terminal Independiente (<leader>tn)
map({ "n", "t" }, "<leader>tn", function()
  term_count = term_count + 1
  -- Creamos un ID único para que Neovim genere buffers distintos
  Snacks.terminal.open(nil, {
    id = "term_" .. term_count,
    win = { title = " Terminal " .. term_count .. " " },
  })
end, { desc = "New Independent Terminal" })

-- 4. Toggle Principal (La terminal por defecto o última usada)
map({ "n", "t" }, "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })
map({ "n", "t" }, "<S-Esc>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })

-- Terminal List (<leader>tl)
map("n", "<leader>tl", function()
  local terminal_items = {}
  local bufs = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(bufs) do
    if vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == "terminal" then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local display_name = name:gsub("term://.-//", "")
      if display_name == "" then
        display_name = "Shell"
      end

      table.insert(terminal_items, {
        buf = bufnr,
        text = display_name,
        id = name:match("term_(%d+)") or tostring(bufnr),
      })
    end
  end

  if #terminal_items == 0 then
    vim.notify("No hay terminales activas", vim.log.levels.WARN)
    return
  end

  Snacks.picker.pick({
    source = "terminal_list",
    items = terminal_items,
    format = function(item)
      return {
        { string.format("󱂬  ID: %s ", item.id), "SnacksPickerLabel" },
        { " " .. item.text, "SnacksPickerValue" },
      }
    end,
    confirm = function(picker, item)
      picker:close()

      -- 1. Intentamos cerrar la ventana flotante actual si existe
      local t = Snacks.terminal.get()
      local win_id = t and t["win"] and t["win"]["win"]

      if win_id and vim.api.nvim_win_is_valid(win_id) then
        -- Usamos pcall para evitar errores si la ventana ya se cerró
        pcall(function()
          vim.api.nvim_win_close(win_id, true)
        end)
      end

      -- 2. Abrimos la nueva terminal en una ventana limpia
      -- Usamos Snacks.win para que sea independiente del historial de toggle
      Snacks.win({
        buf = item.buf,
        position = "float",
        backdrop = 60,
        width = 0.8,
        height = 0.8,
        border = "rounded",
        title = " Terminal " .. item.id .. " ",
        title_pos = "center",
        wo = {
          winhighlight = "Normal:SnacksTerminal,NormalFloat:SnacksTerminal",
        },
      })

      -- 3. Entramos en modo insert inmediatamente
      vim.schedule(function()
        vim.cmd("startinsert")
      end)
    end,
    title = " Listado de Terminales Activas ",
  })
end, { desc = "Terminal List" })
