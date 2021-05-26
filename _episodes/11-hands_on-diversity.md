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
In the last lesson, we created our phyloseq object, which contain the information 
of both of our samples: `JC1A` and `JP4D`. Let´s take a look again at the
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
loaded a package that will help us to create artistically-proclived figures:[ggplot2](https://www.statmethods.net/advgraphs/ggplot2.html).

ggplot2 has been created with the idea that any graphic can be expressed with three components:
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

Unraveling the above code. We first call the `ggplot` function(*i.e. ggplot()*). This will tell R that we want to 
create a new plot and  the parameters indicated inside this function will apply to all the layers of the plot. We 
gave two arguments to the `ggplot` code: (i) the data that we want to show in our figure (*i.e. data = deept*), 
that is the data inside deept, and (ii) we defined the `aes` function(*i.e. mapping = aes(x = Samples,y = Reads)*),
which will tell `ggplot` how the variables will be mapped in the figure. In in this case, **x** is the name of the 
samples and **y** the number of reads. It is noticiable that we did not need to express the entire path to access
to this columns to the `aes` function (*i.e.* x = deept[,"Samples"]), that is because the code is so well 
written to figure it out by itself. What happend if we only call `ggplot` without the any **geom**(*i.e.* `geom_col`):

![image](https://user-images.githubusercontent.com/67386612/119437234-4ff53480-bce3-11eb-8a0a-8c58e2079b23.png)
###### Figure 2. ggplot function result without a specified geom

We need to tell `ggplot` how we want to visually represent the data, which we did by adding a new geom layer. In this
example, we used `geom_col`, which tells `ggplot` we want to visually represent the relationship between **x** and
**y** as columns-bars:

![image](https://user-images.githubusercontent.com/67386612/119435571-fe977600-bcdf-11eb-8d88-ca8753e72825.png)
###### Figure 1. Sample read as bars in a plot

## Transformation and manipulation of data

By inspection on the above figure, it is evident that there is a great difference in the number of total 
reads(i.e. information) of each sample. Before we further process our data, take a look if we have any 
no-identified read. Marked as "NA" on the different taxonomic levels:

~~~
summary(merged_metagenomes@tax_table@.Data== "NA")
~~~
{: .language-r}
~~~
  Kingdom          Phylum          Class           Order           Family       
 Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical  
 FALSE:2738      FALSE:2736      FALSE:2647      FALSE:2696      FALSE:2636     
                 TRUE :2         TRUE :91        TRUE :42        TRUE :102      
   Genus          Species       
 Mode :logical   Mode :logical  
 FALSE:2601      FALSE:2428     
 TRUE :137       TRUE :310  
~~~
{: .output}

By the above command, we can see that there are NAs on different taxonomic leves. Although it is
expected to see some NAs at the species, or even at the genus level, we will get rid of the ones at 
the phylum level to proceed with the analysis:

~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, Phylum != "")
summary(merged_metagenomes@tax_table@.Data== "")
~~~
{: .language-r}
~~~
  Kingdom          Phylum          Class           Order           Family       
 Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical  
 FALSE:2736      FALSE:2736      FALSE:2647      FALSE:2696      FALSE:2636     
                                 TRUE :89        TRUE :40        TRUE :100      
   Genus          Species       
 Mode :logical   Mode :logical  
 FALSE:2600      FALSE:2426     
 TRUE :136       TRUE :310   
~~~
{: .output}


Next, since our metagenomes have different sizes, it is imperative to convert the number 
of assigned read into percentages (i.e. relative abundances) so as to compare them. 
~~~
head(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}
~~~
        JC1A JP4D
356       16  170
41294      1   23
374        4   68
114615     3    9
722472     2    9
2057741    2   16
~~~
{: .output}
~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
head(percentages@otu_table@.Data)
~~~
{: .language-r}
~~~
             JC1A       JP4D
356     1.7391304 0.75454949
41294   0.1086957 0.10208611
374     0.4347826 0.30181980
114615  0.3260870 0.03994674
722472  0.2173913 0.03994674
2057741 0.2173913 0.07101642
~~~
{: .output}

In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function `tax_grom`. 

~~~
glom <- tax_glom(percentages, taxrank = 'phylum')
View(glom@tax_table@.Data
~~~
![image](https://user-images.githubusercontent.com/67386612/119710874-7ff82100-be24-11eb-84ec-974e483572f5.png)
###### Figure 3. Taxonomic-data table after agrupation at phylum level.

Another phyloseq function is `psmelt`, which melt phyloseq objects into a `data.frame` 
to manipulate them with packages like `ggplot2` and `vegan`.
~~~
percentages <- psmelt(glom)
str(percentages)
~~~
{: .language-r}
~~~
'data.frame': 62 obs. of  5 variables:
 $ OTU      : chr  "31989" "31989" "1883" "327575" ...
 $ Sample   : chr  "JP4D" "JC1A" "JC1A" "JP4D" ...
 $ Abundance: num  84.6 76.3 16.3 5.89 5.34 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Proteobacteria" "Actinobacteria" "Bacteroidetes" ...
~~~
{: .output}

Now, let's create another `data-frame` with the original data. This will help us to compare
both datasets.
~~~
raw <- psmelt(merged_metagenomes)
str(raw)
~~~
{: .language-r}
~~~
'data.frame': 62 obs. of  5 variables:
 $ OTU      : chr  "31989" "2350" "1883" "31989" ...
 $ Sample   : chr  "JP4D" "JP4D" "JP4D" "JC1A" ...
 $ Abundance: num  19060 1326 1204 702 500 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Bacteroidetes" "Actinobacteria" "Proteobacteria" ...
~~~
{: .output}

With these objects and what we learned regarding `ggplot2`, we can proceed to compare them
by a plot. First, let´s create the figure for the raw data (*i.e* `ram.data` object)
~~~
raw.plot <- ggplot(data=raw.data, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
~~~
{: .language-r}

Next, we will create the figure for the representation of the relative abundance data, and ask
RStudio to show us both plots:
~~~
rel.plot <- ggplot(data=percentages, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
raw.plot | rel.plot
~~~
{: .language-r}

![image](https://user-images.githubusercontent.com/67386612/119714182-2db8ff00-be28-11eb-8508-4e3f356f71bb.png)
###### Figure 4. Taxonomic diversity of absolute and relative abundance

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
                             
