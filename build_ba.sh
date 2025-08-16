#!/bin/bash
# build_ba.sh
# Lukas Batschelet
# 2025-08-16
# Skript zum Kompilieren der Bachelorarbeit und Aktualisieren der Website
# Das Skript erstellt ein Versioniertes PDF der Bachelorarbeit und kopiert es in das Submodul intermind.ch/static-docs
# Das Skript kann mit ./build_ba.sh ausgeführt werden.

set -euo pipefail


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# === Konfiguration ===
# LaTeX
MAIN_TEX_FILE="Arbeit/main.tex"
OUTPUT_DIR="Arbeit/out"
ARCHIVE_DIR="Arbeit/archiv"
TOP_LEVEL_DIR="."                             
BASE_PDF_NAME="main.pdf"
FINAL_NAME_PREFIX="Bachelorarbeit_Lukas_Batschelet"

# Website/Submodule
SUBMODULE_DIR="intermind.ch"                 
WEB_DOC_DIR="${SUBMODULE_DIR}/static-docs"
STABLE_WEB_NAME="Bachelorarbeit_Lukas_Batschelet.pdf"

# Git-Automation fürs Submodule
PUSH_SUBMODULE="${PUSH_SUBMODULE:-true}"
SUBMODULE_BRANCH_DEFAULT="${SUBMODULE_BRANCH_DEFAULT:-main}"

echo "--- Starte Build-Prozess für Bachelorarbeit ---"
echo "[DEBUG] SCRIPT_DIR=$SCRIPT_DIR"
echo "[DEBUG] SUBMODULE_DIR=$SUBMODULE_DIR"
echo "[DEBUG] WEB_DOC_DIR=$WEB_DOC_DIR"

# 1) Verzeichnisse
echo "[1] Erstelle Verzeichnisse (falls nötig)..."
mkdir -p "$OUTPUT_DIR" "$ARCHIVE_DIR"

# 2) latexmk
echo "[2] Führe latexmk aus (Output → '$OUTPUT_DIR')..."
latexmk -pdf -outdir="$OUTPUT_DIR" -jobname="${BASE_PDF_NAME%.pdf}" "$MAIN_TEX_FILE"

# 3) Ergebnis prüfen
COMPILED_PDF="$OUTPUT_DIR/$BASE_PDF_NAME"
if [ ! -f "$COMPILED_PDF" ]; then
  echo "!!! FEHLER: Kompilierte PDF '$COMPILED_PDF' nicht gefunden!"
  exit 1
fi
echo "    Latexmk erfolgreich."

# 4) Versioniertes PDF ins Top-Level
TIMESTAMP="$(date +'%Y%m%d_%H%M')"
FINAL_PDF_NAME="${TIMESTAMP}_${FINAL_NAME_PREFIX}.pdf"
FINAL_PDF_PATH="$TOP_LEVEL_DIR/$FINAL_PDF_NAME"

echo "[3] Archiviere Vorversionen & verschiebe neues PDF..."
find "$TOP_LEVEL_DIR" -maxdepth 1 -type f -name "*_${FINAL_NAME_PREFIX}.pdf" -print -exec mv {} "$ARCHIVE_DIR/" \;
mv "$COMPILED_PDF" "$FINAL_PDF_PATH"
echo "    Neu: $FINAL_PDF_PATH"

# 5) Kopie für Website (stabiler Name)
echo "[4] Aktualisiere Website-Datei → ${WEB_DOC_DIR}/${STABLE_WEB_NAME}"
mkdir -p "$WEB_DOC_DIR"

echo "    Quelle: $(pwd)/$FINAL_PDF_PATH"
echo "    Ziel:   $(pwd)/${WEB_DOC_DIR}/${STABLE_WEB_NAME}"

if [ ! -f "$FINAL_PDF_PATH" ]; then
  echo "!!! FEHLER: Quelle fehlt: $FINAL_PDF_PATH"
  exit 1
fi

cp -fv "$FINAL_PDF_PATH" "${WEB_DOC_DIR}/${STABLE_WEB_NAME}"

# Direkt verifizieren:
if [ -f "${WEB_DOC_DIR}/${STABLE_WEB_NAME}" ]; then
  echo "    OK: Kopiert -> ${WEB_DOC_DIR}/${STABLE_WEB_NAME}"
else
  echo "!!! FEHLER: Datei nach cp NICHT vorhanden!"
  ls -la "${WEB_DOC_DIR}" || true
  exit 1
fi

# 6) Submodule commit/push + Pointer im Hauptrepo
if [ -d "$SUBMODULE_DIR" ]; then
  echo "[5] Git-Update im Submodule (${SUBMODULE_DIR})..."
  CURR_BRANCH="$(git -C "$SUBMODULE_DIR" rev-parse --abbrev-ref HEAD || echo HEAD)"
  if [ "$CURR_BRANCH" = "HEAD" ]; then
    echo "    Submodule in detached HEAD → Branch anlegen/wechseln…"
    git -C "$SUBMODULE_DIR" switch -c analyse-update || git -C "$SUBMODULE_DIR" checkout analyse-update
    CURR_BRANCH="analyse-update"
  fi

  git -C "$SUBMODULE_DIR" add "static-docs/${STABLE_WEB_NAME}"
  git -C "$SUBMODULE_DIR" commit -m "Update Dokumentation: ${STABLE_WEB_NAME} ($(date '+%Y-%m-%d %H:%M'))" || echo "    Nichts zu committen."

  if [ "$PUSH_SUBMODULE" = "true" ]; then
    echo "    Push → origin/${CURR_BRANCH}…"
    git -C "$SUBMODULE_DIR" push -u origin "$CURR_BRANCH" || echo "    WARN: Push fehlgeschlagen."
  else
    echo "    Push übersprungen (PUSH_SUBMODULE=false)."
  fi

  echo "    Aktualisiere Submodule-Pointer im Hauptrepo…"
  git add "$SUBMODULE_DIR"
  git commit -m "Update Submodule-Pointer: ${SUBMODULE_DIR}" || echo "    Nichts zu committen im Hauptrepo."
else
  echo "    WARN: Submodule-Verzeichnis '${SUBMODULE_DIR}' nicht gefunden – Git-Schritte übersprungen."
fi

# 7) Wörter zählen (best-effort)
echo "[6] Zähle Wörter (Total + pro Section)..."
texcount -inc -q -sub=section \
  -template='Gesamt: {sum}\n{SUB?{title}: {sum}\n?SUB}' \
  "$MAIN_TEX_FILE" || true

echo "--- Build-Prozess beendet ---"
exit 0
