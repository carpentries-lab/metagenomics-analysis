---
source: md
title: "Diversity Tackled With R "
teaching: 40
exercises: 10
questions:
- "How can I obtain the abundance of the reads?"
- "How can I use R to explore diversity?"
objectives:
- "Comprehend which libraries are required for metagenomes diversity analysis."  
- "Grasp how a phyloseq object is made."
- "Undestand the needed commands to create a phyloseq object for analysis."
keypoints:
- "The library `phyloseq` manages metagenomics objects and computes alpha diversity."  
- "Transform your named matrixes into Phyloseq objects using `pyhloseq(TAX, OTU)`."
- "Use `help()` to discover the capabilities of libraries."
- "The library `ggplot2` allows publication-quality plotting in R."
---

# First plunge into diversity
*Look at your fingers, controlled by the mind can do great things. But imagine if each one have a little brain of its own, with 
different ideas, desires, and fears ¡How wonderful things will be made out of an artist with such hands!* 
  -Ode to multidisciplinarity

Species diversity, is the number of species that are represented in a certain community. 
Once we know the taxonomic composition of our metagenomes, we can do diversity analyses. 
Here we will talk about the two most used diversity metrics, α diversity (within one metagenome) and β (across metagenomes).   

- α Diversity: Can be represented as the richness (*i.e.* number of different species in an environment) and abundance(*i.e.* the number of individuals of
each species inside the environment). It can be measured by calculating a diversity index such as Shannon's, Simpson's, Chao1, etc.  
<a href="{{ page.root }}/fig/03-07-01.png">
  <img src="{{ page.root }}/fig/03-07-01.png" alt="Alpha diversity represented by fishes in a pond. Here, alpha diversity is represented at its simplest way: Richness" />
</a>

###### Figure 1. Alpha diversity represented by fishes in a pond. Here, alpha diversity is represented at its simplest way: Richness
 
- β Diversity: It is the difference (measured as distance) between two or more environments. 
It can be measured with metrics like Bray-Curtis dissimilarity, Jaccard distance or UniFrac distance, to name a few. Each one 
of this distance metrics are focused in a characteristic of the community (*e.g.* Unifrac distance measures the phylogenetic relationship
between the species of the community).

<a href="{{ page.root }}/fig/03-07-02.png">
  <img src="{{ page.root }}/fig/03-07-02.png" alt="Alpha and Beta diversity represented by fishes in a pond" />
</a>

###### Figure 2. Alpha and Beta diversity represented by fishes in a pond.

For this lesson we will use Phyloseq, an R package specialized in metagenomic analysis. We will use it along with Rstudio to analyze our data. 

## α diversity  

|-------------------+-----------------------------------------------------------------------------------------------------------------|   
| Diversity Indices |                             Description                                                                         |   
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|      Shannon (H)  | Estimation of species richness and species evenness. More weigth on richness.                                   |   
|-------------------+-----------------------------------------------------------------------------------------------------------------|   
|    Simpson's (D)  |Estimation of species richness and species evenness. More weigth on evenness.                                    |                              
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
  
- Chao1  

| Variable             |  Definition |   
:-------------------------:|:-------------------------:  
<img src="../fig/equation.svg">| Definition  
<img src="https://render.githubusercontent.com/render/math?math=F_1,F_2">|Count of singletons and doubletons respectively    
<img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S_{Obs}">| The number of observed species  

 <!-- coment we use https://viereck.ch/latex-to-svg/ to convert from latex to svg because Chao equation didnot render correctly with github math!-->

## β diversity  
Diversity β measures how different two or more communities are, either in their composition (richness)
or in the abundance of the organisms that compose it (abundance). 
- Bray-Curtis dissimilarity: The difference on richness and abundance across environments (samples). Weight on abundance. Measures the differences 
from 0 (equal communities) to 1 (different communities)
- Jaccard distance: Based on presence / absence of species (diversity). 
It goes from 0 (same species in the community) to 1 (no species in common)
- UniFrac: Measures the phylogenetic distance; how alike the trees in each community are. 
There are two types, without weights (diversity) and with weights (diversity and abundance)  

There are different ways to plot and show the results of such analysis. Among others,  PCA, PCoA or NMDS analysis are widely used.

> ## Exercise 1: 
> In the next picture there are two lakes with different fish species:
> <a href="{{ page.root }}/fig/03-07-01e.png">
>   <img src="{{ page.root }}/fig/03-07-01e.png" alt="Diversity question in two lakes" />
> </a>
> Which of the options below is true for the alpha diversity in lake A, lake B, and beta diversity between A and N
> 1. 3, 3, 1
> 2. 3, 3, 4
> 3. 9, 7, 16
>
> Please, paste your result on the collaborative document provided by instructors. 
> *Hic Sunt Leones!* (*Here be Lions!*)  
>
>> ## Solution
>> 2. 3, 3, 4
> {: .solution}
{: .challenge}


# Creating lineage and rank tables  

In this lesson we will use RStudio to analize two microbiome samples from CCB, you don't have to install anything, 
you already have an instance on the cloud ready to be used.   

For this purpose, we will use packages in R. A *package* is a family of code units (functions, classes, variables) that 
implement a set of related tasks. Importing a package is like getting a piece of lab equipment out of a storage locker 
and setting it up on the bench. Packages provide additional functionality to the basic R code, much like a new piece 
of equipment adds functionality to a lab space.

Packages like Quiime2, MEGAN, Vegan or Phyloseq in R allows us to obtain these diversity indexes by 
manipulating taxonomic-assignation data.  In this lesson, we will use Phyloseq. In order to do so, we need to generate 
an abundance matrix from the Kraken output files. One program widely used for this purpose is `kraken-biom`.

But before we face our first storm in this code sea, let's learn one useful tool in RStudio.

## The terminal in RStudio

RStudio has an integrated terminal that uses the same language as the one we learnd in the Command-line lessons. As well, R's terminal 
is an interface that executes programs, and is better to deal with long data sets than in a visual interface.  

You can also known in which directory you are standing in the terminal, by using `pwd`. 

Let's explore the content of some of our data files. In order to do it, we have to move to 
the  folder where our taxonomic-data files are: 
~~~
$ cd /home/dcuser/dc_workshop/taxonomy
~~~~
{: .bash}

First, we will visualize the content of our directory by the `ls` command.  
~~~
$ ls
~~~
{: .bash}
~~~
JC1A.kraken  JC1A.report  JP41.report  JP4D.kraken  JP4D.report  mags_taxonomy
~~~
{: .output}

Files `.kraken` and `kraken.report`are the output of the Kraken program, we can see a few lines of the file `.kraken` 
using the command `head`.   
~~~
$ head JP4D.kraken  
~~~
{: .bash}
~~~
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:19691:2037 0 250|251 0:216 |:| 0:217
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:14127:2052 0 250|238 0:216 |:| 0:204
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:14766:2063 0 251|251 0:217 |:| 0:217
C MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:15697:2078 2219696 250|120 0:28 350054:5 1224:2 0:1 2:5 0:77 2219696:5 0:93 |:| 379:4 0:82
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:15529:2080 0 250|149 0:216 |:| 0:115
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:14172:2086 0 251|250 0:217 |:| 0:216
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:17552:2088 0 251|249 0:217 |:| 0:215
U MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:14217:2104 0 251|227 0:217 |:| 0:193
C MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:15110:2108 2109625 136|169 0:51 31989:5 2109625:7 0:39 |:| 0:5 74033:2 31989:5 1077935:1 31989:7 0:7 60890:2 0:105 2109625:1
C MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:19558:2111 119045  251|133 0:18 1224:9 2:5 119045:4 0:181 |:| 0:99
  
~~~
{: .output}

This information may be confused, let's take out our cheatsheet to understand some of its components:


|------------------------------+------------------------------------------------------------------------------|  
| Column                       |                              Description                                     |  
|------------------------------+------------------------------------------------------------------------------|  
|   C                          |  Classified or unclassified                                                  |  
|------------------------------+------------------------------------------------------------------------------|  
|   MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:15697:2078               |FASTA header of the sequence         |   
|------------------------------+------------------------------------------------------------------------------|  
|  2219696                     | Tax ID                                                                       |  
|------------------------------+------------------------------------------------------------------------------|  
|    250:120                   |Read length                                                                   |   
|------------------------------+------------------------------------------------------------------------------|  
|  0:28 350054:5 1224:2 0:1 2:5 0:77 2219696:5 0:93 379:4 0:82|kmers hit to a taxonomic ID *e.g.* tax ID 350054 has 5 hits, tax ID 1224 has 2 hits, etc. |   
|-------------------+-----------------------------------------------------------------------------------------|  

There are other set of files with `.report` suffix. This is an output with the same information as the one found
in the `.kraken` files, but in a more human-readable sintax:
~~~
$ head JP4D.report  
~~~
{: .bash}
~~~
78.13 587119  587119  U 0 unclassified
 21.87  164308  1166  R 1 root
 21.64  162584  0 R1  131567    cellular organisms
 21.64  162584  3225  D 2     Bacteria
 18.21  136871  3411  P 1224        Proteobacteria
 14.21  106746  3663  C 28211         Alphaproteobacteria
  7.71  57950 21  O 204455            Rhodobacterales
  7.66  57527 6551  F 31989             Rhodobacteraceae
  1.23  9235  420 G 1060                Rhodobacter
  0.76  5733  4446  S 1063                  Rhodobacter sphaeroides
  ~~~
{: .output}


## Kraken-biom 

Kraken-biom is a program that creates BIOM tables from the Kraken output 
[kraken-biom](https://github.com/smdabdoub/kraken-biom)

Let's take a look at the different flags that `kraken-biom` has:

~~~
$ conda activate metagenomics 
~~~
{: .bash}

~~~
$ kraken-biom -h                  
~~~
{: .bash}

~~~
usage: kraken-biom [-h] [--max {D,P,C,O,F,G,S}] [--min {D,P,C,O,F,G,S}]
                   [-o OUTPUT_FP] [--otu_fp OTU_FP] [--fmt {hdf5,json,tsv}]
                   [--gzip] [--version] [-v]
                   kraken_reports [kraken_reports ...]

Create BIOM-format tables (http://biom-format.org) from Kraken output
(http://ccb.jhu.edu/software/kraken/).
.
.
.
~~~
{: .output}
By a close look at the first output lines, it is noticeable that we need a specific output
from Kraken: `.reports`. 

With the next command, we are going to create a table in [Biom](https://biom-format.org/) format called `cuatroc.biom`:
~~~
$ kraken-biom JC1A.report JP4D.report JP41.report --fmt json -o cuatroc.biom
~~~
{: .bash}

If we inspect our folder, we will see that the `cuatroc.biom` file has been created, this is 
a `biom` object which contains both, the abundances of each OTU and the identificator of each OTU.
With this result, we are ready to return to RStudio's console and beggin to manipulate our 
taxonomic-data.

#  Manipulating lineage and rank tables with phyloseq  

## Load required packages  

Phyloseq is a library with tools to analyze and plot your metagenomics tables. Let's install [phyloseq](https://joey711.github.io/phyloseq/) (This instruction might not work on certain versions of R) and other libraries required for its execution:  

~~~
> if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

> BiocManager::install("phyloseq") # Install phyloseq

> install.packages(c("ggplot2", "readr", "patchwork")) #install ggplot2 and patchwork to chart publication-quality plots and readr to read rectangular datasets.
~~~
{: .language-r}  

Once the libraries are installed, we must make them available for this R session. Now load the libraries (a process needed every time we begin a new work 
in R and we are going to use them):

~~~
> library("phyloseq")
> library("ggplot2")
> library("readr")
> library("patchwork")
~~~
{: .language-r}

  
### Load data with the number of reads per OTU and taxonomic labels for each OTU  

First we tell R in which directory we are working.
~~~
> setwd("~/dc_workshop/taxonomy/")
~~~
{: .language-r}

Let's procced to create the phyloseq object with the `import_biom` command:
~~~
> merged_metagenomes <- import_biom("cuatroc.biom")
~~~
{: .language-r}

Now, we can inspect the result by asking what class is the object created, and 
doing a close inspection of some of its content:
~~~
> class(merged_metagenomes)
~~~
{: .language-r}
~~~
[1] "phyloseq"
attr("package")
[1] "phyloseq"
~~~
{: .output}
The "class" command indicate that we already have our phyloseq object.
Let's try to access the data that is stored inside our `merged_metagenomes` object. Since a phyloseq object
is a special object in R, we need to use the operator `@` to explore the subsections of data inside `merged_metagenomes`.
If we type `merged_metagenomes@` five options are displayed, from them `tax_table` and `otu_table` are the ones that
we will use. After writting `merged_metagenomes@otu_table` or `merged_metagenomes@tax_table`, an option of `.Data` 
will be the one choosed in both cases. Let's see what is inside of our `tax_table`:
~~~
> View(merged_metagenomes@tax_table@.Data)
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-03.png">
  <img src="{{ page.root }}/fig/03-07-03.png" alt="Table of the OTU data from our `merged_metagenomes` object" />
</a>


###### Figure 3. Table of the OTU data from our `merged_metagenomes` object.

Next, let's get rid of some of the innecesary characters 
in the OTUs identificator and put names to the taxonomic ranks:

~~~
> merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
> colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-04.png">
  <img src="{{ page.root }}/fig/03-07-04.png" alt="Table of the OTU data from our `merged_metagenomes` object. With corrections" />
</a>

###### Figure 4. Table of the OTU data from our `merged_metagenomes` object. With corrections

To explore how many phyla we have, we are going to use a command name `unique()`. Let's try what result
we obtain with the next code:
~~~
> unique(merged_metagenomes@tax_table@.Data[,"Phylum"])
~~~
{: .language-r}
~~~
 [1] "Proteobacteria"              "Actinobacteria"              "Firmicutes"                 
 [4] "Cyanobacteria"               "Deinococcus-Thermus"         "Chloroflexi"                
 [7] "Armatimonadetes"             "Bacteroidetes"               "Chlorobi"                   
[10] "Gemmatimonadetes"            "Planctomycetes"              "Verrucomicrobia"            
[13] "Lentisphaerae"               "Kiritimatiellaeota"          "Chlamydiae"                 
[16] "Acidobacteria"               "Spirochaetes"                "Synergistetes"              
[19] "Nitrospirae"                 "Tenericutes"                 "Coprothermobacterota"       
[22] "Ignavibacteriae"             "Candidatus Cloacimonetes"    "Fibrobacteres"              
[25] "Fusobacteria"                "Thermotogae"                 "Aquificae"                  
[28] "Thermodesulfobacteria"       "Deferribacteres"             "Chrysiogenetes"             
[31] "Calditrichaeota"             "Elusimicrobia"               "Caldiserica"                
[34] "Candidatus Saccharibacteria" "Dictyoglomi" 
~~~
{: .output}

This is useful, but what we need to do if we need to know how many of our reads have been assigned to the 
`Firmicutes` phylum?. Let´s use the command `sum()` to ask R, how many of the reads fill this requiriment:
~~~
> sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Firmicutes")
~~~
{: .language-r}
~~~
[1] 580
~~~
{: .output}

> ## Exercise 1: 
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the learned code to find out how many reads have been assigned to
> your chosen phylum and what are the unique names of the genera inside it.
> がんばれ! (ganbate; *good luck*):
>> ## Solution
>> Change the name of a new phylum wherever it is needed to get the result.
>> As an example, here is the solution for Proteobacteria:
>>sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria")
>>unique(merged_metagenomes@tax_table@.Data[merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria", "Genus"])
> {: .solution}
{: .challenge} 


> ## Phyloseq objects
> Finally, we can review our object and see that all datasets (i.e. JC1A, JP4D, and JP41) are in the our object.
> If you look at our Phyloseq object, you will see that there are more data types 
> that we can use to build our object(?phyloseq), such as a phylogenetic tree and metadata 
> concerning our samples. These are optional, so we will use our basic
> phyloseq object for now, composed of the abundances of specific OTUs and the 
> names of those OTUs.  
{: .callout}


### Plot alpha diversity 

We want to know how is the bacterial diversity, so we will prune all of the 
non-bacterial organisms in our metagenome. To do this we will make a subset 
of all bacterial groups and save them.
~~~
> merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
~~~
{: .language-r}

Now let's look at some statistics of our metagenomes:

~~~
> merged_metagenomes
~~~
{: .language-r}
~~~
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 4024 taxa and 3 samples ]
tax_table()   Taxonomy Table:    [ 4024 taxa by 7 taxonomic ranks ]
~~~ 
{: .output}
~~~
> sample_sums(merged_metagenomes)
~~~
{: .language-r}
~~~
  JC1A   JP4D   JP41 
 18412 149590  76589 
~~~ 
{: .output}

~~~
> summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}
~~~
      JC1A              JP4D              JP41        
 Min.   :  0.000   Min.   :   0.00   Min.   :   0.00  
 1st Qu.:  0.000   1st Qu.:   3.00   1st Qu.:   1.00  
 Median :  0.000   Median :   7.00   Median :   5.00  
 Mean   :  4.575   Mean   :  37.17   Mean   :  19.03  
 3rd Qu.:  2.000   3rd Qu.:  21.00   3rd Qu.:  14.00  
 Max.   :399.000   Max.   :6551.00   Max.   :1994.00  
~~~ 
{: .output}

By the output of the `sample_sums()` command we can see how many reads there are
in the library. Also, the Max, Min and Mean output on `summary()` can give us an
idea of the evenness. Nevertheless, to have a more visual representation of the
diversity inside the samples (i.e. α diversity) we can now look at a ggplot2
graph created using Phyloseq:

~~~
> plot_richness(physeq = merged_metagenomes, 
              measures = c("Observed","Chao1","Shannon")) 
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-05.png">
  <img src="{{ page.root }}/fig/03-07-05.png" alt=" Alpha diversity indexes for both samples" />
</a>

###### Figure 5. Alpha diversity indexes for both samples

Each of these metrics can give insight of the distribution of the OTUs inside 
our samples. For example Chao1 diversity index gives more weight to singletons
and doubletons observed in our samples, while Shannon is a entropy index 
remarking the impossiblity of taking two reads out of the metagenome "bag" 
and that these two will belong to the same OTU.


> ## Exercise 2: 
> While using the help provided in `plot_richness()`, divide these three flags between the members of your breakout-room:
> 1. `nrow()`
> 2. `sortby()`
> 3. `title()`
>
> Use these flags to generate new figures that show you and your breakroom-coterie 
> other ways to present the data.
> 
> Please, paste your result on the collaborative document provided by instructors. 
> Hic Sunt Leones! (Here be Lions!)  
>
{: .challenge}  
  
  
> ## Discussion
>
> How much can the α diversity can be changed by eliminating the singletons
> and doubletons?
{: .discussion}
  
  
                             
{% include links.md %}
