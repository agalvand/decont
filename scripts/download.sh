# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output


url="$1"
outdir="$2"
uncompress="$3"
exclude_word="$4"


mkdir -p "$outdir"


filename=$(basename "$url")
filepath="$outdir/$filename"


echo "Descargando $url..."
wget -q "$url" -O "$filepath"


if [[ "$uncompress" == "yes" && "$filepath" == *.gz ]]; then
    echo "Descomprimiendo $filename..."
    gunzip -f "$filepath"
    filepath="${filepath%.gz}"
fi


if [[ -n "$exclude_word" ]]; then
    echo "Filtrando secuencias que contienen '$exclude_word'..."
    awk -v exclude="$exclude_word" '
        /^>/ { printheader = ($0 !~ exclude)}
        printheader' "$filepath" > "$filepath.filtered"
    mv "${filepath}.filtered" "$filepath"
fi

echo "Finalizado. Tu archivo se encuentra en: $filepath"
