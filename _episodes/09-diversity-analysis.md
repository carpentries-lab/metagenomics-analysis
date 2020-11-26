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
head JC1A.kraken   
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

~~~
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JP4D.kraken_ranked
$ rm ranked
~~~
{: .bash}

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


~~~
$ cut -f3 JC1A.kraken   |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1A.kraken_ranked
$ rm ranked
~~~
{: .bash}


~~~
$ cut -f1 JP4D.kraken_ranked |taxonkit lineage | \
taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | \
cut  -f1,3 >JP4D.lineage_table
~~~
{: .bash}

~~~
$ cut -f1 JC1A.kraken_ranked |taxonkit lineage |\
taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" | cut  -f1,3 >JC1A.lineage_table
~~~
{: .bash}

Errors are saved in `JC1A.error` and `JP4D.error` files  Common errors are `deleted` and `merged`.   
~~~
$ grep deleted JP4D.error
~~~
{: .bash}

The file contains one line with the word `deleted`.  

~~~
$ 04:29:50.903 [WARN] taxid 119065 was deleted  
~~~
{: .output}  
  
We can remove this line by using a one liner.  
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

Now lets ser fot the `merged` error in the `JP4D` error file.  
  
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

~~~
$ cat  JP4D.merged  | while read line;\
 do \
    original=$(echo $line|cut -d' ' -f 1); \
    new=$( echo $line|cut -d' '  -f2); \
    perl -p -i -e "s/$original/$new/" JP4D.kraken-wc;\
     done                      
$ cut -f3 JP4D.kraken-wc    |sort -n |uniq -c > ranked 
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JP4D.kraken_ranked-wc
$ rm ranked
~~~
{: .bash} 

~~~
$ grep deleted JC1A.error 
$ grep merged JC1A.error | cut -d' ' -f4,8 > JC1A.merged    
$ cp JC1A.kraken JC1A.kraken-wc
$ cat  JC1A.merged  | while read line;\
  do\
    original=$(echo $line|cut -d' ' -f 1); \
    new=$( echo $line|cut -d' '  -f2); \
    perl -p -i -e "s/$original/$new/" JC1A.kraken-wc;\
  done    
$ cut -f3 JC1A.kraken-wc |sort -n |uniq -c > ranked  
$ cat ranked |while read a b; do echo $b$'\t'$a; done > JC1A.kraken_ranked-wc
$ rm ranked
~~~
{: .bash} 

~~~
$  perl -ne  'print if !/119065/'  JP4D.lineage_table >JP4D.lineage_table-2 
~~~
{: .bash}


~~~
$ cut -d' ' -f1 JP4D.merged  | while read line;\
 do \
    perl -p -i -e  "s/$line/DELETE/"  JP4D.lineage_table-2;\
 done    
 $  perl -p -i -e  "s/;/\t/g" JP4D.lineage_table-2;\ 
 $ grep -v DELETE JP4D.lineage_table-2 > JP4D.lineage_table-wc
~~~
{: .bash}


~~~
$ cp JC1A.lineage_table JC1A.lineage_table-2
$ cut -d' ' -f1 JC1A.merged  | while read line;\
 do \
     perl -p -i -e  "s/$line/DELETE/" JC1A.lineage_table-2 ;\     
 done   
 
 $  perl -p -i -e  "s/;/\t/g" JC1A.lineage_table-2 ;\ 
 $  grep -v DELETE JC1A.lineage_table-2 > JC1A.lineage_table-wc
~~~
{: .bash}



wget  ftp://ftp.ncbi.nih.gov/pub/taxonomy/  
tar -xzf taxdump.tar.gz       


~~~
$ nano JC1A.kraken_ranked-wc
$ OTU  JC1A
~~~
{: .bash}  

~~~
$ rm *.kraken-wc                            
$ mkdir ../results
$ mv *wc ../results/.
$ rm *lineage* *ranked* *merged  
~~~
{: .bash}  


In console:  
`.language-r`: R source:

~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq")

~~~
{: .language-r}


~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq")
~~~
{: .language-r}

~~~
library("phyloseq")
library("ggplot2")
library("readr")
library("patchwork")
~~~
{: .language-r}


> ## Exercise
> 
> Ejercicio `ERR2143795/JP4D_R1.fastq ` file? How confident
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

