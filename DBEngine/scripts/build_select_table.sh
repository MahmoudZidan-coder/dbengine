#! /usr/bin/bash

arguments=("${@}")
table_path=${arguments[0]}

indicees=("${arguments[@]:4}")
indicess_string="${arguments[@]:4}"
no_indicees=${#indicees[@]}
condition_col=${arguments[1]}

com_op=${arguments[2]}
value=${arguments[3]}


columns_names=$(sed '1p' "$table_path""_meta")
IFS=' ' read -ra names <<< "$columns_names"

border_text=""
header_cols_text=""
header_size_text=""

for ((i=0; i<$no_indicees; i++))
do
    border_text+="----------------------"
    header_size_text+="%-20s%-2s"
    header_cols_text+=" ${names[${indicees[$i]}]} | "
done

header_size_text=$header_size_text"\n"

echo $border_text
printf $header_size_text $header_cols_text 
echo $border_text


awk -F";" -v con_col="$condition_col" -v op="$com_op" -v val="$value" -v idxs="$indicess_string" -v border="$border_text" '

BEGIN {
    split(idxs, req_idxs, " ")
    con_col+=1
}

{
    if (op == "="){
	if ( $con_col == val){
	    for (i = 1; i <= length(req_idxs); i++) {
		req_col=req_idxs[i]+1
            	printf "%-20s%s%s", $req_col, "|", (i == length(req_idxs) ? "\n" : " ")
	    }
	    print border
     	}
    } else if (op == "<"){
	if ( $con_col < val){
	    for (i = 1; i <= length(req_idxs); i++) {
		req_col=req_idxs[i]+1
            	printf "%-20s%s%s", $req_col, "|", (i == length(req_idxs) ? "\n" : " ")
	    }
	    print border
     	}
    }else if (op == ">"){
	if ( $con_col > val){
	    for (i = 1; i <= length(req_idxs); i++) {
		req_col=req_idxs[i]+1
            	printf "%-20s%s%s", $req_col, "|", (i == length(req_idxs) ? "\n" : " ")
	    }
	    print border
     	}
    }else {
	for (i = 1; i <= length(req_idxs); i++) {
	    req_col=req_idxs[i]+1
            printf "%-20s%s%s", $req_col, "|", (i == length(req_idxs) ? "\n" : " ")
	}
	print border
    }
    
}' $table_path





















