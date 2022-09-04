---
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
math: true
---

## First plunge into diversity
*Look at your fingers, controlled by the mind can do great things. But imagine if each one have a little brain of its own, with 
different ideas, desires, and fears ¡How wonderful things will be made out of an artist with such hands!* 
  -Ode to multidisciplinarity

Species diversity, in it's must simple definition is the number of species in a particular area and their relative abundance (eveness).
Once we know the taxonomic composition of our metagenomes, we can do diversity analyses. 
Here we will talk about the two most used diversity metrics, α diversity (within one metagenome) and β (across metagenomes).   

- α Diversity: Can be represented as the richness (*i.e.* number of different species in an environment) and abundance of hte species in the area(*i.e.* the number of individuals of
each species inside the environment). It can be measured by calculating a diversity index such as Shannon's, Simpson's, Chao1, etc. 

<a href="{{ page.root }}/fig/03-07-01.png">
  <img src="{{ page.root }}/fig/03-07-01.png" alt="Alpha diversity diagram: In lake A, we have three fishes, each one of a different species. On lake B, we have two fishes each one of a different species.And in lake C we have four fishes, each one of different species." />
</a>
<em> Figure 1. Alpha diversity represented by fishes in a pond. Here, alpha diversity is represented at its simplest way: Richness. <em/>
 
- β Diversity: It is the difference (measured as distance) between two or more environments. 
It can be measured with metrics like Bray-Curtis dissimilarity, Jaccard distance or UniFrac distance, to name a few. Each one 
of this distance metrics are focused in a characteristic of the community (*e.g.* Unifrac distance measures the phylogenetic relationship
between the species of the community).

In the next example, we will look at the α and the β components of diversity of a 
dataset of fishes in three lakes. The most simple way to calculate the β-diversity 
is to calculate the species that are distinc between two lakes (sites). Let's take 
Lake A and Lake B to do an example. The number of species en Lake A is 3, to this 
quantity we will supress the number of these species that are shared with the Lake 
B: 2. So the number of unique species in Lake A compared to Lake B is (3-2):1. To 
this number we will sum the result of the same operations but now taken Lake B as 
our site of reference. In the end, the β diversity between Lake A and Lake B is 
(3-2) + (3-2) = 2. This process can be repeated taking each pair of lakes as the 
focused sites.

<a href="{{ page.root }}/fig/03-07-02.png">
  <img src="{{ page.root }}/fig/03-07-02.png" alt="Alpha and Beta diversity diagram: Each lake has a different number of species and each species has a different number of fish individuals. Both metrics are taken into account to measure alfa and beta diversity." />
</a>
<em> Figure 2. Alpha and Beta diversity represented by fishes in a pond.<em/>

If you want to read more about diversity, we recommend to you this [paper](https://link.springer.com/article/10.1007/s00442-010-1812-0) on 
the concept of diversity.

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
$ H = - \sum_{i=1}^{S} p_{i} \ln{p_{i}} $ | Definition
$ S $ | Number of OTUs 
$ p_{i} $ | The proportion of the community represented by OTU i

<!-- <img src="https://render.githubusercontent.com/render/math?math=H=-\sum_{i=1}^{S}p_i\:ln{p_i}"> | Definition
<img src="https://render.githubusercontent.com/render/math?math=S"> | Number of OTUs  
<img src="https://render.githubusercontent.com/render/math?math=p_i">|  The proportion of the community represented by OTU i    -->

- Simpson's (D) 

| Variable             |  Definition |   
:-------------------------:|:-------------------------:  
$ D = \frac{1}{\sum_{i=1}^{S} p_{i}^{2}} $ | Definition
$ S $ | Total number of the species in the community
$ p_{i} $ | Proportion of community represented by OTU i
  
  
<!-- <img src="https://render.githubusercontent.com/render/math?math=D=\frac{1}{\sum_{i=1}^{S}p_i^2}">| Definition   
<img src="https://render.githubusercontent.com/render/math?math=S"> | Total number of the species in the community   
<img src="https://render.githubusercontent.com/render/math?math=p_i" align="middle"> | Proportion of community represented by OTU i     -->
  
- Chao1  

| Variable             |  Definition |   
:-------------------------:|:-------------------------:  
$ S_{chao1} = S_{Obs} + \frac{F_{1} \times (F_{1} - 1)}{2 \times (F_{2} + 1)} $ | Count of singletons and doubletons respectively
$ F_{1}, F_{2} $ | Count of singletons and doubletons respectively
$ S_{chao1}=S_{Obs} $ | The number of observed species
  
  
<!-- <img src="../fig/equation.svg">| Definition  
<img src="https://render.githubusercontent.com/render/math?math=F_1,F_2">|Count of singletons and doubletons respectively    
<img src="https://render.githubusercontent.com/render/math?math=S_{chao1}=S_{Obs}">| The number of observed species   -->

 <!-- coment we use https://viereck.ch/latex-to-svg/ to convert from latex to svg because Chao equation didnot render correctly with github math!-->

### β diversity  
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
>   <img src="{{ page.root }}/fig/03-07-01e.png" alt="In lake A, we have four different species, two of these species have 3 specimens each one. This lake also have two specimens of another species and only one specimen of the other specie. We got nine fishes total. On the other hand, lake B has only three different species, the most populated specie has five specimens and we have only one specimen of the other two species. We got seven species total in lake B " />
> </a>
> Which of the options below is true for the alpha diversity in lake A, lake B, and beta diversity between lakes A and B, respectively.
> 1. 4, 3, 1
> 2. 4, 3, 5
> 3. 9, 7, 16
>
> Please, paste your result on the collaborative document provided by instructors. 
> *Hic Sunt Leones!* (*Here be Lions!*)  
>
>> ## Solution
>> Answer: 4, 3, 5
> {: .solution}
{: .challenge}


## Creating lineage and rank tables  

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

### The terminal in RStudio

RStudio has an integrated terminal that uses the same language as the one we learnd in the Command-line lessons. As well, R's terminal 
is an interface that executes programs, and is better to deal with long data sets than in a visual interface.  

You can also known in which directory you are standing in the terminal, by using `pwd`. 

Let's explore the content of some of our data files. In order to do it, we have to move to 
the  folder where our taxonomic-data files are: 
~~~
$ cd ~/dc_workshop/taxonomy
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

Files `.kraken` and `.report`are the output of the Kraken program, we can see a few lines of the file `.kraken` 
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


### Kraken-biom 

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

With the next command, we are going to create a table in [Biom](https://biom-format.org/) format called `cuatroc.biom`. We will include the two samples we have been working with (`JC1A` and `JP4D`) and a thrid one `JP41`, to be able to perform certain analyses later on.
~~~
$ kraken-biom JC1A.report JP4D.report JP41.report --fmt json -o cuatroc.biom
~~~
{: .bash}

If we inspect our folder, we will see that the `cuatroc.biom` file has been created, this is 
a `biom` object which contains both, the abundances of each OTU and the identificator of each OTU.
With this result, we are ready to return to RStudio's console and beggin to manipulate our 
taxonomic-data.

##  Manipulating lineage and rank tables with phyloseq  

### Load required packages  

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
The "class" command indicates that we already have our phyloseq object.
Let's try to access the data that is stored inside our `merged_metagenomes` object. Since a phyloseq object
is a special object in R, we need to use the operator `@` to explore the subsections of data inside `merged_metagenomes`.
If we type `merged_metagenomes@` five options are displayed; `tax_table` and `otu_table` are the ones that
we will use. After writting `merged_metagenomes@otu_table` or `merged_metagenomes@tax_table`, an option of `.Data` 
will be the one choosed in both cases. Let's see what is inside of our `tax_table`:
~~~
> View(merged_metagenomes@tax_table@.Data)
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-03.png">
  <img src="{{ page.root }}/fig/03-07-03.png" alt="A table where the taxonomic 
  identification information of all OTUs is displayed. Each row represent one 
  OTU and the columns its identification at different levels in the taxonomic taxonomic classification ranks, begging with Kingdom until we reach Species 
  in the seventh column " />
</a>
<em> Figure 3. Table of the OTU data from our `merged_metagenomes` object. <em/>

Next, let's get rid of some of the innecesary characters 
in the OTUs identificator and put names to the taxonomic ranks:

To remove unnecessary characters in `.Data` (matrix), we are going to use command `substring()`. This command is useful to extract or replace characters in a vector. To use the command, we have to indicate the vector (x) followed by the first element to replace or extract (first) and the last element to be replaced (last). For instance: `substring (x, first, last)`. `substring()` is a "flexible" command, especially to select characters of different lengths as in our case. Therefore, it is not necessary to indicate "last", so it will take the last position of the character by default. Considering that a matrix is a arrangement of vectors, we can use this command. Each character in `.Data` is preceded by 3 spaces occupied by a letter and two underscores, for example: `o__Rhodobacterales`. In this case "Rodobacterales" starts at position 4 with an R. So to remove the unnecessary characteres we will use the following code:

~~~
> merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
> colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-04.png">
  <img src="{{ page.root }}/fig/03-07-04.png" alt="The same table we saw in Figure 
  3 but with informative names in each of the columns. Now, we can see which of 
  the columns are associated with which taxonomic classification rank" />
</a>
<em> Figure 4. Table of the OTU data from our `merged_metagenomes` object. With corrections. <em/>

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

This is useful, but what we need to do if we need to know how many of our OTUs have been assigned to the phylum
Firmicutes?. Let´s use the command `sum()` to ask R:
~~~
> sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Firmicutes")
~~~
{: .language-r}
~~~
[1] 580
~~~
{: .output}

> ## Exercise 2: Explore a phylum
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the learned code to find out how many OTUs have been assigned to
> your chosen phylum and what are the unique names of the genera inside it.
> がんばれ! (ganbate; *good luck*):
>> ## Solution
>> Change the name of a new phylum wherever it is needed to get the result.
>> As an example, here is the solution for Proteobacteria:
>> ~~~ 
>> sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria")
>> ~~~ 
>> {: .language-r}
>> ~~~
>> [1] 1949
>> ~~~
>> {: .output}
>> ~~~
>> unique(merged_metagenomes@tax_table@.Data[merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria", "Genus"])
>> ~~~
>> {: .language-r}
>> 
> {: .solution}
{: .challenge} 


> ## Phyloseq objects
> Finally, we can review our object and see that all datasets (i.e. JC1A, JP4D, and JP41) are in the object.
> If you look at our Phyloseq object, you will see that there are more data types 
> that we can use to build our object(`?phyloseq()`), such as a phylogenetic tree and metadata 
> concerning our samples. These are optional, so we will use our basic
> phyloseq object for now, composed of the abundances of specific OTUs and the 
> names of those OTUs.  
{: .callout}


## Plot alpha diversity 

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
> #open a pdf to save the plot
  pdf("richness_plot.pdf") 
> plot_richness(physeq = merged_metagenomes, 
              measures = c("Observed","Chao1","Shannon")) 
>  # Close the pdf file
> dev.off() 
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-07-05.png">
  <img src="{{ page.root }}/fig/03-07-05.png" alt="A figure divided in three 
  sections. Each of these sections represent a diferent alpha diversity index. 
  Inside this sections, each point represent the value assigned on this index to 
  the three different samples. We can see how the different indexes gives 
  different values to the same sample." />
</a>
<em> Figure 5. Alpha diversity indexes for both samples. <em/>

You can see your plot by open the file richness_plot.pdf Each of these metrics
 can give insight of the distribution of the OTUs inside 
our samples. For example Chao1 diversity index gives more weight to singletons
and doubletons observed in our samples, while Shannon is a entropy index 
remarking the impossiblity of taking two reads out of the metagenome "bag" 
and that these two will belong to the same OTU.


> ## Exercise 3: 
> While using the help provided explore these options available for the function in `plot_richness()`:
> 1. `nrow`
> 2. `sortby`
> 3. `title`
>
> Use these options to generate new figures that show you 
> other ways to present the data.
>
>> ## Solution
>> The code and the plot using the three options will look as follows:
>> The "title" option adds a title to the figure.
>> ~~~
>> > #pdf("richness_plot_title.pdf") 
>> > plot_richness(physeq = merged_metagenomes, 
>>              title = "Alpha diversity indexes for both samples in Cuatro Cienegas",
>>              measures = c("Observed","Chao1","Shannon"))
>> > dev.off() 
>> ~~~
>> {: .language-r}
>> 
>> <a href="{{ page.root }}/fig//TitleFlag.png">
>> <img src="{{ page.root }}/fig//TitleFlag.png" alt="Alpha diversity indexes for both samples with title" />
>> </a>
>> 
>> The "nrow" option arranges the graphics horizontally.
>> ~~~
>> > #pdf("richness_plot_horizontal.pdf") 
>> > plot_richness(physeq = merged_metagenomes, 
>>              title = "Alpha diversity indexes for both samples in Cuatro Cienegas",
>>              measures = c("Observed","Chao1","Shannon"),
>>              nrow=3)
>> > dev.off() 
>> ~~~
>> {: .language-r}
>>  
>> <a href="{{ page.root }}/fig//NrowFlag.png">
>> <img src="{{ page.root }}/fig//NrowFlag.png" alt="Alpha diversity indexes for both samples horizontal with title" />
>> </a>
>> 
>> The "sortby" option orders the samples from least to greatest diversity depending on the parameter. In this case, it is ordered by "Shannon" and tells us that the JP4D sample has the lowest diversity and the JP41 sample the highest.
>> ~~~
>> > #pdf("richness_plot_sorted.pdf") 
>> > plot_richness(physeq = merged_metagenomes, 
>>              title = "Alpha diversity indexes for both samples in Cuatro Cienegas",
>>              measures = c("Observed","Chao1","Shannon"),
>>              sortby = "Shannon") 
>> > dev.off() 
>> ~~~
>> {: .language-r}
>> 
>> <a href="{{ page.root }}/fig//SortbyFlag.png">
>> <img src="{{ page.root }}/fig//SortbyFlag.png" alt="Alpha diversity indexes for both samples with title sort by Shannon" />
>> </a>
>>
>>
>>  Considering the above mentioned, together with the 3 graphs, we can say that the samples JP41 and JP4D present a high diversity with respect to the JC1A, but that the diversity of the sample JP41 is mainly given by singletons or doubletons, instead, the diversity of JP4D is given by species in much greater abundance. Although because the values of H (Shannon) above 3 are considered to have a lot of diversity.
>> 
>  {: .solution}
{: .challenge}  
  
  
> ## Discussion
>
> How much can the α diversity can be changed by eliminating the singletons
> and doubletons?
{: .discussion}
  
  
                             
{% include links.md %}
