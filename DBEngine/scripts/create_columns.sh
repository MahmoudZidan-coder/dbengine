#! /usr/bin/bash

function check_constraint {
    user_constraints=$1
    if [ $user_constraints == "pk" ]; then
	echo $user_constraints
    elif [ $user_constraints == "no" ]; then
	echo $user_constraints
    elif [[ $user_constraints == "notnull,unique" || $user_constraints == "unique,notnull" ]]; then
	echo $user_constraints
    elif [[ $user_constraints == "notnull,unique" || $user_constraints == "unique,notnull" ]]; then
	echo $user_constraints
    elif [[ $user_constraints == "notnull" || $user_constraints == "unique" ]]; then
	cols_constraints+=($user_constraints)
	echo $user_constraints
    else 
	echo false
    fi
}



allowed_constraints=("pk" "notnull" "unique" "no")



names=()
constraints=()
dtypes=()
no_pk=0
meta_file_path=$1
while true
do
    read -p "Enter the number of columns to be created in the table: " col_count
    if [[ $col_count =~ ^[0-9]+$ ]]; then
	if [ $col_count -ge 1 ]; then
	    counter=1
	    while [ $counter -le $col_count ]
	    do
		read -p "Col $counter : Enter 'Col Name' 'pk,unique,notnull,no' 'Data Type' : " -a column
		# check count of passed values 
		if [ ${#column[@]} -eq 3 ]; then

		    col_name=${column[0]}
		    col_constraints=${column[1]}
		    col_dtype=${column[2]}
		    ## validate col name
		    if [[ "$col_name" =~ ^[[:alpha:]]+$ ]]; then
			if [ ! ${#names[@]} -eq 0  ]; then
			    exists=false
			    for name in "${names[@]}"
			    do
				if [ $name == $col_name ]; then
				    echo -e "${RED}this col name is added before${RESET}"
				    exists=true
				    break
				fi
			    done
			    if [ $exists == true ]; then
				continue
			    fi
			fi
			### validate data type
			if [[ "$col_dtype" == "int" || "$col_dtype" == "str" ]]; then
			    #### validate constraints
			    if [[ "$col_constraints" =~ ^[a-zA-Z,]+$ ]]; then			
				result=$(check_constraint $col_constraints)
				if [ "$result" != "false" ]; then
				    if [ $result == "pk" ]; then
					no_pk=$((no_pk + 1))
				    fi
				    if [ ! ${#constraints[@]} -eq 0  ]; then
			    		exists=false
			    		for const in "${constraints[@]}"
			    		do
					    if [[ $const == "pk" && $result == "pk" ]]; then
				    		echo -e "${RED}table can have only one primary key${RESET}"
				    		exists=true
				    		break
					    fi
			    		done
			    		if [ $exists == true ]; then
					    continue
			    		fi
				    fi
				    constraints+=($result)
				    names+=($col_name)
				    dtypes+=($col_dtype)
				    counter=$((counter+1))
				else
				    echo -e "${RED}constraints can be one of 'pk' 'no' 'unique' 'notnull' 'notnull,unique' 'unique,notnull' 'no'${RESET}"
				    fi
			    else
				echo -e "${RED}add constraints separated by ','${RESET}"
			    fi
			    #### end validate constraints
			else
			    echo -e "${RED}WRONG ENTRY! Valid data types are \"int\" \"str\".${RESET}"
			fi
			### end validate data type
		    else
			echo -e "${RED}WRONG ENTRY! Column name only contains letters.${RESET}"
		    fi
		    ## end validate col name
		else
		    echo -e "${RED}WRONG ENTRY! Enter column name, constriants and data type.${RESET}"
	    	fi
		# end of check of passed values count
	    done
	    break	    
	else
	    echo -e "${RED}Tables must have at least one column${RESET}"
    	fi
    else
	echo -e "${RED}Not valid entry, enter the number of columns${RESET}"
    fi
done

if [ $no_pk -gt 0 ]; then

    if [ -f $meta_file_path ]; then
        echo "${names[@]}" >> $meta_file_path
        echo "${constraints[@]}" >> $meta_file_path
        echo "${dtypes[@]}" >> $meta_file_path
    else
        echo -e "${RED}ERROR: Can not find table meta file ${RESET}"
        exit 2
    fi

else
	echo -e "${RED}ERROR: Can not create table without primary keys ${RESET}"
	exit 2
fi
