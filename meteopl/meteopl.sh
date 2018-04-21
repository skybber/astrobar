#!/bin/bash
WORK_DIR="${HOME}/workspaces/workspace/astrows/meteopl"
wget -q -O ${WORK_DIR}/forecast.png `prognoza_pogody_url.py`
gm convert -filter Sinc -crop 540x310 -resize x200 ${WORK_DIR}/forecast.png ${WORK_DIR}/forecast1.png
gm convert -filter Sinc -crop 540x320+0+310 -resize x200 ${WORK_DIR}/forecast.png ${WORK_DIR}/forecast2.png
