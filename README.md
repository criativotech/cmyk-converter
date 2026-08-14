# 🎨 CMYK Converter CLI & Dolphin Integration

> Conversor interativo e inteligente de arquivos RGB para CMYK (Preimpressão Gráfica) para Linux, com suporte a terminal e integração ao Dolphin File Manager (KDE Plasma 5 e 6).

[![License: MIT](https://img.shields.io/badge/License-MIT-00FF44.svg?style=for-the-badge)](#)
[![Linux](https://img.shields.io/badge/OS-Linux-00CED1?style=for-the-badge&logo=linux&logoColor=white)](#)
[![KDE Plasma](https://img.shields.io/badge/KDE-Plasma%206-1D99F3?style=for-the-badge&logo=kde&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Shell-Bash-181717?style=for-the-badge&logo=gnu-bash&logoColor=white)](#)

---

## 📌 Sobre o Projeto

Converter arquivos visuais de **RGB (Telas)** para **CMYK (Impressão Gráfica)** mantendo vetores intactos e perfis de cor específicos (como **FOGRA39** ou **US Web Coated SWOP**) costuma ser um desafio no ecossistema de software livre.

O **CMYK Converter** é uma solução completa em Shell Script que:
1. **Identifica automaticamente o tipo de arquivo** (PDF, PNG, JPG, TIFF, WEBP).
2. **Varre o sistema em busca de perfis ICC instalados** e permite a escolha via menu interativo.
3. **Preserva vetores em arquivos PDF** usando o motor Ghostscript.
4. **Integra-se diretamente ao Dolphin (KDE)** pelo menu de contexto do botão direito (`CMYK > CONVERT`).

---

## 🛠️ Requisitos de Sistema

Certifique-se de ter instalado:
- **Ghostscript** (`gs`)
- **ImageMagick** (`magick` ou `convert`)
- **KDialog** (já nativo em ambientes KDE Plasma)

```bash
# openSUSE
sudo zypper in ghostscript ImageMagick kdialog

# Fedora
sudo dnf install ghostscript ImageMagick kdialog

# Arch Linux
sudo pacman -S ghostscript imagemagick kdialog

# Ubuntu / Debian
sudo apt install ghostscript imagemagick kdialog

```

## 🚀 Instalação em 1 Clique
Clone o repositório e rode o instalador:

Bash
```git clone [https://github.com/criativotech/cmyk-converter.git](https://github.com/criativotech/cmyk-converter.git)
cd cmyk-converter
chmod +x install.sh
./install.sh
```

## 🖥️ Formas de Uso
1. Pelo Dolphin (Interface Gráfica)
Clique com o botão direito sobre qualquer imagem ou PDF.

Acesse o submenu CMYK > CONVERT.

Selecione o perfil de cor na janela gráfica que abrir e confirme.

2. Pelo Terminal (CLI Interativo)
Execute em qualquer pasta:
Bash
```
cmyk-converter
```

Arraste o arquivo ou digite o caminho quando solicitado.

## 🗑️ Desinstalação
Para remover completamente o utilitário e os menus:
```
Bash
./uninstall.sh
```

## ⭐ Apoie o Projeto
Desenvolvido por Criativotech para a comunidade de criadores visuais no Linux. Se este projeto ajudou seu fluxo de impressão, deixe uma estrela ⭐ no repositório!

---

## Autor

-   **criativotech**

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/K3K01KWCZW)
---
