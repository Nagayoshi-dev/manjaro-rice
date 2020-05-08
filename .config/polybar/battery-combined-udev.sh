#!/bin/bash

battery_print() {
    path_ac="/sys/class/power_supply/AC"
    path_battery_0="/sys/class/power_supply/BAT0"
    path_battery_1="/sys/class/power_supply/BAT1"

    ac=0
    battery_level_0=0
    battery_level_1=0
    battery_max_0=0
    battery_max_1=0

    if [ -f "$path_ac/online" ]; then
        ac=$(cat "$path_ac/online")
    fi

    if [ -f "$path_battery_0/energy_now" ]; then
        battery_level_0=$(cat "$path_battery_0/energy_now")
    fi

    if [ -f "$path_battery_0/energy_full" ]; then
        battery_max_0=$(cat "$path_battery_0/energy_full")
    fi

    if [ -f "$path_battery_1/energy_now" ]; then
        battery_level_1=$(cat "$path_battery_1/energy_now")
    fi

    if [ -f "$path_battery_1/energy_full" ]; then
        battery_max_1=$(cat "$path_battery_1/energy_full")
    fi

    battery_level=$(("$battery_level_0 + $battery_level_1"))
    battery_max=$(("$battery_max_0 + $battery_max_1"))

    battery_percent=$(("$battery_level * 100"))
    battery_percent=$(("$battery_percent / $battery_max"))

    ICON=""
    if [ "$ac" -eq 1 ]; then
        if [ "$battery_percent" -ge 98 ]; then
            ICON='ﮣ'
        elif [ "$battery_percent" -ge 90 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 80 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 60 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 40 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 30 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 20 ]; then
            ICON=''
        else
            ICON=''
        fi
    else
        if [ "$battery_percent" -ge 98 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 90 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 80 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 70 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 60 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 50 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 40 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 30 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 20 ]; then
            ICON=''
        elif [ "$battery_percent" -ge 10 ]; then
            ICON=''
        else
            ICON=''
        fi
    fi

    case "$1" in
        --percent)
            echo  "$battery_percent%"
            ;;
        --icon)
            echo "$ICON"
            ;;
        *)
            echo "$ICON $battery_percent%"
            ;;
    esac
}

path_pid="/tmp/battery-combined-udev.pid"

case "$1" in
    --update)
        pid=$(cat $path_pid)

        if [ "$pid" != "" ]; then
            kill -10 "$pid"
        fi
        ;;
    *)
        echo $$ > $path_pid

        trap exit INT
        trap "echo" USR1

        while true; do
            battery_print "$1"
            sleep 30 &
            wait
        done
        ;;
esac
