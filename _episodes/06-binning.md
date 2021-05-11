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

We will not perform the binning process in this lesson because the data we are working with is not adequate for it, but let's look at the commands without running them. The command for running MaxBin is `run_MaxBin.pl`, and the arguments it needs are the FASTA file of the assmbly, the FASTQ with the reads and an output directory where you want your results stored.
~~~
$ mkdir MaxBin
$ run_MaxBin.pl -contig JC1A_contigs.fasta -reads JC1A_R1.fastq -reads2 JC1A_R2.fastq -out MaxBin/
~~~
{: .bash}  

The quality of a MAG is highly dependent on the size of the genome of the species, its abundance in the community, and the depth at which we sequenced it.
Two important things that can be meassured to know its quality is the completeness (is the MAG a complete genome?) and the contamination (does the MAG contain only one genome?). 

[CheckM](https://github.com/Ecogenomics/CheckM) is a good program to see the quality of our MAGs. It gives a meassure of the completeness and the contamination by counting marker genes in the MAGs. The lineage workflow that is a part of CheckM places your bins in a refrence tree to know to which lineage it corresponds and to use the appropriate marker genes to estimate the quality parameters. With this we have the quality estimates printed in the console.
~~~
$mkdir CHECKM
$checkm lineage_wf -r VAMB/bins/ CHECKM/
~~~
{: .bash} 

~~~

~~~
{: .output} 

To have this values and more parameters about your assembly, like genome size, GC content and contig length, we now run the quality step of CheckM and make it print the output in a `TSV` table.
~~~
$checkm qa CHECKM/lineage.ms CHECKM/ --file CHECKM/quality_sample.tsv --tab_table -o 2
~~~
{: .bash} 
~~~
$ ls CHECKM/
~~~
{: .bash} 

~~~
quality_sample.tsv
~~~
{: .output} 



{% include links.md %}
