#! /usr/bin/bash

dbdir=$databases_dir/$1

read -p "Enter name of table to be created: " tname

if [ -d $dbdir ]; then
    	
    if [ -n "$tname" ]; then    # check if the user already entered a name, if not exit.

	if [[ "$tname" =~ ^[[:alnum:]]+$ ]]; then
	    if [[ ! -f "$dbdir/$tname" || ! -f "$dbdir/$tname""_meta" ]]; then
		# checking for the data file		
		if [ ! -f "$dbdir/$tname" ]; then
		    echo -e "Creating table \"$tname\" data file...."
		    touch "$dbdir/$tname"
		    echo -e "${GREEN}Table \"$tname\" data file created successfully.${RESET}"
		fi
		# checking for the meta file
		if [ ! -f "$dbdir/$tname""_meta" ]; then
		    touch "$dbdir/$tname""_meta"
		    create_cols="$scripts_dir/create_columns.sh"
		    if [ -f $script_path ]; then
			$create_cols "$dbdir/$tname""_meta"
			exit_code=$?
			if [ $exit_code -eq 2 ]; then
			    if [ -f "$dbdir/$tname" ]; then
		    		rm "$dbdir/$tname"
			    fi
			    if [ -f "$dbdir/$tname""_meta" ]; then
		    		rm "$dbdir/$tname""_meta"
			    fi
			    exit 2
			fi
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		        exit 1
		    fi

		    echo -e "Creating table $tname meta 1file...."
		    echo -e "${GREEN}Table \"$tname\" meta data file created successfully.${RESET}"
		fi
	    else
		echo -e "${RED}this table already exists ${RESET}"
		exit 2
	    fi 	
	else
	    echo -e "${RED}the table name can not contain spaces or special characters ${RESET}"
	    exit 2
	fi
    else
        echo -e "${RED}You need to enter a table name ${RESET}"
	exit 2
    fi

else
    echo -e "${RED} Missing important directory ${RESET} $dbdir"
    exit 1
fi
