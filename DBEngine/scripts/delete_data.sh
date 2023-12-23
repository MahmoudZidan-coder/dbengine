#! /usr/bin/bash

dbdir=$1
table_data_file="$dbdir/$2"
table_meta_file="$dbdir/$2""_meta"

if [ -d $dbdir ]; then

    if [[ -f $table_meta_file && -f $table_data_file ]]; then
	
	num_columns=$(awk '{print NF; exit}' "$table_meta_file")
	columns_names=$(sed '1p' "$table_meta_file")
	IFS=' ' read -ra names <<< "$columns_names"
	
	while true
	do

	    read -p "WHERE (col) (=/>/<) (value) or leave empty for truncating table: " -a condition
	    # truncating table
	    if [ "${#condition[@]}" -eq 0 ]; then
		read -p "Are sure to truncate $2 table? [y/n]: " confirm
		if [ $confirm == "y" ]; then
		    echo "" > $table_data_file
		    exit
		elif [ $confirm == "n" ]; then
		    exit
		else
		    echo -e "${RED}choose yes or no${RESET}"
		    continue
		fi
	    fi

	    # validating user input
	    if [ ${#condition[@]} -ge 3 ]; then

	    	found=false
	    	condition_col=${condition[0]}
	    	com_op=${condition[1]}
	    	value=${condition[@]:2}
		
		value_string=""
		for val in "${value[@]}"; do
    		value_string+=" $val"
		done
		value_string="${value_string:1}"
		## check the column
	    	for i in ${!names[@]}
	    	do
		    if [ $condition_col == ${names[i]} ]; then
		        found=true
			con_col_idx=$i
		        break
		    fi
	    	done

	    	if ! $found; then
		    echo -e "${RED}condition column must be one of the select columns${RESET}" 
		    continue
		fi
		## end check the column

		### check the operator
		if [[ $com_op == "=" || $com_op == "<" || $com_op == ">" ]]; then
		    if [[ "$value_string" =~ ^[^0-9]+$ && ! $com_op == "=" ]]; then
			echo now here
			echo $com_op
			echo $value_string
			echo -e "${RED}only choose > and < with numeric values${RESET}"
			continue
		    fi
		    ########################################################
		    script_path="$scripts_dir/filter_data_to_delete.sh"
		    if [ -f $script_path ]; then
			$script_path "$table_data_file" "$con_col_idx" "$com_op" "$value_string"
		    else
		        echo -e "${RED}Missing important file ${RESET} $script_path"
			echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
			exit 1
		    fi
		    ########################################################4
		    exit
		else
		    echo -e "${RED}choose operator from = > and <${RESET}"
		fi
		### check the operator
	    else
		echo -e "${RED}Make sure you follow the condition syntax ${RESET}"
	    fi
	    # end validating user input
	done
    else
        echo -e "${RED} Missing table files ${RESET} $dbdir"
        exit 2
    fi
else
    echo -e "${RED} Missing important directory ${RESET} $dbdir"
    exit 1
fi

