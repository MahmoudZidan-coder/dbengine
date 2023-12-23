#!/usr/bin/bash

export databases_dir="./databases"
export scripts_dir="./scripts"

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export RESET='\033[0m'

echo -e "${YELLOW}$(date) ${RESET}, Connecting to Database Engine....."
echo "Checking Files....."

if [[ -d $databases_dir && -d $scripts_dir ]]
then
    echo -e "${GREEN}Connected to DB Engine successfully. ${RESET}\n"
    
    PS3=$'\e[01;33mSelect an option: \e[0m'
    
    while true; do
    echo -e "\e[01;33mChoose from the options below: \e[0m"
    select query in "List Databases" "Create Database" "Delete Database" "Connect Database" "Exit"
    do
        case $query in
	    "List Databases") 
		script_path="$scripts_dir/list_databases.sh"
		while true
		do
		    if [ -f $script_path ]; then
			$script_path   # running the list databases script.
			exit_code=$?
			if [ $exit_code -eq 0 ]; then
			   break 2
			elif [ $exit_code -eq 1 ]; then
			   exit 1
			fi
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
			exit 1
		    fi
		done
	    ;;
	    "Create Database") 
		script_path="$scripts_dir/create_databases.sh"
		while true
		do
		    if [ -f $script_path ]; then
			$script_path   # running the create databases script.
			exit_code=$?
			if [ $exit_code -eq 0 ]; then
			   break 2
			elif [ $exit_code -eq 1 ]; then
			   exit 1
			fi
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
			exit 1
		    fi
		done
	    ;;
	    "Delete Database") 
		script_path="$scripts_dir/delete_databases.sh"
		while true
		do
		    if [ -f $script_path ]; then
			$script_path   # running the delete databases script.
			exit_code=$?
			if [ $exit_code -eq 0 ]; then
			   break 2
			elif [ $exit_code -eq 1 ]; then
			   exit 1
			fi
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
			exit 1
		    fi
		done
	    ;;
	    "Connect Database")
		script_path="$scripts_dir/connect_databases.sh"
		while true
		do
		    if [ -f $script_path ]; then
			$script_path   # running the delete databases script.
			exit_code=$?
			if [ $exit_code -eq 0 ]; then
			   break 2
			elif [ $exit_code -eq 1 ]; then
			   exit 1
			fi
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
			exit 1
		    fi
		done
	    ;;
	    "Exit") 
		echo -e "${YELLOW}$(date) ${RESET}, Disconnecting Database Engine....."
		echo -e "${GREEN}Goodbye!!${RESET}"		
		exit 0;;
	    *) echo -e "${RED}please select a proper option!${RESET}"; break
	esac
    done
    done
else
    echo -e "${RED}Failed to connect, missing important files. ${RESET}"
fi
