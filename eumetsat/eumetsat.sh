#!/bin/bash
./download.sh
./archive.py

rm -f last_im.jpg
LAST_IM=$(ls -t ./data1/*.jpg | head -1)
ln -s ${LAST_IM} last_im.jpg
gm convert -filter Sinc -resize x200 last_im.jpg eumetsat_im.png

rm -f last_cz.jpg
LAST_CZ=$(ls -t ./data2/*.jpg | head -1)
ln -s ${LAST_CZ} last_cz.jpg
gm composite -filter Sinc -resize x200  msgcz.hranice.png -resize x200 last_cz.jpg eumetsat_cz.png

