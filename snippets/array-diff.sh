#!/bin/bash

declare -a arr_tmp
declare -a arr_old
declare -a arr_new
declare -a arr_dif

arr_old=("a" "b" "c" "d" "e" "f" "g" "\t\t")
arr_new=("a" "b" "d" "e" "g")

# one liner
 echo -e "One Line:"
 echo -e "--------"
echo ${arr_new[@]} ${arry_old[@]} | tr ' ' '\n' | sort | uniq -u
echo -e "--------\n"

# fubction
# Thanks to:
# https://github.com/fabianlee/blogcode/blob/master/bash/arraydiff.sh
function arraydiff() {
  awk 'BEGIN{RS=ORS=" "}
       {NR==FNR?a[$0]++:a[$0]--}
       END{for(k in a) if (a[k]) print k}' <(echo -n "${!1}") <(echo -n "${!2}")
}

arr_tmp=($(arraydiff arr_old[@] arr_new[@]))
# Sort and remove string "install"
readarray -t arr_tmp < <(printf '%s\n' "${arr_tmp[@]/'install'}" | sort)

# remove empty or \t values from array 
# create new array to fix inexes
    echo -e "Function:"
    echo -e "--------"
for f in ${!arr_tmp[@]}; do
    if [ -n "${arr_tmp[f]}" ]; then
        echo -e "${f}" "${arr_tmp[f]}"
        [[ $f ]] && arr_dif+=( "${arr_tmp["f"]}" )
    fi
    if [ -z "${arr_tmp[f]}" ]; then
        echo -e "${f}" "${arr_tmp[f]}"
    fi
    done

echo -e "Old:" ${arr_old[@]}
echo -e "New:" ${arr_new[@]}
echo -e "tmp:" ${arr_tmp[@]}
echo -e "dif:" ${arr_dif[@]}