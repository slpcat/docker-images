#!/bin/bash
# Filename:     conkytoggle.sh
# Purpose:      toggle conky on/off
# Authors:      Original: Kerry and anticapitalista, secipolla for antiX
#               Rewrite: antiX-Dave
# Latest change: 23, July, 2025.
################################################################################

function conky_state {
    user=$(whoami)
    conkypids=$(pgrep -x -u $user conky)
}

function toggle {
    conky_state
    conkysave="$HOME/.conky/conky-save.sh"
    if [ -n "$YAD_PID" ]; then kill -15 "$YAD_PID"; fi
    if [ ! -d "$HOME/.conky/" ]; then mkdir "$HOME/.conky"; fi
    if [ -n "$conkypids" ]; then
        if [ -f $conkysave ]; then rm $conkysave; fi
        for pid in $conkypids; do
            cmd=$(ps --no-headers -p $pid -o args)
            echo "$cmd &" >> $conkysave
            kill -15 $pid  > /dev/null 2>&1
        done
    else
        if [ -f $conkysave ]; then 
            bash $conkysave  > /dev/null 2>&1
        else
            conky  > /dev/null 2>&1
        fi
    fi
}

function startup_state {
    conkyload=$(grep "^LOAD_CONKY" $HOME/.desktop-session/desktop-session.conf)
    if [ -n $conkyload ]; then
        conkyloadstate=$(echo ${conkyload#LOAD_CONKY=} |tr -d '"')
    fi
}

function startup_toggle {
    startup_state
    if [ -n "$YAD_PID" ]; then kill -15 "$YAD_PID"; fi
    if [ "$conkyloadstate" = "true" ]; then
        sed "s/^LOAD_CONKY=.*/LOAD_CONKY=\"false\"/g" -i $HOME/.desktop-session/desktop-session.conf
    else
        sed "s/^LOAD_CONKY=.*/LOAD_CONKY=\"true\"/g" -i $HOME/.desktop-session/desktop-session.conf
    fi
}

function gui {
    while :; do
        conky_state
        startup_state
        if [ -n "$conkypids" ]; then
            tooltip_running=$"Conky is currently running"
            switch_running="/usr/share/pixmaps/on.png"
        else
            tooltip_running=$"Conky is currently off"
            switch_running="/usr/share/pixmaps/off.png"
        fi
        
        if [ "$conkyloadstate" = "true" ]; then
            tooltip_startup=$"Conky startup currently enabled"
            switch_startup="/usr/share/pixmaps/on.png"
        else
            tooltip_startup=$"Conky startup currently disabled"
            switch_startup="/usr/share/pixmaps/off.png"
        fi
        slider_text_running=$"Conky setting for current session"
        slider_text_startup=$"Conky setting for startup"
        yad --undecorated --borders=10 --center --columns=1 --form \
        --title=$"Conky Toggle for antiX"  \
        --window-icon="/usr/share/icons/papirus-antix/48x48/actions/cm_options.png" \
        --field="$slider_text_running!$switch_running!$tooltip_running":BTN "bash -c \"toggle $YAD_PID \""  \
        --field="$slider_text_startup!$switch_startup!$tooltip_startup":BTN "bash -c \"startup_toggle $YAD_PID\"" \
        --button='x':1 > /dev/null 2>&1
        
        case "$?" in
            1) break;; 
            252) break;;
            *) sleep 0.5 ;;
        esac
        
    done
}

export -f startup_toggle toggle conky_state startup_state

case $1 in 
    --gui) gui;;
    --startup) startup_toggle;;
    *)  toggle ;;
esac
