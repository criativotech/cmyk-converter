#!/usr/bin/env bash
# ==============================================================================
# CMYK Converter - Instalador Automático (CLI + Dolphin Service Menu)
# Compatível com KDE Plasma 5 e Plasma 6
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}======================================================"
echo "         INSTALADOR DO CMYK CONVERTER"
echo -e "======================================================${NC}\n"

# Diretórios de destino dinâmicos na HOME do usuário atual
BIN_DIR="$HOME/.local/bin"
MENU_DIR="$HOME/.local/share/kio/servicemenus"
MENU_DIR_LEGACY="$HOME/.local/share/kservices5/ServiceMenus"

mkdir -p "$BIN_DIR" "$MENU_DIR" "$MENU_DIR_LEGACY"

echo -e "${YELLOW}[1/3] Instalando scripts em $BIN_DIR...${NC}"
cp cmyk-converter.sh "$BIN_DIR/cmyk-converter"
chmod +x "$BIN_DIR/cmyk-converter"

cp cmyk-converter-gui.sh "$BIN_DIR/cmyk-converter-gui.sh"
chmod +x "$BIN_DIR/cmyk-converter-gui.sh"
echo -e "${GREEN}  ✓ Utilitários CLI e GUI instalados com sucesso.${NC}"

echo -e "\n${YELLOW}[2/3] Gerando Service Menu do Dolphin com caminho absoluto...${NC}"
cat << DESKTOP_EOF > "$MENU_DIR/cmyk-converter.desktop"
[Desktop Entry]
Type=Service
X-KDE-ServiceTypes=KonqPopupMenu/Plugin
MimeType=image/jpeg;image/png;image/tiff;image/webp;application/pdf;
Actions=ConvertToCMYK;
X-KDE-Submenu=CMYK
X-KDE-Submenu[pt_BR]=CMYK

[Desktop Action ConvertToCMYK]
Name=CONVERT
Name[pt_BR]=CONVERT
Icon=document-print
Exec=/bin/bash $BIN_DIR/cmyk-converter-gui.sh %u
DESKTOP_EOF

chmod +x "$MENU_DIR/cmyk-converter.desktop"
cp "$MENU_DIR/cmyk-converter.desktop" "$MENU_DIR_LEGACY/cmyk-converter.desktop" 2>/dev/null || true
echo -e "${GREEN}  ✓ Service Menu configurado com suporte ao Plasma 5 e 6.${NC}"

echo -e "\n${YELLOW}[3/3] Atualizando cache de serviços do KDE...${NC}"
if command -v kbuildsycoca6 &> /dev/null; then
    kbuildsycoca6 --noincremental &>/dev/null || true
elif command -v kbuildsycoca5 &> /dev/null; then
    kbuildsycoca5 --noincremental &>/dev/null || true
fi
echo -e "${GREEN}  ✓ Cache do KDE atualizado.${NC}"

echo -e "\n${CYAN}======================================================"
echo -e "${GREEN}  ✓ INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo -e "${CYAN}======================================================${NC}"
echo -e "• No Terminal: Digite ${YELLOW}cmyk-converter${NC} em qualquer pasta."
echo -e "• No Dolphin:  Botão direito em imagem/PDF > ${YELLOW}CMYK > CONVERT${NC}.\n"
