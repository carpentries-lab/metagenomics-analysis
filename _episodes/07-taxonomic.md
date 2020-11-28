---
title: "Taxonomic Assignation"
teaching: 30
exercises: 15
questions:
- "How can I assign a taxonomy to my contigs?"
objectives:
- "Understand how taxonomic assignation works"
keypoints:
- "A database with previous knowledge is needed for taxonomic assignation"
- "Kraken2 is a program for taxonomic assignation"
---

<a href="{{ page.root }}/fig/sesgos.png">
  <img src="{{ page.root }}/fig/sesgos.png" alt="Cog Metagenome" />
</a>

Taxonomic assignation of each sequence into Operational Taxonomic
Units (OTUs) can be done either after reads has been assembled into 
contigs, or using unassembled reads. The comparison database in this 
assignation process must be constructed using complete genomes. There are 
many programs for doing taxonomic mapping, almost all of them follows one 
of the next strategies:  

1. BLAST: Using BLAST or DIAMOND, these mappers search for the most likely hit 
for each sequence within a database of genomes. This strategy is slow.    
  
2. Kmers: A genome database is broken into pieces of length k, search 
for unique pieces by taxonomic group, from species to LCA. Then they break the 
sequence into pieces of length k, look for where these are placed within the tree 
and make the classification with the most probable position.    

3. Markers: They look for markers of a database made a priori in the sequences 
to be classified and assign the taxonomy depending on the hits obtained.    

> ## Taxonomy assignation software `.callout`
>
> There are three strategies for taxonomy assignation: blast, kmers and markers. 
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
{: .code}
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

Despite we have our input files we also need a comparison database before 
start working with kraken2. There are [several databases](http://ccb.jhu.edu/software/kraken2/downloads.shtml) 
compatibles to be used with kraken2 in the taxonomical assignation process. 
Minikraken is a popular database that attempts to conserve its sensitivity 
despite its small size (Needs 8GB of RAM for classification).  Lets download minikraken database using the command
`curl`.   

~~~
$ curl -O ftp://ftp.ccb.jhu.ed u/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz         
$ tar -xvzf minikraken2_v2_8GB_201904.tgz 
~~~
{: .code}

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
In this case we can use fastq files as inputs, in this case the inputs would be files 
` JP4DASH2120627WATERAMPRESIZED_R1.trim.fastq.gz` and ` JP4DASH2120627WATERAMPRESIZED_R2.trim.fastq.gz`
which are the outputs of our trimming process. In this case the outputs will be two files, the report
JP4D_kraken.report and the file JP4D.kraken.  
  
~~~
$ kraken2 --use-names --threads 4 --db minikraken2_v2_8GB_201904_UPDATE --fastq-input --report JP4D_kraken.report  --gzip-compressed --paired JP4DASH2120627WATERAMPRESIZED_R1.trim.fastq.gz  JP4DASH2120627WATERAMPRESIZED_R2.trim.fastq.gz  > JP4D.kraken
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
and seems that we do not have them. In fact if we consult our memory with `free -b` 
we can see that we only have `135434240bytes`, and we wont be able to run kraken2 in 
this machine.For that reason we precomputed in a more powerful machine the taxonomy 
assignation of this reads. The command that was run was in fact not with fastq files,
kraken2 can also be run after the assembly process, in this case the input is a fasta file, 
the one that we assembled with megahit. In a more powerful machine
we would first copy our assembly into this directory and run kraken2. 
Output files in this command are also JP4DA.kraken and JP4DA_kraken.report.  
~~~
$ cp ../../data/trimmed_fastq/megahit_result/final.contigs.fa  JP4D.fasta  
$ kraken2 --db minikraken2_v2_8GB_201904_UPDATE --fasta-input  JP4D.fasta --threads 12 --output JP4D.kraken --report JP4D_kraken.report 
~~~
{: .bash}  

Lets visualize the precoomputed outputs of kraken2 in our assembled metagenome.  
~~~
head ~/dc_workshop/taxonomy/JP4D.kraken  
~~~
{: .bash}

~~~
C	k141_0	1365647	416	0:1 1365647:5 2:5 1:23 0:348
U	k141_1411	0	411	0:377
U	k141_1	0	425	0:391
C	k141_1412	1484116	478	0:439 1484116:3 0:2
C	k141_2	72407	459	0:350 2:3 0:50 2:6 72407:5 0:3 72407:2 0:6
U	k141_1413	0	335	0:301
U	k141_3	0	302	0:268
C	k141_1414	2072936	347	0:138 2:5 1224:5 2:5 0:33 252514:1 0:121 2072936:5
U	k141_4	0	447	0:413
U	k141_5	0	303	0:269
U	k141_1415	0	443	0:409
U	k141_1416	0	304	0:270
C	k141_6	1	413	1:379
~~~
{: .output}

~~~
head ~/dc_workshop/report/JP4D_kraken.report
~~~
{: .bash} 
~~~
 62.10	1748	1748	U	0	unclassified
 37.90	1067	8	R	1	root
 37.48	1055	0	R1	131567	  cellular organisms
 37.48	1055	33	D	2	    Bacteria
 27.99	788	40	P	1224	      Proteobacteria
 17.05	480	32	C	28211	        Alphaproteobacteria
  6.32	178	16	O	356	          Rhizobiales
  1.17	33	1	F	41294	            Bradyrhizobiaceae
  0.75	21	4	G	374	              Bradyrhizobium
  0.11	3	3	S	114615	                Bradyrhizobium sp. ORS 278
  0.07	2	2	S	722472	                Bradyrhizobium lablabi
  0.07	2	2	S	2057741	                Bradyrhizobium sp. SK17
  0.07	2	2	S	1437360	                Bradyrhizobium erythrophlei
~~~
{: .output}  

We have reach the tsv files, the final step in our metagenomic pipeline showed in lesson-3.  
After we have the taxnomy assignation what follows is some visualization of our results.  


## Visualization of taxonomic assignation results  
[Krona](https://github.com/marbl/Krona/wiki) is a hierarchical data visualization software. Krona allows data to be explored with zooming, multi-layered pie charts and includes support for several bioinformatics tools and raw data formats. 

~~~
krona updateTaxonomy.sh
~~~
{: .language-bash}

~~~
cut -f2,3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken >  krona.input
ktImportTaxonomy krona.input -o krona.out.html
scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/results/krona*html . 
~~~
{: .language-bash}


~~~
grep -v $'\t'0 krona.input >krona.input2  
ktImportTaxonomy krona.input2 -o krona2.out.html
scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/results/krona*html . 
~~~
{: .language-bash}

~~~
cut -f2,3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken >  krona.input
ktImportTaxonomy krona.input -o krona.out.html
~~~
{: .language-bash}


<a href="{{ page.root }}/fig/krona1.svg">
  <img src="{{ page.root }}/fig/krona1.svg" alt="Krona Visualization" />
</a>



<a href="{{ page.root }}/fig/krona2.svg">
  <img src="{{ page.root }}/fig/krona2.svg" alt="Krona Visualization" />
</a>


Kraken, Centrifuge and MetaPhlAn. Pavian should be locally installed using R and Shiny, but we can try the [Pavian demo WebSite](https://fbreitwieser.shinyapps.io/pavian/) to visualize our results.  

<a href="{{ page.root }}/fig/uploadPavian.PNG">
  <img src="{{ page.root }}/fig/uploadPavian.PNG" alt="upload Pavian" />
</a>

<a href="{{ page.root }}/fig/ResultsOverview.PNG">
  <img src="{{ page.root }}/fig/ResultsOverview.PNG" alt="Results Overview" />
</a>

<a href="{{ page.root }}/fig/sample.PNG">
  <img src="{{ page.root }}/fig/sample.PNG" alt="sample" />
</a>

<a href="{{ page.root }}/fig/SampleSelected.PNG">
  <img src="{{ page.root }}/fig/SampleSelected.PNG" alt="Sample Selected" />
</a>

<a href="{{ page.root }}/fig/Comparison.PNG">
  <img src="{{ page.root }}/fig/Comparison.PNG" alt="Comparison" />
</a>



> ## `.discussion`
>
> Discussion questions.
{: .discussion}

                             
{% include links.md %}
