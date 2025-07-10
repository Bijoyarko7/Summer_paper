#!/usr/bin/env bash
set -euo pipefail

# ─────────── Config ───────────
PAPERS_DIR="Papers"                # where your PDFs live
WORKING_DIR="working"              # scratch space
TABLES_BASE="data/tables"          # root for CSVs
IMAGES_BASE="data/images"          # root for images
PROCESS_SCRIPT="scripts/process_pdf.py"
# ─────────────────────────────────

# make sure our folders exist
mkdir -p "$WORKING_DIR" "$TABLES_BASE" "$IMAGES_BASE"

# loop over every PDF under $PAPERS_DIR
find "$PAPERS_DIR" -type f -name '*.pdf' | while IFS= read -r pdf; do
  stem=$(basename "$pdf" .pdf)
  name=${stem// /_}
  echo -e "\n=== Processing $name ==="

  # 1) flatten
  flat="$WORKING_DIR/${name}_flat.pdf"
  gs -q \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dNOPAUSE -dBATCH -dSAFER \
    -sOutputFile="$flat" \
    "$pdf"

  # 2) quick text-check; if <100 chars, OCR it
  if ! python - <<EOF
import pdfplumber
with pdfplumber.open("$flat") as D:
    total = sum(len(p.extract_text() or "") for p in D.pages)
print(total > 100)
EOF
  then
    echo "→ OCR’ing $name …"
    ocrmypdf -q "$flat" "$flat"
  fi

  # 3) extract tables & images
  python "$PROCESS_SCRIPT" \
    "$flat" \
    "$TABLES_BASE/$name" \
    "$IMAGES_BASE/$name"

  # 4) warn if no tables
  if [ -f "$TABLES_BASE/$name/FAILED.txt" ]; then
    echo "⚠️  No tables found: $TABLES_BASE/$name/FAILED.txt"
  fi
done

echo -e "\n✅  All done!"
echo "Tables → $TABLES_BASE/"
echo "Images → $IMAGES_BASE/"
