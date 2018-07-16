# Domain Distance Script 

## Installation

### Required software

We will require the following software to be installed in order to run the script out-of-the-box:
1. [RNABranchIDViz](https://github.com/maxieds/RNABranchIDViz)
2. [megacc](https://www.megasoftware.net/) 

### Cloning the local script repository

To install the script, first clone the GitHub repository into your home directory:
```
$ cd ~
$ git clone https://github.com/maxieds/domain-distance-script.git
$ cd domain-distance-script
```
Next, we should make the key script ``dds.sh`` executable in the current working directory:
```
chmod +x dds.sh
```
Now the script is ready to be run (see below)!

## Usage 

### Script parameters

Running the script requires passing it three key items:
1. The name of an alignment (i.e., *Muscle* or *ClustalW*) config file with extension ``*.mao``; 
2. The name of a distance config file with extension ``*.mao``; and 
3. The name of an input newline-separated text file containing the full (absolute) path names of 
   each full CT file we wish to consider in the alignment-to-distance analysis.

### Script syntax
First, note that the contents of the file ``myseqs.txt`` in the below is given by 
```
d.16.e.E.cuniculi_nop.ct
d.16.b.M.leprae_nop.ct
```
Let's give an example of running the script with our desired parameters:
```
$ export ACFGFILE=config-files/clustal_align_nucleotide.mao
$ export DCFGFILE=config-files/distance_estimation_pairwise_nucleotide.mao
$ export MYSEQSFILE=myseqs.txt
$ ./dds.sh --align-config=$ACFGFILE --dist-config=$DCFGFILE --input=$MYSEQSFILE | tail -n 5
```
This should output something like the following:
```
Domain-wise Distance Summary:
> Domain #1 Distance: 1.05561752
> Domain #2 Distance: 0.72167020
> Domain #3 Distance: 0.60125824
> Domain #4 Distance: 0.96824050
```
The previous distance computation uses the *ClustalW* alignment. Let's recompute this time using the 
*Muscle* alignment options:
```
$ export ACFGFILE=config-files/muscle_align_nucleotide.mao
$ export DCFGFILE=config-files/distance_estimation_pairwise_nucleotide.mao
$ export MYSEQSFILE=myseqs.txt
$ ./dds.sh --align-config=$ACFGFILE --dist-config=$DCFGFILE --input=$MYSEQSFILE
```
This should output something like the following:
```
Now running RNABranchIDViz to generate subdomain FASTA files ... 
This could take a while depending on how many structures were input.
Now generating the domain-wise alignments and distances ...
     > Generating data for domain #1
     > Generating data for domain #2
     > Generating data for domain #3
     > Generating data for domain #4
Domain-wise Distance Summary:
> Domain #1 Distance: 0.58991078
> Domain #2 Distance: 0.68627662
> Domain #3 Distance: 0.46816360
> Domain #4 Distance: 0.68226090
```
After running the ``dds.sh`` script, any runtime messages output by ``megacc`` during the 
execution of the script can be viewed by running (press ``q`` to exit): 
```
$ less mega-messages.out
```

## Other options to the script

For the purposes of debugging there is a ``--noclean`` script which will prevent the intermediate 
``*.meg`` and summary ``*.txt`` files from being removed after the execution of the script. 
Be forewarned however, that if you attempt to re-run the script you should delete these intermediate 
files to make sure that ``megacc`` does not see them and rename the output files slightly (like by 
prepending ``filename(#).meg``). If this happens then the script will not operate on the correct set of 
files generated by the most recent run of the component programs. Another way to make sure that the 
intermediate files are always uniquely named in conjunction with the ``--noclean`` option is to also 
set the ``--datestamp-files`` option: 
```
$ ./dds.sh --align-config=$ACFGFILE --dist-config=$DCFGFILE --input=$MYSEQSFILE --noclean --datestamp-files
$ ls -lh | grep local
```
The above should generate a directory listing that resembles the following output:
```
-rw-rw-r-- 1 maxie maxie 1.3K Jul 16 02:55 localAlignmentFile-branch01-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.1K Jul 16 02:55 localAlignmentFile-branch01-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie  882 Jul 16 02:55 localAlignmentFile-branch02-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.1K Jul 16 02:55 localAlignmentFile-branch02-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie 1.2K Jul 16 02:55 localAlignmentFile-branch03-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.1K Jul 16 02:55 localAlignmentFile-branch03-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie  468 Jul 16 02:55 localAlignmentFile-branch04-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.1K Jul 16 02:55 localAlignmentFile-branch04-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie 1.2K Jul 16 02:55 localDistanceFile-branch01-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.5K Jul 16 02:55 localDistanceFile-branch01-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie 1.2K Jul 16 02:55 localDistanceFile-branch02-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.5K Jul 16 02:55 localDistanceFile-branch02-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie 1.2K Jul 16 02:55 localDistanceFile-branch03-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.5K Jul 16 02:55 localDistanceFile-branch03-2018-07-16-025530_summary.txt
-rw-rw-r-- 1 maxie maxie 1.2K Jul 16 02:55 localDistanceFile-branch04-2018-07-16-025530.meg
-rw-rw-r-- 1 maxie maxie 2.5K Jul 16 02:55 localDistanceFile-branch04-2018-07-16-025530_summary.txt
```
