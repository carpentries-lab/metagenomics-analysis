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
To be able to analyze each species individualy the original genomes in the sample can be separated with a process called binning. 
In this process, the assembled contigs from the metagenome will be assigned to different bins (FASTA files that contain certain contigs). Ideally, each bin corresponds to only one original genome.

<a href="{{ page.root }}/fig/Binning(47).png">
  <img src="{{ page.root }}/fig/Binning(47).png" width="435" height="631" alt="Cog Metagenome" />
</a>

Although an obvious way to separate contigs that correspond to a different species is by their taxonomic assignation, there are more reliable methods that do the binning using characteristics of the contigs, such as their GC content, the use of tetranucleotides (composition) or their coverage (abundance).

[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorith that distinguishes contigs that belong to different bins according to their coverage levels and the tetranucleotide frequencies they have.

We will perform the binning process with a different sample from the same study because the samples we have been working with are not adequate for binning. The command for running MaxBin is `run_MaxBin.pl`, and the arguments it needs are the FASTA file of the assmbly (it is already pre-computed `ERS1949771_contigs.fasta`), the FASTQ with the reads and the output directory and name. 
~~~
$ mkdir MAXBIN
$ run_MaxBin.pl -thread 12 -contig ERS1949771_contigs.fasta -reads ERS1949771_1.fastq -reads2 ERS1949771_2.fastq -out MAXBIN/ERS1949771
~~~
{: .bash}  
It will take a few minutes to run. And it will finish with an output like this:

~~~
========== Job finished ==========
Yielded 4 bins for contig (scaffold) file ERS1949771_contigs.fasta

Here are the output files for this run.
Please refer to the README file for further details.

Summary file: MAXBIN/ERS1949771.summary
Genome abundance info file: MAXBIN/ERS1949771.abundance
Marker counts: MAXBIN/ERS1949771.marker
Marker genes for each bin: MAXBIN/ERS1949771.marker_of_each_gene.tar.gz
Bin files: MAXBIN/ERS1949771.001.fasta - MAXBIN/ERS1949771.004.fasta
Unbinned sequences: MAXBIN/ERS1949771.noclass

Store abundance information of reads file [ERS1949771_1.fastq] in [MAXBIN/ERS1949771.abund1].
Store abundance information of reads file [ERS1949771_2.fastq] in [MAXBIN/ERS1949771.abund2].


========== Elapsed Time ==========
0 hours 7 minutes and 34 seconds.
~~~
{: .output}  

With the summary file we can have a quick look at the bins that MaxBin produced. 

~~~
$ more MAXBIN/ERS1949771.summary
~~~
{: .bash}  

~~~
Bin name	Completeness	Genome size	GC content
ERS1949771.001.fasta	98.1%	5220938	39.1
ERS1949771.002.fasta	94.4%	3462062	33.1
ERS1949771.003.fasta	57.0%	1341358	44.4
ERS1949771.004.fasta	71.0%	2256981	64.0
~~~
{: .output}  

~~~
Can we trust the quality of our bins only with the given information? 
What else do we want to know about them to confidently use them for further analysis?
~~~
{: .discussion}  

#Quality check 

The quality of a MAG is highly dependent on the size of the genome of the species, its abundance in the community, and the depth at which we sequenced it.
Two important things that can be meassured to know its quality is the completeness (is the MAG a complete genome?) and the contamination (does the MAG contain only one genome?). 

[CheckM](https://github.com/Ecogenomics/CheckM) is a good program to see the quality of our MAGs. It gives a meassure of the completeness and the contamination by counting marker genes in the MAGs. The lineage workflow that is a part of CheckM places your bins in a refrence tree to know to which lineage it corresponds and to use the appropriate marker genes to estimate the quality parameters. Unfortunately the lineage workflow uses a lot of memory so it can't run in our machines, but we can also tell CheckM to use marker genes from Bacteria instead if we use the taxonomic workflow, wich uses little memory. This is a less accurate aproach but it can also be very useful if you want all of your bins analysed with the same markers. 

We will run the taxonomy workflow specifying the use of markers at the domain level specific for the rank Bacteria, we will specify that our bins are in FASTA format, that they are located in the `MAXBIN` directory and that we want our loutput in the `CHECKM/` directory. 
~~~
$ mkdir CHECKM
$ checkm taxonomy_wf domain Bacteria -x fasta MAXBIN/ CHECKM/
~~~
{: .bash} 

The run will end with our results printed in the console.
~~~
--------------------------------------------------------------------------------------------------------------------------------------------------------------
  Bin Id           Marker lineage   # genomes   # markers   # marker sets   0     1    2    3   4   5+   Completeness   Contamination   Strain heterogeneity  
--------------------------------------------------------------------------------------------------------------------------------------------------------------
  ERS1949771.002      Bacteria         5449        104            58        1     51   51   1   0   0       98.28           38.62               0.00          
  ERS1949771.001      Bacteria         5449        104            58        1    101   2    0   0   0       98.28            3.45              50.00          
  ERS1949771.004      Bacteria         5449        104            58        20    74   10   0   0   0       73.51           11.68              10.00          
  ERS1949771.003      Bacteria         5449        104            58        35    64   5    0   0   0       66.58            6.03               0.00          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
~~~
{: .output} 

To have this values and more parameters about your assembly, like contig number and length, in an output that is more usable we now run the quality step of CheckM `checkm qa` and make it print the output in a `TSV` table. We specify the the file of the marker that it used in the previous step `Bacteria.ms`, the name of the output file we want `quality_ERS1949771.tsv`, that we want a table `--tab_table`, and the option number 2 `-o 2` is to ask for more parameters printed on the table. 
~~~
$  checkm qa CHECKM/Bacteria.ms CHECKM/ --file CHECKM/quality_ERS1949771.tsv --tab_table -o 2
~~~
{: .bash} 

The table is to big to fit our screen but we can download it and open it in a spreadsheet.

{% include links.md %}
