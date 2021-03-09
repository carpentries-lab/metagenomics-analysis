---
source: md
title: "Diversity Analysis"
teaching: 30
exercises: 30
questions:
- "How can I use R to explore diversity?"
objectives:
- "Visualize different estimates of α diversity."
- "Load libraries required for metagenomes alpha diversity plotting."  
- "Transform named matrixes into Phyloseq objects."
- "Use help to discover the capabilities of libraries."
- "Chart diversity estimates."
keypoints:
- "The library `phyloseq` manages metagenomics objects and computes alpha diversity."  
- "The libraries `ggplot2` and `patchwork`allow publication-quality plotting in R."
- "Transform your named matrixes into Phyloseq objects using `pyhloseq(TAX, OTU)`."
- "Use `help()` to discover the capabilities of libraries."
---
    
## Using R studio
In this lesson we will use R studio to analize two microbiome samples from 4C, you don't have to install anything, you already have an instance on the cloud ready to be used. 

1. Click on this [shared google sheet](https://docs.google.com/spreadsheets/d/1w78TuQUdtI2Fgk4DFG26YYkXTkUg2vTjVLaRH-D_7xk/edit?usp=sharing) and in the first column write without spaces your name and lastname. Check that you do not overwrite other participant's names. 

2. Now copy your instance address into your browser (Chrome or Firefox) and login into R studio.  
The address should look like:  `http://ec2-3-235-238-92.compute-1.amazonaws.com:8787/`  
Your credencials are user:dcuser pass:data4Carp.  

3. Data are already stored at your instance, but in case you lose your data you can donwload it [here](https://drive.google.com/file/d/15dW1sQCIhtmCUvS0IUOMPBH5m1gqNB0m/view?usp=sharing).

## Exploring metagenome data with the terminal  
  
The terminal is a program that executes programs, and is better to deal with long data sets than a visual interface.  
First to visualize the content of our directory you can use the `ls` command.  
`ls`  

Now you can also known in which directory you are standing by using `pwd`. 

Let's explore the content of some of our data files.  
Files `.kraken` are the output of the Kraken program, we can see a few lines of the file using the command `head`.   
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

  
### Load data with the number of reads per OTU and taxonomic labels for each OTU.  

Now, we have to load the taxonomic assignation data into objets in R:

~~~
OTUS <- read_delim("JC1A.kraken_ranked-wc","\t", escape_double = FALSE, trim_ws = TRUE)
TAXAS <- read_delim("JC1A.lineage_table-wc", "\t", escape_double = FALSE, 
                    col_types = cols(subspecies = col_character(),  
                    subspecies_2 = col_character()), trim_ws = TRUE)

~~~
{: .language-r}


### Build Phyloseq object  

Phyloseq objects are a collection of information regarding a single or a group of metagenomes, 
these objects can be manually constructed using the basic data structures available in R or can
be created by importing the output of other programs, such as QUIIME and kraken-biom.

Since we imported our data to basic R data types, we will build our Phyloseq object manually
by extracting the OTU's names and abundances.

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
Now we will make the phyloseq data types out of our matrices.

~~~
OTU = otu_table(abundances, taxa_are_rows = TRUE)
TAX = tax_table(lineages)
~~~
{: .language-r}

We will now construct a Phyloseq object using Phyloseq data types: 

~~~
metagenome_JC1A = phyloseq(OTU, TAX)
~~~
{: .language-r}

> ## `.callout`
>
>If you look at our Phyloseq object, you will see that there are more data types 
>that we can use to build our object(?phyloseq), as a phylogenetic tree and metadata 
>concerning our samples. These are optional, so we will use our basic
>phyloseq object for now.  
{: .callout}

## Creating a phyloseq object by kraken-biom

In the above lines we explored how to create a phyloseq object using basic R functions.
Certainly, this is a method that helps to practize and masterize the manipulation of 
different type of objects and information. But we can obtain the same result by using
programs that will extract the information from the kraken output files and will
save us time. One of this options is kraken-biom.

kraken-biom is a programm that creates BIOM tables from the Kraken output 
[kraken-biom](https://github.com/smdabdoub/kraken-biom)

First, let's take a look at the different flags that kraken-biom have and an example
of its usage:

~~~
usage: kraken-biom [-h] [--max {D,P,C,O,F,G,S}] [--min {D,P,C,O,F,G,S}]
                      [-o OUTPUT_FP] [--fmt {hdf5,json,tsv}] [--gzip]
                      [--version] [-v]
                      kraken_reports [kraken_reports ...]                   
~~~
{: .bash}

By a close look at the code lines, it is noticeable that we need a specific output
from Kraken, those are the kraken.reports. 



~~~
kraken-biom S1.txt S2.txt --fmt json
~~~
{: .bash}

### Plot diversity estimates at desired taxonomic resolution

We want to know how is the bacterial diversity, so, we will prune all of the non-bacterial organisms in our metagenome. To do this 
we will make a subset of all bacterial groups and save them.
~~~
metagenome_JC1A <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

Now let's look at some statistics of our metagenomes:

~~~
summary(metagenome_JC1A@otu_table@.Data)
~~~
{: .language-r}

The Max, Min and Mean can give us an idea of the eveness, but to have a more 
visual representation of the α diversity we can now look at a ggplot2
graph created using Phyloseq:

~~~
p = plot_richness(metagenome_JC1A, measures = c("Observed", "Chao1", "Shannon")) 
p + geom_point(size=5, alpha=0.7)  
~~~
{: .language-r}

Each of these metrics can give insight of the distribution of the OTUs inside 
our samples. For example. Chao1 diversity index gives more weight to singletons
and doubletons observed in our samples. While Shannon is a entrophy index 
remarking the impossiblity of taking two reads out of the metagenome "bag" 
and that these two will belong to the same OTU.

> ## Exercise: build a Phyloseq object by yourself
> 
> Import the `JP4D metagenome` and plot its α diversity with the mentioned metrics.
> 
>> ## Solution
>> 
>> Repeat the previous instructions replacing JC1A for JP4D whenever it's appropiate:
>>
>>  At the end, you should have the Phyloseq object 'metagenome_JP4D'. 
>> 
> {: .solution}
{: .challenge}  



> ## Exercise
> 
> Use the help from plot_richness to discover other ways to plot diversity estimates using Phyloseq
> and use another index to show the α diversity in our samples.
> 
>> ## Solution
>> 
>> '?plot_richness' or help("plot_richness")
>> 
>>One of the widely α diversity indexes used is Simpson diversity index, as an example
>>of solution, here it is the plot with an extra metric, which is Simpson α index:
>> p = plot_richness(metagenome_JC1A, measures = c("Observed", "Chao1", "Shannon", "Simpson")) 
>> 
>> 
> {: .solution}
{: .challenge}  
  
  
### Merge two metagenomes to compare them  

Now that you have both Phyloseq objects, one for each metagenome, you can merge them into one object:

~~~
merged_metagenomes = merge_phyloseq(metagenome_JC1A, metagenome_JP4D)
~~~
{: .language-r}


Let´s look at the abundance of our metagenomes.  

~~~
summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}

Now, it is evident that there is a great difference in the total reads(i.e. information) of each sample.
Before we further process our data, let's take a look if we have any no-identified read. Marked as "NA"
on the different taxonomic levels:

~~~
summary(merged_metagenomes@tax_table@.Data== "NA")
~~~
{: .language-r}

By the above line, we can see that there are NA on the different taxonomic leves. Although it is
expected to see some NAs at species, or even at genus level, we will get rid of the ones at phylum
lever to procced with the analysis:

~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, phylum != "NA")
~~~
{: .language-r}


Next, since our metagenomes have different sizes it might be a good idea to convert the number of assigned read into percentages (i.e. relative abundances). 

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
> How much did the α diversity changed due to the filterings that we made?
{: .discussion}
  
  
                             
{% include links.md %}

