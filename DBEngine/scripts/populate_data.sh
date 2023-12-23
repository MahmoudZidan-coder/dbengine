#! /usr/bin/bash


function check_uniqueness {
     data_count=$(wc -l $1 | cut -d" " -f1)
     col_data=$(cut -d";" -f$i $1)
     found=false
     for ((l=1; l<=data_count; l++))
     do
          lval=$(echo "$col_data" | sed -n "$l""p")
          if [[ $value == "$lval" ]]; then
               found=true
               break
          fi
     done
     echo $found			
}

dbdir=$1
table_data_file="$dbdir/$2"
table_meta_file="$dbdir/$2""_meta"

if [ -d $dbdir ]; then

    if [ -f $table_meta_file ]; then
	
	if [ ! -f $table_data_file ]; then
	    echo -e "${RED}table data file is not found, creating new one...${RESET}"
	    touch $table_data_file
	    echo -e "${GREEN}Created successfully.${RESET}"
	fi
	
	num_columns=$(awk '{print NF; exit}' "$table_meta_file")

	echo -e "${GREEN}Enter new row values: ${RESET}"
	col_to_add=()
	for ((i=1; i<=$num_columns; i++))
	do
    	    col=$(cut -d" " -f$i $table_meta_file)

    	    name=$(echo "$col" | sed -n '1p')
    	    constraints=$(echo "$col" | sed -n '2p')
    	    dtype=$(echo "$col" | sed -n '3p')

	    IFS=',' read -ra constraints <<< "$constraints"
    	    constraints_count=${#constraints[@]}
    	    const="${constraints[@]}"
    	    while true;
    	    do    	    
    	        read -p "$name [$dtype] [$const]"": " value
		# handling int values
    	        if [ $dtype == "int" ]; then
		    if [[ ! "$value" =~ ^[0-9]+$ && -n "$value" ]]; then
			echo -e "${RED}$name is int, only numeric values are accepted.${RESET}"
			continue
		    fi
		fi
		# handling str values
		unique=false
		notnull=false
		
		for constraint in ${constraints[@]}
		do
		    if [[ $constraint == "pk" || $constraint == "unique" ]]; then
			unique="true"
		    fi
		    if [[ $constraint == "pk" || $constraint == "notnull" ]]; then
			notnull="true"
		    fi
		done

		if [[ $notnull == "true" && ! -n $value ]]; then
		    echo -e "${RED}you must enter a value.${RESET}"
		elif [[ $notnull == "false" && ! -n $value ]]; then
		    col_to_add+=(" ")
		    break
		else
		    if [ $unique == "true" ]; then
			    
			found=$(check_uniqueness $table_data_file)
				
			if [ $found == true ]; then
			    echo -e "${RED}Duplicate value, enter another one.${RESET}"
			else
			    col_to_add+=("$value")
			    break
			fi
		    else
			col_to_add+=("$value")
			break
		    fi
    	        fi   

	    done
	done	
    else
        echo -e "${RED} Missing table meta file ${RESET} $dbdir"
        exit 2
    fi

else
    echo -e "${RED} Missing important directory ${RESET} $dbdir"
    exit 1
fi

for field in "${col_to_add[@]}"; do
    row+="$field;"
done

row=${row%;}

if [ -f $table_data_file ]; then
    echo $row >> $table_data_file
    echo -e "${GREEN}row added successfully.${RESET}"
else
    echo -e "${RED}error finding table data file.${RESET}"
    exit 2
fi
