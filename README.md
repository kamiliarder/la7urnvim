# la7urnvim

A personal Neovim configuration — minimal, fast, and opinionated. Built on top of [ntk148v/neovim-config](https://github.com/ntk148v/neovim-config) and extended to fit my own workflow.

> ⚠️ This config is maintained for personal use. Feel free to fork and adapt it, but no support is guaranteed.

> ⚠️ Mostly vibe-coded, use at your own risk!!

---

## Features

- [blink.cmp](https://github.com/saghen/blink.cmp) for code completion
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) for code suggestion
- [which-key.nvim](https://github.com/folke/which-key.nvim) to see what each keybind does
- [alpha-nvim](https://github.com/goolord/alpha-nvim) customizeable dashboard integrated with [devexcuses.nvim](https://github.com/mahyarmirrashed/devexcuses.nvim/)
- [mini.files](https://github.com/nvim-mini/mini.files) to navigate and manipulate file system

---

## Requirements

- **Neovim** `>= 0.8`
- **git**  for plugin management via lazy.nvim
- **ripgrep** (`rg`) used by telescope for live grep
- **fd** / **fdfind** used by telescope for file finding

---

## Installation

> Back up your existing config first if you have one:
> ```sh
> mv ~/.config/nvim ~/.config/nvim.bak
> ```

Clone the repo into your Neovim config directory:

```sh
git clone https://github.com/kamiliarder/la7urnvim.git ~/.config/nvim
```

Open Neovim. [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself automatically and install all plugins on first launch.

---

## Structure

```
~/.config/nvim/
├── init.lua           # Entrypoint — loads lazy.nvim and core modules
├── lua/
│   ├── plugins/       # Plugin specs (lazy.nvim)
│   ├── options.lua    # Vim options
│   ├── mappings.lua   # Keymaps
│   ├── autocmds.lua   # Autocommands
│   └── custom.lua     # Optional user overrides
└── screenshots/       # Preview screenshots
```

### Customization

You can override or extend the config without touching the core files. Create `lua/custom.lua` and export a `configs` function:

```lua
-- lua/custom.lua
return {
  configs = function()
    -- your overrides here
    vim.opt.relativenumber = true
  end,
}
```

---

## Plugin Manager

This config uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. It is automatically bootstrapped on first launch — no manual install needed.

To manage plugins, open Neovim and run:

```
:Lazy
```

---

## License

[Apache-2.0](./LICENSE)
