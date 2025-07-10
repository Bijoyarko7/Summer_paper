#!/usr/bin/env python3
"""
process_pdf.py

Usage: python process_pdf.py <PDF_PATH> <TABLES_OUT_DIR> <IMAGES_OUT_DIR>
"""
import sys
from pathlib import Path

import camelot       # pip install "camelot-py[cv]"
import tabula        # pip install tabula-py
import pdfplumber    # pip install pdfplumber
import fitz          # pip install PyMuPDF
import pandas as pd  # pip install pandas

def extract_tables(pdf_path, tables_out_dir):
    base = Path(tables_out_dir)
    base.mkdir(parents=True, exist_ok=True)

    # 1) Camelot: try stream then lattice
    for flavor in ("stream", "lattice"):
        sub = base / flavor
        sub.mkdir(exist_ok=True)
        try:
            tables = camelot.read_pdf(str(pdf_path), pages="all", flavor=flavor)
            if tables:
                print(f"[camelot:{flavor}] {len(tables)} tables")
                for i, table in enumerate(tables, start=1):
                    table.to_csv(sub / f"table_{i}.csv", index=False)
                return
        except Exception as e:
            print(f"[camelot:{flavor}] error:", e)

    # 2) Fallback to tabula-py
    try:
        dfs = tabula.read_pdf(str(pdf_path), pages="all", multiple_tables=True)
        if dfs:
            sub = base / "tabula"
            sub.mkdir(exist_ok=True)
            print(f"[tabula] {len(dfs)} tables")
            for i, df in enumerate(dfs, start=1):
                (sub / f"table_{i}.csv").write_text(df.to_csv(index=False))
            return
    except Exception as e:
        print("[tabula] error:", e)

    # 3) Last-resort pdfplumber
    sub = base / "pdfplumber"
    sub.mkdir(exist_ok=True)
    count = 0
    with pdfplumber.open(str(pdf_path)) as doc:
        for pg_num, page in enumerate(doc.pages, start=1):
            for tbl_i, tbl in enumerate(page.extract_tables(), start=1):
                df = pd.DataFrame(tbl[1:], columns=tbl[0])
                df.to_csv(sub / f"page{pg_num}_table{tbl_i}.csv", index=False)
                count += 1
    if count:
        print(f"[pdfplumber] {count} tables")
        return

    # 4) Nothing at all → flag for manual review
    (base / "FAILED.txt").write_text("No tables found\n")
    print("[FAIL] no tables extracted")

def extract_images(pdf_path, images_out_dir):
    out = Path(images_out_dir)
    out.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(str(pdf_path))
    total = 0
    for p in range(len(doc)):
        for idx, img in enumerate(doc.get_page_images(p), start=1):
            pix = fitz.Pixmap(doc, img[0])
            ext = "png" if pix.alpha else "jpg"
            pix.save(str(out / f"page{p+1}_img{idx}.{ext}"))
            pix = None
            total += 1
    print(f"[images] {total} images")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    pdf_path, tables_dir, images_dir = sys.argv[1:]
    print(f"→ Processing {pdf_path}")
    extract_tables(pdf_path, tables_dir)
    extract_images(pdf_path, images_dir)
    print("✅ Finished.\n")
