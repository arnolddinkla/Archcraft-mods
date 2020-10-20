#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail   : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

## Dirs #############################################
polybar_path="$HOME/.config/polybar"
rofi_path="$HOME/.config/rofi"
termite_path="$HOME/.config/termite"
geany_path="$HOME/.config/geany"
openbox_path="$HOME/.config/openbox"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
nitrogen --save --set-zoom-fill /usr/share/backgrounds/bg_3.jpg

# polybar ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="beach"/g' $polybar_path/launch.sh
sed -i -e 's/font-0 = .*/font-0 = "Sans:size=10;3"/g' $polybar_path/beach/config.ini

# relaunch polybar
$polybar_path/launch.sh

# rofi ---------------------------------
sed -i -e 's/STYLE=.*/STYLE="beach"/g' "$rofi_path/bin/mpd" "$rofi_path/bin/network" "$rofi_path/bin/screenshot"
sed -i -e 's/DIR=.*/DIR="beach"/g' "$rofi_path/bin/launcher" "$rofi_path/bin/powermenu"
sed -i -e 's/STYLE=.*/STYLE="launcher"/g' "$rofi_path/bin/launcher"
sed -i -e 's/STYLE=.*/STYLE="powermenu"/g' "$rofi_path/bin/powermenu"
sed -i -e 's/font:.*/font:				 	"Sans 10";/g' "$rofi_path/beach/font.rasi"

sed -i -e 's/font:.*/font:				 	"Sans 10";/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
sed -i -e 's/border:.*/border:					0px;/g' "$rofi_path/dialogs/askpass.rasi" "$rofi_path/dialogs/confirm.rasi"
cat > $rofi_path/dialogs/colors.rasi << _EOF_
/* Color-Scheme */

* {
    BG:    #e7e8ebff;
    FG:    #93a1a1ff;
    BDR:   #73a1a1ff;
}
_EOF_

# Network Manager ---------------------------------
sed -i -e 's#dmenu_command = .*#dmenu_command = rofi -dmenu -theme beach/networkmenu.rasi#g' "$HOME"/.config/networkmanager-dmenu/config.ini

# termite ---------------------------------
sed -i -e 's/font = .*/font = Monospace 10/g' $termite_path/config
sed -i '/colors/Q' $termite_path/config

cat >> $termite_path/config << _EOF_
[colors]

foreground = #93a1a1
background = #e7e8eb
cursor = #558888

#black
color0 = #282c2c
color8 = #484c4e

#red
color1 = #b05f5f
color9 = #b05f5f

#green
color2 = #88aa55
color10 = #88aa55

#yellow
color3 = #ccb05f
color11 = #ccb05f

#blue
color4 = #556973
color12 = #556973

#magenta
color5 = #9d64aa
color13 = #9d64aa

#cyan
color6 = #558888
color14 = #558888

#white
color7 = #eaeaed
color15 = #f6f7f8
_EOF_

# alt config
cp "$termite_path"/config "$termite_path"/config_easy
sed -i -e 's/font = .*/font = Sans 10/g' $termite_path/config_easy

# reload settings
killall -USR1 termite

# geany ---------------------------------
sed -i -e 's/color_scheme=.*/color_scheme=github.conf/g' "$geany_path"/geany.conf
sed -i -e 's/editor_font=.*/editor_font=Terminus 9/g' "$geany_path"/geany.conf

# gtk theme, icons and fonts ---------------------------------
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Lighter"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Arc"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Arc"
xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 10"

# openbox ---------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="beach"
	layout="CLM"
	font="Sans"
	fontsize="10"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	# Margins
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 20 "$config"
}

obconfig && openbox --reconfigure

# dunst ---------------------------------
sed -i -e 's/geometry = .*/geometry = "300x60-20-50"/g' $dunst_path/dunstrc
sed -i -e 's/font = .*/font = Sans 10/g' $dunst_path/dunstrc
sed -i -e 's/frame_width = .*/frame_width = 0/g' $dunst_path/dunstrc

cat > $dunst_path/sid << _EOF_
Dark
_EOF_

sed -i '/urgency_low/Q' $dunst_path/dunstrc
cat >> $dunst_path/dunstrc << _EOF_
[urgency_low]
timeout = 4
background = "#e7e8eb"
foreground = "#93a1a1"
frame_color = "#e7e8eb"

[urgency_normal]
timeout = 8
background = "#e7e8eb"
foreground = "#93a1a1"
frame_color = "#e7e8eb"

[urgency_critical]
timeout = 20
background = "#e7e8eb"
foreground = "#d42434"
frame_color = "#ff7700"
_EOF_

pkill dunst && dunst &

# Plank ---------------------------------
cat > $HOME/.cache/plank.conf << _EOF_
[dock1]
alignment='center'
auto-pinning=true
current-workspace-only=false
dock-items=['xfce-settings-manager.dockitem', 'exo-file-manager.dockitem', 'termite.dockitem']
hide-delay=0
hide-mode='auto'
icon-size=32
items-alignment='center'
lock-items=false
monitor=''
offset=88
pinned-only=false
position='right'
pressure-reveal=false
show-dock-item=false
theme='Transparent'
tooltips-enabled=true
unhide-delay=0
zoom-enabled=true
zoom-percent=120
_EOF_

# reload settings
cat $HOME/.cache/plank.conf | dconf load /net/launchpad/plank/docks/

# Other ---------------------------------
sed -i -e 's/progressbar_color = .*/progressbar_color = "cyan"/g' $HOME/.ncmpcpp/config

## EOF #############################################
