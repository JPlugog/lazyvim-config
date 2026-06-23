# 🚀 Neovim IDE Portable — Mobile & Native Development

> Configuración modular de Neovim basada en **LazyVim** optimizada para desarrollo
> **Flutter**, **React Native**, **Kotlin** y **Swift** con debugging visual integrado.

---

## 📋 Plan General

| Objetivo | Estrategia |
|----------|-----------|
| IDE portable | Todo en `~/.config/nvim`, clonable con un solo `git clone` |
| Modularidad | Un archivo por dominio en `lua/plugins/` |
| Mínima configuración manual | Usar **Extras oficiales** de LazyVim para LSPs, linters y formatters |
| Debugging visual | nvim-dap + dap-ui con layout personalizado |
| Portabilidad total | Sin dependencias hardcodeadas a paths del sistema |

---

## 📁 Estructura de Archivos

```
~/.config/nvim/
├── init.lua                          # Bootstrap (no tocar)
├── lazyvim.json                      # ⭐ Extras activados
├── lazy-lock.json                    # Lockfile de plugins (auto-generado)
├── .gitignore                        # Ignora archivos temporales
├── .neoconf.json                     # Config de LSP para el proyecto
├── stylua.toml                       # Formatter de Lua
├── LICENSE
├── README.md                         # ← Este archivo
│
├── lua/
│   ├── config/
│   │   ├── lazy.lua                  # Setup de lazy.nvim (no tocar)
│   │   ├── options.lua               # Opciones globales + Snacks terminal
│   │   ├── keymaps.lua               # ⭐ Keymaps personalizados
│   │   └── autocmds.lua              # Autocommands
│   │
│   └── plugins/
│       ├── example.lua               # Ejemplo de LazyVim (referencia)
│       ├── dashboard.lua             # ⭐ Dashboard ASCII personalizado
│       ├── terminal.lua              # ⭐ Terminal flotante (Snacks)
│       ├── lang-flutter.lua          # ⭐ Flutter/Dart (extiende extra)
│       ├── lang-react-native.lua     # ⭐ React Native/TS (extiende extra)
│       ├── lang-kotlin.lua           # ⭐ Kotlin + DAP Android
│       ├── lang-swift.lua            # ⭐ Swift + DAP codelldb
│       └── debugging.lua             # ⭐ DAP UI, signos, keymaps debug
```

> Los archivos marcados con ⭐ son los personalizados/modificados.

---

## 🔌 Extras de LazyVim Activados

Configurados en `lazyvim.json` — LazyVim se encarga de instalar LSPs, treesitter parsers, linters y formatters automáticamente:

| Extra | Qué provee |
|-------|-----------|
| `lang.typescript` | tsserver, eslint, prettier, treesitter tsx/ts |
| `lang.kotlin` | kotlin_language_server, treesitter kotlin |
| `lang.swift` | sourcekit-lsp, treesitter swift |
| `lang.dart` | flutter-tools, dart LSP, treesitter dart |
| `dap.core` | nvim-dap, nvim-dap-ui, mason-nvim-dap, keymaps base |

---

## 🐛 Debugging (nvim-dap)

### Layout Visual

```
┌──────────────────────────────────────────────────────────┐
│  Scopes (35%)    │                                       │
│  Breakpoints(15%)│           EDITOR                      │
│  Stacks (25%)    │                                       │
│  Watches (25%)   │                                       │
├──────────────────┴───────────────────────────────────────┤
│  REPL (50%)              │  Console (50%)                │
└──────────────────────────────────────────────────────────┘
```

### Keymaps de Debug

| Keymap | Acción |
|--------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint condicional |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dl` | Run last session |
| `<leader>dR` | Restart session |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |

### Signos Visuales

| Signo | Significado |
|-------|------------|
| ● (rojo) | Breakpoint activo |
| ◆ (amarillo) | Breakpoint condicional |
| ◈ (azul) | Log point |
| ▶ (verde) | Línea actual de ejecución |
| ○ (gris) | Breakpoint rechazado |

---

## 🔧 Archivos Base de LazyVim (no modificados)

Estos vienen del [starter template](https://github.com/LazyVim/starter) y no se deben editar directamente:

- `init.lua` — Bootstrap de lazy.nvim
- `lua/config/lazy.lua` — Setup del plugin manager
- `lua/config/autocmds.lua` — Autocommands base
- `.neoconf.json` — Configuración de LSP workspace
- `stylua.toml` — Reglas de formateo Lua
- `lazy-lock.json` — Lockfile auto-generado (sí se sube a Git)

---

## ⭐ Archivos Modificados/Creados (tu configuración)

| Archivo | Propósito |
|---------|----------|
| `lazyvim.json` | Extras activados (typescript, kotlin, swift, dart, dap) |
| `lua/config/options.lua` | Terminal flotante con Snacks |
| `lua/config/keymaps.lua` | Navegación, terminales múltiples, reload |
| `lua/plugins/dashboard.lua` | Dashboard ASCII art personalizado |
| `lua/plugins/terminal.lua` | Config de terminal flotante |
| `lua/plugins/lang-flutter.lua` | Flutter: debugger via DAP, widget guides, dev log |
| `lua/plugins/lang-react-native.lua` | RN: emmet para JSX, treesitter parsers |
| `lua/plugins/lang-kotlin.lua` | Kotlin: configuración DAP para Android |
| `lua/plugins/lang-swift.lua` | Swift: DAP con codelldb para iOS/macOS |
| `lua/plugins/debugging.lua` | DAP UI layout, signos visuales, keymaps extra |

---

## 🚀 Guía de Portabilidad

### Instalación en una máquina nueva

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/nvim-config.git ~/.config/nvim

# 2. Abrir Neovim (lazy.nvim se instala solo)
nvim

# 3. Esperar a que Lazy instale todos los plugins
# 4. Mason instalará automáticamente los LSPs/DAPs necesarios
```

### Requisitos del sistema

| Herramienta | Para qué |
|-------------|----------|
| Neovim ≥ 0.10 | Base |
| Git | Plugins |
| Node.js ≥ 18 | TypeScript LSP, React Native |
| Flutter SDK | Flutter/Dart development |
| Kotlin (kotlinc) | Kotlin LSP |
| Xcode CLI Tools | Swift (sourcekit-lsp) |
| ripgrep | Búsqueda rápida (Telescope) |
| fd | File finder |

### Qué se sube a Git

```gitignore
# .gitignore actual
tt.*
.tests
doc/tags
debug
.repro
foo.*
*.log
data
```

**SÍ subir:** Todo lo demás (incluyendo `lazy-lock.json` para reproducibilidad).

**NO subir:** `data/`, logs, archivos temporales de test.

---

## 📅 Fecha de creación

**26 de Mayo, 2026** — Neovim 0.10+ / LazyVim v8

---

## 🔄 Clonar en otro equipo

**Instalación limpia:**
```bash
git clone https://github.com/JPlugog/lazyvim-config.git ~/.config/nvim
```

**Si ya tiene neovim/LazyVim configurado:**
```bash
rm -rf ~/.config/nvim
git clone https://github.com/JPlugog/lazyvim-config.git ~/.config/nvim
```

Al abrir neovim, Lazy detecta `lazy-lock.json` e instala los plugins automáticamente.

**Consideraciones:**
- La config es agnóstica al SO (funciona en macOS y Linux sin cambios)
- La ruta `~/.config/nvim` es estándar en ambos sistemas
- Plugins de lenguajes específicos (ej: Swift) se ignoran si las dependencias no están presentes
- Instalar dependencias externas: `ripgrep`, `fd`, `node`, `gcc`/`clang` (para treesitter)

---

## 💡 Tips

- Usa `:LazyExtras` para ver/activar más extras sin tocar archivos.
- Usa `:Mason` para gestionar LSPs, formatters y DAPs instalados.
- Usa `:Lazy` para actualizar plugins y ver el estado.
- Los archivos en `lua/plugins/` se cargan automáticamente — solo crea un `.lua` y listo.
- Para agregar un nuevo lenguaje: activa su extra en `lazyvim.json` y crea `lang-NOMBRE.lua` solo si necesitas algo extra.
