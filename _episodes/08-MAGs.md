---
title: "MAGs"
teaching: 10
exercises: 0
questions:
- "How are Metagenome assembly genomes (MAG) conformed"
objectives:
- "Explain how a genome is reconstructed from a metagenome"
keypoints:
- "Keyboard keys need to use `<kbd>` HTML tag."
---
## Bining 
As the contigs that we obtain from the assembly come from different species, 
it is necessary to separate them by species to be able to analyze each species 
individually. This process is called binning.  

We can do binning based on the taxonomic assignment, or using characteristics 
of the contigs, such as their GC content, coverage or the use of tetranucleotides.

Binning dependent on taxonomy is relatively trivial, but there are different algorithms 
for binning independent of taxonomy. These algorithms can be based on composition or abundance,
[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorithm
with an hybrid composition-abundance approach.  


<a href="{{ page.root }}/fig/Binning(47).png">
  <img src="{{ page.root }}/fig/Binning(47).png" width="350" height="600" alt="Cog Metagenome" />
</a>

~~~
$ run_MaxBin.pl 
~~~
{: .bash}
~~~
MaxBin 2.2.7                                                                                           
No Contig file. Please specify contig file by -contig                                                  
MaxBin - a metagenomics binning software.                                                              
Usage:                                                                                                   
run_MaxBin.pl                                                                                             
-contig (contig file)                                                                                   
-out (output file)                                                                                                               
~~~
{: output}


~~~
$ run_MaxBin.pl 
~~~
{: .bash}

> ## Bining strategies `.callout`
>
> Reads can be assembled into contigs according to two main strategies: composition and abbundance.
> Many binning algorithms uses a combination of both strategies.  
{: .callout}

## MAGs (Metagenome Assembly Genome)  
After doing the binning we can assemble MAGs, either by putting together the contigs 
that correspond to a single species or using the reads that were used to assemble 
those contigs to reassemble a genome using a traditional assembler
The quality of a MAG is highly dependent on the size of the genome of the species, 
its abundance in the community, and the depth at which we sequence. Anvio is a good program to see the quality of our MAGs


 

