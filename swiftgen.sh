#!/bin/bash
set -euo pipefail

# Конфиг SwiftGen
CONFIG_FILE="swiftgen.yml"

# Цвета для логов
BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"

# Лог для бренда
log_brand() {
    local brand="$1"
    echo -e "Генерация ресурсов для: ${BOLD}${YELLOW}${brand}${RESET}"
}

# Лог для шага
log_step() {
    local step="$1"
    echo -e "${YELLOW}${step}${RESET}"
}

# Универсальная функция запуска SwiftGen для заданного бренда
run_swiftgen() {
    local brand="$1"
    export TARGET_BRAND="$brand"
    log_brand "$brand"
    swiftgen config run --config "$CONFIG_FILE"
}

# Генерация ресурсов
if [[ $# -eq 1 ]]; then
    # Генерация для конкретного бренда + общие ресурсы
    run_swiftgen "$1"
    unset TARGET_BRAND
else
    # Генерация для всех брендов
    BRANDS=("Brewsell" "Harucha")
    for BRAND in "${BRANDS[@]}"; do
        run_swiftgen "$BRAND"
    done
fi

echo -e "${BOLD}${GREEN}✅ Генерация ресурсов завершена${RESET}"
