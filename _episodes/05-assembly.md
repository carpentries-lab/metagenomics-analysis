---
title: "Metagenome Assembly"
teaching: 15
exercises: 5
questions:
- "Why genomic data should be assembled?"
- "What is the difference between reads and contigs?"
- "How can we assemble a metagenome?"
- "How can we obtain the original genomes from a metagenome?"
objectives: 
- "Understand what is an assembly."  
- "Use an enviroment in a bioinformatic pipeline."
keypoints:
- "Assemblies uses algorithms to group reads into contigs."
- "Three famous algorithms are Greedy extension, OLC and De Bruijin graphs."
- "MetaSPAdes is a metagenome assembler."
- "The FASTQ files from the quality control process are the inputs for the assembly software."
- "A FASTA file with contigs is the output of the assembly process."
- "Binning can be used to obtain the original genomes (MAGs) from metagenomes."
---


## Assembling reads
An assembly is a data structure that maps the sequence data to a reconstruction of the target.
The assembly process groups reads into contigs and contigs into scaffolds. There are many programs devoted to
[genome](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2874646/) and metagenome assembly, some of the
main strategies they use are: Greedy extension, OLC and De Bruijn charts. When metagenomics is
shotgun instead of amplicon metagenomics an extra assembly step must be run
[documentation](https://kramdown.gettalong.org/converter/html.html#auto-ids),

<a href="{{ page.root }}/fig/EnsambladoFinal.png">
  <img src="{{ page.root }}/fig/EnsambladoFinal.png" width="500" height="600" alt="Cog Metagenome" />
</a>


[MetaSPAdes](https://github.com/ablab/spades) is a NGS de novo assembler for assembling large and complex metagenomics data, and it is one of the most used and recommended. It is part of the SPAdes toolkit, that contains several assembly pipelines, being metaSPAdes the one dedicated to metagenomic assembly.
Let's see what happens if we enter the metaspades.py command on our terminal.

~~~
$ metaspades.py
~~~
{: .source}

~~~
$ metaspades.py: command not found   
~~~
{: .error}


## Activating metagenomic environment  
Environments are part of a bioinformatic tendency to make repdoucible research, 
they are a way to share our computational environments with our colleges and 
with our future self. MetaSPAdes is not activated in the (base) environment but 
this AWS instances came with an environment called metagenomics. We need to activate 
it in order to start using MetaSPAdes. 

Conda environments are activated with `conda activate` direction:  
~~~
$ conda activate metagenomics  
~~~
{: .bash}

After the environment has been activated, a label is shown before the `$` sign.
~~~
(metagenomics) $
~~~
{: .output}

Now if we call MetaSPAdes at the command line it wont be any error, 
instead a long help will be displayed at our screen.
~~~
$ metaspades.py
~~~
{: .bash}

~~~
SPAdes genome assembler v3.15.0 [metaSPAdes mode]

Usage: spades.py [options] -o <output_dir>

Basic options:
  -o <output_dir>             directory to store all the resulting files (required)
  --iontorrent                this flag is required for IonTorrent data
  --test                      runs SPAdes on toy dataset
  -h, --help                  prints this usage message
  -v, --version               prints version

Input data:
  --12 <filename>             file with interlaced forward and reverse paired-end reads
  -1 <filename>               file with forward paired-end reads
  -2 <filename>               file with reverse paired-end reads    
~~~
{: .output}
 
> ## `.callout`
>
> Enviroments help in science reproducibility, allowing to share the specific conditions in which a pipeline is run.
> Conda is an open source package management system and environment management system that runs on Windows, macOS and 
> Linux.
{: .callout}

## MetaSPAdes options  

The help that we just saw tells us how to run metaspades.py. We are going to use the most simple options, just specifying our forward paired end reads with `-1` and reverse paired end reads with `-2`, and the output directory where we want our results to be stored. 
 ~~~
$ cd ~/dc_workshop/data/trimmed_fastq
$ metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz -o ../../assembly_JC1A &
~~~
{: .bash}

> ## `.callout`
> The `&` sign that we are using at the end of the command is for telling the machine to run the command on the background, this will help us to avoid the cancelation of the opperation in case the connection with the AWS machine is unstable. 
{: .callout}

When the run is finished it shows this message:

~~~
======= SPAdes pipeline finished.

SPAdes log can be found here: /home/dcuser/dc_workshop/assembly_JC1A/spades.log

Thank you for using SPAdes!

~~~
{: .bash}

If we now look at the contents of this directory...
~~~
$ cd ../../assembly_JC1A
$ ls
~~~
{: .bash}

~~~
6126594.log
assembly_graph_after_simplification.gfa
assembly_graph.fastg
assembly_graph_with_scaffolds.gfa
before_rr.fasta
contigs.paths
corrected
dataset.info
first_pe_contigs.fasta
input_dataset.yaml
contigs.fasta
scaffolds.fasta
K21
K33
K55
misc
params.txt
pipeline_state
run_spades.sh
run_spades.yaml
scaffolds.paths
spades.log
strain_graph.gfa
tmp
            
~~~
{: .output}

As we can see MetaSPAdes gave us a lot of files. The ones with the assembly are the `contigs.fasta` and the `scaffolds.fasta`. The contigs are just made from assembled reads, but the scaffolds are the result from a subsequent process in which the contigs are ordered and oriented and connected with Ns.

Other interesting output is the folder `corrected`, it contains the reads with the sequencing errors corrected. We will return to it latter. 

Let's rename the file that contains our assembled contigs. 
~~~
$ mv contigs.fasta JC1A_contigs.fasta
~~~
{: .bash}


> ## `.discussion`
>
> Does amplicon metagenomics needs an assembly step in its analysis workflow?  
{: .discussion}


## Metagenomic binning
To be able to analyze each species individualy the original genomes in the sample can be separated with a process called binning. 
In this process, the assembled contigs from the metagenome will be assigned to different bins (FASTA files that contain certain contigs). Ideally, each bin corresponds to only one original genome.

Although an obvious way to separate contigs that correspond to a different species is by their taxonomic assignation, there are more reliable methods that do the binning using characteristics of the contigs, such as their GC content, the use of tetranucleotides (composition) or their coverage (abundance).

[Maxbin](https://sourceforge.net/projects/maxbin/files/) is a binning algorithm. The information it uses to distinguish contigs that correspond to different genomes, is the coverage levels of the contigs and the tetranucleotide frequencies they have.


<a href="{{ page.root }}/fig/Binning(47).png">
  <img src="{{ page.root }}/fig/Binning(47).png" width="350" height="600" alt="Cog Metagenome" />
</a>

We will not perform the binning process in this lesson because the data we are working with is not adequate for it, but let's look at the commands without running them.  
~~~
$ run_MaxBin.pl -thread 12 -contig JC1A_contigs.fasta -reads JC1A_R1.fastq -reads2 JC1A_R2.fastq -out MaxBin/
~~~
{: .bash}  


> ## Bining strategies `.callout`
>
> Contigs can be assigned to bins according to two main strategies: composition and abundance.
> Many binning algorithms uses a combination of both strategies.  
{: .callout}

## MAGs (Metagenome-Assembled Genomes)  
MAGs are the original genomes that we are looking for with the binning process. The binned contigs can be used as MAGs, but a more reliable way to obtain MAGs is by re-assembling the reads from the binned contigs. For this we need to map the reads to the binned contigs, to separate the reads that correspond to each bin, and then re-assemble them. 
With Bowtie2 we can do the mapping (also called alignment) of the reads to the contigs of one bin to extract this reads. The reads we will be using are the reads corrected by MetaSPAdes. Let's see the command to do this with the bin named `JC1A_contigs_MaxBin.01.fasta`.

<a href="{{ page.root }}/fig/mapping_bins.png">
  <img src="{{ page.root }}/fig/mapping_bins.png" width="350" height="600" alt="Cog Metagenome" />
</a>

~~~
#Build the index
$ bowtie2-build JC1A_contigs_MaxBin.01.fasta JC1A_contigs_MaxBin.01

#Perform the mapping using the corrected reads from the MetaSPAdes output
$ bowtie2 --threads 12 --sensitive-local -x JC1A_contigs_MaxBin.01.fasta -1 corrected/JC1A_R1.00.0_0.cor.fastq -2 corrected/JC1A_R2.00.0_0.cor.fastq -S JC1A_01.sam

#Convert from sam format to bam format
$ samtools view -F 4 -bS JC1A_01.sam > JC1A_01.bam

#Obtain the reads from the bam file
$ bamtools convert -in JC1A_01.bam -format fastq > JC1A_01.fastq

~~~
{: .bash}  

Having the corrected reads that correspond to only one bin `JC1A_01.fastq`, we can re-assemble them to obtain the MAG using SPAdes.
~~~
$ spades.py -s JC1A_01.fastq -o JC1A_01
~~~
{: .bash}  

The quality of a MAG is highly dependent on the size of the genome of the species, its abundance in the community, and the depth at which we sequenced it.
Two important things that can be meassured to know its quality is the completeness (is the MAG a complete genome?) and the contamination (does the MAG contain only one genome?). 

[CheckM](https://github.com/Ecogenomics/CheckM) is a good program to see the quality of our MAGs. It gives a meassure of the completeness and the contamination by counting marker genes in the MAGs.


{% include links.md %}
