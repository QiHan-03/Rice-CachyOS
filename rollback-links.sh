#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="${1:?Usage: bash rollback-links.sh BACKUP_DIRECTORY}"
SRC="$REPO/.config"
DEST="$HOME/.config"

BACKUP="$(realpath "$BACKUP")"

if [[ ! -d "$BACKUP" ]]; then
    echo "Backup directory not found: $BACKUP"
    exit 1
fi

if [[ "$BACKUP" != "$HOME/.config-backups/"* ]]; then
    echo "Refusing unexpected backup location"
    exit 1
fi

# Remove symlinks created by the deployment,
# including links for files that had no previous version.
while IFS= read -r -d '' file; do
    rel="${file#"$SRC"/}"
    target="$DEST/$rel"

    if [[ -L "$target" ]] &&
       [[ "$(readlink -f "$target")" == "$(readlink -f "$file")" ]]; then
        rm -- "$target"
        echo "Unlinked: $rel"
    fi
done < <(find "$SRC" \( -type f -o -type l \) -print0)

# Restore files saved during deployment.
while IFS= read -r -d '' file; do
    rel="${file#"$BACKUP"/}"
    target="$DEST/$rel"

    mkdir -p "$(dirname "$target")"

    if [[ -e "$target" || -L "$target" ]]; then
        echo "Skipping occupied destination: $rel"
        continue
    fi

    mv -- "$file" "$target"
    echo "Restored: $rel"
done < <(find "$BACKUP" \( -type f -o -type l \) -print0)

echo "Rollback finished."
