
#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO/.config"
DEST="$HOME/.config"
BACKUP="$HOME/.config-backups/deploy-$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${1:-}"

if [[ ! -d "$SRC" ]]; then
    echo "Repository .config directory not found"
    exit 1
fi

# Files managed by the theme generator, not symlinked
GENERATED=(
    "kitty/matugen.conf"
    "hypr/hyprlock-colors.conf"
    "gtk-3.0/colors.css"
    "gtk-4.0/colors.css"
    "gtk-3.0/settings.ini"
    "gtk-4.0/settings.ini"
    "rofi/colors.rasi"
    "quickshell/Theme.qml"
)

count=0

while IFS= read -r -d '' file; do
    rel="${file#"$SRC"/}"

    # Skip generated files
    skip=false
    for g in "${GENERATED[@]}"; do
        if [[ "$rel" == "$g" ]]; then
            skip=true
            break
        fi
    done
    [[ "$skip" == true ]] && continue

    target="$DEST/$rel"

    # Already linked to the correct file
    if [[ -L "$target" ]] &&
       [[ "$(readlink -f "$target")" == "$(readlink -f "$file")" ]]; then
        continue
    fi

    if [[ "$DRY_RUN" == "--dry-run" ]]; then
        echo "Would link: $rel"
        ((count+=1))
        continue
    fi

    mkdir -p "$(dirname "$target")"

    # Preserve the previous file or symlink
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP/$(dirname "$rel")"
        mv "$target" "$BACKUP/$rel"
    fi

    ln -s "$file" "$target"
    echo "Linked: $rel"
    ((count+=1))

done < <(find "$SRC" \( -type f -o -type l \) -print0)

echo "Processed $count files."
echo "Backup location: $BACKUP"
