#! /usr/bin/bash

#set -x
options=("List Tables" "Create Table" "Drop Table" "Insert Into" "Select From" "Delete From" "Disconnect DB")
if [ -d $databases_dir ]; then

    databases=($(find "$databases_dir" -maxdepth 1 -type d | cut -d/ -f3)) # only count subdirs as databases and ignore files.

    read -p "Enter name of database to be connected: " dbname

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
	    echo -e "Connecting database \"$dbname\".... "
	    if [ -d $databases_dir ]; then		
		echo -e "${GREEN}Connected successfully${RESET}"
		PS3=$'\033[0;34m'"$dbname---> "$'\e[0m'
		while true; do
    		echo -e "\033[0;34mChoose from the options below: \e[0m"		
		select query in "${options[@]}"
    		do
		    case $query in
	    		"List Tables")
			    script_path="$scripts_dir/list_tables.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname # running the list databases script.
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
	    		"Create Table") 
			script_path="$scripts_dir/create_tables.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname # running the list databases script.
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
	    		"Drop Table")
			    script_path="$scripts_dir/drop_tables.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname # running the list databases script.
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
			"Insert Into")
			    script_path="$scripts_dir/insert_data.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname 
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
			"Select From")
			    script_path="$scripts_dir/select_data.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname 
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
			"Delete From")
			    script_path="$scripts_dir/delete_from_table.sh"
			    while true
			    do
		    		if [ -f $script_path ]; then
				    $script_path $dbname 
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
			"Disconnect DB") echo "Disconnecting... $dbname"; exit 0 ;;
			*) echo -e "${RED}Choose a proper option${RESET}" ; break ;;
		    esac
		done
		done
	    else
		echo -e "${RED}Something went wrong,${RESET} $databases_dir ${RED}not found${RESET}"
		echo -e "${RED}Can not connect database${RESET} \"$dbname\""
		echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		exit 1
	    fi
	else
	    echo -e "${RED}this database does not exist, make sure you entered the right name.${RESET}"
	    exit 2
	 fi
    else
        echo -e "${RED}You need to enter a database name ${RESET}"
	exit 2
    fi

else
    echo -e "${RED}Missing important directory${RESET} $databases_dir"
    exit 1
fi
