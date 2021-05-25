---
source: md
title: "Diversity Analysis"
teaching: 30
exercises: 20
questions:
- "How can we compare depth-contrasting samples?"
- "Which alternatives do we have to import taxonomic-assignation data in R?"
objectives:
- "Comprehend which libraries are required for metagenomes diversity analysis."  
- "Grasp how a phyloseq object is made"
- "Understand how the help command can help to discover the capabilities of libraries."
- "Apply the learned code to get diversity estimates."
- "Use the diversity data to visualize different estimates of α diversity."
keypoints:
- "The library `phyloseq` lets you manipulate metagenomic data in a taxonomic specific perspective."  
- "The library `ggplot2` creates plots that helps/remarks the data analysis"
- "The kraken-biom program can automatize the creation of the phyloseq object"
---

# Assemble and manipulate a phyloseq object with a myriad of samples

*Before your fingers touch the keys, it must be decided in your mind why you are doing it...explore 
is welcome and praised, not moving at all or senseless movement will draw you somewhere far from your 
goal*

  -Sergio Cuellar

## Visualizing our data with ggplot2
In the last lesson, we created our phyloseq object, which containing the information 
of both of our samples: `JC1A` and `metagenome_JP4D`. Let´s take a look again at the
 number of reads in our data.  
~~~
merged_metagenomes
sample_sums(merged_metagenomes)
~~~
{: .language-r}
~~~
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 2738 taxa and 2 samples ]
tax_table()   Taxonomy Table:    [ 2738 taxa by 7 taxonomic ranks ]

 JC1A  JP4D 
  920 22530 
~~~
{: .output}
~~~
summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}
~~~
      JC1A             JP4D        
 Min.   : 0.000   Min.   :  0.000  
 1st Qu.: 0.000   1st Qu.:  1.000  
 Median : 0.000   Median :  2.000  
 Mean   : 0.336   Mean   :  8.229  
 3rd Qu.: 0.000   3rd Qu.:  5.000  
 Max.   :24.000   Max.   :945.000
~~~
{: .output}

It is useful to see numbers, but there are other ways to deliver information and how there are 
relationships between variables. 
R has its own [base plotting system](https://www.statmethods.net/graphs/index.html), but we have already 
loaded a package that will help us to create artistically-proclived figures: [ggplot](https://www.statmethods.net/advgraphs/ggplot2.html)
ggplot2 has been created with the idea that any graphic can be expressed by three components:
* Data set
* Coordinates
* Set of **geoms**, that is the visual representation of the data 
This **geoms** can be thinked as layers that can be overlapped one over another, so special attention 
need to be required to show useful information-layers to deliver a messagge. We are going to create an 
example with some of the data that we already have. Let's create a data-frame with the next code:
~~~
deept <- data.frame(Samples = sample_names(merged_metagenomes),
                    Reads = sample_sums(merged_metagenomes))
deept
~~~
{: .language-r}

~~~
     Samples Reads
JC1A    JC1A   920
JP4D    JP4D 22530
~~~
{: .output}

Now, we can do a figure with the three components mentioned(data, coordinates, and geom):
~~~
ggplot(data = deept, mapping = aes(x = Samples,y = Reads)) +
  geom_col()
~~~
{: .language-r}
![image](https://user-images.githubusercontent.com/67386612/119435571-fe977600-bcdf-11eb-8d88-ca8753e72825.png)
###### Figure 1. Sample read as bars in a plot

It is evident that there is a great difference in the total reads(i.e. information) of each sample.
Before we further process our data, take a look if we have any no-identified read. Marked as "NA"
on the different taxonomic levels:

~~~
summary(merged_metagenomes@tax_table@.Data== "NA")
~~~
{: .language-r}

By the above command, we can see that there are NAs on different taxonomic leves. Although it is
expected to see some NAs at the species, or even at the genus level, we will get rid of the ones at 
the phylum level to proceed with the analysis:

~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, phylum != "NA")
~~~
{: .language-r}


Next, since our metagenomes have different sizes, it is imperative to convert the number 
of assigned read into percentages (i.e. relative abundances) so as to compare them. 

~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
~~~
{: .language-r}

In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function `tax_grom`. Also, the function `psmelt` melt phyloseq 
objects into a `data.frame` to manipulate them with packages like `ggplot` and `vegan`.

~~~
glom <- tax_glom(percentages, taxrank = 'phylum')
data <- psmelt(glom)
~~~
{: .language-r}

With the new `data.frame`, we can change the identification of the OTUs whose 
relative abundance is less than 0.2%, so as to have a number of OTUs that not 
surpass the recommended ones (8-9). 8 to 9 contrasting colors are the most that 
the human eye can distinguish in terms of color in a plot.

~~~
data$phylum <- as.character(data$phylum)
data$phylum[data$Abundance < 0.2] <- "Phyla < 0.2% abund."
~~~
{: .language-r}

Whit this object, we can create a plot to compare the obtained relative abundance
against the absolute abundance.

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
{: .language-r}

![image](https://user-images.githubusercontent.com/67386612/112223252-4706ba80-8bef-11eb-8f09-08d95191dcc1.png)
Figure 2. Diversity at phylum level (i) with absolute abundances and (ii) relative abundance.


At once, we can denote the difference between the two plots and how  
processing the data can enhance the display of important results.

## Going further, lets took an interest lineage and explore it thoroughly

As we have already reviewed, phyloseq offers a lot of tools to manage  
and explore data. Lets take a look deeply to a tool that we already
use, but now with a guided exploration. The `subset_taxa` command is used to
extract specific lineages from a stated taxonomic level, we have used it
in the past lesson to get rid from the reads that does not belong to bacteria:

~~~
metagenome_JC1A <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~
{: .language-r}

We are going to it now to extract an specific phylum from our 
data, and explore it at a more lower taxonomic lever: Genus

~~~
cyanos <- subset_taxa(merged_metagenomes, phylum == "Cyanobacteria")
cyanos <- subset_taxa(cyanos, genus != "NA")
cyanos  = transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
glom <- tax_glom(cyanos, taxrank = "genus")
data <- psmelt(glom)
cyanos <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=genus))+ 
    geom_bar(aes(), stat="identity", position="stack")
~~~
{: .language-r} 

![image](https://user-images.githubusercontent.com/67386612/112223345-67cf1000-8bef-11eb-9bdc-4fe239bca9b2.png)
Figure 3. Diversity of Cyanobacteria at genus level inside our samples.

> ## Exercise 1  
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the code learned to generate a plot where you can 
> show us the abundance in each of the sample
> Please, paste your result on the next document, there you can find 
> the Breakout room where you need to be working with, good luck:
> https://docs.google.com/document/d/1oFg3uUZUANf7S1Mh2KamzrcGhkKsXP5Mk1KxKv6k8wA/edit?usp=sharing 
>> ## Solution
>> Change "Cyanobacteria" wherever it is needed to get a result from
>> other phylum, as an example, here is the solution for Proteobacteria:
>>proteo <- subset_taxa(merged_metagenomes, phylum == "Proteobacteria")
>>proteo <- subset_taxa(proteo, genus != "NA")
>>proteo  = transform_sample_counts(proteo, function(x) x*100 / sum(x) )
>>glom <- tax_glom(proteo, taxrank = "genus")
>>data <- psmelt(glom)
>>proteo <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=genus))+ 
>>  geom_bar(aes(), stat="identity", position="stack")
> {: .solution}
{: .challenge} 
                             

## kraken-biom as an alternative to create a phyloseq object

In the above lines, we explored how to create a phyloseq object using basic R functions.
Certainly, this is a method that helps to practice and master the manipulation of 
different types of objects and information. But we can obtain the same result by using
programs that will extract the information from the kraken output files and will help
us to save time. One program widely used for this purpose is kraken-biom.

kraken-biom is a program that creates BIOM tables from the Kraken output 
[kraken-biom](https://github.com/smdabdoub/kraken-biom)


### Using the kraken.report files with kraken-biom

For the next few steps, lets return to the terminal since kraken-biom is ment to be
used there. Lets take a look at the different flags that kraken-biom have:

~~~
$ kraken-biom -h                  
~~~
{: .bash}

By a close look at the first output lines, it is noticeable that we need a specific output
from Kraken: `kraken.report`s. If you explore the different files inside 
the folder where we are located, you will see that the reports for each sample are 
inside.

With the next command, we are going to create a table in Biom format called `cuatroc.biom`:

~~~
$ kraken-biom JC1A.report JP4D.report --fmt json -o cuatroc.biom
~~~
{: .bash}

If we inspect our folder, we will see that the object "cuatroc.biom" is now part of 
our files, this is a biom object which contains both, the abundances of each OTU and 
the identificator of each OTU. With this file we will procced to create the phyloseq 
object by the `import_biom` command:

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
{: .language-r}

The "class" command indicate that we already have our phyloseq object. Also, 
inside the tax_table we see that it looks just like the one created in the
last episode of the lesson. Let's get rid of some of the innecesary characters 
in the OTUs identificator and put name to the taxonomic ranks:

~~~
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
~~~
{: .language-r}

Finally, we can review our object and see that both datasets 
(i.e. JC1A and JP4D) are in the our object.
