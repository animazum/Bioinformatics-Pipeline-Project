# Bioinformatics-Pipeline-Project


Hello, this program is called Bioinformatics-Pipeline-Project and it does the following…
1. Read counts for the regions specified in a provided BED file outputed as JSON.
2. Extract reads in the regions and convert them into a FASTA file.

########################## IMPORTANT NOTES  ##########################
This program will need bam files and bed with the regions that you want to extract. 
The output files will be a directory with the original bam file, the original bed file, a sorted bam file, 
a json file with the counts of the regions specified, the reads of the regions in bam and fasta format. 

PLEASE TYPE THE NAME OF A .txt FILE containing the bam
and bed files, DO NOT USE FILES WITH SPACES IN THE NAMES.
Please uncompress all files that you want to use before using the program.

Format example for inputfile:
file.bam file.bed
file2.bam file2.bed
file.x.bam filez.bed

See example file: list.BAM.BED.txt

Be sure to have all the bam, bed and .txt files in the working directory
You need samtools to run this script.

I will upload a file with example bam and bed files in case that you need to do some testing before using larger files.

This program in intended to be capable to use an n number of bam or bed files. Also It only requires samtools and basic bash tools
so practically any linux machine would be able to run it in no time.
############################################################################

#Recomended preparations to run the program:

Install docker and create docker container 
I recommend to use docker for this as it is a very powerful tool to test and use any program in a safe and controlled environment. 
Also it standardize the usage of the program in any computer with linux ubuntu of similar. 
But Docker is not fundamentally needed. 

Installation of docker can be found in dockers website: 
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
Follow the steps to instal docker as they could change depending on date, year, etc that you are looking at this readme file. 

Also I have to say that for this program I used linux ubuntu 20.04 but it could also run in any other similar linux OS or unix OS. 

#### Creating the docker container. 
$sudo docker run -d -t --name MYCONTAINER ubuntu bash

####Open the container 
sudo docker exec -it MYCONTAINER bash

#### basic linux maintenance so your container is updated and ready to run
$apt-get update 
$apt-get upgrade

Now that you are in your container create a directory to store your data 
$mkdir MYFILE

### In case that your have data to download from github … (it is impotant to write “raw” in the web address to download the correct raw data). 
$wget https://github.com/BLABLA/BLABLA/raw/BLABLA/BLABLA/mt.bam

###In case that you have downloaded your data outside of your docker conatiner... Move your data into your docker container 
after you have downloaded it from your original location. (to know your container id simply type inyour computer $sudo docker ps, 
and a list of all your containers will be visible)

$sudo docker cp “/MY/LAPTOP/FILE/” MYACONTAINERID:/MYFILE

#############################################
Running the program
Now to this program we need to install samtools, its quite easy to install it.
$apt-get install samtools

Have fun running the program (in case that the script does not have de correct permissions be sure to set $chmod +x script.ExtractReadCounts.sh)
$ ./script.ExtractReadCounts.sh list.BAM.BED.txt
