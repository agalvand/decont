# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

# STAR --runThreadN 4 --runMode genomeGenerate --genomeDir <outdir> \
# --genomeFastaFiles <genomefile> --genomeSAindexNbases 9

ref="$1"
outdir="$2"

mkdir -p "$outdir"

echo "Indexando el genoma $ref..."

STAR --runThreadN 4 --runMode genomeGenerate --genomeDir "$outdir" \
--genomeFastaFiles "$ref" --genomeSAindexNbases 9

echo "Índice generado en $outdir"