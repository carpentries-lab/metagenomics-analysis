---
source: md
title: "Diversity analysis"
teaching: 30
exercises: 30
questions:
- "How can I use R to explore diversity?"
objectives:
- "Visualize different estimates of α diversity"
- "Load libraries required for metagenomes alpha diversity plotting"  
- "Transform named matrixes into phyloseq objects"
- "Use help to discover the capabilities of libraries"
- "Chart diversity estimates"
keypoints:
- "The library `phyloseq` manages metagenomics objects and computes alpha diversity"  
- "The libraries `ggplot2` and 'patchwork' allow publication-quality plotting in R"
- "Transform your named matrixes into phyloseq objects using `pyhloseq(TAX, OTU)`"
- "Use `help()` to discover the capabilities of libraries"
---
    
## Using R studio
In this lesson we will use R studio to analize two microbiome samples from 4C, you don't have to install anything, you already have an instance on the cloud ready to be used. 

1. Click on this [shared google sheet](https://docs.google.com/spreadsheets/d/1w78TuQUdtI2Fgk4DFG26YYkXTkUg2vTjVLaRH-D_7xk/edit?usp=sharing) and in the first column write without spaces your name and lastname. Check that you do not overwrite other participant's names. 

2. Now copy your instance address into your browser (Chrome or firefox) and login into R studio.  
The address should look like:  `http://ec2-3-235-238-92.compute-1.amazonaws.com:8787/`  
Your credencials are user: dcuser pass:data4Carp.  

3. Data are already stored at your instance, but in case you lose your data you can donwload it [here](https://drive.google.com/file/d/15dW1sQCIhtmCUvS0IUOMPBH5m1gqNB0m/view?usp=sharing).

## Exploring metagenome data with the terminal.  
  
The terminal is a program that executes programs, and is better to deal with long data sets than a visual interface.  
First to visualize the content of our directory you can use the `ls` command.  
`ls`  

Now you can also known in which directoryare you standing by using `pwd`  

Lets explore the content of some of our data files.  
Files `.kraken` are the output of the kraken program, we can see a few lines of the file using the command `head`    
~~~
head JC1A.kraken 
~~~
{: .bash}

How would you see the last lines of the file report?  
~~~
tail JC1A.report 
~~~
{: .bash}
  


##  Manipulating lineage and rank tables in phyloseq  

  
### Load required packages  

Phyloseq is a library with tools to analyze and plot your metagenomics tables. Let's install [phyloseq](https://joey711.github.io/phyloseq/) (This instruction might not work on certain versions of R) and other libraries required for its execution:  

~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq") # Install phyloseq

install.packages(c("ggplot2", "readr", "patchwork")) #install ggplot2 and patchwork to chart publication-quality plots. readr to read rectangular datasets.
~~~
{: .language-r}  

Once the libraries are installed, we must make them available for this R session. Now load the libraries (a process needed every time we began a new work 
in R and we are going to use phyloseq):

~~~
library("phyloseq")
library("ggplot2")
library("readr")
library("patchwork")
~~~
{: .language-r}

  
### Load data with the number of reads per OTU and Taxonomic labels for each OTU.  

Now we have to load our metagenomes files on R 

~~~
OTUS <- read_delim("JC1A.kraken_ranked-wc","\t", escape_double = FALSE, trim_ws = TRUE)
TAXAS <- read_delim("JC1A.lineage_table-wc", "\t", escape_double = FALSE, 
                    col_types = cols(subspecies = col_character(),  
                    subspecies_2 = col_character()), trim_ws = TRUE)

~~~
{: .language-r}


### Build Phyloseq object  

Phyloseq objects are a collection of information regarding a single or a group pf metagenomes, 
these objects can be manually constructed using the basic data structures available in R or can
be created by importing the output of other programs, such as QUIIME.

Since we imported our data to basic R data types, we will build our phyloseq object manually.

~~~
# Get OTU IDs from both lists
names1 = OTUS$OTU
names2 = TAXAS$OTU

# Remove OTU IDs from both lists
OTUS$OTU = NULL
TAXAS$OTU = NULL
~~~
{: .language-r}

~~~
# Convert both lists to matrix
abundances = as.matrix(OTUS)
lineages = as.matrix(TAXAS)

# Assign the OTU IDs as the names of the rows of the matrixes you just built
row.names(abundances) = names1
row.names(lineages) = names2
~~~
{: .language-r}

All that we've done so far is transforming the taxonomic lineage table 
and the OTU abundance table into a format that can be read by phyloseq.
Now we will make the phyloseq data types out of our tables.

~~~
OTU = otu_table(abundances, taxa_are_rows = TRUE)
TAX = tax_table(lineages)
~~~
{: .language-r}

We will now construct a phyloseq object using phyloseq data types: 

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

### Plot diversity estimates at desired taxonomic resolution

We want to know how is bacterial diversity yhen, we will prune all of the non-bacterial organisms in our metagenome. To do this 
we will make a subset of all bacterial groups and save them
~~~
Bacteria <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

We will also filter out the taxonomic groups that have less than 10 reads assigned to them.

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



> ## Exercise: build a phyloseq object by yourself
> 
> Import the `JP4D metagenome` and plot its α diversity
> 
>> ## Solution
>> 
>> Repeat the previous instructions replacing JC1A for JP4D whenever it's appropiate
>> at the end, you should have the phyloseq object 'metagenome_JP4D'. 
>> 
> {: .solution}
{: .challenge}  



> ## Exercise
> 
> Use the help from plot_richness to discover other ways to plot diversity estimates using phyloseq
> 
>> ## Solution
>> 
>> '?plot_richness' or help("plot_richness")
>> 
>> Go to the Examples in the help panel and run plot_richness using soulrep and GlobalPatterns datasets
>> 
>> 
> {: .solution}
{: .challenge}  
  
  
### Merge two metagenomes to compare them  

Now that you have both phyloseq objects, one for each metagenome, you can merge them into one object:

~~~
merged_metagenomes = merge_phyloseq(metagenome_JC1A, metagenome_JP4D)
~~~
{: .language-r}


Let´s look at the phylum abundance of our metagenomes.  
Since our metagenomes have different sizes it might be a good idea to convert the number of assigned read into percentages (i.e. relative abundances). 

~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
~~~
{: .language-r}

Now, we can make a comparative graph between absolute reads and percentages.

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
                             
  
> ## `.discussion`
>
> How much did the α diversity change due to the filterings that we made?
{: .discussion}
  
  
                             
{% include links.md %}

