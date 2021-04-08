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


