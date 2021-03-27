---
title: "Taxonomic Assignation"
teaching: 30
exercises: 15
questions:
- "How can I assign a taxonomy to my contigs?"
objectives:
- "Understand how taxonomic assignation works."
keypoints:
- "A database with previous gathered knowledge (genomes) is needed for taxonomic assignation."
- "Kraken2 is a program for taxonomic assignation."
---

<a href="{{ page.root }}/fig/sesgos.png">
  <img src="{{ page.root }}/fig/sesgos.png" alt="Cog Metagenome" />
</a>

Taxonomic assignation follows the sequence assignation into Operational Taxonomic
Units (OTUs, that is, groups of related individuals). This can be done either
after reads have been assembled into contigs, or using unassembled reads. 
The comparison database in this assignation process must be constructed using 
complete genomes. There are many programs for doing taxonomic mapping, 
almost all of them follows one of the next strategies:  

1. BLAST: Using BLAST or DIAMOND, these mappers search for the most likely hit 
for each sequence within a database of genomes (i.e. mapping). This strategy is slow.    
  
2. K-mers: A genome database is broken into pieces of length k, so as to be able to 
search for unique pieces by taxonomic group, from lowest common ancestor (LCA), 
passing through phylum, class, order, to species. Then, the algorithm 
break the query sequence (reads, contigs) into pieces of length k,
look for where these are placed within the tree and make the 
classification with the most probable position.    

3. Markers: They look for markers of a database made a priori in the sequences 
to be classified and assign the taxonomy depending on the hits obtained.    

> ## Taxonomy assignation software `.callout`
>
> There are three strategies for taxonomy assignation: BLAST, k-mers and markers. 
{: .callout}

[Kraken 2](https://ccb.jhu.edu/software/kraken2/) is the newest version of Kraken, 
a taxonomic classification system using exact k-mer matches to achieve 
high accuracy and fast classification speeds. kraken2 is already installed in the metagenome
environment, lets have a look at kraken2 help.  
 
> ## Activate metagenomics environment
> To be able to use kraken2, remember to activate the metagenomics environment with `conda activate metagenomics` 
{: .callout}

~~~  
$ kraken2  
~~~ 
{: .bash}

~~~
Need to specify input filenames!                                                                      
Usage: kraken2 [options] <filename(s)>                                                                                                                                                                      
Options:                                                                                                  
--db NAME               Name for Kraken 2 DB                                                                                   
                        (default: none)                                                               
--threads NUM           Number of threads (default: 1)                                                
--quick                 Quick operation (use first hit or hits)    
~~~  
{: .output}

Now lets go to the directory were our trimmed reads are located.  
~~~
$ cd /home/dcuser/dc_workshop/data/trimmed_fastq 
~~~
{: .bash}

In addition to our input files we also need a database with which to compare them, before we
start working with kraken2. There are [several databases](http://ccb.jhu.edu/software/kraken2/downloads.shtml) 
compatible to be used with kraken2 in the taxonomical assignation process. 
Minikraken is a popular database that attempts to conserve its sensitivity 
despite its small size (Needs 8GB of RAM for the assignation). Let's download minikraken database using the command
`curl`.   

~~~
$ curl -O ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz         
$ tar -xvzf minikraken2_v2_8GB_201904.tgz 
~~~
{: .bash}

> ## Very important to know your database! `.callout`
> The database you use will determine the result you get for your data.
> Imagine you are searching for a lineage that was recently discovered and it is not part of the available databases. Would you find it?
{: .callout}

> ## Exercise
> 
> What is the command `tar` doing to the file `minikraken2_v2_8GB_201904.tgz`.  
> 
>> ## Solution
>> `tar` command is used in linux to decompress files, so in this case it 
>> is extracting the content of the compressed file  `minikraken2_v2_8GB_201904.tgz`  
>> 
> {: .solution}
{: .challenge}                             
                             
As we have learned, taxonomic assignation can be attempted before the assembly process. 
In this case we can use FASTQ files as inputs, in this case the inputs would be the files 
`JP4D_R1.trim.fastq.gz` and `JP4D_R2.trim.fastq.gz`
which are the outputs of our trimming process. And the outputs will be two files: the report
`JP4D_kraken.report` and the file `JP4D.kraken`.  
  
~~~
$ kraken2 --use-names --threads 4 --db minikraken2_v2_8GB_201904_UPDATE --fastq-input --report JP4D_kraken.report  --gzip-compressed --paired JP4D_R1.trim.fastq.gz  JP4D_R2.trim.fastq.gz  > JP4D.kraken
~~~
{: .bash}
~~~
Unknown option: fastq-input                                                                            
Loading database information...Failed attempt to allocate 8000000000bytes;                             
you may not have enough free memory to load this database.                                             
If your computer has enough RAM, perhaps reducing memory usage from                                    
other programs could help you load this database?                                                      
classify: unable to allocate hash table memory    
~~~
{: .error}

As we can see in the output we need 8000000000bytes=8G in RAM to run kraken2, 
and seems that we do not have them. In fact, if we consult our memory with `free -b` 
we can see that we only have `135434240bytes`, and we wont be able to run kraken2 in 
this machine. 

For that reason, we precomputed in a the taxonomy in a server i.e. a more powerful machine. 
assignation of this reads. but we did this not with the trimmed reads but with the assembled 
contigs, in this case the input is a FASTA file of assembled contigs (`JP4D.fasta`). 
In the server, after we assembled the metagenome for this sample, we copied our 
assembly into our working directory and run kraken2. Output files in this command are 
also `JP4D.kraken` and `JP4D_kraken.report`. (Do not run the next commands, 
the results are already in the taxonomy directory).

~~~
$ cp ../../assembly/JP4D.fasta .
$ kraken2 --db minikraken2_v2_8GB_201904_UPDATE --fasta-input JP4D.fasta --threads 12 --output JP4D.kraken --report JP4D_kraken.report 
~~~
{: .bash}  

Let's look at the precomputed outputs of kraken2 in our assembled metagenome.  
~~~
head ~/dc_workshop/taxonomy/JP4D.kraken  
~~~
{: .bash}

~~~
U       k141_55805      0       371     0:337                                                         
U       k141_0  0       462     0:428                                                                 
U       k141_55806      0       353     0:319                                                         
U       k141_55807      0       296     0:262                                                         
C       k141_1  953     711     0:54 1224:2 0:152 28211:2 0:15 953:3 0:449                           
U       k141_2  0       480     0:446                                                                 
C       k141_3  28384   428     0:6 1286:2 0:8 28384:14 0:11 1:3 0:350                                
U       k141_4  0       302     0:268                                                                 
U       k141_5  0       714     0:680                                                                 
U       k141_6  0       662     0:628 
~~~
{: .output}

~~~
head ~/dc_workshop/report/JP4D_kraken.report
~~~
{: .bash} 
~~~
75.95	77818	77818	U	0	unclassified
 24.05	24642	5	R	1	root
 24.01	24597	0	R1	131567	  cellular organisms
 24.01	24597	562	D	2	    Bacteria
 19.88	20365	581	P	1224	      Proteobacteria
 15.16	15530	494	C	28211	        Alphaproteobacteria
  7.92	8116	7	O	204455	          Rhodobacterales
  7.84	8033	945	F	31989	            Rhodobacteraceae
  1.44	1476	51	G	1060	              Rhodobacter
  0.92	943	711	S	1063	                Rhodobacter sphaeroides

~~~
{: .output}  

> ## Reading a Kraken report `.callout`
>
> 1. Percentage of reads covered by the clade rooted at this taxon
> 2. Number of reads covered by the clade rooted at this taxon
> 3. Number of reads assigned directly to this taxon
> 4. A rank code, indicating (U)nclassified, (D)omain, (K)ingdom, (P)hylum, (C)lass, (O)rder, (F)amily, (G)enus, or (S)pecies. All other ranks are simply '-'.
> 5. NCBI taxonomy ID
> 6. Indented scientific name
{: .callout}

We have reached the tsv files, the final step in our metagenomic pipeline showed in [lesson-3](https://carpentries-incubator.github.io/metagenomics/03-assessing-read-quality/index.html).  
After we have the taxonomy assignation what follows is some visualization of our results.  


## Visualization of taxonomic assignation results  
[Krona](https://github.com/marbl/Krona/wiki) is a hierarchical data visualization software. Krona allows data to be explored with zooming, multi-layered pie charts and includes support for several bioinformatics tools and raw data formats. To use Krona in our results, lets go first into our taxonomy directory, which contains the precalculated Kraken outputs.  

### Krona  
~~~
$ cd ~/dc_workshop/taxonomy  
$ pwd
~~~
{: .bash}  
~~~
$ home/dcuser/dc_workshop/taxonomy  
~~~
{: .output}  

Krona is called with the `ktImportTaxonomy` command that needs an input and an output file.  
In our case we will create the input file with the columns three and four from `JP4D.kraken` file.     
~~~
$ cut -f2,3 JP4D.kraken >  JP4D.krona.input
~~~
{: .language-bash}  

Now we call Krona in our `JP4D.krona.input` file and save results in `JP4D.krona.out.html`.  
~~~
$ ktImportTaxonomy JP4D.krona.input -o JP4D.krona.out.html
~~~
{: .language-bash}  

Instead of the output we expected and error appeared. 
~~~
Loading taxonomy...
Taxonomy not found in /home/dcuser/.miniconda3/envs/metagenomics/opt/krona/taxonomy. Was updateTaxonomy.sh run? at /home/dcuser/.miniconda3/envs/metagenomics/opt/krona/scripts/../lib/KronaTools.pm line 1540.
~~~
{: .error}  

It seems that a necessary command for Krona to work was not executed, so let's do that. But we need to deactivate our environment first.

~~~
$ conda deactivate
$ bash /home/dcuser/.miniconda3/envs/metagenomics/opt/krona/updateTaxonomy.sh 
~~~
{: .language-bash}  

Once it's done we activate the environment and try again.
~~~
$ conda activate metagenomics
$ ktImportTaxonomy JP4D.krona.input -o JP4D.krona.out.html
~~~
{: .language-bash}  

And finally, open another terminal in your local computer,download the Krona output and open it on a browser.
~~~
$ scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/taxonomy/JP4D.krona.out.html . 
~~~
{: .bash}  

What do you see? 

<a href="{{ page.root }}/fig/krona1.svg">
  <img src="{{ page.root }}/fig/krona1.svg" alt="Krona Visualization" />
</a>

### Pavian
Pavian is another visualization tool that allows comparison between multiple samples. 
Pavian should be locally installed and needs R and Shiny, 
but we can try the [Pavian demo WebSite](https://fbreitwieser.shinyapps.io/pavian/) 
to visualize our results.  

First we need to download the files needed as inputs in Pavian:
`JC1A_kraken.report` and `JP4D_kraken.report`.  
This files corresponds to our Kraken reports. Again in our local machine lets use `scp` command.  
~~~
$ scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/report/*report . 
~~~
{: .language-bash}

We go to the [Pavian demo WebSite](https://fbreitwieser.shinyapps.io/pavian/), click on Browse and choose our reports.

<a href="{{ page.root }}/fig/uploadPavian.PNG">
  <img src="{{ page.root }}/fig/uploadPavian.PNG" alt="upload Pavian" />
</a>

We click on the Results Overview tab.

<a href="{{ page.root }}/fig/ResultsOverview.PNG">
  <img src="{{ page.root }}/fig/ResultsOverview.PNG" alt="Results Overview" />
</a>

We click on the Sample tab.

<a href="{{ page.root }}/fig/sample.PNG">
  <img src="{{ page.root }}/fig/sample.PNG" alt="sample" />
</a>

We can look at the abundance of a specific taxon by clicking on it.

<a href="{{ page.root }}/fig/SampleSelected.PNG">
  <img src="{{ page.root }}/fig/SampleSelected.PNG" alt="Sample Selected" />
</a>

We can look at a comparison of both our samples in the Comparison tab. 

<a href="{{ page.root }}/fig/Comparison.PNG">
  <img src="{{ page.root }}/fig/Comparison.PNG" alt="Comparison" />
</a>


> ## `.discussion`
>
> What do you think is harder to assign, a species (like _E. coli_) or a phylum (like Proteobacteria)?
{: .discussion}

                             
{% include links.md %}
