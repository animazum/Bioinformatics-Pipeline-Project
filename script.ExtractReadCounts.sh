#!/usr/bin/env bash
echo "#################################################################################
PLEASE TYPE THE NAME OF A .txt FILE containing the bam and bed files, DO NOT USE FILES WITH SPACES IN THE NAMES.
Please uncompress all files that you want to use before using the program.

Format example for inputfile: file.bam file.bed file2.bam file2.bed file.x.bam filez.bed

See example file: list.BAM.BED.txt

Be sure to have all the bam, bed and .txt files in the working directory You need samtools and bamtools to run this script.

I will upload a file with example bam and bed files in case that you need to do some testing before using larger files.
(test BAM file was retrieved from https://github.com/brainstorm/)

This program is capable of using as many bam or bed files as needed. Also It only requires samtools, bamtools and basic bash tools,
so practically any machine linux ubuntu 20.04 LTS or similar would be able to run it in no time.
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
