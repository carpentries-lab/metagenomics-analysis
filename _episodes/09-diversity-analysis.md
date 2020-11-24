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
|     Chao1         | Abundance based coverage estimator of species richness.           <img src="https://render.githubusercontent.com/render/math?math=e^{i \pi} = -1"|         
|-------------------+------------------------------------------------------------------------------|

- Shannon (H): <img src="https://render.githubusercontent.com/render/math?math=H=-\sum_{i=1}^{S}p_i ln{p_i}">
- Simpson's (D) <img src="https://render.githubusercontent.com/render/math?math=D=\frac{1}{\sum_{i=1}^{S}p_i^2i}">
- ACE <img src="https://render.githubusercontent.com/render/math?math=S_{ACE}=S_{abund}+\frac{a}{b}+\frac{c}{d}+\gamma^2">
- Chao1 <img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S{Os}+\frac{q}{b}">

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

