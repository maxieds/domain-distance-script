Anna Kirkpatrick's Notes: 

We are using MEGA: https://www.megasoftware.net/

It looks like there is a deb available, so install should be simple. (I have played with the software, but using the Windows version.)

There is a command line interface, which I'm sure is what you will end up using, but most of the documentation seems to be centered around the GUI. As much as I hate to say it, you might want to try doing these computations from the GUI first (where it will be easier to follow the documentation) before moving to the command line.

Essentially, we will be doing 2 separate steps with MEGA. Both of these steps happen after your code has separated out the domains, and they will happen independently for each domain.

Step one is to construct a multiple sequence alignment. That's basically what it sounds like: a way of aligning the whole list of sequences.  You will be aligning nucleotide sequences, not amino acids. For the moment, we will use the ClustalW method with the default parameters. Here's the relevant documentation for the overview of sequence alignment: https://www.megasoftware.net/web_help_10/index.htm#t=Part_II_Assembling_Data_For_Analysis%2FBuilding_Sequence_Alignments%2FIntroduction_to_Alignment_Explorer.htm and for ClustalW in particular: https://www.megasoftware.net/web_help_10/index.htm#t=Part_II_Assembling_Data_For_Analysis%2FBuilding_Sequence_Alignments%2FClustalW%2FAbout_ClustalW.htm

The input to multiple sequence alignment is your set of *.fasta files, and you will output a *.meg file.

Step 2 is to compute distances.  MEGA groups this under analysis. We will compute pairwise Kimura 2-parameter distance, giving a matrix of distances. Then we'll take a simple average over all of these pairwise distances. So this step takes the *.meg file as input and outputs a single floating-point number.

Here's the documentation on Kimura 2-parameter distance: https://www.megasoftware.net/web_help_10/index.htm#t=Kimura_2-parameter_distance.htm

As before, we will use the default values for all of the parameters.

MEGA has a function to calculate that average for you, as well, so you shouldn't need to write any new code.  This should just be a matter of stringing the pieces together.

The other link you probably need is the documentation on the command line interface.  That documentation seems to start here: https://www.megasoftware.net/web_help_10/index.htm#t=MEGA-CC_Overview.htm
