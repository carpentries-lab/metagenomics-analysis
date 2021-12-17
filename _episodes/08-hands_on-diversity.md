---
source: md
title: "Taxonomic Analysis with R"
teaching: 40
exercises: 20
questions:
- "How can we compare depth-contrasting samples?"
- "How can we manipulate our data to deliver a messagge?"
objectives:
- "Learn and create figures using `ggplot2`"
- "Learn how to manipulate data-types inside your phyloseq object"
- "Understand how to extract specific information from taxonomic-assignation data"
keypoints:
- "The library `phyloseq` lets you manipulate metagenomic data in a taxonomic specific perspective."  
- "The library `ggplot2` creates plots that helps/remarks the data analysis"
- "Creativity is welcome to explore and present your data"
---

# Assemble and manipulate a phyloseq object with a myriad of samples

*Before your fingers touch the keys, it must be decided in your mind why you are doing it...exploration 
is welcome and praised, not moving at all or senseless movement will draw you somewhere far from your 
goal*

  -Sergio Cuellar

## Visualizing our data with ggplot2
In the last lesson, we created our phyloseq object, which contains the information 
of our samples: `JC1A`, `JP41` and `JP4D`. Let´s take a look again at the
 number of reads in our data.  
~~~
merged_metagenomes
sample_sums(x = merged_metagenomes)
~~~
{: .language-r}

~~~
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 4024 taxa and 3 samples ]
tax_table()   Taxonomy Table:    [ 4024 taxa by 7 taxonomic ranks ]

  JC1A   JP4D   JP41 
 18412 149590  76589
~~~
{: .output}


Now with `summary` lets get a sense about the distribution of the reads 
in the different OTUs. This function answers how many reads are in average
in an OTU, and what are the maximum numbers of reads in certain category. 



~~~
summary(merged_metagenomes@otu_table@.Data)
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

It is useful to see numbers, but there are other ways to deliver information and to
unerstand the relationships between variables. Lets try some graphics. 
R has its own [base plotting system](https://www.statmethods.net/graphs/index.html), but we have already 
loaded a package that will help us to create artistically-proclived figures:[ggplot2](https://www.statmethods.net/advgraphs/ggplot2.html).

ggplot2 has been created with the idea that any graphic can be expressed with three components:
* Data set
* Coordinates
* Set of **geoms**, that is the visual representation of the data 

This **geoms** can be thought as layers that can be overlapped one over another, so special care 
is required to show useful information-layers to deliver a messagge. We are going to create an 
example with some of the data that we already have. Let's create a data-frame with the next code:
~~~
deep <- data.frame(Samples = sample_names(merged_metagenomes),
                    Reads = sample_sums(merged_metagenomes))
deep
~~~
{: .language-r}

~~~
     Samples  Reads
JC1A    JC1A  18412
JP4D    JP4D 149590
JP41    JP41  76589
~~~
{: .output}
`deep` is a new dataframe where we store the name of the sample and its corresponding number of reads.

Now, we can do a figure with the three components mentioned(data, coordinates, and geom):
~~~
ggplot(data = deep, mapping = aes(x = Samples,y = Reads)) +
  geom_col()
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-08-01.png">
  <img src="{{ page.root }}/fig/03-08-01.png" alt="Sample read counts as bars in a plot" />
</a>

###### Figure 1. Sample read counts as bars in a plot

Unraveling the above code. We first called the `ggplot` function (*i.e. ggplot()*). This will tell R that we want to 
create a new plot and the parameters indicated inside this function will apply to all the layers of the plot. We 
gave two arguments to the `ggplot` code: (i) the data that we want to show in our figure (*i.e. data = deep*), 
that is the data inside `deep`, and (ii) we defined the `aes` function(*i.e. mapping = aes(x = Samples,y = Reads)*),
which will tell `ggplot` how the variables will be mapped in the figure. In this case, **x** is the name of the 
samples and **y** the number of reads. It is noticiable that we did not need to express the entire path to access
to this columns to the `aes` function (*i.e.* x = deep[,"Samples"]), that is because the code is so well 
written taht it figures it out by itself. What would happend if we only call `ggplot` without the any **geom**(*i.e.* `geom_col`) is:

<a href="{{ page.root }}/fig/03-08-02.png">
  <img src="{{ page.root }}/fig/03-08-02.png" alt="ggplot function result without a specified geom" />
</a>

###### Figure 2. ggplot function result without a specified geom

We need to tell `ggplot` how we want to visually represent the data, which we did by adding a new geom layer. In this
example, we used `geom_col`, which tells `ggplot` we want to visually represent the relationship between **x** and
**y** as columns-bars:

<a href="{{ page.root }}/fig/03-08-01.png">
  <img src="{{ page.root }}/fig/03-08-01.png" alt="Sample read as bars in a plot" />
</a>

###### Figure 1. Sample read as bars in a plot

>## Exercise 1  : Exploring geoms
> 
> Go into groups and explore other geoms that can be useful for presenting the data
> of the number or reads in each sample. There are some cheat sheets of [ggplot2](https://blog.rstudio.com/2015/12/21/ggplot2-2-0-0/)
> around the internet. You can give them a try. 
{: .challenge} 

## Transformation and manipulation of data

By inspection on the above figure, it is evident that there is a great difference in the number of total 
reads(i.e. information) of each sample. Before we further process our data, take a look if we have any 
non-identified read. Marked as blank (i.e "") on the different taxonomic levels:

~~~
summary(merged_metagenomes@tax_table@.Data== "")
~~~
{: .language-r}
~~~
  Kingdom          Phylum          Class           Order           Family          Genus          Species       
 Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical  
 FALSE:4024      FALSE:4024      FALSE:3886      FALSE:4015      FALSE:3967      FALSE:3866      FALSE:3540     
                                 TRUE :138       TRUE :9         TRUE :57        TRUE :158       TRUE :484      
~~~
{: .output}
With the command above, we can see that there are blanks on different taxonomic leves. Although it is
expected to see some blanks at the species, or even at the genus level, we will get rid of the ones at 
the genus level to proceed with the analysis:

~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, Genus != "")
summary(merged_metagenomes@tax_table@.Data== "")
~~~
{: .language-r}
~~~
  Kingdom          Phylum          Class           Order           Family          Genus          Species       
 Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical  
 FALSE:3866      FALSE:3866      FALSE:3739      FALSE:3860      FALSE:3858      FALSE:3866      FALSE:3527     
                                 TRUE :127       TRUE :6         TRUE :8                         TRUE :339 
~~~
{: .output}


Next, since our metagenomes have different sizes, it is imperative to convert the number 
of assigned read into percentages (i.e. relative abundances) so as to compare them. 
~~~
head(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}
~~~
        JC1A JP4D JP41
1060      32  420   84
1063     316 5733 1212
2033869  135 1232  146
1850250  114  846  538
1061      42 1004  355
265       42  975  205
~~~
{: .output}
~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
head(percentages@otu_table@.Data)
~~~
{: .language-r}
~~~
             JC1A      JP4D      JP41
1060    0.1877383 0.3065134 0.1179709
1063    1.8539161 4.1839080 1.7021516
2033869 0.7920211 0.8991060 0.2050447
1850250 0.6688178 0.6174056 0.7555755
1061    0.2464066 0.7327130 0.4985675
265     0.2464066 0.7115490 0.2879052
~~~
{: .output}

## Beta diversity

As we mentioned before, the beta diversity is a measure of how alike or different are our samples(overlap between 
discretely defined sets of species or operational taxonomic units).
In order to measure this, we need to calculate an index that suits the objetives of our research. By this code,
we can display all the possible distance metrics that phyloseq can use:
~~~
> distanceMethodList
~~~
{: .language-r}
~~~
$UniFrac
[1] "unifrac"  "wunifrac"

$DPCoA
[1] "dpcoa"

$JSD
[1] "jsd"

$vegdist
 [1] "manhattan"  "euclidean"  "canberra"   "bray"       "kulczynski" "jaccard"    "gower"     
 [8] "altGower"   "morisita"   "horn"       "mountford"  "raup"       "binomial"   "chao"      
[15] "cao"       

$betadiver
 [1] "w"   "-1"  "c"   "wb"  "r"   "I"   "e"   "t"   "me"  "j"   "sor" "m"   "-2"  "co"  "cc"  "g"  
[17] "-3"  "l"   "19"  "hk"  "rlb" "sim" "gl"  "z"  

$dist
[1] "maximum"   "binary"    "minkowski"

$designdist
[1] "ANY"
~~~
{: .output}
Describing all this possible distance-metrics is beyond the scope 
of this lesson, but here we show which are the ones that need a 
phylogenetic relationship between the species-OTUs present in our samples:

* Unifrac
* Weight-Unifrac
* DPCoA  
  
We do not have a phylogenetic tree or the phylogenetic relationships. 
So we can not use any of those three. We will use [Bray-curtis](http://www.pelagicos.net/MARS6300/readings/Bray_&_Curtis_1957.pdf), 
since is one of the most robust and widely use distance metric to 
calculate beta diversity.

**Let's keep this up!** We already have all that we need to begin the beta diversity analysis. We will use 
the `phyloseq` command `ordinate` to generate a new object where the distances between our samples will be 
allocated after they are calculated. For this command, we need to specify which method we will use to generate
a matrix. In this example, we will use Non-Metric Multidimensional Scaling or [NMDS](https://academic.oup.com/bioinformatics/article/21/6/730/199398). NMDS attempts to represent 
the pairwise dissimilarity between objects in a low-dimensional space, in this case a two dimensional plot.
~~~
> meta.ord <- ordinate(physeq = percentages, method = "NMDS", 
                     distance = "bray")
~~~
{: .language-r}
If you get some warning messages after running this script, fear not. This is because we only have three samples
,this makes the algorithm to displays a warning concerning the lack of difficulty in generating the distance 
matrix. 

By now, we just need the command `plot_ordination()`, to see the results from our beta diversity analysis:
~~~
plot_ordination(physeq = percentages, ordination = meta.ord)
~~~
{: .language-r}  

<a href="{{ page.root }}/fig/03-08-03.png">
  <img src="{{ page.root }}/fig/03-08-03.png" alt="Beta diversity with NMDS of three samples" />
</a>

###### Figure 3. Beta diversity with NMDS of "three" samples

## Ploting our data

### Difference of our samples at specific taxonomic levels
 
In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function `tax_glom()`. 

~~~
glom <- tax_glom(percentages, taxrank = 'Phylum')
View(glom@tax_table@.Data)
~~~
{: .language-r}  

<a href="{{ page.root }}/fig/03-08-04.png">
  <img src="{{ page.root }}/fig/03-08-04.png" alt="Taxonomic-data table after agrupation at phylum level" />
</a>

###### Figure 4. Taxonomic-data table after agrupation at phylum level.

Another phyloseq function is `psmelt()`, which melts phyloseq objects into a `data.frame` 
to manipulate them with packages like `ggplot2` and `vegan`.
~~~
percentages <- psmelt(glom)
str(percentages)
~~~
{: .language-r}
~~~
'data.frame': 99 obs. of  5 variables:
 $ OTU      : chr  "1063" "1063" "1063" "2350" ...
 $ Sample   : chr  "JP4D" "JC1A" "JP41" "JP41" ...
 $ Abundance: num  85 73.5 58.7 23.8 19.1 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Proteobacteria" "Proteobacteria" "Bacteroidetes" ...
~~~
{: .output}

Now, let's create another data-frame with the original data. This will help us to compare
both datasets.
~~~
raw <- tax_glom(physeq = merged_metagenomes, taxrank = "Phylum")
raw.data <- psmelt(raw)
str(raw.data)
~~~
{: .language-r}
~~~
'data.frame': 99 obs. of  5 variables:
 $ OTU      : chr  "1063" "1063" "2350" "1063" ...
 $ Sample   : chr  "JP4D" "JP41" "JP41" "JC1A" ...
 $ Abundance: num  116538 41798 16964 12524 9227 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Proteobacteria" "Bacteroidetes" "Proteobacteria" ...
~~~
{: .output}

With these objects and what we have learned regarding `ggplot2`, we can proceed to compare them
with a plot. First, let´s create the figure for the raw data (*i.e* `raw.plot` object)
~~~
raw.plot <- ggplot(data=raw.data, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
~~~
{: .language-r}
Position_fill() and position_stack() automatically stack values in reverse order of the group aesthetic, 
which for bar charts is usually defined by the fill aesthetic (the default group aesthetic is formed by the 
combination of all discrete aesthetics except for x and y). This default ensures that bar colours align with the default legend.
When stacking across multiple layers it's a good idea to always set the `group` aesthetic in the ggplot() call. 
This ensures that all layers are stacked in the same way. For more info [position_stack](https://ggplot2.tidyverse.org/reference/position_stack.html) 

Next, we will create the figure for the representation of the relative abundance data, and ask
RStudio to show us both plots:
~~~
rel.plot <- ggplot(data=percentages, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
raw.plot | rel.plot
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-08-05.png">
  <img src="{{ page.root }}/fig/03-08-05.png" alt="Taxonomic diversity of absolute and relative abundance" />
</a>

###### Figure 5. Taxonomic diversity of absolute and relative abundance

At once, we can denote the difference between the two plots and how processing the data can 
enhance the display of important results. However, it is noticeable that we have too much taxa
to adequatly distinguish the color of each one of them, less of the ones that hold the greatest
abundance. In order to change that, we will use the power of data-frames and R. We will change
the identification of the OTUs whose relative abundance is less than 0.2%:
~~~
percentages$Phylum <- as.character(percentages$Phylum)
percentages$Phylum[percentages$Abundance < 0.5] <- "Phyla < 0.5% abund."
unique(percentages$Phylum)
~~~
{: .language-r}
~~~
[1] "Proteobacteria"    "Bacteroidetes"     "Actinobacteria"    "Firmicutes"        "Cyanobacteria"    
[6] "Planctomycetes"    "Verrucomicrobia"   "Phyla < 0.5 abund"
~~~
{: .output}

Let's ask R to display the figures again by re-running our code:
~~~
rel.plot <- ggplot(data=percentages, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
raw.plot | rel.plot
~~~
{: .language-r}

<a href="{{ page.root }}/fig/03-08-06.png">
  <img src="{{ page.root }}/fig/03-08-06.png" alt="Taxonomic diversity of absolute and relative abundance with corrections" />
</a>


###### Figure 6. Taxonomic diversity of absolute and relative abundance with corrections

>## Exercise 2  : Taxa agglomeration
> 
> Go into groups and agglomerate the taxa in the raw data, so as to have
> a better visualization of the data. Remeber checking the data-classes inside
> your data-frame. According to the [ColorBrewer](https://github.com/axismaps/colorbrewer/) package
> it is recommended not to have more than 9 different colors in a plot.
> 
> What is the best way to run the next script? Compare your graphs with your partners
> 
> Hic Sunt Leones! (Here be Lions!):
> 
> B) unique(raw.data$Phylum)
> 
> A) raw.plot <- ggplot(data=raw.data, aes(x=Sample, y=Abundance, fill=Phylum))+ 
>  geom_bar(aes(), stat="identity", position="stack")
>  
> C) raw.data$Phylum[raw.data$Abundance < 300] <- "Minoritary Phyla"
>> ## Solution
>> By reducing agglomerating the samples that have less than 300 reads, we can get a more decent plot.
>> Certainly, this will be difficult since each of our samples has contrasting number of reads.
>> 
>> C) raw.data$Phylum[raw.data$Abundance < 300] <- "Minoritary Phyla"
>> 
>> B) unique(raw.data$Phylum)
>> 
>> A) raw.plot <- ggplot(data=raw.data, aes(x=Sample, y=Abundance, fill=Phylum))+ 
>>  geom_bar(aes(), stat="identity", position="stack")
>>  
>>  Show your plots:
>>  
>>  raw.plot | rel.plot
>> 
>> <a href="{{ page.root }}/fig/03-08-01e.png">
>>   <img src="{{ page.root }}/fig/03-08-01e.png" alt="Taxonomic diversity of absolute and relative abundance with corrections" />
>> </a>
> {: .solution}
{: .challenge} 

## Going further, let's take an interesting lineage and explore it thoroughly

As we have already reviewed, phyloseq offers a lot of tools to manage and explore data. Let's take a 
look deeply to a function that we already use, but now with a guided exploration. The `subset_taxa` 
command is used to extract specific lineages from a stated taxonomic level, we have used it to get 
rid from the reads that does not belong to bacteria:
~~~
merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
~~~
{: .language-r}

We are going to use it now to extract an specific phylum from our data, and explore it at a lower 
taxonomic level: Genus. We will take as an example the phylum cyanobacteria (certainly, this is a biased
and arbitrary decision, but who does not feel attracted these incredible microorganisms?):
~~~
cyanos <- subset_taxa(merged_metagenomes, Phylum == "Cyanobacteria")
unique(cyanos@tax_table@.Data[,2])
~~~
{: .language-r}
~~~
[1] "Cyanobacteria"
~~~
{: .output}

Let's do a little review of all that we saw today: **Transformation of the data; Manipulation of the 
information; and plotting**:
~~~
cyanos  = transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
glom <- tax_glom(cyanos, taxrank = "Genus")
g.cyanos <- psmelt(glom)
g.cyanos$Genus[g.cyanos$Abundance < 10] <- "Genera < 10.0 abund"
p.cyanos <- ggplot(data=g.cyanos, aes(x=Sample, y=Abundance, fill=Genus))+ 
  geom_bar(aes(), stat="identity", position="stack")
p.cyanos
~~~
{: .language-r} 

<a href="{{ page.root }}/fig/03-08-07.png">
  <img src="{{ page.root }}/fig/03-08-07.png" alt="Diversity of Cyanobacteria at genus level inside our samples" />
</a>

###### Figure 7. Diversity of Cyanobacteria at genus level inside our samples.

> ## Exercise 3 
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the code learned to generate a plot where you can 
> show us the abundance at genus level in each of the samples.
> Please, paste your result on the collaborative document provided by instructors. がんばて!(ganbate; *good luck*):
>> ## Solution
>> Change "Cyanobacteria" wherever it is needed to get a result for
>> other phylum, as an example, here is the solution for Proteobacteria:
>>
>>proteo <- subset_taxa(merged_metagenomes, Phylum == "Proteobacteria")
>>
>>proteo  = transform_sample_counts(proteo, function(x) x*100 / sum(x) )
>>
>>glom <- tax_glom(proteo, taxrank = "Genus")
>>
>>g.proteo <- psmelt(glom)
>>
>>g.proteo$Genus[g.proteo$Abundance < 3] <- "Genera < 3.0 abund"
>>
>>unique(g.proteo$Genus)
>>
>>proteo <- ggplot(data=g.proteo, aes(x=Sample, y=Abundance, fill=Genus))+ 
>>  geom_bar(aes(), stat="identity", position="stack")
>>
>>proteo
>><a href="{{ page.root }}/fig/03-08-02e.png">
>>  <img src="{{ page.root }}/fig/03-08-02e.png" alt="Diversity of Proteobacteria at genus level inside our samples" />
>></a>
> {: .solution}
{: .challenge} 
                             

