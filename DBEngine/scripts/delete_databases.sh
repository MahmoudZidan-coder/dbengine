#! /usr/bin/bash

#set -x

if [ -d $databases_dir ]; then

    databases=($(find "$databases_dir" -maxdepth 1 -type d | cut -d/ -f3)) # only count subdirs as databases and ignore files.

    read -p "Enter name of database to be deleted: " dbname
	
    if [ -n "$dbname" ]; then    # check if the user already entered a name, if not exit.
	found=false        
	
	for db in ${databases[@]}
	do
	    if [ "$db" == "$dbname" ]; then
		found=true
		break
	    fi
	done
	
	if $found; then
	    echo -e "deleting database \"$dbname\"......"
	    if [ -d $databases_dir ]; then
	        rm -ri "$databases_dir/$dbname"
	        echo -e "${GREEN}Database${RESET} \"$dbname\" ${GREEN}deleted successfully${RESET}"
	        exit 0
	    else
		echo -e "${RED}Something went wrong, ${RESET}$database_dir ${RED}directory not found!!! ${RESET}"
		echo -e "${RED}Error deleting the database${RESET}"
		echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		exit 1
	    fi
	else
	    echo -e "${RED}Database${RESET} \"$dbname\" ${RED}not found, make sure you have entered the right name! \n${RESET}"
	    exit 2
	fi

    else
        echo -e "${RED}You need to enter a database name${RESET}"
	exit 2
    fi

else
    echo -e "${RED}Missing important directory${RESET} $databases_dir"
    exit 1
fi
