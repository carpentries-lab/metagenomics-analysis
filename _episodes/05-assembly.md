---
title: "Metagenome Assembly"
teaching: 15
exercises: 5
questions:
- "Why genomic data should be assembled?"
- "What is the difference between reads and contigs?"
- "How can we assemble a metagenome?"
- "How can we obtain individual genomes from a metagenome?"
objectives: 
- "Understand what is an assembly"  
- "Use an enviroment in a bioinformatic pipeline"
- "Generate MAGs from an assembled metagenome"
keypoints:
- "Assemblies uses algorithms to group reads into contigs"
- "Three famous algorithms are Greedy extension, OLC and De Bruijin graphs"
- "Megahit is a metagenome assembler"
- "The fastq files from quality control process are the inputs for the assembly software"
- "A fasta file with contigs is the output of the assembly process"
- "Binning can be used to obtain individual genomes (MAGs) from metagenomes"
---


## Assembling reads
An assembly is a data structure that maps the sequence data to a reconstruction of the target.
Assemblies groups reads into contigs and contigs into scaffolds. There are many programs devoted to
[genome](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2874646/) and metagenome assembly, some of the
main strategies they use are: Greedy extension, OLC and De Bruijn charts. When metagenomics is
shotgun instead of amplicon metagenomics an extra assembly step must be run
[documentation](https://kramdown.gettalong.org/converter/html.html#auto-ids),

<a href="{{ page.root }}/fig/EnsambladoFinal.png">
  <img src="{{ page.root }}/fig/EnsambladoFinal.png" width="500" height="600" alt="Cog Metagenome" />
</a>


MEGAHIT is a NGS de novo assembler for assembling large and complex metagenomics data in a 
time- and cost-efficient manner.  

~~~
    megahit -1 SAMPLE_1.fastq  -2 SAMPLE_2.fastq  -m 0.5  -t 12  -o megahit_result
~~~
{: .source}

~~~
megahit: command not found   
~~~
{: .error}


## Activating metagenomic environment  
Environments are part of a bioinformatic tendency to make repdoucible research, 
they are a way to share our computational environments with our colleges and 
with our future self.  Megahit is not activated in the (base) environment but 
this AWS instances came with an environment called metagenomics. We need to activate 
it in order to satrt using megahit. 

Conda environments are activated with `conda activate` direction:  
~~~
conda activate metagenomics  
~~~
{: .code}

After the environment has been activated a label is shown before the `$` sign.
~~~
(metagenomics) $
~~~
{: .output}

Now if we call megahit at the command line it wont be any error, 
instead a long help will be displayed at our screen.   
~~~
megahit
~~~
{: .bash}

~~~
megahit: MEGAHIT v1.2.9 
contact: Dinghua Li <voutcn@gmail.com>
Usage:   megahit [options] {-1 <pe1> -2 <pe2> | --12 <pe12> | -r <se>} [-o <out_dir>]             
~~~
{: .output}
 
> ## `.callout`
>
> Enviroments help in science reproducibility, allowing to share the specific conditions in which a pipeline is run
> Conda is an open source package management system and environment management system that runs on Windows, macOS and 
> Linux.
{: .callout}

## Megahit options  


~~~
    megahit -1 SAMPLE_1.fastq  -2 SAMPLE_2.fastq  -m 0.5  -t 12  -o megahit_SAMPLE
~~~
{: .source}



~~~
.output: ls megahit_SAMPLE/final.contigs.fa
~~~
{: .output}





## Special Blockquotes

~~~
    megahit -1 JP4D_R1.trim.fastq.gz \
             -2 JP4D_R2.trim.fastq.gz \
             -m 0.5 -t 12 -o megahit_JP4D
~~~
{: .source}

~~~
2020-11-21 05:33:32 - MEGAHIT v1.2.9                                                        
2020-11-21 05:33:32 - Maximum number of available CPU thread is 2.                          
2020-11-21 05:33:32 - Number of thread is reset to the 2.                                   
2020-11-21 05:33:32 - Using megahit_core with POPCNT and BMI2 support                       
2020-11-21 05:33:32 - Convert reads to binary library                                       
2020-11-21 05:33:38 - b'INFO  sequence/io/sequence_lib.cpp  :   77 - Lib 0 (/home/dcuser/dc_workshop/data/trimmed_fastq/JP4D_R1.trim.fastq.gz,/home/dcuser/dc_workshop/data/trimmed_fastq/JP4D_R2.trim.fastq.gz): pe, 1502854 reads, 251 max length'                                                                          
2020-11-21 05:33:38 - b'INFO  utils/utils.h:152 - Real: 6.0234\tuser: 2.1600\tsys: 0.4680\tmaxrss: 160028'                          
2020-11-21 05:33:38 - k-max reset to: 141                                                   
2020-11-21 05:33:38 - Start assembly. Number of CPU threads 2                               
2020-11-21 05:33:38 - k list: 21,29,39,59,79,99,119,141                                     
2020-11-21 05:33:38 - Memory used: 2070839296                                               
2020-11-21 05:33:38 - Extract solid (k+1)-mers for k = 21                                   
2020-11-21 05:34:39 - Build graph for k = 21                                                
2020-11-21 05:35:58 - Assemble contigs from SdBG for k = 21                                 
2020-11-21 05:39:58 - Local assembly for k = 21                                             
2020-11-21 05:41:00 - Extract iterative edges from k = 21 to 29                             
2020-11-21 05:41:37 - Build graph for k = 29                                                
2020-11-21 05:42:19 - Assemble contigs from SdBG for k = 29                                 
2020-11-21 05:44:58 - Local assembly for k = 29                                             
2020-11-21 05:46:53 - Extract iterative edges from k = 29 to 39                             
2020-11-21 05:47:14 - Build graph for k = 39          
~~~
{: .bash}
       



> ## `.discussion`
>
> ¿Does amplicon metagenomics needs an assembly step in its analysis worflow?  
{: .discussion}


## Bining
To be abel to analyze each species individualy we can separate the original genomes in the sample with a process called binning. 
In this process, the assembled contigs from the metagenome will be assigned to different bins (fasta files that contain certain contigs). Ideally, each bin corresponds to only one original genome.

Although an obvious way to separate contigs that correspond to a different species is by their taxonomic assignation, there are more reliable methods that do the binning using characteristics of the contigs, such as their GC content, the use of tetranucleotides (composition) or their coverage (abundance).

[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorithm. The information it uses to distinguish contigs that correspond to different genomes, is the coverage levels of the contigs and the tetranucleotide frequencies they have.


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
{: .output}


~~~
$ run_MaxBin.pl 
~~~
{: .bash}

> ## Bining strategies `.callout`
>
> Contigs can be assigned to bins according to two main strategies: composition and abbundance.
> Many binning algorithms uses a combination of both strategies.  
{: .callout}

## MAGs (Metagenome-Assembled Genomes)  
MAGs are the original genomes that we are looking for with the binning process. The binned contigs can be used as MAGs, but a more reliable way to obtain MAGs is by re-assembling the reads from the binned contigs. For this we need to map the original reads to the binned contigs and then re-assemble them. 

The quality of a MAG is highly dependent on the size of the genome of the species, 
its abundance in the community, and the depth at which we sequence.
Two important things that can be meassured to know its quallity is the completeness (is the MAG a complete genome?) and the distinctiveness (does the MAG contain only one genome?). 

Anvio is a good program to see the quality of our MAGs

{% include links.md %}
