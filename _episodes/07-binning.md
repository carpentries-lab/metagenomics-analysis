---
title: "Metagenome Binning"
teaching: 15
exercises: 5
questions:
- "How can we obtain the original genomes from a metagenome?"
objectives: 
- "Obtain MAGs from the metagenomic assembly."
- "Check the quality of the MAGs."  
keypoints:
- "Binning can be used to obtain the original genomes (MAGs) from metagenomes."
- "To know the quality of our MAGs we use the level of contamination and completeness."
---

## Metagenomic binning
To be able to analyze each species individualy the original genomes in the sample can be separated with a process called binning. We call these genomes reconstructed from a metagenomic assembly MAGs (Metagenome-Assembled Genomes).
In this process, the assembled contigs from the metagenome will be assigned to different bins (FASTA files that contain certain contigs). Ideally, each bin corresponds to only one original genome (a MAG).

<a href="{{ page.root }}/fig/Binning(47).png">
  <img src="{{ page.root }}/fig/Binning(47).png" width="435" height="631" alt="Cog Metagenome" />
</a>

Although an obvious way to separate contigs that correspond to a different species is by their taxonomic assignation, there are more reliable methods that do the binning using characteristics of the contigs, such as their GC content, the use of tetranucleotides (composition) or their coverage (abundance).

[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorithm that distinguishes contigs that belong to different bins according to their coverage levels and the tetranucleotide frequencies they have.

Let's bin the sample we just assembled. The command for running MaxBin is `run_MaxBin.pl`, and the arguments it needs are the FASTA file of the assmbly, the FASTQ with the reads and the output directory and name. 
~~~
$ cd ~/dc_workshop/results/assembly_JC1A
$ mkdir MAXBIN
$ run_MaxBin.pl -thread 12 -contig JC1A_contigs.fasta -reads ../../data/trimmed_fastq/JC1A_R1.trim.fastq.gz -reads2 ../../data/trimmed_fastq/JC1A_R2.trim.fastq.gz -out MAXBIN/JC1A &
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

It seems that it is impossible to bin our assembly because the amount of marker genes is less than 1. We could have expected this as we know it is a small sample.

We will perform the binning process with a different sample from the same study. We have the assembly precomputed in the `~/dc-workshop/mags/` directory.
~~~
$ cd ~/dc_workshop/mags/
$ mkdir MAXBIN
$ run_MaxBin.pl -thread 12 -contig JP41_contigs.fasta -reads JP41_1.fastq -reads2 JP41_2.fastq -out MAXBIN/JP41 &
~~~
{: .bash}  
It will take a few minutes to run. And it will finish with an output like this:

~~~

========== Job finished ==========
Yielded 4 bins for contig (scaffold) file JP41_contigs.fasta

Here are the output files for this run.
Please refer to the README file for further details.

Summary file: MAXBIN/JP41.summary
Genome abundance info file: MAXBIN/JP41.abundance
Marker counts: MAXBIN/JP41.marker
Marker genes for each bin: MAXBIN/JP41.marker_of_each_gene.tar.gz
Bin files: MAXBIN/JP41.001.fasta - MAXBIN/JP41.004.fasta
Unbinned sequences: MAXBIN/JP41.noclass

Store abundance information of reads file [JP41_1.fastq] in [MAXBIN/JP41.abund1].
Store abundance information of reads file [JP41_2.fastq] in [MAXBIN/JP41.abund2].


========== Elapsed Time ==========
0 hours 7 minutes and 36 seconds.

~~~
{: .output}  

With the summary file we can have a quick look at the bins that MaxBin produced. 

~~~
$ more MAXBIN/JP41.summary
~~~
{: .bash}  

~~~
Bin name	Completeness	Genome size	GC content
JP41.001.fasta	98.1%	5220938	39.1
JP41.002.fasta	94.4%	3462062	33.1
JP41.003.fasta	57.0%	1341358	44.4
JP41.004.fasta	71.0%	2256981	64.0
~~~
{: .output}  

> ## `.discussion` The quality of MAGs
>
>Can we trust the quality of our bins only with the given information? 
>What else do we want to know about them to confidently use them for further analysis?
{: .discussion}

# Quality check 

The quality of a MAG is highly dependent on the size of the genome of the species, its abundance in the community, and the depth at which we sequenced it.
Two important things that can be meassured to know its quality are the completeness (is the MAG a complete genome?) and the contamination (does the MAG contain only one genome?). 

[CheckM](https://github.com/Ecogenomics/CheckM) is a good program to see the quality of our MAGs. It gives a meassure of the completeness and the contamination by counting marker genes in the MAGs. The lineage workflow that is a part of CheckM places your bins in a refrence tree to know to which lineage it corresponds to and to use the appropriate marker genes to estimate the quality parameters. Unfortunately the lineage workflow uses a lot of memory so it can't run in our machines, but we can also tell CheckM to use marker genes from Bacteria instead, if we use the taxonomic workflow, which uses little memory. This is a less accurate aproach but it can also be very useful if you want all of your bins analysed with the same markers. 

We will run the taxonomy workflow specifying the use of markers at the domain level, specific for the rank Bacteria, we will specify that our bins are in FASTA format, that they are located in the `MAXBIN` directory and that we want our output in the `CHECKM/` directory. 
~~~
$ mkdir CHECKM
$ checkm taxonomy_wf domain Bacteria -x fasta MAXBIN/ CHECKM/ &
~~~
{: .bash} 

The run will end with our results printed in the console.
~~~
--------------------------------------------------------------------------------------------------------------------------------------------------------
  Bin Id     Marker lineage   # genomes   # markers   # marker sets   0     1    2    3   4   5+   Completeness   Contamination   Strain heterogeneity  
--------------------------------------------------------------------------------------------------------------------------------------------------------
  JP41.002      Bacteria         5449        104            58        1     51   51   1   0   0       98.28           38.62               0.00          
  JP41.001      Bacteria         5449        104            58        1    101   2    0   0   0       98.28            3.45              50.00          
  JP41.004      Bacteria         5449        104            58        20    74   10   0   0   0       73.51           11.68              10.00          
  JP41.003      Bacteria         5449        104            58        35    64   5    0   0   0       66.58            6.03               0.00          
--------------------------------------------------------------------------------------------------------------------------------------------------------
~~~
{: .output} 

To have this values and more parameters about your assembly, like contig number and length, in an output that is more usable and shearable we now run the quality step of CheckM `checkm qa` and make it print the output in a `TSV` table. We specify the file of the markers that it used in the previous step `Bacteria.ms`, the name of the output file we want `quality_JP41.tsv`, that we want a table `--tab_table`, and the option number 2 `-o 2` is to ask for more parameters printed on the table. 
~~~
$  checkm qa CHECKM/Bacteria.ms CHECKM/ --file CHECKM/quality_JP41.tsv --tab_table -o 2
~~~
{: .bash} 

The table is to big to fit our screen but we can download it and open it in a spreadsheet. This will be very useful when you need to document your work or communicate it. 

In a terminal that is standing on our local computer do:

~~~
$ cd ~/Desktop/
$ scp dcuser@ec2-18-207-132-236.compute-1.amazonaws.com:/home/dcuser/dc_workshop/mags/CHECKM/quality_JP41.tsv .
~~~
> ## Exercise 1 Discuss the quality of the obtained MAGs
>
> Download the quality file to your local computer and open it in a spreadsheet.
> Then discuss with your team which of the MAGs has the best quality and why.
>
>> ## Solution
>>$ cd ~/Desktop/
>>
>>$ scp dcuser@ec2-18-207-132-236.compute-1.amazonaws.com:/home/dcuser/dc_workshop/mags/CHECKM/quality_JP41.tsv .
>>
>>The MAG with the ID JP41.001 is the more complete and less contaminated one. 
> {: .solution}
{: .challenge}

{: .bash} 
{% include links.md %}
