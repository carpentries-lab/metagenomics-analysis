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

Once we know the taxonomic composition of our metagenomes, we can do diversity analyses. 
Here we will talk about the two most used diversity metrics, diversity α (within one metagenome) and β (between metagenomes).   

- α Diversity: Represents the richness (e.g. number of different species) and species' abundance. It can be measured by calculating richness, 
 Eveness, or using a diversity index, such as Shannon's, Simpson's, Chao's, etc.  
 
- β Diversity: It is the difference (measured as distance) between two or more metagenomes. 
It can be measured with metrics like Bray-Curtis dissimilarity, Jaccard distance or UniFrac, to name a few.  

For this lesson we will use phyloseq, an R package specialized in metagenomic analysis. We will use it along with Rstudio to analyze our data. 
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


| Italic             |  Block letters |
:-------------------------:|:-------------------------:
![]<|mg float="left" src="https://render.githubusercontent.com/render/math?math=S_{abund}">|![]<img src="https://render.githubusercontent.com/render/math?math=S_{rare}">   
 
  Where <img src="https://render.githubusercontent.com/render/math?math=S_{abund}"> and <img src="https://render.githubusercontent.com/render/math?math=S_{rare}">  are the number of abundant and rare OTUs respectively,
<img src="https://render.githubusercontent.com/render/math?math=C_{ACE}"> is the sample abundance coverage estimator, <img src="https://render.githubusercontent.com/render/math?math=F_1"> is the frequency of singletons, and <img src="https://render.githubusercontent.com/render/math?math=\gamma_{ACE}^2"> is the estimated coefficient  of variation in rare OTUs.

- Chao1 <img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S{Os}+\frac{F_1(F_1-1)}{2(F_2+1)}">  
 Where <img src="https://render.githubusercontent.com/render/math?math=F_1,F_2"> are the count of singletons and doubletons respectively, and Sobs is the number of observed species.

The rarefaction curves allow us to know if the sampling was exhaustive or not. 
In metagenomics this is equivalent to knowing if the sequencing depth was sufficient

## Distance between two metagenomes  
Diversity β measures how different two or more metagenomes are, either in their composition (diversity)
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
$ cd ~/dc_workshop/taxonomy
$ head JC1A.kraken   
~~~
{: .bash}

~~~
 C k141_0  1365647 416     0:1 1365647:5 2:5 1:23 0:348    
 U       k141_1411       0       411     0:377                                       
 U       k141_1  0       425     0:391                                               
 C       k141_1412       1484116 478     0:439 1484116:3 0:2                          
 C       k141_2  72407   459     0:350 2:3 0:50 2:6 72407:5 0:3 72407:2 0:6           
 U       k141_1413       0       335     0:301     
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
$ cut -f1 JP4D.kraken_ranked-wc |taxonkit lineage |\
  taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s};{S}" |\
  cut  -f1,3 > JP4D.lineage_table-wc                                        
~~~
{: .bash}

~~~
$ 10:34:06.833 [WARN] taxid 0 not found          
~~~
{: .output}  

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


wget  ftp://ftp.ncbi.nih.gov/pub/taxonomy/  
tar -xzf taxdump.tar.gz       


~~~
$ nano JC1A.kraken_ranked-wc
 OTU  JC1A
~~~
{: .bash}  

~~~
$ nano JC1A.lineage_table-wc
OTU	superkingdom	phylum	class	order	family	genus	species	subspecies	subspecies_2
~~~
{: .bash}  

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
~~~
{: .bash}  


Let's install phyloseq (This instruction might not work on certain version of R) 
and the rest of the required libraries:  

~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq")

install.packages(c("ggplot2", "readr", "patchwork"))

~~~

Now let's load the libraries 

~~~
library("phyloseq")
library("ggplot2")
library("readr")
library("patchwork")
~~~
{: .language-r}

Now we have to load the our metagenomes on R 

~~~
OTUS <- read_delim("JC1A.kraken_ranked-wc","\t", escape_double = FALSE, trim_ws = TRUE)
TAXAS <- read_delim("JC1A.lineage_table-wc", "\t", escape_double = FALSE, \
                    col_types = cols(subspecies = col_character(),  \
                    subspecies_2 = col_character()), trim_ws = TRUE)

~~~
{: .language-r}

Phyloseq objects are a collection of information about one or more metagenomes, these
objects can manually constructed using the basic data structures available in R or can
be created by importing the output of other programs, such as QUIIME.

Since we imported our data to basic R data types, we will make our phyloseq object manually.

~~~
names1 = OTUS$OTU
names2 = TAXAS$OTU
~~~
{: .language-r}

~~~
OTUS$OTU = NULL
TAXAS$OTU = NULL
~~~
{: .language-r}

~~~
abundances = as.matrix(OTUS)
lineages = as.matrix(TAXAS)
~~~
{: .language-r}

~~~
row.names(abundances) = names1
row.names(lineages) = names2
~~~
{: .language-r}

All that we've done so far is transforming the taxonomic lineage table 
and the OTU abundance table into a format that can be read by phyloseq,
now we will make the phyloseq data types out of our tables.

~~~
OTU = otu_table(abundances, taxa_are_rows = TRUE)
TAX = tax_table(lineages)
~~~
{: .language-r}

We will now construct a phyloseq object using phyloseq data types 

~~~
metagenome_JC1A = phyloseq(OTU, TAX)
~~~
{: .language-r}

> ## `.callout`
>
>If you look at our phyloseq object, you will see that there's more data types 
>that we can use to build our object. These are optional, so we will use our basic
>phyloseq object for now.  
{: .callout}


We then will prune all of the non-bacterial organisms in our metagenome. To do this 
we will make a subset of all bacterial groups and save them
~~~
Bacteria <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

We will then filter out the taxonomic groups that have less than 10 reads assigned to them.

~~~
metagenome_JC1A <- prune_taxa(taxa_sums(metagenome_JC1A)>10,metagenome_JC1A)
~~~
{: .language-r}


Now let's look at some statistics of our metagenomes, like the mean number 
of reads assigned to a taxonomic group

~~~
max(sample_sums(metagenome_JC1A))
min(sample_sums(metagenome_JC1A))
mean(sample_sums(metagenome_JC1A))
~~~
{: .language-r}

The max, min and mean can give us an idea of the eveness, but to have a more 
visual representation of the α diversity we can now look at a ggplot2
graph created using phyloseq 

~~~
p = plot_richness(metagenome_JC1A, measures = c("Observed", "Chao1", "Shannon")) 
p + geom_point(size=5, alpha=0.7)  
~~~
{: .language-r}


> ## `.discussion`
>
> How much did the α diversity change due to the filterings that we made?
{: .discussion}


> ## Exercise
> 
> How can you import the `JP4D metagenome` to phyloseq? 
> 
>> ## Solution
>> 
>> Repeat the previous instructions replacing JC1A for JP4D whenever it's appropiate
>> 
> {: .solution}
{: .challenge}  



Now that you have both pyloseq objects, one for each metagenome, you can merge them into one object

~~~
merged_metagenomes = merge_phyloseq(metagenome_JC1A, metagenome_JP4D)
~~~
{: .language-r}


Let´s look at the phylum abundance of our metagenomes. 
Since our metagenomes have different sizes it might be a good idea to 
convert the number of assigned read into percentages. 

~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
~~~
{: .language-r}

Now we can make a comparative graph between absolute reads and percentages.

~~~
absolute_count = plot_bar(merged_metagenomes, fill="phylum")
absolute_count = absolute_count + geom_bar(aes(color=phylum, fill=phylum), stat="identity", position="stack") + ggtitle("Absolute abundance")

percentages = plot_bar(percentages, fill="phylum")
percentages = percentages + geom_bar(aes(color=phylum, fill=phylum), stat="identity", position="stack") + ggtitle("Relative abundance")

absolute_count | percentages
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

