---
source: md
title: "Diversity Analysis"
teaching: 40
exercises: 20
questions:
- "How can I use R to explore diversity?"
- "Which alternatives do we have to import taxonomic-assignation data in R?"
- "How can we compare depth-contrasting samples?"
objectives:
- "Comprehend which libraries are required for metagenomes diversity analysis."  
- "Grasp how a phyloseq object is made"
- "Understand how the help command can help to discover the capabilities of libraries."
- "Apply the learned code to get diversity estimates."
- "Use the diversity data to visualize different estimates of α diversity."
keypoints:
- "The library `phyloseq` manages metagenomics objects and computes alpha diversity."  
- "Transform your named matrixes into Phyloseq objects using `pyhloseq(TAX, OTU)`."
- "Use `help()` to discover the capabilities of libraries."
- "The libraries `ggplot2` and `patchwork`allow publication-quality plotting in R."
- "The kraken-biom program can automatize the creation of the phyloseq object"
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

Let's explore the content of some of our data files. So we have to move to the corresponding folder where our taxonomic-data files are: 

~~~
cd /home/dcuser/dc_workshop/taxonomy
~~~~
{: .bash}

Files `.kraken` and `kraken.report`are the output of the Kraken program, we can see a few lines of the file `.kraken` using the command `head`.   

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

Next, we have to load the taxonomic assignation data into objets in R:

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
names1 <- OTUS$OTU
names2 <- TAXAS$OTU

# Remove OTU IDs from both lists
OTUS$OTU <- NULL
TAXAS$OTU <- NULL
~~~
{: .language-r}

~~~
# Convert both lists to matrix
abundances <- as.matrix(OTUS)
lineages <- as.matrix(TAXAS)

# Assign the OTU IDs as the names of the rows of the matrixes you just built
row.names(abundances) <- names1
row.names(lineages) <- names2
~~~
{: .language-r}

All that we've done so far is transforming the taxonomic lineage table 
and the OTU abundance table into a format that can be read by phyloseq.
Now we will make the phyloseq data types out of our matrices.

~~~
OTU <- otu_table(abundances, taxa_are_rows = TRUE)
TAX <- tax_table(lineages)
~~~
{: .language-r}

We will now construct a Phyloseq-object using Phyloseq data types we have created: 

~~~
metagenome_JC1A <- phyloseq(OTU, TAX)
~~~
{: .language-r}

> ## `.callout`
>
>If you look at our Phyloseq object, you will see that there are more data types 
>that we can use to build our object(?phyloseq), as a phylogenetic tree and metadata 
>concerning our samples. These are optional, so we will use our basic
>phyloseq object for now composed of the abundances of specific OTUs and the 
>names of those OTUs.  
{: .callout}


### Plot diversity estimates at desired taxonomic resolution

We want to know how is the bacterial diversity, so, we will prune all of the 
non-bacterial organisms in our metagenome. To do this we will make a subset 
of all bacterial groups and save them.
~~~
metagenome_JC1A <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

Now let's look at some statistics of our metagenomes:

~~~
metagenome_JC1A
sample_sums(metagenome_JC1A)
summary(metagenome_JC1A@otu_table@.Data)
~~~
{: .language-r}

By the output of the sample_sums command we can see how many reads they are
in the library. Also, the Max, Min and Mean outout on summary can give us an
idea of the eveness. Nevertheless, to have a more visual representation of the
diversity inside the sample (i.e. α diversity) we can now look at a ggplot2
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

Next, as we have both Phyloseq objects, one for each metagenome, you can merge
them into one object:

~~~
merged_metagenomes = merge_phyloseq(metagenome_JC1A, metagenome_JP4D)
~~~
{: .language-r}


Let´s look at the abundance of our metagenomes.  

~~~
merged_metagenomes
sample_sums(merged_metagenomes)
summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}

It is evident that there is a great difference in the total reads(i.e. information) of each sample.
Before we further process our data, let's take a look if we have any no-identified read. Marked as "NA"
on the different taxonomic levels:

~~~
summary(merged_metagenomes@tax_table@.Data== "NA")
~~~
{: .language-r}

By the above command, we can see that there are NAs on the different taxonomic leves. Although it is
expected to see some NAs at species, or even at genus level, we will get rid of the ones at phylum
level to procced with the analysis:

~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, phylum != "NA")
~~~
{: .language-r}


Next, since our metagenomes have different sizes it is imperative to convert the number 
of assigned read into percentages (i.e. relative abundances) so as to compare them. 

~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
~~~
{: .language-r}

In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function "tax_grom". Also, the function "psmelt" lets melt phyloseq 
objects into data.frame to manipulate them with ggplot and other libraries as vegan

~~~
glom <- tax_glom(percentages, taxrank = 'phylum')
data <- psmelt(glom)
~~~

With the new data.frame, we can change the identification of the OTUs whose 
relative abundance is less than 0.2% so as to have a number of recommended OTUs
to contrast them in different colors (8-9)

~~~
data$phylum <- as.character(data$phylum)
data$phylum[data$Abundance < 0.2] <- "Phyla < 0.2% abund."
~~~

Whit this object, we can create a plot which let us compare this relative abundance
against the absolute abundance that we have at the beggining

~~~
percentages <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
  
glom <- tax_glom(merged_metagenomes, taxrank = 'phylum')
data <- psmelt(glom)
data$phylum <- as.character(data$phylum)
absolute_count <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
  
absolute_count | percentages
~~~

At once, we can denote the difference between the two plots and how the 
presentation of the data can be enhanced by conscient management of the 
different objects.



> ## `.discussion`
> Have you ever heard of the rarefaction process?
> When you encounter depth.contrasting samples as these, What other 
> methods beyond rarefaction you could think/heard/tried of?   
{: .discussion}                             

## kraken-biom as an alternative to create a phyloseq object

In the above lines we explored how to create a phyloseq object using basic R functions.
Certainly, this is a method that helps to practize and masterize the manipulation of 
different type of objects and information. But we can obtain the same result by using
programs that will extract the information from the kraken output files and will help
us to save time. One program widely used for this purpose is kraken-biom.

kraken-biom is a program that creates BIOM tables from the Kraken output 
[kraken-biom](https://github.com/smdabdoub/kraken-biom)


### Using the kraken.report files with kraken-biom

For the next few steps, lets return to the terminal since kraken-biom is ment to be
used there. Lets take a look at the different flags that kraken-biom have:

~~~
kraken-biom -h                  
~~~
{: .bash}

By a close look at the first output lines, it is noticeable that we need a specific output
from Kraken, those are the `kraken.report`. If you explore the different files inside 
the folder where we are located, you will see that the reports for each sample are 
inside.
~~~
kraken-biom JC1A.report JP4D.report --fmt json -o cuatroc.biom
~~~
{: .bash}

If we inspect our folder, we will see that the object "cuatroc.biom" is now part of 
our folder, this is a biom object which contains both, the abundances of each OTU and 
the identificator of each OTU. With this object we will procced to create the phyloseq 
object.

~~~
merged_metagenomes <- import_biom("cuatroc.biom")
~~~
{: .language-r}

Now, we can inspect the result by asking what class is the object created, and 
doing a close inspection of some of its content:
~~~
class(merged_metagenomes)
View(merged_metagenomes@tax_table@.Data)
~~~
The "class" command indicate that we already have our phyloseq object and 
inside the tax_table we see that it looks just like the one created before.
Lets get rid of some of the innecesary characters in the OTUs identificator
and put name to the taxonomic ranks:
~~~
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
~~~

Finally, we can review our object and see that both datasets 
(i.e. JC1A and JP4D) are in the our object.
  
> ## `.discussion`
>
> How much did the α diversity can changed by elimination singletons
> and doubletons?
{: .discussion}
  
  
                             
{% include links.md %}

