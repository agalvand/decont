# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

data="$1"
outdir="$2"
sid="$3"

mkdir -p "$outdir"

cat "$data"/"$sid"-*.fastq.gz > "$outdir"/"$sid".fastq.gz

echo "Merged $sid into $outdir/$sid.fastq.gz"
