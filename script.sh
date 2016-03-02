#!/usr/bin/env bash
# Console colorse
RED="\033[31m"
BLUE="\033[34m"
WHITE="\033[37m"
GREEN="\033[32m"
DEFAULT="\033[0m"

#Text format
BOLD_TEXT=$(tput bold)
NORMAL_TEXT=$(tput sgr0)

echo -e "${RED}${BOLD_TEXT}Following is the input needed:"
echo -e "${GREEN}\$1: FILE_NAME"
echo -e "${GREEN}\$2: DELIMITER"
echo -e "${GREEN}\$3: DATE_FIELD IN NUMERIC VALUE"
echo -e "${GREEN}\$4: DATE_FORMAT"
DEFAULT_INPUT_VALUES=("FILENAME" "DELIMITER" "DATE_FIELD_NUMBER" "DATE_FORMAT")
input=()
isInputCorrect="true"

for i in `eval echo {1..${#DEFAULT_INPUT_VALUES[@]}}`
do
    input[$(($i-1))]=`eval echo '$'$i`
    declare ${DEFAULT_INPUT_VALUES[$(($i-1))]}=$(($i-1))
done
for i in `eval echo {0..$((${#DEFAULT_INPUT_VALUES[@]}-1))}`
do
    echo -e "${DEFAULT}=================================="
    if [[ ${input[$i]} == "" ]]
    then
        echo -e "${BOLD_TEXT}${RED}Please insert:" ${WHITE}${DEFAULT_INPUT_VALUES[$i]}
        isInputCorrect="false"
    else
        echo -e "${BLUE}${DEFAULT_INPUT_VALUES[$i]}: ${input[$i]}"
    fi
done

echo -e "${DEFAULT}=================================="

if [[ $isInputCorrect == "false" ]]
then
    echo -e "${RED}Sorry we couldn't proceed without above all input."
    exit 1
else
    bash ./validation.sh
    echo -e "${GREEN}We are executing code here!!!"
    date=()
    date_count=()

    year_start_position=$(echo ${input[$DATE_FORMAT]} | grep -i -aob 'y' | grep -oE '^[0-9]+' | head -1)
    month_start_position=$(echo ${input[$DATE_FORMAT]} | grep -i -aob 'M' | grep -oE '^[0-9]+' | head -1)
    OLDIFS=$IFS; IFS=$'\n'
    for line in $(cat ${input[$FILENAME]}*); do
        row_date_backup=$(echo $line | cut -d${input[$DELIMITER]} -f${input[$DATE_FIELD_NUMBER]})
        #row_date=$(echo $row_date | cut -c1-7)
        row_date=$(echo $row_date_backup | cut -c$(($year_start_position+1))-$(($year_start_position+4)))"-"
        row_date=$row_date"$(echo $row_date_backup | cut -c$(($month_start_position+1))-$(($month_start_position+2)))"

        if [[ ${#date[@]} == "0" ]]; then
            date[0]=$row_date
            date_count[0]=1;
        else
            isDateExist="false"
            IFS=$OLDIFS
            for i in `eval echo {0..$((${#date[@]}-1))}`; do
                if [[ ${date[$i]} == $row_date ]]; then
                    date_count[$i]=$((${date_count[$i]}+1))
                    isDateExist="true"
                    break
                fi
            done
            if [[ $isDateExist == "false" ]]; then
                #todo: sorting
                date[${#date[@]}]=$row_date;
                date_count[${#date_count[@]}]=1;
            fi
        fi
    done

    echo -e "${BOLD_TEXT}${RED}|--------|--------|"
    echo -e "${RED}|DATE    | Count  |"
    echo -e "${RED}|--------|--------|"
    for i in `eval echo {0..$((${#date[@]}-1))}`
    do
        echo -e ${NORMAL_TEXT}${RED}"|"${WHITE}${date[i]} ${RED}"|" ${WHITE}${date_count[i]}${RED}"      |"
    done
    echo -e "${RED}|--------|--------|${DEFAULT}"
    exit 0
fi
