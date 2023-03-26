echo "" > toc.txt
touch toc.txt
pag=0
files=""
for i in *.pdf
do
	read -p "include $i? " answ
	if [ $answ = "y" ]; then
		files="$files $i "
		echo "$i/$((1+pag)),Black,notBold,notItalic,open,TopLeftZoom,0,997,0.0" |
			sed 's/.pdf//' >> toc.txt

		add=`./jpdfbookmarks-2.5.2/jpdfbookmarks_cli.exe -d $i |
			sed "s/\/\(.*\),Black/\/\1+$pag,Black/" `

		echo "$add" >> toc.txt
		# echo "" >> toc.txt

		pag=$((pag + `exiftool $i | awk -F": " '/Page Count/{print $2}'`))
		# echo "$pag"
	fi
done
echo ""

echo "Merging the pdfs... it may require some time..."
pdfunite $files out.pdf

echo "Fixing bookmarks..."
bash fix_toc_txt.sh

echo "Importing them..."
./jpdfbookmarks-2.5.2/jpdfbookmarks_cli.exe -a new_toc.txt -f out.pdf

echo "done!"
rm temp.txt toc.txt new_toc.txt
