#!/usr/bin/env bash
# ==============================================================================
# BASH NA PISTA - https://github.com/criativotech/cmyk-converter
# AUTOR - criativotech
# Script: cmyk-converter.sh
# Descrição: Conversor interativo RGB -> CMYK para Imagens e PDFs (Preimpressão)
# Uso: ./cmyk-converter.sh
# ==============================================================================

set -euo pipefail

# Cores do Terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "  /===========================================\\"
echo "  |      BASH NA PISTA - INTERACTIVE CLI      |"
echo "  |       Conversor Profissional para CMYK    |"
echo "  \\===========================================/"
echo -e "${NC}"

# 1. Pergunta o caminho do arquivo
read -rp "$(echo -e "${YELLOW}📁 Arraste ou digite o caminho do arquivo (PDF, PNG, JPG, TIFF): ${NC}")" FILE_INPUT

# Limpa aspas do caminho se arrastado para o terminal
FILE_INPUT="${FILE_INPUT//\'/}"
FILE_INPUT="${FILE_INPUT//\"/}"

if [[ ! -f "${FILE_INPUT}" ]]; then
    echo -e "${RED}[ERRO] Arquivo não encontrado: ${FILE_INPUT}${NC}"
    exit 1
fi

# Extrai extensão e diretório
FILENAME=$(basename -- "${FILE_INPUT}")
EXT="${FILENAME##*.}"
EXT_LOWER=$(echo "${EXT}" | tr '[:upper:]' '[:lower:]')
DIRNAME=$(dirname -- "${FILE_INPUT}")
OUTPUT_FILE="${DIRNAME}/${FILENAME%.*}_cmyk.${EXT_LOWER}"

echo -e "\n${GREEN}[✓] Arquivo detectado:${NC} ${FILENAME} (Formato: ${EXT_LOWER})"

# 2. Varredura de Perfis ICC no Sistema
echo -e "\n${CYAN}🔍 Buscando perfis ICC instalados no seu sistema...${NC}"

mapfile -t ICC_PROFILES < <(find /usr/share/color/icc ~/.local/share/icc ~/.color/icc -type f -iname "*.icc" -o -iname "*.icm" 2>/dev/null)

SELECTED_PROFILE=""

if [[ ${#ICC_PROFILES[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Perfis de Cor ICC encontrados:${NC}"
    echo "  [0] Usar conversão CMYK padrão (Sem perfil específico)"

    i=1
    for profile in "${ICC_PROFILES[@]}"; do
        echo "  [$i] $(basename "${profile}")"
        ((i++))
    done

    read -rp "$(echo -e "${YELLOW}Escolha o número do perfil desejado [0-$((i-1))]: ${NC}")" PROFILE_CHOICE

    if [[ "$PROFILE_CHOICE" -gt 0 && "$PROFILE_CHOICE" -lt "$i" ]]; then
        SELECTED_PROFILE="${ICC_PROFILES[$((PROFILE_CHOICE-1))]}"
        echo -e "${GREEN}[✓] Perfil selecionado:${NC} $(basename "${SELECTED_PROFILE}")"
    else
        echo -e "${GREEN}[✓] Usando conversão CMYK genérica do sistema.${NC}"
    fi
else
    echo -e "${YELLOW}[!] Nenhum perfil ICC encontrado nas pastas padrão do sistema. Usando CMYK genérico.${NC}"
fi

echo -e "\n${GREEN}[+] Processando conversão... Aguarde.${NC}"

# 3. Identificação e Execução por Formato
case "${EXT_LOWER}" in
    pdf)
        # Processa PDF com Ghostscript
        if ! command -v gs &> /dev/null; then
            echo -e "${RED}[ERRO] Ghostscript (gs) não instalado! Instale com: sudo zypper in ghostscript${NC}"
            exit 1
        fi

        GS_PROFILE_ARGS="-sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK"
        if [[ -n "${SELECTED_PROFILE}" ]]; then
            GS_PROFILE_ARGS+=" -sOutputICCProfile=\"${SELECTED_PROFILE}\""
        fi

        eval gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
             ${GS_PROFILE_ARGS} \
             -sOutputFile="\"${OUTPUT_FILE}\"" "\"${FILE_INPUT}\"" -loglevel quiet
        ;;

    png|jpg|jpeg|tif|tiff|webp)
        # Processa Imagem com ImageMagick
        if command -v magick &> /dev/null; then
            CMD="magick"
        elif command -v convert &> /dev/null; then
            CMD="convert"
        else
            echo -e "${RED}[ERRO] ImageMagick não encontrado!${NC}"
            exit 1
        fi

        if [[ -n "${SELECTED_PROFILE}" ]]; then
            $CMD "${FILE_INPUT}" -profile "${SELECTED_PROFILE}" "${OUTPUT_FILE}"
        else
            $CMD "${FILE_INPUT}" -colorspace CMYK "${OUTPUT_FILE}"
        fi
        ;;

    *)
        echo -e "${RED}[ERRO] Formato de arquivo '.${EXT_LOWER}' não suportado para conversão CMYK.${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}[✓] CONVERSÃO CONCLUÍDA COM SUCESSO!${NC}"
echo -e "📄 Arquivo Gerado: ${CYAN}${OUTPUT_FILE}${NC}"
echo -e "${GREEN}======================================================${NC}"
