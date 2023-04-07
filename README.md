# merge-pdf-with-toc
Merge more pdf files into one, preserving the toc (table of contents) of all of them (ie merging also that).

## Usage
Bring all the pdfs into this current folder, then execute the script `pdf_and_toc.sh` (make sure that the folder of jpdfbookmarks is in the same directory of the script). At the end there will be a `out.pdf` (or whatever name you choose) file with the result.

For each pdf in the current folder, it will be asked if you want to include them in the merging process.

If yes, it asks if you want to add a chapter with the current pdf name as title (like to say "here starts the current pdf content").
If you answer yes to this, it then asks how you want to add the chapters of the current pdf: as sub-chapters of the "pdf file" chapter, or as single ones, indipendent of the pdf out of which they came from.

## Technical comments and Requirements
- The library *jpdfbookmarks* is used, so *java* is required in order to run it
- The merging of the pdf is done by the command *pdfunite*, which is installable on ubuntu through the package *poppler-utils* (sudo apt install it)
- For the pdf handling also the package *exiftool* is required, and it is installable as before through the package *libimage-exiftool-perl*
- The other script `fix_toc_txt.sh` finalizes the computation of the pages

## Example
Here there is a small example of the result, using the pdfs in the Test folder, where we can see how the single toc of each pdf ended also here, correctly shifted, into the final document.

![example of the result](./example.png)

## Run of the example
```bash
include 01-Introduction.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include 02-ElementsOfC++.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include 03-FloatingPoints.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include 04-VectorsArraysTuples.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include 05-PointersSmartPointersandReferences.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include 06-Functions-Functors-Lambdas.pdf? y
  bookmark also the file? y
  add file chapters as sub-chapters? y
include out.pdf? n

Merging the pdfs... it may require some time...
Fixing bookmarks...
Importing them...
done!

How to call the final pdf? Lectures
```
