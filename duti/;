#!/usr/bin/env bash
# set_calibre.sh – make calibre default for all common ebook extensions
# usage: chmod +x set_calibre.sh && ./set_calibre.sh

APP_ID="net.kovidgoyal.calibre"

for ext in epub mobi azw azw3 azw4 kf8 fb2 txt rtf pdf djvu \
           chm cbr cbz cbt cbc lit lrf lrx pdb pml rb tcr oeb; do
  duti -s "$APP_ID" ."$ext" all
done

echo "ebook extensions now open with calibre"

