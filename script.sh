# Console colorse
RED="\033[31m"
BLUE="\033[34m"
WHITE="\033[37m"
GREEN="\033[32m"
DEFAULT="\033[0m"

#Text format
BOLD_TEXT=$(tput bold)
NORMAL_TEXT=$(tput sgr0)

echo -e "${RED}${BOLD_TEXT}Following is the input needed:";
echo -e "${GREEN}\$1: FILE_NAME";
echo -e "${GREEN}\$2: DELIMITER";
echo -e "${GREEN}\$3: DATE_FIELD IN NUMERIC VALUE";
echo -e "${GREEN}\$4: DATE_FORMAT";
DEFAULT_INPUT_VALUES=("FILENAME" "DELIMITER" "DATE_FIELD_NUMBER" "DATE_FORMAT");
input=();
isInputCorrect="true";

for i in `eval echo {1..${#DEFAULT_INPUT_VALUES[@]}}`
do
    input[$(($i-1))]=`eval echo '$'$i`;
done;

for i in `eval echo {0..$((${#DEFAULT_INPUT_VALUES[@]}-1))}`
do
    echo -e "${DEFAULT}=================================="
    if [[ ${input[$i]} == "" ]]
    then
        echo -e "${BOLD_TEXT}${RED}Please insert:" ${WHITE}${DEFAULT_INPUT_VALUES[$i]};
        isInputCorrect="false";
    else
        echo -e "${BLUE}${DEFAULT_INPUT_VALUES[$i]}: ${input[$i]}";
    fi
done;

echo -e "${DEFAULT}=================================="

if [[ $isInputCorrect == "false" ]]
then
    echo -e "${RED}Sorry we couldn't proceed without above all input."
    exit 1;
else
    echo "We are executing code here!!!"
    exit 0;
fi
