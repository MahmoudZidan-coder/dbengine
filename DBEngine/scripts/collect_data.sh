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
	    read -p "SELECT FROM ('all' for displaying all columns): " -a needed_cols

	    if [[ ${#needed_cols[@]} -eq 1 && ${needed_cols[0]} == "all" ]]; then
		needed_cols=("${names[@]}")
		break
	    fi	

	    # validating user input
	    wrong_inputs=()
	    for input in ${needed_cols[@]}
	    do
	        found=false
	        for col in ${columns_names[@]}
	        do
		    if [ $input == $col ]; then
		        found=true
		    fi
	        done

	        if ! $found; then
		    wrong_inputs+=($input)
	        fi
	    done

	    if [ ! ${#wrong_inputs[@]} -eq 0 ]; then
		echo -e "${RED}${wrong_inputs[@]}${RESET} do not exist in ${RED}$2${RESET} table"
	    else
		break
	    fi
	    # end validating user input
	done
	#####################################################################
	while true
	do

	    read -p "WHERE (col) (=/>/<) (value) or leave empty for no condition: " -a condition

	    if [ "${#condition[@]}" -eq 0 ]; then
		con_col_idx=0
	    	com_op="no"
	    	value=""
		########################################################
		col_indicees=()
		for col in "${needed_cols[@]}"
		do
		    for i in "${!names[@]}"; do
    			if [ "${names[$i]}" == "$col" ]; then
        		    col_indicees+=($i)
        		    break
    			fi
		    done
		done
		########################################################
		script_path="$scripts_dir/build_select_table.sh"
		if [ -f $script_path ]; then
		     $script_path "$table_data_file" "$con_col_idx" "$com_op" "$value_string" "${col_indicees[@]}"
		else
		    echo -e "${RED}Missing important file ${RESET} $script_path"
		    echo -e "${RED}Disconnecting Eatabase Engine... ${RESET}"
		    exit 1
		fi
		########################################################4
		exit
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
	    	for col in ${needed_cols[@]}
	    	do
		    if [ $condition_col == $col ]; then
		    found=true
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
			echo -e "${RED}only choose > and < with numeric values${RESET}"
			continue
		    fi
		    ########################################################
		    col_indicees=()
		    for col in "${needed_cols[@]}"
		    do
			for i in "${!names[@]}"; do
    			    if [ "${names[$i]}" == "$col" ]; then
        			col_indicees+=($i)
				if [ "$col" == "$condition_col" ]; then
				    con_col_idx=$i
				fi
        			break
    			    fi
			done
		    done
		    ########################################################
		    script_path="$scripts_dir/build_select_table.sh"
		    if [ -f $script_path ]; then
			$script_path "$table_data_file" "$con_col_idx" "$com_op" "$value_string" "${col_indicees[@]}"
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

