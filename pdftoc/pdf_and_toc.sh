echo "" > toc.txt
pag=0
files=""

for i in *.pdf
do
	read -p "include $i? " answ
	if [ $answ = "y" ]; then

		read -p "  > bookmark also the file? " book_file
		if [ $book_file = "y" ]; then
			echo "$i/$((1+pag)),Black,notBold,notItalic,open,TopLeftZoom,0,997,0.0" |
			sed 's/.pdf//' >> toc.txt

			read -p "  > add file chapters as sub-chapters? " sub_chap
			if [ $sub_chap = "y" ]; then
				add=`./pdftoc/jpdfbookmarks_cli.exe -d "$i" |
				sed "s/\/\(.*\),Black/\/\1+$pag,Black/" | sed "s/\(.*\)/\t\1/" `
				echo -e "$add" >> toc.txt
			else
				add=`./pdftoc/jpdfbookmarks_cli.exe -d "$i" |
				sed "s/\/\(.*\),Black/\/\1+$pag,Black/" `
				echo -e "$add" >> toc.txt
			fi
		else
			add=`./pdftoc/jpdfbookmarks_cli.exe -d "$i" |
			sed "s/\/\(.*\),Black/\/\1+$pag,Black/" `
			echo -e "$add" >> toc.txt
		fi
		
		pag=$((pag + `exiftool "$i" | awk -F": " '/Page Count/{print $2}'`))
		## Remover spaces from file name
		mv "$i" `echo $i | sed -e 's/ /_abc_/g'` 2>/dev/null
		j="`echo $i | sed -e 's/ /_abc_/g'`"
		files="$files $j "

	elif [ $answ == "a" ]; then
		# answer a (like all) for saying yes to both questions

		echo "$i/$((1+pag)),Black,notBold,notItalic,open,TopLeftZoom,0,997,0.0" |
			sed 's/.pdf//' >> toc.txt
		add=`./pdftoc/jpdfbookmarks_cli.exe -d "$i" |
			sed "s/\/\(.*\),Black/\/\1+$pag,Black/" | sed "s/\(.*\)/\t\1/" `
			echo -e "$add" >> toc.txt

		pag=$((pag + `exiftool "$i" | awk -F": " '/Page Count/{print $2}'`))
		## Remover spaces from file name
		mv "$i" `echo $i | sed -e 's/ /_abc_/g'` 2>/dev/null
		j="`echo $i | sed -e 's/ /_abc_/g'`"
		files="$files $j "
	fi
done

echo ""

echo "Merging the pdfs... it may require some time..."
# echo $files
pdfunite $files out.pdf

echo "Fixing bookmarks..."
bash ./pdftoc/fix_toc_txt.sh
# cat new_toc.txt

echo "Importing them..."
./pdftoc/jpdfbookmarks_cli.exe -a new_toc.txt -f out.pdf

echo "done!"
echo ""
rm temp.txt toc.txt
read -p "How to call the final pdf? " pdf_name
mv out.pdf "$pdf_name.pdf"
# rm new_toc.txt

## Recover original names
for file in $files
do
	mv "$file" "`echo $file | sed -e 's/_abc_/ /g'`" 2>/dev/null
done
