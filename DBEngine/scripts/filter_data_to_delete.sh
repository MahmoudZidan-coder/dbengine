#! /usr/bin/bash

arguments=("${@}")
table_path=${arguments[0]}

condition_col=${arguments[1]}
com_op=${arguments[2]}
value=${arguments[3]}

result=$(awk -F";" -v con_col="$condition_col" -v op="$com_op" -v val="$value" '
BEGIN{con_col+=1}
{
 if (op == "="){
	if ($con_col != val){
	    print $0
     	}
 } else if (op == "<"){
	if ($con_col >= val){
	    print $0
     	}
 }else if (op == ">"){
	if ($con_col <= val){
	    print $0
 	}
 }   
}' $table_path)

echo "" > $table_path

for line in "${result[@]}"; do
    echo "$line" >> $table_path
done

sed -i "1d" "$table_path"












