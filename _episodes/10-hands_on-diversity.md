---
source: md
title: "Diversity Analysis"
teaching: 30
exercises: 20
questions:
- "How can I merge sample-specific data into a phyloseq object?"
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
## Assemble and manipulate a phyloseq object with a myriad of samples
*Before your fingers touch the keys, it must be decided in your mind why you are doing 
this for, exploring is welcome and praised...not moving at all or senseless movement 
will draw you somewhere far from your goal*

  -Sergio Cuellar

In the last lesson we created two phyloseq objects, each containing the information
of one of our samples: "metagenome_JC1A" and "metagenome_JP4D". But useful 

### Merge two metagenomes to compare them  

Next, as we have both Phyloseq objects, one for each metagenome, you can merge
them into one object:

~~~
$ merged_metagenomes = merge_phyloseq(metagenome_JC1A, metagenome_JP4D)
~~~
{: .language-r}


Let´s look at the abundance of our metagenomes.  

~~~
$ merged_metagenomes
$ sample_sums(merged_metagenomes)
$ summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}

Moreover, we can made plots with the diversity indexes evaluated before, but with our
entire database:

~~~
$ p = plot_richness(merged_metagenomes, measures = c("Observed", "Chao1", "Shannon")) 
$ p + geom_point(size=5, alpha=0.7)
~~~

![image](https://user-images.githubusercontent.com/67386612/112223149-23dc0b00-8bef-11eb-8651-677a5713a5bb.png)
Figure 1. Alpha diversity indexes for each of our samples

It is evident that there is a great difference in the total reads(i.e. information) of each sample.
Before we further process our data, let's take a look if we have any no-identified read. Marked as "NA"
on the different taxonomic levels:

~~~
$ summary(merged_metagenomes@tax_table@.Data== "NA")
~~~
{: .language-r}

By the above command, we can see that there are NAs on the different taxonomic leves. Although it is
expected to see some NAs at species, or even at genus level, we will get rid of the ones at phylum
level to procced with the analysis:

~~~
$ merged_metagenomes <- subset_taxa(merged_metagenomes, phylum != "NA")
~~~
{: .language-r}


Next, since our metagenomes have different sizes it is imperative to convert the number 
of assigned read into percentages (i.e. relative abundances) so as to compare them. 

~~~
$ percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
~~~
{: .language-r}

In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function "tax_grom". Also, the function "psmelt" lets melt phyloseq 
objects into data.frame to manipulate them with ggplot and other libraries as vegan

~~~
$ glom <- tax_glom(percentages, taxrank = 'phylum')
$ data <- psmelt(glom)
~~~

With the new data.frame, we can change the identification of the OTUs whose 
relative abundance is less than 0.2% so as to have a number of recommended OTUs
to contrast them in different colors (8-9)

~~~
$ data$phylum <- as.character(data$phylum)
$ data$phylum[data$Abundance < 0.2] <- "Phyla < 0.2% abund."
~~~

Whit this object, we can create a plot which let us compare this relative abundance
against the absolute abundance that we have at the beggining

~~~
$ percentages <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=phylum))+ 
    geom_bar(aes(), stat="identity", position="stack")
  
$ glom <- tax_glom(merged_metagenomes, taxrank = 'phylum')
$ data <- psmelt(glom)
$ data$phylum <- as.character(data$phylum)
$ absolute_count <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=phylum))+ 
    geom_bar(aes(), stat="identity", position="stack")
  
$ absolute_count | percentages
~~~
![image](https://user-images.githubusercontent.com/67386612/112223252-4706ba80-8bef-11eb-8f09-08d95191dcc1.png)
Figure 2. Diversity at phylum level (i) with absolute abundances and (ii) relative abundance.


At once, we can denote the difference between the two plots and how the 
presentation of the data can be enhanced by conscient management of the 
different objects.

## Going further, lets took an interest lineage and explore it thoroughly

As we have already reviewed, phyloseq offers a lot of tools to manage  
and explore data. Lets take a look deeply to a tool that we already
use, but into a guided exploration. The "subset_taxa" command is used to
extract specific lineages from a stated taxonomic level, we have used it
to get rid from the reads that does not belong to bacteria at superkindom
level:

~~~
$ metagenome_JC1A <- subset_taxa(metagenome_JC1A, superkingdom == "Bacteria")
~~~

We are going to used this command to extract an specific phylum from our 
data, and explore it at a more lower taxonomic lever: Genus

~~~
$ cyanos <- subset_taxa(merged_metagenomes, phylum == "Cyanobacteria")
$ cyanos <- subset_taxa(cyanos, genus != "NA")
$ cyanos  = transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
$ glom <- tax_glom(cyanos, taxrank = "genus")
$ data <- psmelt(glom)
$ cyanos <- ggplot(data=data, aes(x=Sample, y=Abundance, fill=genus))+ 
    geom_bar(aes(), stat="identity", position="stack")
~~~
![image](https://user-images.githubusercontent.com/67386612/112223345-67cf1000-8bef-11eb-9bdc-4fe239bca9b2.png)
Figure 3. Diversity of Cyanobacteria at genus level inside our samples.

> ## Exercise
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the code learned to generate a plot where you can 
> show us the abundance in each of the sample
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
$ kraken-biom -h                  
~~~
{: .bash}

By a close look at the first output lines, it is noticeable that we need a specific output
from Kraken, those are the `kraken.report`. If you explore the different files inside 
the folder where we are located, you will see that the reports for each sample are 
inside.
~~~
$ kraken-biom JC1A.report JP4D.report --fmt json -o cuatroc.biom
~~~
{: .bash}

If we inspect our folder, we will see that the object "cuatroc.biom" is now part of 
our folder, this is a biom object which contains both, the abundances of each OTU and 
the identificator of each OTU. With this object we will procced to create the phyloseq 
object.

~~~
$ merged_metagenomes <- import_biom("cuatroc.biom")
~~~
{: .language-r}

Now, we can inspect the result by asking what class is the object created, and 
doing a close inspection of some of its content:
~~~
$ class(merged_metagenomes)
$ View(merged_metagenomes@tax_table@.Data)
~~~
The "class" command indicate that we already have our phyloseq object and 
inside the tax_table we see that it looks just like the one created before.
Lets get rid of some of the innecesary characters in the OTUs identificator
and put name to the taxonomic ranks:
~~~
$ merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
$ colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
~~~

Finally, we can review our object and see that both datasets 
(i.e. JC1A and JP4D) are in the our object.
