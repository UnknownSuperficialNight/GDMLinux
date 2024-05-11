#!/bin/bash

# Script Name: GDMLinux
# Author: [@UnknownSuperficialNight]
# Author Link: [https://github.com/UnknownSuperficialNight]
# Date Creation: [2023-07-06]
# Copyright © 2023-2024 @UnknownSuperficialNight
# Description: [Grim Dawn Mod Manager for linux]

# All Rights Reserved by @UnknownSuperficialNight

# Don't comment on my "Interesting" code i did this all in around 8 hours over time ill improve it to be better you can request new features my making a issue with the enhancement Label

# Also hi (｡･ω･)ﾉﾞ hope u like the program

# Important must be at top varibles
COLOUR="$(tput setaf 160)"
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
#

#input functions
#

# Top menu options
array=("Full_Rainbow_Download" "Grim_main_menu" "Grim_UI" "Grim_Internals" "GrimTex_coming_soon" "Cursors" "UI_misc" "Sounds")
# Define an associative array to parse menu options
declare -A menu_items=(
	["Full_Rainbow_Download"]="Full_Rainbow Full_Rainbow_uninstall"
	["Grim_main_menu"]="MainMenu_Vanilla MainMenu_AoM USN_Loading MainMenu_FG"
	["Grim_UI"]="Burrwitch_UI_Theme Malmouth_UI_Theme Forgotten_Ui_archived Default_Theme"
	["Grim_Internals"]="Grim_Internals Grim_Internals_Uninstall"
	["Cursors"]="Grim_Dawn_Larger_Cursors_res_2560x1440_2k Grim_Dawn_Larger_Cursors_res_3840x1600 Grim_Dawn_Larger_Cursors_res_3840x2160_4k Grim_Dawn_Larger_Cursors_res_5120x2880_5k Grim_Dawn_Larger_Cursors_res_7680x4320_8k Cursor_Uninstall"
	["UI_misc"]="journaljumbers journaljumbersPo factions_goodsinfos factions_goodsinfos_plus_journalnumbers UI_misc_Uninstall"
	["Sounds"]="Better_Sounds Better_S_w_Music Sounds_Uninstall"
)

# Block top menu options if one or the other is installed
# Value's is what is blocked if Key is installed
declare -A Top_menu_conflicts=(

)
# Define an associative array used for later processing # DO NOT PUT ANYTHING INTO THE ARRAY IT SHOULD BE EMPTY
declare -A new_array=()
# If a sub menu item is in this array, it will do "theme default" else it will do Not Installed
menu_items_t_or_f=(Grim_main_menu Grim_UI)
# Defines what commands to run in the uninstall function
uninstall_entries=(Full_Rainbow_uninstall MainMenu_FG Default_Theme Grim_Internals_Uninstall Cursor_Uninstall UI_misc_Uninstall Sounds_Uninstall)
# Define an array of custom functions to run instead of the normal uninstall function
uninstall_entries_custom=(Grim_Internals_Uninstall)
# Define an associative array that sets URLs for each menu option
# The URL array must have the same name as the menu option
declare -A URL_array=(
	["Full_Rainbow"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Rainbow_filter.7z"
	["MainMenu_Vanilla"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/MainMenu_Vanilla.7z"
	["MainMenu_AoM"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/MainMenu_AoM.7z"
	["Forgotten_Ui_archived"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Forgotten_UI_Theme_1.04.7z"
	["Burrwitch_UI_Theme"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Burrwitch_UI_Theme_1.20.7z"
	["Malmouth_UI_Theme"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Malmouth_UI_Theme_1.11.7z"
	["USN_Loading"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/USN_Loading.7z"
	["Grim_Internals"]="function Install_main_Grim_Internals"
	["Grim_Dawn_Larger_Cursors_res_2560x1440_2k"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Grim%20Dawn%20Larger%20Cursors%20V2.1%20(1.33x).7z"
	["Grim_Dawn_Larger_Cursors_res_3840x1600"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Grim%20Dawn%20Larger%20Cursors%20V2.1%20(1.5x).7z"
	["Grim_Dawn_Larger_Cursors_res_3840x2160_4k"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Grim%20Dawn%20Larger%20Cursors%20V2.1%20(2x).7z"
	["Grim_Dawn_Larger_Cursors_res_5120x2880_5k"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Grim%20Dawn%20Larger%20Cursors%20V2.1%20(2.66x).7z"
	["Grim_Dawn_Larger_Cursors_res_7680x4320_8k"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Grim%20Dawn%20Larger%20Cursors%20V2.1%20(4x).7z"
	["journaljumbers"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/journaljumbers.7z"
	["journaljumbersPo"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/journaljumbersPo.7z"
	["factions_goodsinfos"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/factions_goodsinfos.7z"
	["factions_goodsinfos_plus_journalnumbers"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/factions_goodsinfos_plus_journalnumbers.7z"
	["Better_Sounds"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Better_Sounds.7z"
	["Better_S_w_Music"]="https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/Better_Sounds_w_Music.7z"
)
# If conflict installed then block the value
declare -A conflict_array
for file in "$SCRIPT_DIR/cache/conflicts/"*; do
	if [[ -f "$file" ]]; then
		key=$(basename "$file")
		value=$(cat "$file")
		conflict_array[$key]="$value"
	fi
done
# Tells where to import/copy from
declare -A import_location=(
	["Full_Rainbow"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["MainMenu_Vanilla"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["MainMenu_AoM"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["Burrwitch_UI_Theme"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Malmouth_UI_Theme"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["USN_Loading"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["Grim_Dawn_Larger_Cursors_res_2560x1440_2k"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Grim_Dawn_Larger_Cursors_res_3840x1600"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Grim_Dawn_Larger_Cursors_res_3840x2160_4k"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Grim_Dawn_Larger_Cursors_res_5120x2880_5k"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Grim_Dawn_Larger_Cursors_res_7680x4320_8k"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["journaljumbers"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["journaljumbersPo"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["factions_goodsinfos"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["factions_goodsinfos_plus_journalnumbers"]="$SCRIPT_DIR/tmp_grim_GDML/Settings"
	["Forgotten_Ui_archived"]="$SCRIPT_DIR/tmp_grim_GDML/Ui"
	["Better_Sounds"]="$SCRIPT_DIR/tmp_grim_GDML/Sound"
	["Better_S_w_Music"]="$SCRIPT_DIR/tmp_grim_GDML/Sound"
)
# This will rename a file so it can be send over
declare -A mv_dir_formatting=(
	#["Full_Rainbow"]="$SCRIPT_DIR/tmp_grim_GDML/Grim Dawn/settings"
)
# Tells where to export/copy to
export_location_func(){
	declare -gA export_location=(
		["Full_Rainbow"]="$directory_path"
		["MainMenu_Vanilla"]="$directory_path"
		["MainMenu_AoM"]="$directory_path"
		["Burrwitch_UI_Theme"]="$directory_path/Settings"
		["Malmouth_UI_Theme"]="$directory_path/Settings"
		["USN_Loading"]="$directory_path"
		["Grim_Dawn_Larger_Cursors_res_2560x1440_2k"]="$directory_path/Settings"
		["Grim_Dawn_Larger_Cursors_res_3840x1600"]="$directory_path/Settings"
		["Grim_Dawn_Larger_Cursors_res_3840x2160_4k"]="$directory_path/Settings"
		["Grim_Dawn_Larger_Cursors_res_5120x2880_5k"]="$directory_path/Settings"
		["Grim_Dawn_Larger_Cursors_res_7680x4320_8k"]="$directory_path/Settings"
		["journaljumbers"]="$directory_path"
		["journaljumbersPo"]="$directory_path"
		["factions_goodsinfos"]="$directory_path"
		["factions_goodsinfos_plus_journalnumbers"]="$directory_path"
		["Forgotten_Ui_archived"]="$directory_path/Settings"
		["Better_Sounds"]="$directory_path/Settings"
		["Better_S_w_Music"]="$directory_path/Settings"
	)
}

##USER CONFIG END
#if [[ -n "$conflict_main_menu_array" ]]; then
#for i in "${conflict_main_menu_array[@]}"
#fi



# Function to recursively rename directories
rename_dirs() {
    local dir parent_dir path
    path="$1"
    for dir in "$path"/*; do
        if [ -d "$dir" ]; then
            rename_dirs "$dir"
            parent_dir=$(dirname "$dir")
            # Get directory name in lowercase
            lowercase_name=$(basename "$dir" | tr '[:upper:]' '[:lower:]')
            # Check if the first character is already uppercase
            if [[ ${lowercase_name:0:1} != [[:upper:]] ]]; then
                # Capitalize only the first character
                newname="${lowercase_name^}"
                mv -v "$dir" "$parent_dir/$newname"
            fi
        fi
    done
}



#
#Help menu for command line arguments
Help_for_cmdline_args(){
	echo "$COLOUR" 'Welcome To The Help Menu:'
	echo "$COLOUR" ''
	echo "$COLOUR" 'Flags:'
	echo "$COLOUR" '--help|-h # For this help menu'
	echo "$COLOUR" '--conflict|-c # For generating conflict files to upload to the repo #DEV option'
	echo "$COLOUR" '--uppercase|-u # For making directories uppercase for saving mods #DEV option'
}
#
while [[ ! $# -eq 0 ]];do
	case "$1" in
		--conflicts|-c)
			mkdir -p "$SCRIPT_DIR/conflict_resolution_tmp"
			for key in "${!URL_array[@]}"; do
				value="${URL_array[$key]}"
				extensions=("${URL_array[$key]##*.}")
				if [[ ! "$value" =~ 'function' && ! -e "$SCRIPT_DIR/conflict_resolution_tmp/$key.$extensions" ]]; then
					curl -L "$value" -o "$SCRIPT_DIR/conflict_resolution_tmp/$key.$extensions" &
				fi
			done
			wait
			for key in "${!URL_array[@]}"; do
				value="${URL_array[$key]}"
				extensions=("${URL_array[$key]##*.}")
				if [[ ! "$value" =~ 'function' && ! -e "$SCRIPT_DIR/conflict_resolution_tmp/processing/$key" ]]; then
					path=$(find "$SCRIPT_DIR/conflict_resolution_tmp" -type f -name "$key.$extensions")
					mkdir -p "$SCRIPT_DIR/conflict_resolution_tmp/processing/$key"
					7z x "$SCRIPT_DIR/conflict_resolution_tmp/$key.$extensions" -o"$SCRIPT_DIR/conflict_resolution_tmp/processing/$key"
					DIRS+=("$SCRIPT_DIR/conflict_resolution_tmp/processing/$key")
				fi
			done
			if [[ -e "$SCRIPT_DIR/cache/conflicts" ]]; then rm -rf "$SCRIPT_DIR/cache/conflicts" ;fi
			mkdir -p "$SCRIPT_DIR/cache/conflicts/$filename"
			get_conflict_numbers=$(echo ${#URL_array[@]})


			# Iterate over each directory in the list
			for i in "${!DIRS[@]}"; do
				# Save the current directory in a variable
				current_dir="${DIRS[$i]}"

				# Iterate over the other directories in the list
				for j in "${!DIRS[@]}"; do
					# Skip the current directory
					if [[ "$j" == "$i" ]]; then
						continue
					fi
					unset rsync_output
					# Compare the current directory to the other directory
					echo "Checking for conflicts between '$current_dir' and '${DIRS[$j]}'..."
					find "$current_dir" -type f -printf '%P\n' | sort > "$SCRIPT_DIR/conflict_resolution_tmp/dir1_files.txt"
					find "${DIRS[$j]}" -type f -printf '%P\n' | sort > "$SCRIPT_DIR/conflict_resolution_tmp/dir2_files.txt"
					echo
					converge=$(comm -12 "$SCRIPT_DIR/conflict_resolution_tmp/dir1_files.txt" "$SCRIPT_DIR/conflict_resolution_tmp/dir2_files.txt")
					rm -f "$SCRIPT_DIR/conflict_resolution_tmp/dir1_files.txt"
					rm -f "$SCRIPT_DIR/conflict_resolution_tmp/dir2_files.txt"
					filename=$(basename "$current_dir")
					opposing_filename=$(basename "${DIRS[$j]}")
					echo "$converge"
					if [[ -n "$converge" ]]; then
						echo "$opposing_filename" >> "$SCRIPT_DIR/cache/conflicts/$filename"
					fi
				done
			done
			rm -rf "$SCRIPT_DIR/conflict_resolution_tmp"
			;;
		--uppercase|-u)
			# Prompt user for directory path
			read -p "Enter the directory path to scan: " input_dir

			# Check if directory exists
			if [ -d "$input_dir" ]; then
				# Call the function with the provided directory path
				rename_dirs "$input_dir"
			else
				echo "Directory does not exist."
			fi
		;;
		--help|-h)
			COLOUR="$(tput setaf 33)"
			Help_for_cmdline_args
			;;
		*)
			COLOUR="$(tput setaf 33)"
			Help_for_cmdline_args
			;;
esac;exit;done
if (( $# == 0 )); then
	for Top_menu_key in "${!Top_menu_conflicts[@]}" ;do
		for value in ${menu_items[$Top_menu_key]}; do
			#echo value: "$value"
			if [[ -e "$SCRIPT_DIR/cache/$value" ]]; then
				for Top_menu_values in ${Top_menu_conflicts[$Top_menu_key]} ;do
					num_elements=${#array[@]}
					for seq_loop in $(seq 0 "$num_elements"); do
						if [[ "${array[$seq_loop]}" == "$Top_menu_values" ]];then
							#echo value3: "${array[$seq_loop]}"
							#echo seq $seq_loop
							#for key_for_name in "${!Top_menu_conflicts[@]}"; do
							#for value_for_name in "${Top_menu_conflicts[$key_for_name]}"; do
							#if [[ -z "$last_name" || "$last_name" != "$last_name" ]];then
							#if [[ "$value_for_name" == *"$Top_menu_values"* ]]; then
							#last_name="$value_for_name"
							#Deleted_value_array_tmp+=("$key_for_name")
							#fi;fi
							#done
							#done
							#Deleted_value_array=($(echo "${Deleted_value_array_tmp[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
							#Deleted_Menu_Array+=("${array[$seq_loop]}")
							accepted_top_menu_conflicts+=("$Top_menu_key")
							toggle_conflicts_for_top=1
							unset array[$seq_loop]
						fi
					done;done
				fi
			done
		done
		vari_func() {
			if command -v "$varibs" &>/dev/null ; then
				echo passed dep check
			else
				echo cant find "$varibs" && pauser=true
				if [[ "$varibs" == 'aria2c' ]]; then echo 'aria2c is only used for the retexture mod if u dont want that mod u dont need aria2c and may proceed without it' ;fi
			fi
		}
		Deps_array=("curl" "7z" "grep" "cut" "aria2c" "sed" "tar" "rsync" "find" "wait" "md5sum" "tr" "seq")
		for dep in "${Deps_array[@]}" ;do varibs="$dep" ; vari_func ;done
		if [[ $pauser == true ]]; then
			echo Failed dep check
			echo
			read -p 'Would you like to proceed anyway? , (y/n)?' -n 1 -r
			echo
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				clear
			else
				exit
			fi
		else
			echo Passed all dep checks
		fi
		clear
		#Disclaimer
		echo "$COLOUR" 'Before we start the main program here is a little disclaimer'
		echo "$COLOUR" 'This script assumes you speak english and are using english in the game'
		echo "$COLOUR" 'also you must disable steam cloud ingame for grim internals'
		echo "$COLOUR" "here is a link incase u need more info 'https://forums.crateentertainment.com/t/how-to-move-your-saves-from-steam-cloud-to-grim-dawns-default-location/28921' "
		echo "$COLOUR" "Grim internals is a optional feature"
		read -p "Press Enter to continue"
		clear
		COLOUR="$(tput setaf 33)"
		echo "$COLOUR"
		clear
		read -p "Enter the directory path of grim dawn example '$HOME/.local/share/Steam/steamapps/common/Grim Dawn': " directory_path
		directory_path=${directory_path%/}
		if [[ -d "$directory_path" ]]; then
			echo "$directory_path exists proceeding"
		else
			echo "Error: directory does not exist"
			echo "did u add a extra slash on the end? remove it "
			exit
		fi
		if [[ ! -e "$SCRIPT_DIR/tmp_grim_GDML" ]]; then mkdir -p "$SCRIPT_DIR/tmp_grim_GDML";fi
		if [[ ! -e "$SCRIPT_DIR/tmp_grim_GDML/backups" ]]; then mkdir -p "$SCRIPT_DIR/tmp_grim_GDML/backups";fi
		if [[ ! -e "$SCRIPT_DIR/cache" ]]; then mkdir -p "$SCRIPT_DIR/cache"; echo "This cache contains Uninstall information for all the mods don't remove it unless you don't want to be able to uninstall mods" >> "$SCRIPT_DIR/cache/READ_ME.txt" ;fi
		if [[ ! -e "$SCRIPT_DIR/cache/conflicts" ]]; then mkdir -p "$SCRIPT_DIR/cache/conflicts" ; curl -L "https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/conflicts_precompiled.7z" -o "$SCRIPT_DIR/cache/conflicts/conflicts_precompiled.7z" ; 7z x "$SCRIPT_DIR/cache/conflicts/conflicts_precompiled.7z" -o"$SCRIPT_DIR/cache" ; rm -f "$SCRIPT_DIR/cache/conflicts/conflicts_precompiled.7z" ;fi
		Generate_script() {
			echo "$COLOUR" 'Instructions:'
			echo "$COLOUR" 'First due to 1.1.9.8 patch we need to use the old 1.1.9.7 executable'
			echo "$COLOUR" 'In the future this may not be needed but for now it is'
			echo "$COLOUR" "On Steam go to 'Properties -> Betas -> Beta Participation' and set it from none to 1.1.9.7"
			echo "$COLOUR" "Let grim dawn update if it dosen't automatically then click on the update button in the game homepage"
			read -p "Press Enter once you have done all of that to proceed"
			Generate_script_md5sum_old=$(md5sum "$directory_path/x64/Grim Dawn.exe")
			cp -f "$directory_path/x64/Grim Dawn.exe" "$SCRIPT_DIR"
			clear
			echo "$COLOUR" 'Instructions:'
			echo "$COLOUR" "Now change back to 1.1.9.8"
			echo "$COLOUR" "On Steam go to 'Properties -> Betas -> Beta Participation' and set it from 1.1.9.7 to none"
			echo "$COLOUR" "Let grim dawn update if it dosen't automatically then click on the update button in the game homepage"
			read -p "Press Enter once you have done all of that to proceed"
			cp -f "$SCRIPT_DIR/Grim Dawn.exe" "$directory_path/x64/Grim Dawn.exe"
			Generate_script_md5sum_new=$(md5sum "$directory_path/x64/Grim Dawn.exe")
			if [[ "$Generate_script_md5sum_old" != "$Generate_script_md5sum_new" ]]; then
				echo "Sums are different"
			else
				echo "Sums are the same"
				echo "partial error: still might work if you continue with the script DevNote: (Works for me i would continue wouldnt hurt) "
				echo "Dev debug: sums are the same"
				read -p "Press Enter to proceed and ignore the warning"
			fi
			if [[ -e "$SCRIPT_DIR/Grim Dawn.exe" ]]; then rm -f "$SCRIPT_DIR/Grim Dawn.exe" ;fi
			clear
			echo "$COLOUR" 'Instructions:'
			echo "$COLOUR" 'Go to steam and in grim dawn launch options add the line below'
			echo "$COLOUR" 'PROTON_DUMP_DEBUG_COMMANDS=1 %command%'
			echo "$COLOUR" "Note: if you already have '%command%' at the end of the launch option then just put"
			echo "$COLOUR" 'PROTON_DUMP_DEBUG_COMMANDS=1 behind %command% and any other commands you have in there'
			echo "$COLOUR" 'Then make sure you have your proton version set in the compatibility tab'
			echo "$COLOUR" 'Then launch the game once you get to the main menu then exit the game and return to the script'
			read -p "Press Enter once you have done all of that to proceed"
			clear
			mkdir -p "$SCRIPT_DIR/tmp_grim_GDML/executable" && cp -f "/tmp/proton_$USER/run" "$SCRIPT_DIR/tmp_grim_GDML/executable/run_grim_dawn.sh"
			grep_run_grim_dawn=$(grep -n "DEF_CMD=" "$SCRIPT_DIR/tmp_grim_GDML/executable/run_grim_dawn.sh" | cut -d':' -f1)
			DEF_CMD=("$directory_path"/x64/GrimInternals64.exe)
			replace_line_var=$(echo DEF_CMD=\(\"$DEF_CMD\"\))
			sed -i "${grep_run_grim_dawn}s|.*|$replace_line_var|" "$SCRIPT_DIR/tmp_grim_GDML/executable/run_grim_dawn.sh"
			chmod +x "$SCRIPT_DIR/tmp_grim_GDML/executable/run_grim_dawn.sh"
			echo "$COLOUR" "The executable to launch grim dawn is in $SCRIPT_DIR/tmp_grim_GDML/executable/run_grim_dawn.sh"
			echo "$COLOUR" 'You can move it anywhere you want aswell and u can use it on lutris as a local game'
			echo "$COLOUR" 'Lutris: for lutris u just need the runner to linux native and then executable set to $SCRIPT_DIR/tmp_grim_GDML/executable'
			read -p "Press Enter to proceed"
			clear
		}
		Install_main_Grim_Internals() {
			Generate_script
			curl -L 'https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/GrimInternals%20(x64)%20v1.107%20Beta.7z.001' -o "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta.7z.001" & curl -L 'https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/GrimInternals%20(x64)%20v1.107%20Beta.7z.002' -o "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta.7z.002" & wait
			7z x "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta.7z.001" -o"$SCRIPT_DIR/tmp_grim_GDML"
			mv "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta/GrimInternals64.exe" "$directory_path/x64"
			mv "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta/GrimInternalsDll64.dll" "$directory_path"
			find "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta" -type f -printf "%P\n" >> "$SCRIPT_DIR/cache/GrimInternals"
			rsync -avy --backup --backup-dir="$SCRIPT_DIR/tmp_grim_GDML" "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta/_GrimInternalsData" "$directory_path"
			rm -rf "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta"
			rm -f "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta.7z.001"
			rm -f "$SCRIPT_DIR/tmp_grim_GDML/GrimInternals (x64) v1.107 Beta.7z.002"
			curl -L 'https://github.com/UnknownSuperficialNight/GDMLinux/raw/main/ConfiguratorBG.bmp' -o "$directory_path/_GrimInternalsData/Configurator/ConfiguratorBG.bmp"
		}
		Grim_Internals_Uninstall(){
			if [[ -e "$SCRIPT_DIR/cache/GrimInternals" ]]; then
				readarray -t files_FG < "$SCRIPT_DIR/cache/GrimInternals"
				for f in "${files_FG[@]}" ;do if [[ -f "$directory_path/$f" ]]; then rm -f "$directory_path/$f" ;fi ;done
				rm -f "$directory_path/x64/GrimInternals64.exe"
				rm -f "$directory_path/GrimInternalsDll64.dll"
				if [[ -e "$directory_path/_GrimInternalsData" ]];then find "$directory_path/_GrimInternalsData" -type d -empty -delete ;fi
				rm -f "$SCRIPT_DIR/cache/GrimInternals"
				if [[ -e "$SCRIPT_DIR/tmp_grim_GDML/executable" ]]; then rm -rf "$SCRIPT_DIR/tmp_grim_GDML/executable" ;fi
				if [[ -e "$SCRIPT_DIR/cache/GrimInternals" ]]; then rm -rf "$SCRIPT_DIR/cache/GrimInternals" ;fi
			fi
		}
		7z_list_func_cacher() {
			file_varible2=$(echo "$file_varible" | sed 's/\..*//')

			7z l "$SCRIPT_DIR/tmp_grim_GDML/$file_varible" | sed 's/.*[[:space:]]\([^[:space:]]\+\)$/\1/' | sed -n '1,/^\s*--\s*$/!{/^--/I!p}' | sed '1,/Name/d' | sed '/folders/,$d' >> "$SCRIPT_DIR/cache/$file_varible2"
		}
		clean_dir() {
			if [[ -e "$directory_path/Settings" ]];then find "$directory_path/Settings" -type d -empty -delete ;fi
		}
		Help_menu() {
			COLOUR="$(tput setaf 196)"
			echo "$COLOUR" 'Menu:'
			COLOUR="$(tput setaf 10)"
			echo "$COLOUR" 'Full_Rainbow_Download:'
			echo "$COLOUR" '"Full_Rainbow" # Rainbow Filter is a mod that changes the colour of items and properties to be more recognisable  '
			echo "$COLOUR" '"Full_Rainbow_uninstall" # Uninstalls Rainbow Filter'
			echo
			echo "$COLOUR" 'Grim_main_menu:'
			echo "$COLOUR" '"MainMenu_Vanilla" # This is the original Grim Dawn main menu theme, the one you would have if you had no dlc'
			echo "$COLOUR" '"MainMenu_AoM" # This is the Ashes of Malmouth main menu theme'
			echo "$COLOUR" '"USN_Loading" # This is my personal theme'
			echo "$COLOUR" '"MainMenu_FG" # This is the Forgotten Gods main menu theme'
			echo
			echo "$COLOUR" 'Grim_UI:'
			echo "$COLOUR" '"Burrwitch_UI_Theme" # New, weathered wood-themed UI mod'
			echo "$COLOUR" '"Malmouth_UI_Theme" # Darker, more gothic or horror-themed visual elements theme mod'
			echo "$COLOUR" '"Forgotten_Ui_archived" # Outdated/old fg based theme'
			echo "$COLOUR" '"Default_Theme" # Default/Normal Grim Dawn UI'
			echo
			echo "$COLOUR" 'Grim_Internals:'
			echo "$COLOUR" '"Grim_Internals" # Utilities/QOL mod : to open ui launch a game (Must not me the main menu) and press (CTRL + f5)'
			echo "$COLOUR" '"Grim_Internals_Uninstall" # Uninstalls Grim Internals'
			echo
			echo "$COLOUR" 'Cursors:'
			echo "$COLOUR" 'All options increase cursor size just choose your resolution'
			echo
			echo "$COLOUR" 'UI_misc:'
			echo "$COLOUR" 'journaljumbers # Shows lore page numbers'
			echo "$COLOUR" 'journaljumbersPo # Shows lore page total numbers so you can see how many you are missing'
			echo "$COLOUR" 'factions_goodsinfos # Adds details to factions on your j screen'
			echo "$COLOUR" 'factions_goodsinfos_plus_journalnumbers # journaljumbers+factions_goodsinfos combined'
			echo
			echo "$COLOUR" 'GrimTex_0.5 # Install small textures for game useful for steam_deck # Download Size="96.1 MiB" | Uncompressed Size="214.0 MiB"'
			echo "$COLOUR" 'GrimTex_1.0 # Install Original texture size but remade to look a litte better # No vram diffrence # Download Size="350.1 MiB" | Uncompressed Size="723.4 MiB"'
			echo "$COLOUR" 'GrimTex_2.0 # Install 2x texture size # recommended for under 8gb Vram # Download Size="2.2 GiB" | Uncompressed Size="5.5 GiB"'
			echo "$COLOUR" 'GrimTex_4.0 # Install 4x texture size # (Very demanding) recommended for over 8gb Vram # Download Size="9.5 GiB" | Uncompressed Size="23.6 GiB"'
			echo "$COLOUR" 'GrimTex_Uninstall # Uninstall GrimTex'
			echo
		}

		#install gum (GUI)
		if [[ ! -e "$SCRIPT_DIR/gum" ]]; then
			gum_dl=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases | grep -m 1 "_Linux_x86_64.*browser_download_url\|browser_download_url.*_Linux_x86_64" | cut -d':' -f2- | sed 's/^[[:space:]]*//' | sed 's/\"//g')
			gum_name=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases | grep -m 1 "_Linux_x86_64.*name\|name.*_Linux_x86_64" | cut -d':' -f2- | sed 's/^[[:space:]]*//' | sed 's/\"//g' | sed 's/\,//g')
			curl -L "$gum_dl" -o "$SCRIPT_DIR/$gum_name"
			mkdir -p "$SCRIPT_DIR/gum"
			tar xzvf "$SCRIPT_DIR/$gum_name" -C "$SCRIPT_DIR/gum"
			rm -f "$SCRIPT_DIR/$gum_name"
		fi
		clear
		Help_menu
		export_location_func
		if [[ "$toggle_conflicts_for_top" == '1' ]]; then
			colour_last="$COLOUR"
			count_toggle_conflicts_for_top=1
			echo "$(tput setaf 11) The following menu's have been disabled due to following installed conflicts"
			for conflicts_for_top_display_loop in "${accepted_top_menu_conflicts[@]}" ;do
				count_toggle_conflicts_for_top=$((count_toggle_conflicts_for_top+1))
				echo $(tput setaf 11) "$conflicts_for_top_display_loop $(tput setaf 160) is blocking these menu's $(tput setaf 11) ${Top_menu_conflicts[$conflicts_for_top_display_loop]} $(tput setaf 160) Uninstall $(tput setaf 11) $conflicts_for_top_display_loop $(tput setaf 160) to unlock $(tput setaf 11) ${Top_menu_conflicts[$conflicts_for_top_display_loop]} $(tput setaf 160) menu's"
				tput setaf "$colour_last"
				if [[ "$count_toggle_conflicts_for_top" -ge "${#accepted_top_menu_conflicts[@]}" ]]; then
					break 2
				fi
			done
		fi
		TUI=($(echo "${array[@]}" | tr ' ' '\n' | "$SCRIPT_DIR/gum/./gum" choose --cursor="🠒 " --selected-prefix="◆" --unselected-prefix="◇" --header="KeyBinding for menu (Space to select/unselect | enter to proceed with selection ) # Select You're Options:" --cursor.foreground="207" --header.foreground="208" --selected.foreground="129" --no-limit))
		if [[ -z "$TUI" ]]; then
			echo "$COLOUR" 'You chose nothing exiting'
			exit
		fi
		TUI_associative_array_key_number=$(echo ${#TUI[@]})
		TUI=("" ${TUI[@]})

		# Loop through the keys in the array
		for key in $(seq 1 "$TUI_associative_array_key_number"); do
			TUI_key="${TUI[key]}"
			if [[ $(echo "${!menu_items[@]}" | grep -o "$TUI_key") == "${TUI[key]}" ]]; then new_array["$TUI_key"]="${menu_items[$TUI_key]}" ;fi
		done
		unset menu_items
		eval "$(declare -p new_array | sed 's/new_array/menu_items/')"
		tput setaf 10


		Main_Menu_Loop(){
			function check_theme() {
				local theme_name="$1"
				if [[ -e "$SCRIPT_DIR/cache/$theme_name" ]]; then
					summary_array+=( 1)
				elif [[ -n "$check_theme_out2" ]]; then summary_array+=( 2)
				else
					summary_array+=( 3)
				fi
				unset "theme_name"
			}

			function Main_menu_ui_call() {
				local choose_args="$1"
				for arg in $(echo "${choose_args[@]}" | tr ' ' '\n');do
					check_theme "$arg"
				done
				sum=$(echo "${summary_array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
				sum_processed=$(echo "$sum" | sed 's/1.*/1/')
				sum_processed2=$(echo $sum_processed | tr -d ' ')
				if [[ "$sum_processed" == '1' ]]; then
					for arg in $(echo "${choose_args[@]}" | tr ' ' '\n');do
						if [[ -e "$SCRIPT_DIR/cache/$arg" ]]; then echo "$(tput setaf 7)Currently Installed: $(tput setaf 1)$arg" ;fi
					done
				elif [[ "$sum_processed2" == '2' ]]; then
					echo "$(tput setaf 7)Currently Installed: $(tput setaf 1)Default_Theme"
			elif [[ "$sum_processed2" == '3' ]]; then echo "$(tput setaf 7)Currently Installed: $(tput setaf 1)Not installed" ;fi
				unset unique_array
				unset summary_array
				unset "check_theme_out2"
				Main_menu_ui_TUI=$(echo "${choose_args[@]}" | tr ' ' '\n' | "$SCRIPT_DIR/gum/./gum" choose )
				echo "$(tput setaf 7)" "You Chose:" "$(tput setaf 124)" "$Main_menu_ui_TUI"
				tput setaf 7
				Main_menu_ui_TUI_array+=("$Main_menu_ui_TUI")
				unset "choose_args"
			}

			Menu_loop_associative_array_key_number=$(echo ${#menu_items[@]})

			for Menu_Main_Loop in $(seq 1 "$Menu_loop_associative_array_key_number");do
				current_selection=${TUI[$Menu_Main_Loop]}
				for i in "${menu_items_t_or_f[@]}" ;do
					if [[ "$current_selection" == "$i" ]] ;then check_theme_out2=1 ;fi
				done
				Main_menu_ui_call "${menu_items[$current_selection]}"
			done
		}
		install_function(){
			if [[ $(echo "${!URL_array[@]}" | grep -o "$Main_menu_ui_TUI_array_select") == "$Main_menu_ui_TUI_array_select" ]]; then
				current_url="${URL_array[$Main_menu_ui_TUI_array_select]}"
				current_export_location="${export_location[$Main_menu_ui_TUI_array_select]}"
				current_import_location="${import_location[$Main_menu_ui_TUI_array_select]}"
				current_mv_dir_formatting="${mv_dir_formatting[$Main_menu_ui_TUI_array_select]}"
				if [[ "$current_url" =~ 'function' ]]; then
					$(echo "$current_url" | cut -d' ' -f2 )
				else
					get_format_Current=$(echo "$current_url" | sed 's/.*\.//')
					curl -L "$current_url" -o "$SCRIPT_DIR/tmp_grim_GDML/$Main_menu_ui_TUI_array_select.$get_format_Current"
					file_varible="$Main_menu_ui_TUI_array_select.$get_format_Current"
					7z_list_func_cacher
					7z x "$SCRIPT_DIR/tmp_grim_GDML/$file_varible" -o"$SCRIPT_DIR/tmp_grim_GDML"
					if [[ -n "$current_mv_dir_formatting" ]]; then mv "$current_mv_dir_formatting" "$current_import_location" ;fi
					rsync -avy --backup --backup-dir="$SCRIPT_DIR/tmp_grim_GDML" "$current_import_location" "$current_export_location"
					if [[ -e "$current_import_location" ]]; then rm -rf "$current_import_location" ;fi
					find "$SCRIPT_DIR/tmp_grim_GDML" -depth -maxdepth 1 -type f -delete -o -path "$SCRIPT_DIR/tmp_grim_GDML/executable" -prune -o -path "$SCRIPT_DIR/tmp_grim_GDML/backups" -prune -o -empty -type d -delete
					if [[ -e "$SCRIPT_DIR/tmp_grim_GDML/$file_varible" ]]; then rm -f "$SCRIPT_DIR/tmp_grim_GDML/$file_varible";fi
				fi;fi
			}
			uninstall_function(){
				for uninstall_custom_var in "${uninstall_entries_custom[@]}" ;do if [[ "$uninstall_key" == "$uninstall_custom_var" ]]; then uninstall_custom=1 ;fi;done
					if [[ -n "$uninstall_custom" ]]; then
						unset uninstall_custom
						$(echo "$uninstall_entries_custom")
					else
						#$uninstall_key
						for key in "${!menu_items[@]}"; do
							for i in "${menu_items[$key]}";do
								Tmparr=(${menu_items[$key]})
								for t in "${Tmparr[@]}";do
									if [[ "$t" = "$Main_menu_ui_TUI_array_select" ]]; then
										value_array_result="$key"
										break
								fi;done;done;done
								tmparr=(${menu_items[$value_array_result]})
								for uninstall_main_loop in "${tmparr[@]}";do
									if [[ -e "$SCRIPT_DIR/cache/$uninstall_main_loop" ]]; then
										uninstall_source_path="${export_location[$uninstall_main_loop]}"
										readarray -t files_FG < "$SCRIPT_DIR/cache/$uninstall_main_loop"
										for f in "${files_FG[@]}" ;do if [[ -f "$uninstall_source_path/$f" ]]; then rm -f "$uninstall_source_path/$f" ;fi ;done
										clean_dir
										rm -f "$SCRIPT_DIR/cache/$uninstall_main_loop"
										break
								fi;done;fi
							}
							Main(){
								Main_Menu_Loop
								#echo ${Main_menu_ui_TUI_array[@]}
								Main_menu_ui_TUI_array=("" ${Main_menu_ui_TUI_array[@]})
								for Main_install_Loop in $(seq 1 "$Menu_loop_associative_array_key_number");do
									current_selection_main=${TUI[Main_install_Loop]}
									Main_menu_ui_TUI_array_select=${Main_menu_ui_TUI_array[Main_install_Loop]}
									for key_tmp in "${!conflict_array[@]}"; do
										readarray -t conflict_check_array <<< "$(echo "${conflict_array[$key_tmp]}" | tr ' ' '\n')"
										for conflict_check in "${conflict_check_array[@]}"; do
											if [[ "$conflict_check" == "$Main_menu_ui_TUI_array_select" ]]; then
												get_value_tmp=${conflict_array[$conflict_check]}
												readarray -t get_value_loop_start <<< "$(echo "$get_value_tmp" | tr ' ' '\n')"
												for get_value in "${get_value_loop_start[@]}"; do
													if [[ -e "$SCRIPT_DIR/cache/$get_value" ]]; then
														tmp_Main_menu_ui_TUI_array_select="$Main_menu_ui_TUI_array_select"
														Main_menu_ui_TUI_array_select="$conflict_check"
														uninstall_function
														Main_menu_ui_TUI_array_select="$tmp_Main_menu_ui_TUI_array_select"
														install_function
														skip=1
														break
												fi;done;fi
											done;done
											if [[ "$skip" == '1' ]]; then
												unset skip
												clear
											else
												for uninstall_check in "${uninstall_entries[@]}" ;do if [[ "$uninstall_check" == "$Main_menu_ui_TUI_array_select" ]]; then uninstall_key=$Main_menu_ui_TUI_array_select ; uninstall_sector=1 ;fi;done
													if [[ -n "$uninstall_sector" ]]; then
														uninstall_function
													elif [[ -e "$SCRIPT_DIR/cache/$Main_menu_ui_TUI_array_select" ]]; then
														uninstall_function
														install_function
													else
														install_function
												fi;fi;done
											}

											Main
											clear
											echo "'########'##::: ##'########::::'#######:'########:::'######::'######:'########:'####'########:'########:";
											echo " ##.....::###:: ##:##.... ##::'##.... ##:##.....:::'##... ##'##... ##:##.... ##. ##::##.... ##... ##..::";
											echo " ##:::::::####: ##:##:::: ##:::##:::: ##:##:::::::::##:::..::##:::..::##:::: ##: ##::##:::: ##::: ##::::";
											echo " ######:::## ## ##:##:::: ##:::##:::: ##:######::::. ######::##:::::::########:: ##::########:::: ##::::";
											echo " ##...::::##. ####:##:::: ##:::##:::: ##:##...::::::..... ##:##:::::::##.. ##::: ##::##.....::::: ##::::";
											echo " ##:::::::##:. ###:##:::: ##:::##:::: ##:##::::::::'##::: ##:##::: ##:##::. ##:: ##::##:::::::::: ##::::";
											echo " ########:##::. ##:########:::. #######::##::::::::. ######:. ######::##:::. ##'####:##:::::::::: ##::::";
											echo "........:..::::..:........:::::.......::..::::::::::......:::......::..:::::..:....:..:::::::::::..:::::";
											# All Rights Reserved by @UnknownSuperficialNight
										fi
