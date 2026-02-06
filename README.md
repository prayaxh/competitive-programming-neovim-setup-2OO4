# Neovim C++ Development Environment

A custom **Neovim configuration** optimized for **C++23 development** and **competitive programming**. Includes **auto-saving**, **session management**, and **one-click compilation & execution** in a separate terminal.

---

## 🛠 Features

* **Colorscheme:** Koda (Dark / Modern)
* **LSP:** `clangd` for C++ autocompletion and diagnostics
* **Treesitter:** Advanced syntax highlighting
* **Auto-Compile:** Optimized (**F8**) and sanitized (**F9**) builds
* **Session Management:** Restores open buffers and cursor positions automatically

---

## 📥 Installation (Linux / Ubuntu)

### 1. Update your system
```bash
sudo apt update
2. Install required packagesBashsudo apt install git g++ gnome-terminal clangd xclip nodejs npm
PackageDescriptiongitplugin managerg++C++ compilergnome-terminalfor running compiled programsclangdLanguage Server Protocol for autocompletion & diagnosticsxclipsystem clipboard supportnodejs & npmrequired for Treesitter parsers3. Setup Neovim ConfigClone this repository or copy init.lua to: ~/.config/nvim/init.luaOpen Neovim:Bashnvim
Wait for Lazy.nvim to automatically download and install plugins.⌨ KeybindingsNote: F-keys work in any mode (Normal, Insert, or Visual).KeyActionDetails<kbd>F4</kbd>Toggle CommentLine/Visual<kbd>F5</kbd>Copy entire fileTo system clipboard<kbd>F6</kbd>Format codeLSP or auto-indent<kbd>F8</kbd>Compile & RunOptimized: C++23, -O2 flags<kbd>F9</kbd>Compile & RunDebug: Sanitizer Address/Undefined
