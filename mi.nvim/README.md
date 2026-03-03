# mi.nvim

Minimal neovim configuration concentrated in a single file (~100 ms startup time).

## 📋 Pre-requisites
- [Neovim 0.10+](https://neovim.io/)
- [Nerd Font](https://www.nerdfonts.com/)
- GCC, Windows users must have [mingw](https://scoop.sh/#/apps?q=mingw&id=965b35870a2cbc6584a302ef1721c7f18faaef24) installed.
- Make, Windows users must have [make](https://scoop.sh/#/apps?q=make&id=c43ff861c0f1713336e5304d85334a29ffb86317) installed.
- curl

> [!IMPORTANT]
> I recommend using [scoop](https://scoop.sh/) (a command-line installer for Windows) to install GCC and Make;

## 🧩 Plugins

- [folke/lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin Manager
- [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) - Colorscheme
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Nvim LSP Config
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) - Nvim Package Manager
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Mason Extension for LSP Config
- [b0o/schemastore.nvim](https://github.com/b0o/SchemaStore.nvim) - Schemastore
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - Nerd Font Icons
- [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File Explorer
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax Highlighting
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippets Collection
- [Saghen/blink.cmp](https://github.com/Saghen/blink.cmp) - Completion Engine
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git Integration
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [nvimdev/indentmini.nvim](https://github.com/nvimdev/indentmini.nvim) - IndentLine

## ⌨️ Mappings

- **\<Leader\> + q** - Quit.
- **\<Leader\> + c** - Comment or uncomment line or block.
- **\<Leader\> + t** - Open or focus file explorer.
- **\<Leader\> + T** - Close file explorer.
- **\<Leader\> + \<Tab\>** - Toggle terminal.
- **\<C\> + w** - Move selected block up.
- **\<C\> + s** - Move selected block down.

**blink.cmp**

- **\<Tab\>** - Select next item.
- **\<S-Tab\>** - Select previous item.
- **\<CR\>** - Confirm.

> [!NOTE]
> **\<C\>** is Ctrl;\
> **\<S\>** is Shift;\
> **\<CR\>** is Enter;\
> **\<Leader\>** is Spacebar;

## 🖼️ Screenshoots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0d2abffd-8715-4d08-a605-c9428d90493f" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7a0ce2f2-c8a0-4b65-b1fa-02f4900f4758" />
