#!/bin/bash
# script from http://www.zagura.ro/

MCINI=~/.mc/ini
TMPINI=/tmp/ini${RANDOM}

if [ "$#" != "1" ]; then
    echo "Usage $0 <scheme filename>"
    exit 0
fi

if ( ps axu | grep -w [m]c >/dev/null) then
    echo "Midnight Commander seems to be running. Please exit Midnight Commander and then change the theme again!"
fi

##Available colors:
#black
#gray
#red
#brightred
#green
#brightgreen
#brown
#yellow
#blue
#brightblue
#magenta
#brightmagenta
#cyan
#brightcyan
#lightgray
#white
#default

BASE_COLOR=gray,black
NORMAL=lightgray,blue
SELECTED=black,cyan
MARKED=yellow,blue
MARKSELECT=yellow,cyan
ERRORS=white,red
MENU=white,cyan
REVERSE=black,lightgray
DNORMAL=black,lightgray
DFOCUS=black,cyan
DHOTNORMAL=blue,lightgray
DHOTFOCUS=blue,cyan
VIEWUNDERLINE=brightred,blue
MENUHOT=yellow,cyan
MENUSEL=white,black
MENUHOTSEL=yellow,black
HELPNORMAL=black,lightgray
HELPITALIC=red,lightgray
HELPBOLD=blue,lightgray
HELPLINK=black,cyan
HELPSLINK=yellow,blue
GAUGE=white,black
INPUT=black,cyan
DIRECTORY=white,blue
EXECUTABLE=brightgreen,blue
LINK=lightgray,blue
STALELINK=brightred,blue
DEVICE=brightmagenta,blue
CORE=red,blue
SPECIAL=black,blue
EDITNORMAL=lightgray,blue
EDITBOLD=yellow,blue
EDITMARKED=black,cyan
ERRDHOTNORMAL=yellow,red
ERRDHOTFOCUS=yellow,lightgray


source ${1}

COLORSTRING="base_color=${BASE_COLOR}:"\
"normal=${NORMAL}:"\
"selected=$SELECTED:"\
"marked=${MARKED}:"\
"markselect=${MARKSELECT}:"\
"errors=${ERRORS}:"\
"menu=${MENU}:"\
"reverse=${REVERSE}:"\
"dnormal=${DNORMAL}:"\
"dfocus=${DFOCUS}:"\
"dhotnormal=${DHOTNORMAL}:"\
"dhotfocus=${DHOTFOCUS}:"\
"viewunderline=${VIEWUNDERLINE}:"\
"menuhot=${MENUHOT}:"\
"menusel=${MENUSEL}:"\
"menuhotsel=${MENUHOTSEL}:"\
"helpnormal=${HELPNORMAL}:"\
"helpitalic=${HELPITALIC}:"\
"helpbold=${HELPBOLD}:"\
"helplink=${HELPLINK}:"\
"helpslink=${HELPSLINK}:"\
"gauge=${GAUGE}:"\
"input=${INPUT}:"\
"directory=${DIRECTORY}:"\
"executable=${EXECUTABLE}:"\
"link=${LINK}:"\
"stalelink=${STALELINK}:"\
"device=${DEVICE}:"\
"core=${CORE}:"\
"special=${SPECIAL}:"\
"editnormal=${EDITNORMAL}:"\
"editbold=${EDITBOLD}:"\
"editmarked=${EDITMARKED}:"\
"errdhotnormal=${ERRDHOTNORMAL}:"\
"errdhotfocus=${ERRDHOTFOCUS}";


while read line
do
    case $line in 
        "[Colors]"* ) read line;; 
        *) echo $line;;       
    esac
done < ${MCINI} > ${TMPINI}

echo  >>${TMPINI}
echo "[Colors]" >>${TMPINI}
echo ${COLORSTRING} >>${TMPINI}

cp ${TMPINI} ${MCINI}
