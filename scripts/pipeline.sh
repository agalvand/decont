#Download all the files specified in data/filenames
for url in $(cat /home/vant/Documentos/Master_ISCIII/Linux_Avanzado/Entrega_final/decont/data/urls) 
do
    bash scripts/download.sh $url data
done

#Download the contaminants fasta file, uncompress it, and 
#filter to remove all small nuclear RNAs
bash scripts/download.sh "https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz" res yes "small nuclear"

# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

# Merge the samples into a single file
for sid in $( ls data/*.fastq.gz | cut -d "-" -f1 | cut -d "/" -f2 | sort | uniq); do 
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# Run cutadapt for all merged files to remove the adapters
    echo "Running cutadapt..."
    mkdir -p log/cutadapt
    mkdir -p out/trimmed
for file in out/merged/*.fastq.gz
do sample=$(basename "$file" .fastq.gz) #obtain the sample ID from the filename
   cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
       -o out/trimmed/${sample}.trimmed.fastq.gz "$file" \ 
      > log/cutadapt/${sample}.log #run cutadapt for each merged file and save the log
done 

# Run STAR for all trimmed files
echo "Running STAR alignment..."
for fname in out/trimmed/*.fastq.gz
do 
    obtain the sample ID from the filename
    sid=$(basename "$fname" .trimmed.fastq.gz)
    mkdir -p out/star/$sid
    STAR --runThreadN 4 --genomeDir res/contaminants_idx \
    --outReadsUnmapped Fastx --readFilesIn out/trimmed/$fname\
    --readFilesCommand gunzip -c --outFileNamePrefix out/star/$sid/ 
done 

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
