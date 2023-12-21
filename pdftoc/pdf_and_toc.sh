#################
# cpath="/<path to folder>/pdftoc"
# it should be something like "/.../pdftoc"
cpath="/mnt/c/Users/feder/Desktop/Ode/Github/merge-pdf-with-toc/pdftoc"
#################

echo "" > toc.txt
pag=0
files=""

read -p "Do you want to use all the pdf in the current folder, or to select them by hand? (all/select/a/s) " choice
if [ $choice = "all" ] || [ $choice = "a" ] ; then
	for i in *.pdf
	do
		echo "Processing file $i"
		echo "$i/$((1+pag)),Black,notBold,notItalic,open,TopLeftZoom,0,997,0.0" |
			sed 's/.pdf//' >> toc.txt
		add=`$cpath/jpdfbookmarks_cli.exe -d "$i" |
			sed "s/\/\(.*\),Black/\/\1+$pag,Black/" | sed "s/\(.*\)/\t\1/" `
			echo -e "$add" >> toc.txt

		pag=$((pag + `exiftool "$i" | awk -F": " '/Page Count/{print $2}'`))
		## Remover spaces from file name
		mv "$i" `echo $i | sed -e 's/ /_abc_/g'` 2>/dev/null
		j="`echo $i | sed -e 's/ /_abc_/g'`"
		files="$files $j "
	done
else
	for i in *.pdf
	do
		read -p "include $i? (y/n/a) " answ
		if [ $answ = "y" ]; then

			read -p "  > bookmark also the file? (y/n) " book_file
			if [ $book_file = "y" ]; then
				echo "$i/$((1+pag)),Black,notBold,notItalic,open,TopLeftZoom,0,997,0.0" |
				sed 's/.pdf//' >> toc.txt

				read -p "  > add file chapters as sub-chapters? (y/n) " sub_chap
				if [ $sub_chap = "y" ]; then
					add=`$cpath/jpdfbookmarks_cli.exe -d "$i" |
					sed "s/\/\(.*\),Black/\/\1+$pag,Black/" | sed "s/\(.*\)/\t\1/" `
					# echo $add
					echo -e "$add" >> toc.txt
				# else
				# 	# add=`$cpath/jpdfbookmarks_cli.exe -d "$i" |
				# 	# sed "s/\/\(.*\),Black/\/\1+$pag,Black/" `
				# 	# echo $add
				# 	# echo -e "$add" >> toc.txt
				# 	continue
				fi
			else
				add=`$cpath/jpdfbookmarks_cli.exe -d "$i" |
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
			add=`$cpath/jpdfbookmarks_cli.exe -d "$i" |
				sed "s/\/\(.*\),Black/\/\1+$pag,Black/" | sed "s/\(.*\)/\t\1/" `
				echo -e "$add" >> toc.txt

			pag=$((pag + `exiftool "$i" | awk -F": " '/Page Count/{print $2}'`))
			## Remover spaces from file name
			mv "$i" `echo $i | sed -e 's/ /_abc_/g'` 2>/dev/null
			j="`echo $i | sed -e 's/ /_abc_/g'`"
			files="$files $j "
		fi
	done
fi

echo ""

echo "Merging the pdfs... it may require some time..."
# echo $files
pdfunite $files out.pdf

echo "Fixing bookmarks..."
bash $cpath/fix_toc_txt.sh
# cat new_toc.txt

echo "Importing them..."
$cpath/jpdfbookmarks_cli.exe -a new_toc.txt -f out.pdf

echo "done!"
echo ""
rm temp.txt toc.txt
# read -p "How to call the final pdf? " pdf_name
# mv out.pdf "$pdf_name.pdf"

# rm new_toc.txt

## Recover original names
for file in $files
do
	mv "$file" "`echo $file | sed -e 's/_abc_/ /g'`" 2>/dev/null
done
