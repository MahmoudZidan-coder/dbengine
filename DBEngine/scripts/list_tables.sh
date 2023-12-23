#! /usr/bin/bash

#set -x

dbdir=$databases_dir/$1

if [ -d $dbdir ]; then

    meta_tables=($(find "$dbdir" -maxdepth 1 -type f -name '*_meta'| cut -d/ -f4)) # only count files as tables
    data_tables=($(find "$dbdir" -maxdepth 1 -type f ! -name '*_meta'| cut -d/ -f4))
    meta_tables_count=${#meta_tables[@]}
    data_tables_count=${#data_tables[@]}

    echo "Listing tables....."
    echo -e "You have ${GREEN}$meta_tables_count total ${RESET}valid table in ${GREEN}$1 ${RESET}database"

    if [ $meta_tables_count -gt 0 ]; then
        for table in ${meta_tables[@]}
        do
	   
	   names=$(sed -n '1p' "$dbdir/$table")
	   constraints=$(sed -n '2p' "$dbdir/$table")
	   dtypes=$(sed -n '3p' "$dbdir/$table")

	   IFS=' ' read -ra names <<< "$names"
	   IFS=' ' read -ra constraints <<< "$constraints"
	   IFS=' ' read -ra dtypes <<< "$dtypes"
	   IFS='_' read -ra table <<< "$table"

	   echo -e "TABLE ${GREEN}${table[0]}${RESET}: ${#names[@]} Columns"
           echo "---------------------------------------------------------------"
           printf "%-20s%-1s%-20s%-1s%-20s\n" " Col" "|" " Constraints" "|" " Data type"
           echo "---------------------------------------------------------------"		
	
 	   for ((i=0;i<${#names[@]};i++))
	   do
		printf "%-20s%-1s%-20s%-1s%-20s\n" " ${names[i]}" "|" " ${constraints[i]}" "|" " ${dtypes[i]}"
		echo "---------------------------------------------------------------"
	   done  	
	done
    else
	exit 0
    fi

else
    echo -e "${RED}Missing important directory ${RESET} $databases_dir"
    exit 1
fi



