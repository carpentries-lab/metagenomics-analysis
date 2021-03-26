---
source: md
title: "Knowing how to navigate in R "
teaching: 40
exercises: 10
questions:
- "What is R and why is important to be learned?"
- "How do I use R tools to manage an R object?"
- "How can I use R to explore diversity?"
objectives:
- "Undestand why R is important"
- "Comprehend which libraries are required for metagenomes diversity analysis."  
- "Grasp how a phyloseq object is made"
- "Use the help command to get more insight on R functions."
- "Undestand the needed commands to create a phyloseq object for analysis"
keypoints:
- "The library `phyloseq` manages metagenomics objects and computes alpha diversity."  
- "Transform your named matrixes into Phyloseq objects using `pyhloseq(TAX, OTU)`."
- "Use `help()` to discover the capabilities of libraries."
- "The library `ggplot2` allow publication-quality plotting in R."
---
## First steps into R 
*It takes courage to sail in uncharted waters*
  -Snoopy
  
### What is R and for what can it be use for?

"R" is used to refer to the programming language and the software that reads and 
interpets what is it on the scripst. RStudio is the most popular program to write
scripts and interact with the R software.

R use a series of written commands and that is great! When you rely in clicking 
and pointing, and in remembering where and why to point here or click that, mistakes
are prone to occur. Moreover, if you manage to get more data, it is easier to just
re-run your script to obtain results. Also, working with scripts makes the steps 
you follow for your analysis clear and shareable. Here are some of the advantages
for working with R:
- R code is reproducible
- R produce high-quality graphics
- R has a large community
- R is interdisciplinary 
- R works on data of all colors and sizes
- R is free!

### A nautical chart of RStudio

RStudio is an Integrated Development Environment(IDE) which we will use to write code,
navigate the files from our computer/cloud, try code, inspect the variables we are 
going to create, and visualize our contribed plots.

![image](https://user-images.githubusercontent.com/67386612/112203976-c046e300-8bd8-11eb-9ee6-72c95f9134f3.png)
Figure 1. RStudio interface screenshot. Clockwise from top left: Source, Environment/History, 
Files/Plots/Packages/Help/Viewer, Console.

You can enter your online RStudio to see your own environment. Let's copy your instance address into your browser
(Chrome or Firefox) and login into R studio.  
The address should look like:  `http://ec2-3-235-238-92.compute-1.amazonaws.com:8787/`  
Your credencials are **user**:dcuser **pass**:data4Carp.  

Although data are already stored in your instance, in case you need it you can donwload it [here](https://drive.google.com/file/d/15dW1sQCIhtmCUvS0IUOMPBH5m1gqNB0m/view?usp=sharing).

### Review of the set-up

As we have revisited throughout the lesson, maintaining related data, analyses in a single folder
is desireable. In R, this folder is called **Working directory**. Here is where R will be looking 
for and saving the files. If you need to check where your working directory is located use `getwd()`.
If your working directory is not what you expected, always can be changed by clicking on the blue 
gear icon and pick the option "Set As Working Directory". Alternatively, you can use the `setwd()`
command for changing it.

Let's use this commands to set or working directiry where we have stored our files from the previos 
lessons:

~~~
$ setwd("~/dc_workshop/results/")
~~~
{: .language-r}

### Having a dialogue with R

There are two main paths to interact with R:(i) by using the console or (ii)by using script files.
The console is where commands can be typed and executed immediately by the software and where the 
results from executed commands will be shown. If R is ready to accept commands, the R console shows
a > prompt. You can type instructions directly into the console and press "Enter", but they will 
be forgotten when you close the session.

For example, let's do some math and save it in R objects:
~~~ 
$ 4+3
$ suma <- 4+3
$ resta <- 2+1
$ total <- suma -resta
$ total
~~~

What would happend if you tap `ctrl` + `l`. Without the lesson page, could you remember of which 
sum of numbers is `suma` made?. Reproducibility is in our minds when we program. For this purpose, 
is convenient to type the commands we want in the script editor, and save the script periodically. 
We can run our code lines in the script by the shortcut `ctrl` + `Enter` 
(on Macs, `Cmd` + `Return` will work). Thus, the command on the current line, or the instructions
in the currently selected text will be sent to the console and will be executed.

### Seeking help

If you face some trouble with some function, let's say `summary()`, you can always type `?summary()`
and a help page will be displayed with useful information for the function use. Furthermore, if you
already know what you want to do, but you do not know which function to use, you can type `??` 
following your inquiry, for example `??barplot` will open a help files in the RStudio's help
panel in the lower right corner.


### Exploring metagenome data with the terminal  
  
In this lesson we will use R studio to analize two microbiome samples from CCB, you don't have to install anything, 
you already have an instance on the cloud ready to be used.   

The terminal is a program that executes programs, and is better to deal with long data sets than a visual interface.  
First to visualize the content of our directory you can use the `ls` command.  

~~~
$ ls
~~~~

Now you can also known in which directory you are standing in the reminal,by using `pwd`. 

Let's explore the content of some of our data files. So we have to move to the corresponding folder where our taxonomic-data files are: 

~~~
$ cd /home/dcuser/dc_workshop/results
~~~~
{: .bash}

Files `.kraken` and `kraken.report`are the output of the Kraken program, we can see a few lines of the file `.kraken` using the command `head`.   

~~~
$ head JC1A.kraken 
~~~
{: .bash}

How would you see the last lines of the file report?  

~~~
$ tail JC1A.report 
~~~
{: .bash}
  


##  Manipulating lineage and rank tables in phyloseq  

  
### Load required packages  

Phyloseq is a library with tools to analyze and plot your metagenomics tables. Let's install [phyloseq](https://joey711.github.io/phyloseq/) (This instruction might not work on certain versions of R) and other libraries required for its execution:  

~~~
$ if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

$ BiocManager::install("phyloseq") # Install phyloseq

$ install.packages(c("ggplot2", "readr", "patchwork")) #install ggplot2 and patchwork to   chart publication-quality plots. readr to read rectangular datasets.
~~~
{: .language-r}  

Once the libraries are installed, we must make them available for this R session. Now load the libraries (a process needed every time we began a new work 
in R and we are going to use phyloseq):

~~~
$ library("phyloseq")
$ library("ggplot2")
$ library("readr")
$ library("patchwork")
~~~
{: .language-r}

  
### Load data with the number of reads per OTU and taxonomic labels for each OTU.  

Next, we have to load the taxonomic assignation data into objets in R:

~~~
$ OTUS <- read_delim("JC1A.kraken_ranked-wc","\t", escape_double = FALSE, trim_ws = TRUE)
$ TAXAS <- read_delim("JC1A.lineage_table-wc", "\t", escape_double = FALSE, 
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
$ names1 <- OTUS$OTU
$ names2 <- TAXAS$OTU

# Remove OTU IDs from both lists
$ OTUS$OTU <- NULL
$ TAXAS$OTU <- NULL
~~~
{: .language-r}

~~~
# Convert both lists to matrix
$ abundances <- as.matrix(OTUS)
$ lineages <- as.matrix(TAXAS)

# Assign the OTU IDs as the names of the rows of the matrixes you just built
$ row.names(abundances) <- names1
$ row.names(lineages) <- names2
~~~
{: .language-r}

All that we've done so far is transforming the taxonomic lineage table 
and the OTU abundance table into a format that can be read by phyloseq.
Now we will make the phyloseq data types out of our matrices.

~~~
$ OTU <- otu_table(abundances, taxa_are_rows = TRUE)
$ TAX <- tax_table(lineages)
~~~
{: .language-r}

We will now construct a Phyloseq-object using Phyloseq data types we have created: 

~~~
$ metagenome_JC1A <- phyloseq(OTU, TAX)
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
$ metagenome_JC1A <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

Now let's look at some statistics of our metagenomes:

~~~
$ metagenome_JC1A
$ sample_sums(metagenome_JC1A)
$ summary(metagenome_JC1A@otu_table@.Data)
~~~
{: .language-r}

By the output of the sample_sums command we can see how many reads they are
in the library. Also, the Max, Min and Mean outout on summary can give us an
idea of the eveness. Nevertheless, to have a more visual representation of the
diversity inside the sample (i.e. α diversity) we can now look at a ggplot2
graph created using Phyloseq:

~~~
$ p = plot_richness(metagenome_JC1A, measures = c("Observed", "Chao1", "Shannon")) 
$ p + geom_point(size=5, alpha=0.7)  
~~~
{: .language-r}

![image](https://user-images.githubusercontent.com/67386612/112221050-95ff2080-8bec-11eb-9fd0-b602d6f153ae.png)
Figure 2. Alpha diversity indexes for JC1A sample

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
>> `?plot_richness` or `help("plot_richness")`
>> 
>>One of the widely α diversity indexes used is Simpson diversity index, as an example
>>of solution, here it is the plot with an extra metric, which is Simpson α index:  
>> `p = plot_richness(metagenome_JC1A, measures = c("Observed", "Chao1", "Shannon", "Simpson"))`
>> ![image](https://user-images.githubusercontent.com/67386612/112221137-b62edf80-8bec-11eb-85aa-dd5be3e8ca16.png)
>>
>> 
> {: .solution}
{: .challenge}  
  
  

  
> ## `.discussion`
>
> How much did the α diversity can be changed by elimination of singletons
> and doubletons?
{: .discussion}
  
  
                             
{% include links.md %}

