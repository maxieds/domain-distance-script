#### dds.sh : Wrapper script around the domain distance finding utilities
#### Author:  Maxie D. Schmidt (maxieds@gmail.com)
#### Created: 06.11.2018

#!/bin/bash

RNABRANCHVIZ=/home/maxie/RNA-projects/RNABranchIDViz/src/RNABranchIDViz
MEGACC=megacc
CLEANUP=true
LOCALFILESUFFIX=""

print_usage() {
     echo "Usage: $0 --align-config=acfg.mao --dist-config=dcfg.mao --input=myseqs.txt [--noclean] [--datestamp-files]"
}

generate_combined_domain_temp_file() {
     outputTempFile=$1;
     domainNum=$2;
     for ctfile in "${InputCTFileNames[@]}"; do
          baseFilename=$(echo "$ctfile" | sed 's/\.[^.]*$//');
          FASTAFile=$(echo "${baseFilename}-branch0${domainNum}.fasta");
          cat $FASTAFile >> $outputTempFile;
     done
}

## Parse the commandline arguments:
for arg in "$@"
do
case $arg in
     --align-config=*)
     ALIGNCFGFILE="${arg#*=}"
     shift
     ;;
     --dist-config=*)
     DISTCFGFILE="${arg#*=}"
     shift
     ;;
     --input=*)
     INPUTCT="${arg#*=}"
     shift
     ;; 
     --noclean)
     CLEANUP=false
     ;;
     --datestamp-files)
     LOCALFILESUFFIX=$(date +"-%F-%H%M%S")
     ;;
     *)
     print_usage
     exit 1
     ;;
esac
done

if [ -z "$ALIGNCFGFILE" ]; then
     print_usage;
     exit 2;
fi
if [ -z "$DISTCFGFILE" ]; then
     print_usage;
     exit 3;
fi
if [ -z "$INPUTCT" ]; then
     print_usage;
     exit 4;
fi

## Now we have valid config and input CT file parameters to work with:
## Run RNABranchIDViz on each file in the input file to generate the 
## individual (X4) domain FASTA files:
echo "Now running RNABranchIDViz to generate subdomain FASTA files ... ";
echo "This could take a while depending on how many structures were input.";

InputCTFileNames=();
while read fname; do
     $RNABRANCHVIZ $fname --output-fasta --quiet;
     InputCTFileNames+=("$fname");
done < $INPUTCT

## Now compute the sequence alignments and generate the distances: 
echo "Now generating the domain-wise alignments and distances ...";

TempFASTAFilename="temp.fasta";
touch $TempFASTAFilename;
MegaRuntimeMessagesOutFile="mega-messages.out";

domainNums=("1" "2" "3" "4");
domainDistances=();
for dnum in "${domainNums[@]}"; do
     echo "     > Generating data for domain #$dnum";
     rm $TempFASTAFilename;
     generate_combined_domain_temp_file $TempFASTAFilename $dnum;
     alignmentOutputFile=$(echo localAlignmentFile-branch0$dnum${LOCALFILESUFFIX}.meg);
     $MEGACC -a $ALIGNCFGFILE -d $TempFASTAFilename -f MEGA -o $alignmentOutputFile > $MegaRuntimeMessagesOutFile 2>&1;
     distanceOutputFile=$(echo localDistanceFile-branch0$dnum${LOCALFILESUFFIX}.meg);
     $MEGACC -a $DISTCFGFILE -d $alignmentOutputFile -f MEGA -o $distanceOutputFile >> $MegaRuntimeMessagesOutFile 2>&1;
     distanceCompValue=$(cat $distanceOutputFile | tail -n 2 | head -n 1 | cut -d']' -f 2 | sed 's/ *//');
     domainDistances+=("  > Domain #$dnum Distance: $distanceCompValue");
done

## Now print the computed distances: 
echo -e "Domain-wise Distance Summary:";
for distSummary in "${domainDistances[@]}"; do
     echo $distSummary;
done

## Cleanup working directory: 
rm $TempFASTAFilename;
if [ "$CLEANUP" = true ]; then 
     rm localAlignment* localDistanceFile*;
fi

exit 0;
