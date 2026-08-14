cat << 'EOF' > cmyk-converter-gui.sh
#!/usr/bin/env bash
# ==============================================================================
# CMYK Converter GUI - Dolphin Service Menu
# ==============================================================================

# Pega o primeiro arquivo passado como argumento
FILE_INPUT="${1:-}"

if [[ -z "${FILE_INPUT}" || ! -f "${FILE_INPUT}" ]]; then
    kdialog --title "CMYK Converter" --error "Nenhum arquivo válido foi selecionado.\nCaminho recebido: '${FILE_INPUT}'"
    exit 1
fi

FILENAME=$(basename -- "${FILE_INPUT}")
EXT="${FILENAME##*.}"
EXT_LOWER=$(echo "${EXT}" | tr '[:upper:]' '[:lower:]')
DIRNAME=$(dirname -- "${FILE_INPUT}")
OUTPUT_FILE="${DIRNAME}/${FILENAME%.*}_cmyk.${EXT_LOWER}"

# Varredura de Perfis ICC instalados
PROFILES=()
while IFS= read -r p; do
    [[ -n "$p" ]] && PROFILES+=("$p")
done < <(find /usr/share/color/icc /usr/share/icc ~/.local/share/icc ~/.color/icc -type f \( -iname "*.icc" -o -iname "*.icm" \) 2>/dev/null)

# Monta menu para o KDialog
MENU_ARGS=("0" "CMYK Padrao (Sem Perfil Especifico)" "on")

i=1
for p in "${PROFILES[@]}"; do
    MENU_ARGS+=("$i" "$(basename "$p")" "off")
    ((i++))
done

CHOICE=$(kdialog --title "CMYK Converter" --radiolist "Selecione o Perfil ICC para converter:\n${FILENAME}" "${MENU_ARGS[@]}" 2>/dev/null)

# Se o usuário clicou em Cancelar
if [[ $? -ne 0 || -z "$CHOICE" ]]; then
    exit 0
fi

SELECTED_PROFILE=""
if [[ "$CHOICE" != "0" ]]; then
    SELECTED_PROFILE="${PROFILES[$((CHOICE-1))]}"
fi

notify-send "CMYK Converter" "Iniciando conversao de ${FILENAME}..." -i document-print

# Execução por tipo de arquivo
case "${EXT_LOWER}" in
    pdf)
        if ! command -v gs &> /dev/null; then
            kdialog --title "Erro" --error "Ghostscript (gs) nao encontrado no sistema."
            exit 1
        fi

        GS_ARGS=(-dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK)
        if [[ -n "${SELECTED_PROFILE}" ]]; then
            GS_ARGS+=("-sOutputICCProfile=${SELECTED_PROFILE}")
        fi
        GS_ARGS+=("-sOutputFile=${OUTPUT_FILE}" "${FILE_INPUT}")

        if ! gs "${GS_ARGS[@]}" &>/dev/null; then
            kdialog --title "Erro" --error "Falha ao processar o PDF com Ghostscript."
            exit 1
        fi
        ;;

    png|jpg|jpeg|tif|tiff|webp)
        CMD=""
        if command -v magick &> /dev/null; then
            CMD="magick"
        elif command -v convert &> /dev/null; then
            CMD="convert"
        else
            kdialog --title "Erro" --error "ImageMagick nao instalado."
            exit 1
        fi

        if [[ -n "${SELECTED_PROFILE}" ]]; then
            "$CMD" "${FILE_INPUT}" -profile "${SELECTED_PROFILE}" "${OUTPUT_FILE}"
        else
            "$CMD" "${FILE_INPUT}" -colorspace CMYK "${OUTPUT_FILE}"
        fi
        ;;

    *)
        kdialog --title "Erro" --error "Formato '.${EXT_LOWER}' nao suportado."
        exit 1
        ;;
esac

notify-send "CMYK Converter" "Arquivo convertido com sucesso!\nSalvo em: ${OUTPUT_FILE}" -i document-print
EOF
