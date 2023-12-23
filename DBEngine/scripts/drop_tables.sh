#! /usr/bin/bash

#set -x

dbdir=$databases_dir/$1

if [ -d $dbdir ]; then

    read -p "Enter name of table to be deleted: " tname
    tables=($(find "$dbdir" -maxdepth 1 -type f | cut -d/ -f4)) # only count files as tables
    	
    if [ -n "$tname" ]; then    # check if the user already entered a name, if not exit.
	found=false        
	
	for table in ${tables[@]}
	do
	    if [[ "$tname" == "$table" || "$tname""_meta" == "$table" ]]; then
		found=true
		break
	    fi
	done
	
	if $found; then
	    echo -e "deleting table \"$tname\"......"
	    if [ -d $dbdir ]; then
		if [[ -f "$dbdir/$tname" && -f "$dbdir/$tname""_meta" ]]; then	        
		    rm -i "$dbdir/$tname" "$dbdir/$tname""_meta"
	            echo -e "${GREEN}table${RESET} \"$tname\" ${GREEN} files successfully${RESET}"
		elif [ -f "$dbdir/$tname" ]; then	        
		    rm -i "$dbdir/$tname"
	            echo -e "${GREEN}table${RESET} \"$tname\" ${GREEN} data file deleted successfully${RESET}"
		elif [ -f "$dbdir/$tname""_meta" ]; then	        
		    rm -i "$dbdir/$tname""_meta"
	            echo -e "${GREEN}table${RESET} \"$tname\" ${GREEN} meta data file deleted successfully${RESET}"
		fi
		exit 0
	    else
		echo -e "${RED}Something went wrong, ${RESET}$dbdir ${RED}directory not found!!! ${RESET}"
		echo -e "${RED}Error deleting the table${RESET}"
		echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		exit 1
	    fi
	else
	    echo -e "${RED}tables${RESET} \"$tname\" ${RED}not found, make sure you have entered the right name! \n${RESET}"
	    exit 2
	fi

    else
        echo -e "${RED}You need to enter a table name${RESET}"
	exit 2
    fi

else
    echo -e "${RED}Missing important directory ${RESET} $dbdir"
    exit 1
fi



