#Word list
wordlist="list.txt"

#Gets the amount of words in the list
list_length=$( cat ${wordlist} | wc -l )

#Function to pick a number
function roll {
awk "BEGIN {srand() ; print int(rand()*(${list_length}-1)) } "
sleep 1
}

#Make sure valid argument was given
if [ $# -eq 0 ]; then
 echo "No arguments given"
 echo "Example: ./passwordgen.bash 6"
else
 #Make sure the argument is a number
 if [ "$1" -eq "$1" ] 2>/dev/null; then
  #Loop to pipe words to an array
  for ((i = 0 ; i < $1 ; i++)); do
   num=$( roll )
   word=$( awk "NR==${num}" "${wordlist}" )
   word_array[${i}]=${word}
  done
  #Echo the whole array
  echo ${word_array[@]}
 else
  echo "Argument must be a number"
  echo "Example: ./passwordgen.bash 6"
 fi
fi
