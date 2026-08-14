cat << 'EOF' > uninstall.sh
#!/usr/bin/env bash
# ==============================================================================
# CMYK Converter - Desinstalador
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[!] Removendo CMYK Converter do sistema...${NC}"

# Remove binários
rm -f "$HOME/.local/bin/cmyk-converter"
rm -f "$HOME/.local/bin/cmyk-converter-gui.sh"

# Remove Service Menus
rm -f "$HOME/.local/share/kio/servicemenus/cmyk-converter.desktop"
rm -f "$HOME/.local/share/kservices5/ServiceMenus/cmyk-converter.desktop"

# Atualiza cache do KDE
if command -v kbuildsycoca6 &> /dev/null; then
    kbuildsycoca6 --noincremental &>/dev/null || true
elif command -v kbuildsycoca5 &> /dev/null; then
    kbuildsycoca5 --noincremental &>/dev/null || true
fi

echo -e "${GREEN}[✓] CMYK Converter removido com sucesso.${NC}"
EOF

chmod +x uninstall.sh
