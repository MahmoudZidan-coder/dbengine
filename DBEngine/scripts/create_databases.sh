#! /usr/bin/bash

#set -x

if [ -d $databases_dir ]; then

    databases=($(find "$databases_dir" -maxdepth 1 -type d | cut -d/ -f3)) # only count subdirs as databases and ignore files.

    read -p "Enter name of database to be created: " dbname
	
    if [ -n "$dbname" ]; then    # check if the user already entered a name, if not exit.

	if [[ "$dbname" =~ ^[[:alnum:]_]+$ ]]; then
		
	    found=false        
	    for db in ${databases[@]}
	    do
	        if [ "$db" == "$dbname" ]; then
		    found=true
		    break
	         fi
	    done
	
	    if $found; then
		echo -e "${RED}this database already exists, choose another name. ${RESET}"
		exit 2
	    else
	    	echo -e "creating database \"$dbname\".... "
		if [ -d $databases_dir ]; then		
		    mkdir "$databases_dir/$dbname"
		    echo -e "${GREEN}Created successfully ${RESET}"
		    exit 0
		else
		    echo -e "${RED}something went wrong,${RESET} $databases_dir ${RED}not found${RESET}"
		    echo -e "${RED}can not create database${RESET} \"$dbname\""
		    echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}" 
		    exit 1
		fi
	    fi
	else
	    echo -e "${RED}the database name can not contain spaces or special characters ${RESET}"
	    exit 2
	fi
    else
        echo -e "${RED}You need to enter a database name ${RESET}"
	exit 2
    fi

else
    echo -e "${RED} Missing important directory ${RESET} $databases_dir"
    exit 1
fi
