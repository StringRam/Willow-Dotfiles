#!/bin/sh
#-----------------------------------------------------------
#Quit running waybar instances
#-----------------------------------------------------------
killall waybar

#-----------------------------------------------------------
# Loading the configuration based on the username
#-----------------------------------------------------------
if [[ $USER = "MDCorrea" ]]
then
    waybar -c ~/.config/waybar/config.jsonc & -s ~/.config/waybar/style.css
else
    waybar &
fi
