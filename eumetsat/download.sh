#!/bin/bash
YCURD=$(date -d "yesterday 13:00" +"%Y%m%d")
CURD=$(date +"%Y%m%d")
wget -q -r -l 1 -A "msgce.ir.${YCURD}*.jpg" --directory-prefix data1/ --no-directories -nc -c http://portal.chmi.cz/files/portal/docs/meteo/sat/msg_hrit/img-msgce-ir/
wget -q -r -l 1 -A "msgcz.24M.${YCURD}*.jpg" --directory-prefix data2/ --no-directories -nc -c http://portal.chmi.cz/files/portal/docs/meteo/sat/msg_hrit/img-msgcz-24M/
wget -q -r -l 1 -A "msgce.ir.${CURD}*.jpg" --directory-prefix data1/ --no-directories -nc -c http://portal.chmi.cz/files/portal/docs/meteo/sat/msg_hrit/img-msgce-ir/
wget -q -r -l 1 -A "msgcz.24M.${CURD}*.jpg" --directory-prefix data2/ --no-directories -nc -c http://portal.chmi.cz/files/portal/docs/meteo/sat/msg_hrit/img-msgcz-24M/
