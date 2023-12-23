#! /usr/bin/bash

dbdir=$databases_dir/$1

if [ -d $dbdir ]; then

	read -p "Enter name of table to select from: " tname
        # check user entered table name
        if [ -n "$tname" ]; then
	    found=false        
	    if [[ -f "$dbdir/$tname" && -f "$dbdir/$tname""_meta" ]]; then
		found=true
            fi
	    ### check entered table already exists
	    if $found; then
	    	script_path="$scripts_dir/collect_data.sh" 
		#### check that script exists
		if [ -f $script_path ]; then
		    $script_path $dbdir $tname # asks for data to be inserted and validates it
		#### end check that script exists
	        else
		   echo -e "${RED}Missing important file ${RESET} $script_path"
		   echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		   exit 1
	        fi
	    ### end check entered table already exists
	    else
	         echo -e "${RED}table${RESET} \"$tname\" ${RED} meta file not found, make sure you have entered the right name! or meta file not corrupted \n${RESET}"
	        exit 2
	    fi
	# end check user entered table name
        else
            echo -e "${RED}You need to enter a table name ${RESET}"
	    exit 2
        fi
else
    echo -e "${RED} Missing important directory ${RESET} $dbdir"
    exit 1
fi
