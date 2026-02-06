Neovim C++ Development EnvironmentThis is a custom Neovim configuration optimized for C++ development (C++23) and competitive programming. It features auto-saving, session management, and integrated one-click compilation and execution in a separate terminal.

🛠️ Features
Colorscheme: Koda (Dark/Modern).
LSP: clangd for C++ autocompletion and diagnostics.
Treesitter: Advanced syntax highlighting.
Auto-Compile: Built-in logic for optimized (F8) and sanitized (F9) C++ builds.
Session Management: Automatically restores open buffers and cursor positions.

📥 Installation (Linux / Ubuntu)
To use this config, you need to install the following system dependencies:

# 1. Update your system
sudo apt update

# 2. Install Git (Plugin Manager), G++ (Compiler), and GNOME Terminal
sudo apt install git g++ gnome-terminal

# 3. Install Clangd (Language Server Protocol)
sudo apt install clangd

# 4. Install xclip (Enables system clipboard support)
sudo apt install xclip

# 5. Install Node.js & NPM (Required for Treesitter parsers)
sudo apt install nodejs npm

Setup the Config
Clone this repository or copy init.lua to: ~/.config/nvim/init.lua
Open Neovim: nvim
Wait for Lazy.nvim to automatically download and install the plugins.

⌨️ KeybindingsKeyAction
F4 -> Toggle Comment (Line/Visual)
F5 -> Copy whole file to system clipboard
F6 -> Format code (LSP or Auto-indent)
F8 -> Compile & Run (Optimized): C++23, -O2 flags
F9 -> Compile & Run (Debug): Sanitize Address/Undefined
The F keys works regardless of which mode you are on.
