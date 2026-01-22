#!/bin/bash
WORKDIR=$(pwd)
echo "alias magic='$WORKDIR/.new/refresh.sh'" >> ~/.bashrc
echo "alias save='$WORKDIR/.new/save.sh'" >> ~/.bashrc

LOG_FILE=".scripts/monitor_extensions.log"
BASE_EXTENSIONS_FILE=".scripts/base_extensions.json"
CURRENT_EXTENSIONS_FILE="/home/codespace/.vscode-remote/extensions/extensions.json"

# Make sure the directory exists
mkdir -p "$(dirname "$LOG_FILE")"

echo "$(date): Skrypt monitor_extensions.sh został uruchomiony" >> "$LOG_FILE"

check_extensions() {
    echo "$(date): Sprawdzanie rozszerzeń..." >> "$LOG_FILE"

    if [ ! -f "$CURRENT_EXTENSIONS_FILE" ]; then
        echo "$(date): Plik $CURRENT_EXTENSIONS_FILE nie istnieje" >> "$LOG_FILE"
        return
    fi

    declare -A base_ids_map
    while IFS= read -r base_id; do
        base_ids_map["$base_id"]=1
    done < <(jq -r '.[] | .identifier.id' "$BASE_EXTENSIONS_FILE")

    load_current_extensions() {
        jq -r '.[] | .identifier.id' "$CURRENT_EXTENSIONS_FILE"
    }

    current_ids=$(load_current_extensions)

    for current_id in $current_ids; do
        if [[ -z "${base_ids_map[$current_id]}" ]]; then
            path=$(jq -r --arg id "$current_id" '.[] | select(.identifier.id == $id) | .location.path' "$CURRENT_EXTENSIONS_FILE")
            if [ -n "$path" ]; then
                echo "$(date): Usuwam rozszerzenie $current_id z katalogu $path" >> "$LOG_FILE"
                rm -rf "$path"

                jq --arg id "$current_id" 'del(.[] | select(.identifier.id == $id))' "$CURRENT_EXTENSIONS_FILE" > "${CURRENT_EXTENSIONS_FILE}.tmp" && mv "${CURRENT_EXTENSIONS_FILE}.tmp" "$CURRENT_EXTENSIONS_FILE"
            fi
        fi
    done
}

while true; do
    check_extensions
    sleep 10
done