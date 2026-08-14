```
# 🎨 CMYK Converter CLI

> Conversor interativo e inteligente de arquivos RGB para CMYK (Preimpressão Gráfica) em Linux.

[![License: MIT](https://img.shields.io/badge/License-MIT-00FF44.svg?style=for-the-badge)](#)
[![Linux](https://img.shields.io/badge/OS-Linux-00CED1?style=for-the-badge&logo=linux&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Shell-Bash-181717?style=for-the-badge&logo=gnu-bash&logoColor=white)](#)

---

## 📌 Sobre o Projeto

Converter arquivos visuais de **RGB (Telas)** para **CMYK (Impressão Gráfica)** mantendo vetores intactos e perfis de cor específicos (como **FOGRA39** ou **US Web Coated SWOP**) costuma ser um desafio no ecossistema de software livre.

O **CMYK Converter CLI** é um script Shell interativo que:
1. **Identifica automaticamente o tipo de arquivo** (PDF, PNG, JPG, TIFF, WEBP).
2. **Varre o sistema em busca de perfis ICC instalados** e permite a escolha via menu numérico.
3. **Preserva vetores em arquivos PDF** usando o motor Ghostscript.
4. **Aplica o perfil e converte imagens em lote/individual** via ImageMagick.

---

## 🛠️ Requisitos de Sistema

Certifique-se de ter instalado no seu sistema Linux:

- **Ghostscript** (para conversão e preservação de PDFs)
- **ImageMagick** (para conversão de formatos de imagem)

### Instalação das Dependências:

- **openSUSE:**
  ```bash
  sudo zypper in ghostscript ImageMagick
```

- **Arch Linux:**
    
    Bash
    
    ```
    sudo pacman -S ghostscript imagemagick
    ```
    
- **Ubuntu / Debian:**
    
    Bash
    
    ```
    sudo apt install ghostscript imagemagick
    ```
    

## 🚀 Como Instalar e Usar

### 1. Clonar o Repositório

Bash

```
git clone [https://github.com/criativotech/cmyk-converter.git](https://github.com/criativotech/cmyk-converter.git)
cd cmyk-converter
```

### 2. Conceder Permissão de Execução

Bash

```
chmod +x cmyk-converter.sh
```

### 3. Executar o Script

Bash

```
./cmyk-converter.sh
```

## 💡 Instalação Global no Sistema (Opcional)

Para rodar o comando `cmyk-converter` de qualquer pasta do seu terminal sem precisar navegar até o repositório:

Bash

```
sudo cp cmyk-converter.sh /usr/local/bin/cmyk-converter
sudo chmod +x /usr/local/bin/cmyk-converter
```

Agora basta digitar `cmyk-converter` em qualquer lugar do seu terminal!

## ⭐ Apoie o Projeto

Desenvolvido por **Criativotech** para a comunidade de criadores visuais no Linux. Se esta ferramenta ajudou seu workflow de impressão, deixe uma **estrela ⭐** neste repositório!

## Autor

-   **criativotech**

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/K3K01KWCZW)
---
