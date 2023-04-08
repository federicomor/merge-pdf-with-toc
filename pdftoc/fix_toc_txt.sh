[ -e temp.txt ] && rm temp.txt
[ -e new_toc.txt ] && rm new_toc.txt

cp toc.txt temp.txt
touch new_toc.txt

IFS="\n"
while read line
do
	line_1=`echo "$line" | sed 's/\(.*\/\)\(.*\),Black.*/\1/'`
	line_2=`echo "$line" | sed 's/\(.*\)\/\(.*\)\(,Black.*\)/\3/'`
	somma=`echo "$line" | sed 's/.*\/\(.*\),Black.*/\1/' | bc`
	echo "$line_1$somma$line_2" >> new_toc.txt
done < toc.txt
