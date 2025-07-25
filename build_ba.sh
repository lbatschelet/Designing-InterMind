#!/bin/bash

# === Konfiguration ===
# Haupt-TeX-Datei (Pfad relativ zum Ort, wo das Skript liegt)
MAIN_TEX_FILE="Arbeit/main.tex" 
# Verzeichnis für Zwischen-/Logdateien (relativ zum Skript)
OUTPUT_DIR="Arbeit/out"
# Verzeichnis für alte PDF-Versionen (relativ zum Skript)
ARCHIVE_DIR="Arbeit/archiv"
# Oberstes Projektverzeichnis (wo das finale PDF landen soll)
TOP_LEVEL_DIR="." 
# Name, den das PDF von latexmk im OUTPUT_DIR erhält
BASE_PDF_NAME="main.pdf" 
# Fester Teil des finalen PDF-Namens
FINAL_NAME_PREFIX="Bachelorarbeit_Lukas_Batschelet"
# === Ende Konfiguration ===

# --- Skript-Logik ---

echo "--- Starte Build-Prozess für Bachelorarbeit ---"

# 1. Sicherstellen, dass die Verzeichnisse existieren
echo "[1] Erstelle Verzeichnisse (falls nötig)..."
mkdir -p "$OUTPUT_DIR"
mkdir -p "$ARCHIVE_DIR"

# 2. Latexmk ausführen, um PDF im OUTPUT_DIR zu erstellen
#    Stellt sicher, dass .latexmkrc für Glossar etc. verwendet wird!
echo "[2] Führe latexmk aus (Log/PDF nach '$OUTPUT_DIR')..."
latexmk -pdf -outdir="$OUTPUT_DIR" -jobname="${BASE_PDF_NAME%.pdf}" "$MAIN_TEX_FILE"

# 3. Prüfen, ob latexmk erfolgreich war
if [ $? -ne 0 ]; then
  echo "!!! FEHLER: latexmk ist fehlgeschlagen!"
  exit 1
fi

# 4. Prüfen, ob die PDF-Datei im Output-Verzeichnis erstellt wurde
COMPILED_PDF="$OUTPUT_DIR/$BASE_PDF_NAME"
if [ ! -f "$COMPILED_PDF" ]; then
  echo "!!! FEHLER: Kompilierte PDF '$COMPILED_PDF' nicht gefunden!"
  exit 1
fi
echo "    Latexmk erfolgreich abgeschlossen."

# 5. Zeitstempel generieren (Format: YYYYMMDD_HHMM)
TIMESTAMP=$(date +'%Y%m%d_%H%M')
FINAL_PDF_NAME="${TIMESTAMP}_${FINAL_NAME_PREFIX}.pdf"
FINAL_PDF_PATH="$TOP_LEVEL_DIR/$FINAL_PDF_NAME"

echo "[3] Bereite finales PDF vor: '$FINAL_PDF_NAME'"

# 6. Existierende(s) alte(s) PDF(s) im TOP_LEVEL_DIR archivieren
#    Suche nach Dateien, die auf _PREFIX.pdf enden und verschiebe sie
echo "    Suche und archiviere ggf. alte Version(en) nach '$ARCHIVE_DIR'..."
# 'find' ist sicherer als 'mv *...' falls es keine Dateien gibt oder bei speziellen Namen
find "$TOP_LEVEL_DIR" -maxdepth 1 -type f -name "*_${FINAL_NAME_PREFIX}.pdf" -print -exec mv {} "$ARCHIVE_DIR/" \;

# 7. Neue PDF-Datei verschieben und umbenennen
echo "    Verschiebe und benenne neue PDF nach '$FINAL_PDF_PATH'..."
mv "$COMPILED_PDF" "$FINAL_PDF_PATH"

if [ $? -eq 0 ]; then
  echo "[4] Erfolgreich abgeschlossen: '$FINAL_PDF_PATH' erstellt/aktualisiert."
else
  echo "!!! FEHLER: Konnte PDF nicht verschieben/umbenennen!"
  exit 1
fi

# Optional: Zwischen-Dateien löschen (auskommentiert lassen, wenn nicht gewünscht)
# echo "[Optional] Lösche Zwischen-Dateien..."
# latexmk -C -outdir="$OUTPUT_DIR" -jobname="${BASE_PDF_NAME%.pdf}" "$MAIN_TEX_FILE"
# Alternativ: rm -rf "$OUTPUT_DIR"

echo "[5] Zähle Wörter mit texcount..."
TEXCOUNT_OUTPUT=$(texcount -inc -sum -1 -sub "$MAIN_TEX_FILE")
echo "    Wortanzahl (gesamt): $TEXCOUNT_OUTPUT"


echo "--- Build-Prozess beendet ---"
exit 0