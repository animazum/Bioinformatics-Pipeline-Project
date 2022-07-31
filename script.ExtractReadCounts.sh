#!/usr/bin/env bash
echo "################################################################################
Hello, this program does:
1. Read counts for the regions specified in a provided BED file outputed as JSON.
2. Extract reads in the regions and convert them into a FASTA file.

PLEASE TYPE THE NAME OF A .txt FILE containing the bam
and bed files, DO NOT USE FILES WITH SPACES IN THE NAMES.
Please uncompress all files that you want to use before hand.

Format example for inputfile:
file.bam file.bed
file2.bam file2.bed
file.x.bam filez.bed

Be sure to have all the bam, bed and .txt files in the working directory
You need samtools to run this script.
#########################################################################################"

#read -r FILENAME  ###<--- In case that you want to make the program interactive :)
FILENAME=${1?Error: no name given}  ### silence it in case that you want to make program interactive

LINES=$(cat $FILENAME)
COUNTER=1
COUNTERs=1

### creating object to know how long is our BAM BED list
FILEDIM=$(wc -l < $FILENAME)

for f in $(seq $FILEDIM); do
  #### reates object with the name of the BAM files to be used
  USELINE=$(awk "NR ==$f" $FILENAME)
  BAM=${USELINE/%[[:blank:]]*}
  mkdir ${BAM/%.bam*/_directory} # creation of directories
    echo "Process $COUNTER: Sorting $BAM bam file..."
    COUNTER=$((COUNTER+1))

#### Sort bam file
  samtools sort "$BAM" -o "${BAM/%.bam/.sorted.bam}"
done

for f in $(seq $FILEDIM); do
  USELINE=$(awk "NR ==$f" $FILENAME)
  BAM=${USELINE/%.bam[[:blank:]]*/.sorted.bam}
    echo "Process $COUNTER: Creating index for $BAM bam file..."
    COUNTER=$((COUNTER+1))

#### Create index for bam file
  samtools index "$BAM"

done

#### Extraction of counts, read and creation of fasta file
for f in $(seq $FILEDIM); do
  USELINE=$(awk "NR ==$f" $FILENAME)
  BAM=${USELINE/%.bam[[:blank:]]*/.sorted.bam}
  #echo "$BAM"
  BED=${USELINE/#*[[:blank:]]}
  #echo "$BED"

    echo "FILE set Number $COUNTERs"
  COUNTERs=$((COUNTERs+1))
      echo "Processing: $BAM file..."
      echo "Processing: $BED file..."

      echo "Extract counts"
  samtools view -c "$BAM" -R "$BED" > "$BAM.json"

    echo "Extract reads"
  samtools view "$BAM" -R "$BED" -O BAM > "${BAM/%.bam/}.reads.bam"

echo "Transform to fasta"
bamtools convert -format fasta -in ${BAM/%.bam/}.reads.bam -out "${BAM/%.bam/}.regions.fasta"
    done

#### move files to already created directories
    for f in $(seq $FILEDIM); do
      USELINE=$(awk "NR ==$f" $FILENAME)
      BAM=${USELINE/%bam*}
      #echo "$BAM"
      BED=${USELINE/#*[[:blank:]]}
      #echo "$BED"
      mv ${BAM%bam*}* ${BAM/./_directory}
      mv ${BED}* ${BAM/./_directory}
    done
