-- Terminales flotantes múltiples sobre Snacks.terminal (default de LazyVim).
--
-- Snacks identifica cada terminal por (cmd, cwd, env, count). Usamos `count`
-- como número de slot (1..MAX) y fijamos el cwd de cada slot al crearla, así
-- el mismo slot siempre resuelve a la misma terminal (sigue corriendo en
-- caliente al ocultarla).
--
-- Reglas para evitar flotantes apiladas:
--   * Antes de mostrar una terminal se ocultan las demás terminales visibles.
--   * Nunca se crean ventanas por fuera de Snacks.terminal (todo pasa por get()).

local M = {}

M.max = 4

local state = {
  cwd = {}, ---@type table<integer, string>
  mru = {}, ---@type integer[] slots usados, el más reciente primero
}

local function touch(n)
  for i, v in ipairs(state.mru) do
    if v == n then
      table.remove(state.mru, i)
      break
    end
  end
  table.insert(state.mru, 1, n)
end

local function opts(n, extra)
  return vim.tbl_extend("force", {
    count = n,
    cwd = state.cwd[n] or LazyVim.root(),
    win = {
      position = "float",
      border = "rounded",
      title = " Terminal " .. n .. " ",
      title_pos = "center",
    },
  }, extra or {})
end

---@return snacks.win?
function M.get(n)
  if not state.cwd[n] then
    return nil
  end
  local t = Snacks.terminal.get(nil, opts(n, { create = false }))
  if t and t:buf_valid() then
    return t
  end
  state.cwd[n] = nil -- la terminal murió (exit / buffer borrado)
  return nil
end

---@return integer[]
function M.alive()
  local ret = {}
  for n = 1, M.max do
    if M.get(n) then
      table.insert(ret, n)
    end
  end
  return ret
end

local function hide_others(keep)
  for _, t in ipairs(Snacks.terminal.list()) do
    if t ~= keep and t:win_valid() then
      t:hide()
    end
  end
end

--- Muestra la terminal N (la crea si no existe) y oculta las demás.
--- Si ya está visible y enfocada, la oculta.
function M.show(n)
  local existing = M.get(n)
  if existing and existing:win_valid() and vim.api.nvim_get_current_win() == existing.win then
    existing:hide()
    return
  end
  hide_others(existing)
  if not state.cwd[n] then
    state.cwd[n] = LazyVim.root()
  end
  touch(n)
  local t, created = Snacks.terminal.get(nil, opts(n))
  if t and not created then
    t:show()
    t:focus()
  end
end

--- Toggle de la última terminal usada (o la más reciente que siga viva).
function M.toggle()
  -- Si hay alguna terminal flotante visible, se oculta (sale de terminales).
  local visible = false
  for _, t in ipairs(Snacks.terminal.list()) do
    if t:win_valid() then
      t:hide()
      visible = true
    end
  end
  if visible then
    return
  end
  for _, n in ipairs(state.mru) do
    if M.get(n) then
      return M.show(n)
    end
  end
  local alive = M.alive()
  M.show(alive[1] or 1)
end

--- Abre el siguiente slot libre.
function M.new()
  for n = 1, M.max do
    if not M.get(n) then
      return M.show(n)
    end
  end
  vim.notify(("Ya hay %d terminales abiertas (usa <leader>t1..t%d)"):format(M.max, M.max), vim.log.levels.WARN)
end

--- Cierra (mata) la terminal actual o la última usada.
function M.kill()
  local info = vim.b.snacks_terminal
  local n = info and info.id or state.mru[1]
  local t = n and M.get(n)
  if not t then
    vim.notify("No hay terminal para cerrar", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_delete(t.buf, { force = true })
  state.cwd[n] = nil
end

function M.pick()
  local items = {}
  for _, n in ipairs(M.alive()) do
    local t = M.get(n)
    local title = t and vim.b[t.buf].term_title or ""
    table.insert(items, { n = n, text = ("Terminal %d  %s"):format(n, title) })
  end
  if #items == 0 then
    vim.notify("No hay terminales activas", vim.log.levels.WARN)
    return
  end
  Snacks.picker.pick({
    source = "float_terminals",
    title = " Terminales Activas ",
    items = items,
    format = function(item)
      return { { item.text, "SnacksPickerLabel" } }
    end,
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function()
          M.show(item.n)
        end)
      end
    end,
  })
end

return M
