---
title: "Metagenome Assembly"
teaching: 30
exercises: 10
questions:
- "Why genomic data should be assembled?"
- "What is the difference between reads and contigs?"
- "How can we assemble a metagenome?"
objectives: 
- "Understand what is an assembly."  
- "Run a metagenomics assembly workflow."
- "Use an enviroment in a bioinformatic pipeline."
keypoints:
- "Assembly groups reads into contigs."
- "De Brujin Graphs use Kmers to assembly cleaned reads"
- "MetaSPAdes is a metagenomes assembler."
- "Assemblers take FastQ files as input and produce a Fasta file as output."
---

## Assembling reads
The assembly process groups reads into contigs and contigs into 
scaffolds, in order to obtain(ideally) the sequence of a whole 
chromosome. There are many programs devoted to
[genome](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2874646/) and 
metagenome assembly, some of the main strategies they use are: Greedy 
extension, OLC and De Bruijn charts. Contrary to metabarcoding, shotgun metagenomics needs an assembly step. This does not mean that metabarcoding never uses an assembly step, but 
sometimes is not needed.

<a href="{{ page.root }}/fig/03-04-01.png">
  <img src="{{ page.root }}/fig/03-04-01.png" width="868" height="777" alt="Cog Metagenome" />
</a>

[MetaSPAdes](https://github.com/ablab/spades) is a NGS de novo assembler 
for assembling large and complex metagenomics data, and it is one of the 
most used and recommended. It is part of the SPAdes toolkit, that 
contains several assembly pipelines.

Some of the problems faced by metagenomics assembly are i) the differences in coverage between the genomes, due to the differences in abundance in the sample, ii) the fact that different species often share conserved regions, iii) and the presence of several strains of a single species in the community. SPAdes already deals with the non-uniform coverage problem in its algorithm, so it is useful for the assembly of simple communities, but the [metaSPAdes](https://pubmed.ncbi.nlm.nih.gov/28298430/) algorithm deals with the other problems as well, allowing it to assemble metagenomes from complex communities. 

Let's see what happens if we enter the metaspades.py command on our terminal.

~~~
$ metaspades.py
~~~
{: .source}

~~~
$ metaspades.py: command not found   
~~~
{: .error}

The reason is because we are not located in our environmnet where we can 
call Spades, but before going any further, let's talk about environmnets.

## Activating an environment  
Environments are part of a bioinformatic tendency to make reproducible research, 
they are a way to share and maintain our programs in their needed versions used for a pipeline with our colleagues and 
with our future self. MetaSPAdes is not activated in the (base) environment but 
this AWS instances came with an environment called metagenomics. We need to activate 
it in order to start using MetaSPAdes. 

We will use [Conda](https://docs.conda.io/en/latest/) as our environment manager. Conda environments are activated with `conda activate` direction:  
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
instead a long help page will be displayed at our screen.
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
 
> ## Conda is an environment management system
>
> Enviroments help in science reproducibility, allowing to share the specific conditions in which a pipeline is run.
> [Conda](https://docs.conda.io/en/latest/) is an open source package management system and environment management system that runs on Windows, macOS and 
> Linux.
{: .callout}

## MetaSPAdes is a   metagenomics assembler

The help that we just saw tells us how to run metaspades.py. We are going 
to use the most simple options, just specifying our forward paired-end 
reads with `-1` and reverse paired-end reads with `-2`, and the output 
directory where we want our results to be stored. 
 ~~~
$ cd ~/dc_workshop/data/trimmed_fastq
$ metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz -o ../../results/assembly_JC1A &
~~~
{: .bash}

> ## Running commands on the background
> The `&` sign that we are using at the end of the command is for telling 
the machine to run the command on the background, this will help us to avoid 
the cancelation of the opperation in case the connection with the AWS machine is unstable. 
{: .callout}

When the run is finished it shows this message:

~~~
======= SPAdes pipeline finished.

SPAdes log can be found here: /home/dcuser/dc_workshop/results/assembly_JC1A/spades.log

Thank you for using SPAdes!

~~~
{: .bash}

No we need to press enter to exit from the background, and a message like this will be displayed:
~~~
[1]+  Done                    metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz -o ../../results/assembly_JC1A
~~~
{: .output}
This is becacause of the use of the `&`. Now, let's go to the files: 
~~~
$ cd ../../results/assembly_JC1A
$ ls -F
~~~
{: .bash}

~~~
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

As we can see, MetaSPAdes gave us a lot of files. The ones with the assembly are the `contigs.fasta` and the `scaffolds.fasta`. 
Also, we found three `K` folders: _K21, K33, and K55_, this contains the individual result files for an assembly 
with k-mers equal to those numbers: 21, 33, and 55. The best assembled results are 
the ones that are displayed outside this k-folders. The folder `corrected` hold the corrected reads 
with the SPAdes algorithm. Moreover, the file 
`assembly_graph_with_scaffolds.gfa` have the information needed to visualize 
our assembly by different means, like programs as [Bandage](https://rrwick.github.io/Bandage/).

The contigs are just made from assembled reads, but the scaffolds are the result 
from a subsequent process in which the contigs are ordered, oriented, and connected with Ns.

We can recognize which sample our assembly outputs corresponds to because they are inside 
the assembly results folder: assembly_JC1A). However the files within it do not have the 
sample ID. It is very useful to rename these files, in case we need them out of its folder.

> ## Exercise 1: Rename all files in a folder
>
> Add JC1A (the sample ID) separated by "_"  at the beggining of the names of all the contents in the assembly_JC1A directory. Remember that many solutions are possible.
> 
> A)  mv * JC1A_    
> B)  mv * JC1A_*    
> C)  for name in *; do mv $name JC1A_; done     
> D)  for name in *; do mv $name JC1A_$name; done      
>    
>> ## Solution
>>~~~
>>
>> A)  No, this option is going to give you as error mv: target 'JC1A_' is not a directory 
>>  This is because mv has two options
>>  mv file_1 file_2
>>  mv file_1, file_2, ..... file_n, directory 
>>  When a list of files is passed to mv, the mv expects the last parameters to be a directory
>>  Here, * gives you a list of all the files in the directory
>>  The last parameter is JC1A_ (which mv expects to be a directory)  
>>  B)  No, Again every file is send to the same file.
>>  C)  No, every file is sent to the same file JC1A_
>> D)  Yes, this is one of the possible solutions.
>> 
>> ¿Do you have another solution?
>>~~~
>>{: .bash}
> {: .solution}
{: .challenge}

{% include links.md %}
