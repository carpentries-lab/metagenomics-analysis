---
title: "Automating Abundance Tables"
teaching: 30
exercises: 25
questions:
- "How can I obtain the abundance of the reads?"
objectives:
- "Understand how taxonomy is used to obtain abundance tables."
keypoints:
- "Abundance can be obtain either before or after the assembly process."
- "A bash script can automate this work."
---


Once we know the taxonomic composition of our metagenomes, we can do diversity analyses. 
Here we will talk about the two most used diversity metrics, diversity α (within one metagenome) and β (between metagenomes).   

- α Diversity: Represents the richness (e.g. number of different species) and species' abundance. It can be measured by calculating richness, 
 and eveness, or by using a diversity index, such as Shannon's, Simpson's, Chao's, etc.  
 
- β Diversity: It is the difference (measured as distance) between two or more metagenomes. 
It can be measured with metrics like Bray-Curtis dissimilarity, Jaccard distance or UniFrac, to name a few.  

For this lesson we will use Phyloseq, an R package specialized in metagenomic analysis. We will use it along with Rstudio to analyze our data. 
[Rstudio cloud](https://rstudio.cloud/) and select "GET STARTED FOR FREE"

## α diversity  

|-------------------+-----------------------------------------------------------------------------------------------------------------|   
| Diversity Indices |                             Description                                                                         |   
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|      Shannon (H)  | Estimation of species richness and species evenness. More weigth on richness.                                   |   
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|    Simpson's (D)  |Estimation of species richness and species evenness. More weigth on evenness.                                    |                           
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|      ACE          | Abundance based coverage estimator of species richness.                                                         |   
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|     Chao1         | Abundance based on species represented by a single individual (singletons) and two individuals (doubletons).    |            
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
 

- Shannon (H): 

| Variable             |  Definition   |     
:-------------------------:|:-------------------------:  
<img src="https://render.githubusercontent.com/render/math?math=H=-\sum_{i=1}^{S}p_i\:ln{p_i}"> | Definition
<img src="https://render.githubusercontent.com/render/math?math=S"> | Number of OTUs  
<img src="https://render.githubusercontent.com/render/math?math=p_i">|  The proportion of the community represented by OTU i   

- Simpson's (D) 

| Variable             |  Definition |   
:-------------------------:|:-------------------------:  
<img src="https://render.githubusercontent.com/render/math?math=D=\frac{1}{\sum_{i=1}^{S}p_i^2}">| Definition   
<img src="https://render.githubusercontent.com/render/math?math=S"> | Total number of the species in the community   
<img src="https://render.githubusercontent.com/render/math?math=p_i" align="middle"> | Proportion of community represented by OTU i    
  
- ACE  

| Variable             |  Definition |  
:-------------------------:|:-------------------------:  
<img src="https://render.githubusercontent.com/render/math?math=S_{ACE}=S_{abund}+\frac{S_{rare}}{C_{ACE}}+\frac{F_1}{C_{ACE}}+\gamma_{ACE}^2"> | Definition    
<img float="left" src="https://render.githubusercontent.com/render/math?math=S_{abund}"> | Number of abundant OTUs   
<img src="https://render.githubusercontent.com/render/math?math=S_{rare}">  | Number of rare OTUs   
<img src="https://render.githubusercontent.com/render/math?math=C_{ACE}">  | Sample abundance coverage estimator  
<img src="https://render.githubusercontent.com/render/math?math=F_1">   | Frequency of singletons  
<img src="https://render.githubusercontent.com/render/math?math=\gamma_{ACE}^2"> | Estimated coefficient  of variation in rare OTUs 

- Chao1  
  
| Variable             |  Desription |  
:-------------------------:|:-------------------------:  
 <img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S_{Obs}+\frac{F_1(F_1-1)}{2(F_2+1)}">  | Definition  
<img src="https://render.githubusercontent.com/render/math?math=F_1,F_2">|Count of singletons and doubletons respectively    
<img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S_{Obs}">| The number of observed species    

The rarefaction curves allow us to know if the sampling was exhaustive or not. 
In metagenomics this is equivalent to knowing if the sequencing depth was sufficient.

## β diversity  
Diversity β measures how different two or more metagenomes are, either in their composition (diversity)
or in the abundance of the organisms that compose it (abundance). 
- Bray-Curtis dissimilarity: Emphasis on abundance. Measures the differences 
from 0 (equal communities) to 1 (different communities)
- Jaccard distance: Based on presence / absence of species (diversity). 
It goes from 0 (same species in the community) to 1 (no species in common)
- UniFrac: Measures the phylogenetic distance; how alike the trees in each community are. 
There are two types, without weights (diversity) and with weights (diversity and abundance)  

It is easy to visualize using PCA, PCoA or NMDS analysis.

## Creating lineage and rank tables  
Packages like Quiime2, MEGAN, Vegan or Phyloseq in R allows to obtain these diversity indexes.  
We will use Phyloseq, in order to do so, we need to generate an abundance matrix from the Kraken output.  

~~~
$ cd ~/dc_workshop/taxonomy
$ head JP4D.kraken   
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



|------------------------------+------------------------------------------------------------------------------|  
| column                       |                              Description                                     |  
|------------------------------+------------------------------------------------------------------------------|  
|   C                          |  Classified or unclassified                                                  |  
|------------------------------+------------------------------------------------------------------------------|  
|    k141_0                    |FASTA header of the read(contig)                                              |                
|------------------------------+------------------------------------------------------------------------------|  
|  1365647                     | Tax id                                                                       |  
|------------------------------+------------------------------------------------------------------------------|  
|    416                       |Read length                                                                   |           
|------------------------------+------------------------------------------------------------------------------|  
|  0:6 1286:2 0:8 28384:14 0:11|kmers hit to a taxonomic id E.g. 0:1 root 6 hit, 1286 has 2 hits, etc.        |           
|-------------------+-----------------------------------------------------------------------------------------|  


First, let's count the occurrences of each taxon.  
~~~
$ cut -f3 JP4D.kraken  |sort -n |uniq -c > ranked
$ head -n5 ranked
~~~
{: .bash}

~~~
 77818 0
 5 1
 562 2
 4 22
 2 32
 ~~~
{: .output}  

Now, let's reverse the columns.  
~~~
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JP4D.kraken_ranked
$ rm ranked
~~~
{: .bash}

Let's see our `JP4D.kraken_ranked` file.  
~~~
head -n5 JP4D.kraken_ranked
~~~
{: .bash}

~~~
0       77818
1       5
2       562
22      4
32      2
~~~
{: .output}  

Let's repeat the process for `JC1A` sample.  
~~~
$ cut -f3 JC1A.kraken   |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1A.kraken_ranked
$ rm ranked
~~~
{: .bash}

Now we will use `taxonkit` to obtain the taxonomy classification of each read.  
In order to access to `taxonkit` and other packages prepared in an environment
called metagenomics, we will call this environment from conda:

~~~
conda activate metagenomics
~~~
{: .bash}

~~~
$ cut -f1 JP4D.kraken_ranked |taxonkit lineage |\
taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" |\
cut  -f1,3 >JP4D.lineage_table
~~~
{: .bash}

Also, let's obtaine a lineage table for `JC1A` sample.  
~~~
$ cut -f1 JC1A.kraken_ranked |taxonkit lineage |\
taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | cut  -f1,3 >JC1A.lineage_table
~~~
{: .bash}


Errors are saved in `JC1A.error` and `JP4D.error` files.  Common errors are `deleted` and `merged`.   
~~~
$ grep deleted JP4D.error
~~~
{: .bash}

The file contains one line with the word `deleted`.  
~~~
$ 04:29:50.903 [WARN] taxid 119065 was deleted  
~~~
{: .output}  
  
We can remove this line by using a `perl` one liner.  
~~~
$ grep 119065 JP4D.kraken                        
$ perl -ne 'print if !/119065/' JP4D.kraken >JP4D.kraken-wc
$ grep 119065 JP4D.kraken-wc                            
~~~
{: .bash}  
  
~~~
$
~~~
{: .output} 

And the line that contains 119065 is gone from the new file JP4D.kraken-wc.    

Now let's see for the `merged` error in the `JP4D` error file.  
~~~
$ grep merged JP4D.error | cut -d' ' -f4,8 > JP4D.merged 
$ head -n5 JP4D.merged 
~~~
{: .bash}
  
~~~
62928 418699                                                                                             
335659 1404864                                                                                           
354203 263377                                                                                            
640511 2654982                                                                                           
644968 694327 
~~~
{: .output} 

And let's substitute all the merged taxon by the corresponding new one. 
~~~
$ cat  JP4D.merged  | while read line;\
 do\
    original=$(echo $line | cut -d' ' -f1);\
    new=$(echo $line  |cut -d' '  -f2);\
    perl -p -i -e "s/$original/$new/" JP4D.kraken-wc;\
     done                      
$ cut -f3 JP4D.kraken-wc | sort -n | uniq -c > ranked 
$ cat ranked | while read a b; do echo $b$'\t'$a; done > JP4D.kraken_ranked-wc
$ rm ranked
~~~
{: .bash} 

With this new working copy of the proportion in taxonomy classification
we can run again taxonkit to obtain the curated lineage table.  
~~~
$ cut -f1 JP4D.kraken_ranked-wc | taxonkit lineage |\
  taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" |\
  cut  -f1,3 > JP4D.lineage_table-wc                                        
~~~
{: .bash}

~~~
$ 10:34:06.833 [WARN] taxid 0 not found          
~~~
{: .output}  

Next, we need to apply this process to our other sample: `JC1A`. We did not 
oobtained any `deleted` taxid, remember?
~~~
04:31:28.340 [WARN] taxid 0 not found
04:31:28.341 [WARN] taxid 335659 was merged into 1404864
04:31:28.341 [WARN] taxid 644968 was merged into 694327
04:31:28.342 [WARN] taxid 2109625 was merged into 2605946
~~~
{: .output}

Result that can be verified, but let's obtained the merged ones:

~~~
$ grep deleted JC1A.error 
$ grep merged JC1A.error | cut -d' ' -f4,8 > JC1A.merged    
$ cp JC1A.kraken JC1A.kraken-wc
$ cat  JC1A.merged  | while read line;\
  do\
    original=$(echo $line|cut -d' ' -f1);\
    new=$( echo $line|cut -d' '  -f2);\
    perl -p -i -e "s/$original/$new/" JC1A.kraken-wc;\
  done    
$ cut -f3 JC1A.kraken-wc | sort -n | uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1A.kraken_ranked-wc
$ rm ranked
~~~
{: .bash} 

~~~
$ cut -f1 JC1A.kraken_ranked-wc |taxonkit lineage |\
  taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" |\
  cut  -f1,3 > JC1A.lineage_table-wc                                        
~~~
{: .bash}

~~~
$ 10:34:06.833 [WARN] taxid 0 not found          
~~~
{: .output}  
   
Finally, we need to add headers to our rank file and our lineage table.  
~~~
$ nano JC1A.kraken_ranked-wc
 OTU  JC1A
~~~
{: .bash}  

~~~
$ nano JC1A.lineage_table-wc
OTU superkingdom	phylum	class	order	family	genus	species	subspecies	subspecies_2
~~~
{: .bash}  

As a last cleaning step, we need to substitute the "," separator in the csv file to "\t" 
After this step we have our tables ready for Phyloseq.  
~~~
$ perl -p -i -e 's/;/\t/g' *.lineage_table-wc                                                                                    
$ head -n5 *.lineage_table-wc 
~~~
{: .bash}

~~~
$ rm *.kraken-wc                            
$ mkdir ../results
$ mv *wc ../results/.
$ rm *lineage* *ranked* *merged  
$ cp *kraken* ../results/.
$ mv *report* ../results/.
~~~
{: .bash}  

[Download full script](https://github.com/carpentries-incubator/metagenomics/blob/gh-pages/files/abundance.sh) 
{% include links.md %}
