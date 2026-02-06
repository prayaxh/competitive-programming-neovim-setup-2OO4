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
git → plugin managerg++ → C++ compilergnome-terminal → for running compiled programsclangd → Language Server Protocol for autocompletion & diagnosticsxclip → system clipboard supportnodejs & npm → required for Treesitter parsers3. Setup Neovim ConfigClone this repository or copy init.lua to: ~/.config/nvim/init.luaOpen Neovim:Bashnvim
Wait for Lazy.nvim to automatically download and install plugins.⌨ KeybindingsKeyActionF4Toggle Comment (Line/Visual)F5Copy entire file to system clipboardF6Format code (LSP or auto-indent)F8Compile & Run (Optimized: C++23, -O2 flags)F9Compile & Run (Debug: Sanitizer Address/Undefined)
