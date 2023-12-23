#! /usr/bin/bash

#set -x

if [ -d $databases_dir ]; then

    databases=($(find "$databases_dir" -maxdepth 1 -type d | cut -d/ -f3)) # only count subdirs as databases and ignore files.
    databases_count=${#databases[@]}

    echo "Listing databases....."
    echo -e "You have ${GREEN} $databases_count total ${RESET} databases"

    if [ $databases_count -gt 0 ]; then
        echo "------------------------------------------"
        echo " DB Name            | # Tables            "
        echo "------------------------------------------"

        for db in ${databases[@]}
        do
	   tables_count=$(find "$databases_dir/$db" -maxdepth 1 -type f -name '*_meta' | wc -l)
	   printf "%-20s%-1s%-20s\n" " $db" "|" " $tables_count"
	   echo "------------------------------------------"	
	done
    else
	exit 0
    fi

else
    echo -e "${RED}Missing important directory ${RESET} $databases_dir"
    exit 1
fi
