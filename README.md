# merge-pdf-with-toc
Merge more pdf files into one, preserving the toc (table of contents) of all of them (ie merging also that).

## Usage
Bring all the pdfs into this current folder. Then execute the script `pdf_and_toc.sh`. At the end there will be a `out.pdf` file with the result.

## Technical comments and Requirements
- The library jpdfbookmarks* is used, so java* is required in order to run it
- The merging of the pdf is done by the command pdfunite, which is installable on ubuntu through *poppler-utils*
- The other script `fix_toc_txt.sh` finalizes the computation of the pages 

Here there are some pdf for a small example of the result, where we can see how the single toc of each pdf ended also here, correctly shifted, into the final pdf.
[example of the result](example.png)
