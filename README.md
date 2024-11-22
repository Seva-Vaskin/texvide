<div align="center">
  <img src="img/logo.svg" alt="TexVIDE Logo" width="200"/>
  <h1>TexVIDE</h1>
  <p>A powerful LaTeX IDE built on Neovim with Docker integration</p>
</div>

<div align="center">
  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)
[![Platform](https://img.shields.io/badge/Platform-OSX-blue.svg)](https://www.apple.com/macos/)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)](https://neovim.io/)

</div>

## 🚀 Quick Start

### Supported platforms

- `Linux`
- `OSX` (unstable)

### Prerequisites

#### Common

- Docker
- [Nerd fonts](https://www.nerdfonts.com/)
- Python 3.10+

#### Linux specific prerequisites

- xhost

#### OSX specific prerequisites

- [iTerm2](https://iterm2.com/) (it is highly recommended to use iTerm2 to work with TexVIDE)
- python-tk (`brew install python-tk`)

### Installation

1. Install [prerequisites](#prerequisites)

2. Clone the repository:

    ```bash
    git clone https://github.com/Seva-Vaskin/texvide.git
    ```

3. Enter the project directory:

    ```bash
    cd texvide
    ```

4. Run the installation script:

    ```bash
    ./install.sh
    ```

### Notes

The installation script will:
1. Check for Docker installation
2. Set up the TexVIDE environment
3. Create necessary configuration files
4. Add TexVIDE to your PATH

## 📖 Documentation

**Note:** documentation is outdated :)

- [🔑 Hotkeys Guide](docs/hotkeys.md)
- [✂️ Snippets Reference](docs/snippets.md)

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [VimTeX](https://github.com/lervag/vimtex) - The core LaTeX plugin
- [UltiSnips](https://github.com/SirVer/ultisnips) - The snippet engine
- [gillescastel/latex-snippets](https://github.com/gillescastel/latex-snippets) - Inspiration for our snippet system
