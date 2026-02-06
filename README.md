# Neovim C++ Development Environment

A custom **Neovim configuration** optimized for **C++23 development** and **competitive programming**. Includes **auto-saving**, **session management**, and **one-click compilation & execution** in a separate terminal.

## 🛠 Features

* **Colorscheme:** Koda (Dark / Modern)
* **LSP:** clangd for C++ autocompletion and diagnostics
* **Treesitter:** Advanced syntax highlighting
* **Auto-Compile:** Optimized (F8) and sanitized (F9) builds
* **Session Management:** Restores open buffers and cursor positions automatically

---

## 📥 Installation (Linux / Ubuntu)

### 1. Update your system
sudo apt update

### 2. Install required packages
sudo apt install git g++ gnome-terminal clangd xclip nodejs npm

* **git** -> plugin manager
* **g++** -> C++ compiler
* **gnome-terminal** -> for running compiled programs
* **clangd** -> Language Server Protocol for autocompletion & diagnostics
* **xclip** -> system clipboard support
* **nodejs & npm** -> required for Treesitter parsers

### 3. Setup Neovim Config
Clone this repository or copy init.lua to: ~/.config/nvim/init.lua

**Open Neovim:**
nvim

*Wait for Lazy.nvim to automatically download and install plugins.*

---

## ⌨ Keybindings

| Key | Action |
| :--- | :--- |
| **F4** | Toggle Comment (Line/Visual) |
| **F5** | Copy entire file to system clipboard |
| **F6** | Format code (LSP or auto-indent) |
| **F8** | Compile & Run (Optimized: C++23, -O2 flags) |
| **F9** | Compile & Run (Debug: Sanitizer Address/Undefined) |

**Note:** F-keys work in any mode (Normal, Insert, or Visual).
