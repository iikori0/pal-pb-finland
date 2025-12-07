#!/bin/bash

if [ -z $1 ] ; then
  echo please feed me a step1inized pblist, such as pb-list-YYY...
  exit 1
fi
PB_LIST="${1}"

echo '<html lang="fi">'
echo '<head>'
echo '<meta charset="UTF-8">'
echo '<title>PB-lista &#8211; Tetris Suomi</title>'
echo '</head>'
echo '<body>'

echo "<pre>"
echo "Gathering player ranking positions..."
POSITIONS=$(cat ${PB_LIST} | grep -Eo -e "^[0-9]+ ")
echo "Gathering player names..."
NAMES=$(cat ${PB_LIST} | grep -Ei " [[:alnum:]öäå_-]+[[:space:]]" | cut -d / -f1 | cut -d " " -f2- | sed -e s@DAS@@g -e s@Roll@@g -e s@TAP@@g -e s@???@@g)
echo "Gathering playing styles..."
STYLES=$(cat ${PB_LIST} | grep -Eo "..../... "|tr -d " ")
echo "Gathering Scores..."
SCORES=$(cat ${PB_LIST} | grep -Eo -e "[0-9][0-9][0-9] [0-9][0-9][0-9]" -e "[0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]")
echo "Gathering level-data..."
#LEVELS=$(cat ${PB_LIST} | grep -Eo "[0-9X]+ → [0-9X]+.." | tr "→" "-" | tr -s "-" | sed s@\-@"\&rarr;"@g)
LEVELS=$(cat ${PB_LIST} | grep -Eo ".[0-9X] → [0-9X]+.." | sed -e 's/\x82/\x20/g' | tr "→" "-" | tr -s "-" | sed s@\-@"\&rarr;"@g)
echo "Gadhering Evidence :DD :DD"
EVIDENCE=$(cat ${PB_LIST} | grep -Eo "[0-9X]+ → [0-9X]+".*| cut -d " " -f4-)

NUMBER_OF_POSITIONS=$(echo "${POSITIONS}" | wc -l)
NUMBER_OF_NAMES=$(echo "${NAMES}" | wc -l)
NUMBER_OF_STYLES=$(echo "${STYLES}" | wc -l)
NUMBER_OF_SCORES=$(echo "${SCORES}" | wc -l)
NUMBER_OF_LEVELS=$(echo "${LEVELS}" | wc -l)
NUMBER_OF_EVIDENCES=$(echo "${EVIDENCE}" | wc -l)

echo NUMBER_OF_POSITIONS = ${NUMBER_OF_POSITIONS}
echo NUMBER_OF_NAMES =  ${NUMBER_OF_NAMES}
echo NUMBER_OF_STYLES = ${NUMBER_OF_STYLES}
echo NUMBER_OF_SCORES = ${NUMBER_OF_SCORES}
echo NUMBER_OF_LEVELS = ${NUMBER_OF_LEVELS}
echo NUMBER_OF_EVIDENCES = ${NUMBER_OF_EVIDENCES}

echo "Running sanity check against gathered data"
SANITY_COUNT=$(echo -e "${NUMBER_OF_POSITIONS}\n${NUMBER_OF_NAMES}\n${NUMBER_OF_STYLES}\n${NUMBER_OF_SCORES}\n${NUMBER_OF_LEVELS}\n${NUMBER_OF_EVIDENCES}" | grep -e ^${NUMBER_OF_SCORES}$ | wc -l)
if [[ ${SANITY_COUNT} -ne 6 ]] ; then
  echo "Some of the results gathered via regex greps are not complete or straight out borked, please fix your script or see if the data given is in right format!"
  exit 1
fi

echo "All went well, let's proceed to attack aggr.. I mean generating the HTML table"
echo "Use CTRL+U to enter source mode and copy the table, see SNIP aids for help."
echo "</pre>"
echo "<!-- *** SNIP YOUR COPYING STARTS HERE *** // -->"
echo "<figure class='wp-block-table'>"
echo "<table>"
echo "<tbody>"
echo "  <tr>"
echo "    <th><strong>#</strong></th>"
echo "    <th><strong>Nimimerkki</strong></th>"
echo "    <th><strong>Tyyli/Konsoli</strong></th>"
echo "    <th><strong>Pisteet</strong></th>"
echo "    <th><strong>Tasot</strong></th>"
echo "    <th><strong>Todiste</strong></th>"
echo "  </tr>"
for LINE_TODO in $(seq 1 ${NUMBER_OF_SCORES}) ; do
  echo "  <tr>"
  echo "<td>${LINE_TODO}</td>"
  echo "<td>$(echo "${NAMES}" | sed "${LINE_TODO}q;d")</td>"
  echo "<td>$(echo "${STYLES}" | sed "${LINE_TODO}q;d")</td>"
  echo "<td>$(echo "${SCORES}" | sed "${LINE_TODO}q;d")</td>"
  echo "<td>$(echo "${LEVELS}" | sed "${LINE_TODO}q;d")</td>"
  echo "<td>$(echo "${EVIDENCE}" | sed "${LINE_TODO}q;d")</td>"
  echo "  </tr>"
done
echo "</tbody>"
echo "</table>"
echo "</figure>"
echo "<!-- *** SNIP YOUR COPYING ENDS HERE *** -->"
echo '</body>'
