#!/bin/bash
set -ueo pipefail
#2025-12-07 Iivari

if ! which lynx &> /dev/null ; then
  echo "this script requires lynx, please install it first."
fi

PB_URL="https://tetrissuomi.wordpress.com/tuloksia/pb-lista/"
echo -e "\ngathering results portion with lynx from ${PB_URL}\n"
TOP_PAL_LISTA=$(lynx "${PB_URL}" -dump --display_charset=utf-8  -assume_charset=utf-8|grep -Ei '^   [0-9]+[[:space:]]+[[:alnum:] öäå_-]+[[:space:]]+[DTR\?].*/')
echo -e "\ngathering lynx generated urls portion with lynx from ${PB_URL}\n"
URLS=$(lynx 'https://tetrissuomi.wordpress.com/tuloksia/pb-lista/' -dump --display_charset=utf-8  | grep -Ei '  [0-9]+\.')
PB_LIST="pb-list-$(date -I)"

while read ROW ; do
  #cho "${ROW} hapa"
  if echo ${ROW} | grep -qEi '\[[0-9]+\]' ; then
  URL_NUMBER_TO_GREP=$(echo ${ROW} | grep -Eio '\[[0-9]+\]' | tr -d \[ | tr -d \]).
  URL_WE_GOT=$(echo "$URLS" | grep -F ${URL_NUMBER_TO_GREP} | grep -o h.*)
  echo "$(echo ${ROW} | cut -d \[ -f1) <a target='_blank' href='${URL_WE_GOT}'>Video</a>"
  else
     echo ${ROW}
  fi     
done < <( echo "${TOP_PAL_LISTA}" ) > ${PB_LIST}
echo -e "\n\nStep 1 completed!"
echo "Please check that ${PB_LIST} contains all the entries as some of the regex-greps might fail in the future"
echo "once you have made sure the list is valid,"
echo "please run cp -va ${PB_LIST} ${PB_LIST}.new"
echo "doing a vimdiff between the previous pb-list and current ${PB_LIST} is highly recommended"
echo "If the data is intact vim the necessary uppdates to ${PB_LIST} and after update run step3-wordpressify-ascii-pbs-to-html-table.sh ${PB_LIST}.new"
echo -e "The first '#' column that has the players placement in the list is generated automatically at step 3 so don't bother fixing them.\n\n"
