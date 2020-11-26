---
source: md
title: "Diversity analysis"
teaching: 10
exercises: 2
questions:
- "What is diversity intra metagenome?"
- "What is diversity inter metagenomes?"
objectives:
- "Understand α diversity"
- "Understand β diversity"
keypoints:
- "Edit the .Rmd files not the .md files"
---

Once we know what our metagenome is made of, we can do the diversity analysis. 
Here we can see the diversity α (within the group) and β (between groups).   

- α Diversity: It can be measured by calculating wealth, 
 Eveness Shannon diversity index, Simpson diversity index, Chao1, etc.  
 
- Diversity β: The difference (or distance) between two communities is measured. 
For example, Bray-Curtis dissimilarity, Jaccard distance or UniFrac are used.  

Phyloseq is an R package specialized in metagenomic metrics. We will use Rstudio in our data. 
[Rstudio cloud](https://rstudio.cloud/) and select "GET STARTED FOR FREE"

## α diversity  

|-------------------+------------------------------------------------------------------------------|   
| Diversity Indices |                             Description                                      |   
|-------------------+------------------------------------------------------------------------------|   
|      Shannon (H)  | Estimation of species richness and species evenness. More weigth on richness.|   
|-------------------+------------------------------------------------------------------------------|   
|    Simpson's (D)  |Estimation of species richness and species evenness. More weigth on evenness. |                             
|-------------------+------------------------------------------------------------------------------|   
|      ACE          | Abundance based coverage estimator of species richness.                      |   
|-------------------+------------------------------------------------------------------------------|   
|     Chao1         | Abundance based coverage estimator of species richness.                      |            
|-------------------+------------------------------------------------------------------------------|   
 

- Shannon (H): <img src="https://render.githubusercontent.com/render/math?math=H=-\sum_{i=1}^{S}p_i\:ln{p_i}">
  Where S is the number of OTUs and <img src="https://render.githubusercontent.com/render/math?math=p_i">  the proportion of the community represented by OTU i. 

- Simpson's (D) <img src="https://render.githubusercontent.com/render/math?math=D=\frac{1}{\sum_{i=1}^{S}p_i^2}">
  Where S is the total number of the species in the community and<img src="https://render.githubusercontent.com/render/math?math=p_i" align="middle"> is the proportion of community represented by OTU i.  
  
- ACE <img src="https://render.githubusercontent.com/render/math?math=S_{ACE}=S_{abund}+\frac{S_{rare}}{C_{ACE}}+\frac{F_1}{C_{ACE}}+\gamma_{ACE}^2"> 
  Where <img src="https://render.githubusercontent.com/render/math?math=S_{abund}"> and <img src="https://render.githubusercontent.com/render/math?math=S_{rare}">  are the number of abundant and rare OTUs respectively,  <img src="https://render.githubusercontent.com/render/math?math=C_{ACE}"> is the sample abundance coverage estimator, <img src="https://render.githubusercontent.com/render/math?math=F_1"> is the frequency of singletons, and <img src="https://render.githubusercontent.com/render/math?math=\gamma_{ACE}^2"> is the estimated coefficient  of variation in rare OTUs.

- Chao1 <img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S{Os}+\frac{F_1(F_1-1)}{2(F_2+1)}">  
 Where <img src="https://render.githubusercontent.com/render/math?math=F_1"> and <img src="https://render.githubusercontent.com/render/math?math=F_2">  are the count of singletons and doubletons respectively, and Sobs is the number of observed species.

The rarefaction curves allow us to know if the sampling was exhaustive or not. 
In metagenomics this is equivalent to knowing if the sequencing depth was sufficient

## Distance between two communities  
Diversity β measures how different two communities are, either in their composition (diversity)
or in the abundance of the organisms that compose it (abundance). 
- Bray-Curtis dissimilarity: Emphasis on abundance. Measures the differences 
from 0 (equal communities) to 1 (different communities)
- Jaccard distance: Based on presence / absence of species (diversity). 
It goes from 0 (same species in the community) to 1 (no species in common)
- UniFrac: Measures the phylogenetic distance; how alike the trees in each community are. 
There are two types, without weights (diversity) and with weights (diversity and abundance)  

It is easy to visualize using PCA, PCoA or NMDS
We can see them in Quiime2, MEGAN or in R with the vegan or phyloseq packages

~~~
$ cut -f3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken  |sort -n |uniq -c > ranked
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JP4DASH2120627WATERAMPRESIZED_kraken.kraken_ranked
$ rm ranked
~~~
{: .bash}

~~~
$ cut -f3 JC1ASEDIMENT120627_kraken.kraken   |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1ASEDIMENT120627_kraken.kraken_ranked
$ rm ranked
~~~
{: .bash}

~~~
 C k141_0  1365647 416     0:1 1365647:5 2:5 1:23 0:348  
~~~
{: .output}



   


|------------------------------+------------------------------------------------------------------------------|  
| column                       |                              Description                                     |  
|------------------------------+------------------------------------------------------------------------------|  
|   C                          |  Classified or unclassified                                                  |  
|------------------------------+------------------------------------------------------------------------------|  
|    k141_0                    |fasta header of the read(contig)  .                                           |                
|------------------------------+------------------------------------------------------------------------------|  
|  1365647                     | tax id                                                                       |  
|------------------------------+------------------------------------------------------------------------------|  
|    416                       |read length                                                                   |           
|------------------------------+------------------------------------------------------------------------------|  
| 0:1 1365647:5 2:5 1:23 0:348 |hits on database E.g. 0:1 root 1 hit, 1365647 has 5 hits, etc.                |           
|-------------------+-----------------------------------------------------------------------------------------|  



First column
~~~
$ cut -f1 JP4DASH2120627WATERAMPRESIZED_kraken.kraken_ranked |taxonkit lineage |taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | cut  -f1,3 >JP4DASH2120627WATERAMPRESIZED_kraken.kraken_ranked_lineage_table
~~~
{: .bash}

~~~
$ cut -f1 JC1ASEDIMENT120627_kraken.kraken_ranked |taxonkit lineage |taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | cut  -f1,3 >JC1ASEDIMENT120627_kraken.kraken_ranked_lineage_table
~~~
{: .bash}

Errors are saved in `JC1ASEDIMENT120627.error` and ` JP4DASH2120627WATERAMPRESIZED.error` files 
Common errors are `deleted` and `merged`. 

~~~
$ grep deleted JP4DASH2120627WATERAMPRESIZED.error
$ perl -ne 'print if !/119065/' JP4DASH2120627WATERAMPRESIZED_kraken.kraken >JP4DASH2120627WATERAMPRESIZED_kraken.kraken-wc
~~~
:{ .bash}

~~~
$ grep merged JP4DASH2120627WATERAMPRESIZED.error
~~~
:{ .bash}


~~~
$ grep merged JP4DASH2120627WATERAMPRESIZED.error | cut -d' ' -f4,8 > JP4DASH2120627WATERAMPRESIZED.merged 
$ cat  JP4DASH2120627WATERAMPRESIZED.merged  | while read line;\
 do \
    original=$(echo $line|cut -d' ' -f 1); \
    new=$( echo $line|cut -d' '  -f2); \
    perl -p -i -e "s/$original/$new/" JP4DASH2120627WATERAMPRESIZED_kraken.kraken-wc;\
     done                      
$ cut -f3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken-wc    |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JP4DASH2120627WATERAMPRESIZED_kraken.kraken-wc_ranked
$ rm ranked
~~~
:{ .bash}

~~~
$ grep deleted JC1ASEDIMENT120627.error 
$ grep merged JC1ASEDIMENT120627.error | cut -d' ' -f4,8 > JC1ASEDIMENT120627.merged    
$ cp JC1ASEDIMENT120627_kraken.kraken JC1ASEDIMENT120627_kraken.kraken-wc
$ cat  JC1ASEDIMENT120627.merged  | while read line;\
 do \
    original=$(echo $line|cut -d' ' -f 1); \
    new=$( echo $line|cut -d' '  -f2); \
    perl -p -i -e "s/$original/$new/" JC1ASEDIMENT120627_kraken.kraken-wc;\
     done    
$ cut -f3 JC1ASEDIMENT120627_kraken.kraken-wc |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1ASEDIMENT120627_wc_ranked
$ rm ranked
~~~
:{ .bash}



wget  ftp://ftp.ncbi.nih.gov/pub/taxonomy/  
tar -xzf taxdump.tar.gz       

~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq")
~~~
{: .lenguage-R}

> ## Exercise
> 
> Ejercicio `ERR2143795/JP4DASH2120627WATERAMPRESIZED_R1.fastq ` file? How confident
> 
>> ## Solution
>> ~~~
>> $ tail 
>> ~~~
>> {: .bash}
>> 
>> ~~~
>> texto
>> ~~~
>> {: .output}
>> 
>> soluion
>> 
> {: .solution}
{: .challenge}                             
                             


> ## `.callout`
>
> An aside or other comment.
{: .callout}

> ## `.discussion`
>
> Discussion questions.
{: .discussion}

                             
{% include links.md %}

