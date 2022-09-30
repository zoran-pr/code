#!/bin/bash

# part of reinstalling linux
# reduce apt-packages backup file 
# by removing already installed packages

declare -a arr_tmp
declare -a arr_old
declare -a arr_new
declare -a arr_apt

old_apt="backup-restore/backup-restore//apt-old-packages.list"
new_apt="backup-restore//apt-new-packages.list"

# Thanks to:
# https://github.com/fabianlee/blogcode/blob/master/bash/arraydiff.sh
function arraydiff() {
  awk 'BEGIN{RS=ORS=" "}
       {NR==FNR?a[$0]++:a[$0]--}
       END{for(k in a) if (a[k]) print k}' <(echo -n "${!1}") <(echo -n "${!2}")
}

readarray -t arr_old < backup-restore/backup-restore//apt-old-packages.list
readarray -t arr_new < backup-restore/include/apt-new-packages.list

arr_tmp=($(arraydiff arr_old[@] arr_new[@]))
# Sort and remove string "install"
readarray -t arr_tmp < <(printf '%s\n' "${arr_tmp[@]/'install'}" | sort)

# remove empty or \t values from array 
# create new array to fix inexes
for f in ${!arr_tmp[@]}; do
    if [ -n "${arr_tmp[f]}" ]; then
      echo "${f}" "${arr_apt[f]}"
      [[ $f ]] && arr_apt+=( "${arr_tmp["f"]}" )
    fi
    done

echo -e "Old::" ${arr_old[0]}
echo -e "New:" ${arr_new[0]}
echo -e "tmp:" ${arr_tmp[200]}
echo -e "apt:" ${arr_apt[200]}


printf "%s\t\t\t\t\tinstall\n" "${arr_apt[@]/' '}" > backup-restore//apt-packages.list
