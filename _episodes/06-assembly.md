---
title: "Metagenome Assembly"
teaching: 15
exercises: 5
questions:
- "Why genomic data should be assembled?"
- "What is the difference between reads and contigs?"
- "How can we assemble a metagenome?"
objectives: 
- "Understand what is an assembly."  
- "Use an enviroment in a bioinformatic pipeline."
keypoints:
- "Assembly uses algorithms to group reads into contigs."
- "The most used algorithm nowadays is De Brujin Graphs"
- "MetaSPAdes is a metagenome assembler."
- "The FASTQ files from the quality control process are the inputs for the assembly software."
- "A FASTA file with contigs is the output of the assembly process."
---


## Assembling reads
The assembly process groups reads into contigs and contigs into scaffolds, in order to obtain, ideally, the sequence of a whole chromosome. There are many programs devoted to
[genome](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2874646/) and metagenome assembly, some of the
main strategies they use are: Greedy extension, OLC and De Bruijn charts. When metagenomics is
shotgun instead of amplicon metagenomics an extra assembly step must be run.

<a href="{{ page.root }}/fig/EnsambladoFinal.png">
  <img src="{{ page.root }}/fig/EnsambladoFinal.png" width="868" height="777" alt="Cog Metagenome" />
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


## Activating a metagenomic environment  
Environments are part of a bioinformatic tendency to make repdoucible research, 
they are a way to share our programs in their specific versions used for a pipeline with our colleagues and 
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
 
> ## Conda is an environment management system `.callout`
>
> Enviroments help in science reproducibility, allowing to share the specific conditions in which a pipeline is run.
> Conda is an open source package management system and environment management system that runs on Windows, macOS and 
> Linux.
{: .callout}

## MetaSPAdes options  

The help that we just saw tells us how to run metaspades.py. We are going to use the most simple options, just specifying our forward paired end reads with `-1` and reverse paired end reads with `-2`, and the output directory where we want our results to be stored. 
 ~~~
$ cd ~/dc_workshop/data/trimmed_fastq
$ metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz -o ../../results/assembly_JC1A &
~~~
{: .bash}

> ## Running commands on the background `.callout`
> The `&` sign that we are using at the end of the command is for telling the machine to run the command on the background, this will help us to avoid the cancelation of the opperation in case the connection with the AWS machine is unstable. 
{: .callout}

When the run is finished it shows this message:

~~~
======= SPAdes pipeline finished.

SPAdes log can be found here: /home/dcuser/dc_workshop/results/assembly_JC1A/spades.log

Thank you for using SPAdes!

~~~
{: .bash}

If we now look at the contents of this directory...
~~~
$ cd ../../results/assembly_JC1A
$ ls
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

As we can see, MetaSPAdes gave us a lot of files. The ones with the assembly are the `contigs.fasta` and the `scaffolds.fasta`. The contigs are just made from assembled reads, but the scaffolds are the result from a subsequent process in which the contigs are ordered and oriented and connected with Ns.

We can recognize which sample our assembly outputs corresponds to because the assembly results folder (assembly_JC1A) has its ID, however the files within it do not have the sample ID. It is very useful to rename these files, in case we need them out of its folder.

> ## Exercise 1 Rename all files in a folder
>
> Add the sample ID (JC1A) to the names of all the contents of the assembly_JC1A directory.
> Remember that many solutions are possible.
>
>
>> ## Solution
>>for name in *; do mv $name JC1A_$name; done
>> 
> {: .solution}
{: .challenge}

> ## `.discussion`
>
> Does amplicon metagenomics needs an assembly step in its analysis workflow?  
{: .discussion}

{% include links.md %}
