---
title: "Metagenome Binning"
teaching: 15
exercises: 5
questions:
- "How can we obtain the original genomes from a metagenome?"
objectives: 
- "Obtain Metagenome-Assembled Genomes from the metagenomic assembly."
- "Check the quality of the Metagenome-Assembled genomes."  
keypoints:
- "Metagenome-Assembled Genomes (MAGs) sometimes are obtained from curated contigs grouped into bins."
- "Use MAXBIN to assign the contigs to bins of different taxa."
- "Use ChekM to evaluate the quality of each Metagenomics-Assembled Genome."
---

## Metagenomic binning
To analyze each of the species inside our sample individually, the 
original genomes in the sample can be separated with a process called binning. 
We call these genomes reconstructed from a metagenomic assembly MAGs(Metagenome-Assembled Genomes).
In this process, the assembled contigs from the metagenome will be assigned to 
different bins (FASTA files that contain certain contigs). Ideally, each bin corresponds to only one original genome (a MAG).

<a href="{{ page.root }}/fig/03-05-01.png">
  <img src="{{ page.root }}/fig/03-05-01.png" width="435" height="631" alt="Cog Metagenome" />
</a>

Although an obvious way to separate contigs that correspond to a different species is by their taxonomic assignation, 
there are more reliable methods that do the binning using 
characteristics of the contigs, such as their GC content, the use of tetranucleotides (composition) or their coverage (abundance).

[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorithm 
that distinguishes between contigs that belong to different bins according to their 
coverage levels and the tetranucleotide frequencies they have.

Let's bin the sample we just assembled. The command for running MaxBin is `run_MaxBin.pl`, and the arguments it needs are the FASTA file of the assembly, the FASTQ with the forward and reverse reads, the output directory, and name. 
~~~
$ cd ~/dc_workshop/results/assembly_JC1A
$ mkdir MAXBIN
$ run_MaxBin.pl -thread 8 -contig JC1A_contigs.fasta -reads ../../data/trimmed_fastq/JC1A_R1.trim.fastq.gz -reads2 ../../data/trimmed_fastq/JC1A_R2.trim.fastq.gz -out MAXBIN/JC1A &
~~~
{: .bash} 
~~~
MaxBin 2.2.7
Thread: 12
Input contig: JC1A_contigs.fasta
Located reads file [../../data/trimmed_fastq/JC1A_R1.trim.fastq.gz]
Located reads file [../../data/trimmed_fastq/JC1A_R2.trim.fastq.gz]
out header: MAXBIN/JC1A
Running Bowtie2 on reads file [../../data/trimmed_fastq/JC1A_R1.trim.fastq.gz]...this may take a while...
Reading SAM file to estimate abundance values...
Running Bowtie2 on reads file [../../data/trimmed_fastq/JC1A_R2.trim.fastq.gz]...this may take a while...
Reading SAM file to estimate abundance values...
Searching against 107 marker genes to find starting seed contigs for [JC1A_contigs.fasta]...
Running FragGeneScan....
Running HMMER hmmsearch....
Try harder to dig out marker genes from contigs.
Marker gene search reveals that the dataset cannot be binned (the medium of marker gene number <= 1). Program stop.
~~~
{: .output} 

It seems that it is impossible to bin our assembly because the amount of marker genes is less than 1. 
We could have expected this as we know it is a small sample.

We will perform the binning process with the other sample from the same study 
that is a little larger. We have the assembly precomputed in the `~/dc-workshop/mags/` directory.
~~~
$ cd ~/dc_workshop/mags/
$ mkdir MAXBIN
$ run_MaxBin.pl -thread 8 -contig JP4D_contigs.fasta -reads ../data/trimmed_fastq/JP4D_R1.trim.fastq.gz -reads2 ../data/trimmed_fastq/JP4D_R2.trim.fastq.gz -out MAXBIN/JP4D &
~~~
{: .bash}  
It will take a few minutes to run. And it will finish with an output like this:

~~~
========== Job finished ==========
Yielded 4 bins for contig (scaffold) file JP4D_contigs.fasta

Here are the output files for this run.
Please refer to the README file for further details.

Summary file: MAXBIN/JP4D.summary
Genome abundance info file: MAXBIN/JP4D.abundance
Marker counts: MAXBIN/JP4D.marker
Marker genes for each bin: MAXBIN/JP4D.marker_of_each_gene.tar.gz
Bin files: MAXBIN/JP4D.001.fasta - MAXBIN/JP4D.004.fasta
Unbinned sequences: MAXBIN/JP4D.noclass

Store abundance information of reads file [../data/trimmed_fastq/JP4D_R1.trim.fastq.gz] in [MAXBIN/JP4D.abund1].
Store abundance information of reads file [../data/trimmed_fastq/JP4D_R2.trim.fastq.gz] in [MAXBIN/JP4D.abund2].


========== Elapsed Time ==========
0 hours 6 minutes and 56 seconds.

~~~
{: .output}  

With the `.summary` file we can have a quick look at the bins that MaxBin produced. 

~~~
$ more MAXBIN/JP4D.summary
~~~
{: .bash}  

~~~
Bin name	Completeness	Genome size	GC content
JP4D.001.fasta	57.9%	3141556	55.5
JP4D.002.fasta	87.9%	6186438	67.3
JP4D.003.fasta	51.4%	3289972	48.1
JP4D.004.fasta	77.6%	5692657	38.9
~~~
{: .output}  

> ## Discussion: The quality of MAGs
>
>Can we trust the quality of our bins only with the given information? 
>What else do we want to know about our MAGs to confidently use them for further analysis?
{: .discussion}

# Quality check 

The quality of a MAG is highly dependent on the size of the genome of the species, its abundance 
in the community, and the depth at which we sequenced it.
Two important things that can be meassured to know its quality are the completeness (is the MAG a complete genome?) 
and if it is contaminated (does the MAG contain only one genome?). 

[CheckM](https://github.com/Ecogenomics/CheckM) is a good program to see the quality of our MAGs. 
It gives a meassure of the completeness and the contamination by counting marker genes in the MAGs. 
The lineage workflow that is a part of CheckM places your bins in a refrence tree to know 
to which lineage it corresponds to and to use the appropriate marker genes to estimate the 
quality parameters. Unfortunately the lineage workflow uses a lot of memory so it can't run 
in our machines, but we can tell CheckM to use marker genes from Bacteria only, in order to spend less memory. 
This is a less accurate aproach but it can also be very useful if you want all of your bins analysed with the same markers. 

We will run the taxonomy workflow specifying the use of markers at the domain level, specific for the rank Bacteria, 
we will specify that our bins are in FASTA format, that they are located in the `MAXBIN` directory 
and that we want our output in the `CHECKM/` directory. 
~~~
$ mkdir CHECKM
$ checkm taxonomy_wf domain Bacteria -x fasta MAXBIN/ CHECKM/ 
~~~
{: .bash} 

The run will end with our results printed in the console.
~~~
--------------------------------------------------------------------------------------------------------------------------------------------------------
  Bin Id     Marker lineage   # genomes   # markers   # marker sets   0    1    2    3    4   5+   Completeness   Contamination   Strain heterogeneity  
--------------------------------------------------------------------------------------------------------------------------------------------------------
  JP4D.002      Bacteria         5449        104            58        3    34   40   21   5   1       94.83           76.99              11.19          
  JP4D.004      Bacteria         5449        104            58        12   40   46   6    0   0       87.30           51.64               3.12          
  JP4D.001      Bacteria         5449        104            58        24   65   11   3    1   0       70.48           13.09               0.00          
  JP4D.003      Bacteria         5449        104            58        44   49   11   0    0   0       64.44           10.27               0.00          
--------------------------------------------------------------------------------------------------------------------------------------------------------

~~~
{: .output} 

To have this values and more parameters about your assembly, like contig number and length, 
in an output that is more usable and shearable we can now run the quality step of CheckM `checkm qa` 
and make it print the output in a `TSV` table, instead of the console. We need to specify the file 
of the markers that it used in the previous step `Bacteria.ms`, the name of the output 
file we want `quality_JP4D.tsv`, that we want a table `--tab_table`, and the option number 2 `-o 2` is to ask for more parameters printed on the table. 
~~~
$  checkm qa CHECKM/Bacteria.ms CHECKM/ --file CHECKM/quality_JP4D.tsv --tab_table -o 2
~~~
{: .bash} 
https://github.com/carpentries-incubator/metagenomics
The table we just made looks like [this](https://github.com/carpentries-incubator/metagenomics/blob/gh-pages/files/quality_JP4D.tsv).
This will be very useful when you need to document your work or communicate it. 

The question of, how much contamination do we can tolerate and how much completeness do we need certainly depends on the scientific question being tackled, but in the [CheckM](https://genome.cshlp.org/content/25/7/1043) paper, there are some parameters that we can follow.

> ## Exercise 1: Discuss the quality of the obtained MAGs
>
> Download the quality file to your local computer and open it in a spreadsheet.
> Then discuss with your team which of the parameters in the table do you find useful.
>
>> ## Solution
>>In a terminal that is standing on your local computer do:
>>
>>$ cd ~/Desktop/
>>
>>$ scp dcuser@ec2-18-207-132-236.compute-1.amazonaws.com:/home/dcuser/dc_workshop/mags/CHECKM/quality_JP4D.tsv .
>>
>>
> {: .solution}
{: .challenge}

{: .bash} 
{% include links.md %}
