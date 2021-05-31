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

*Before your fingers touch the keys, it must be decided in your mind why you are doing it...explore 
is welcome and praised, not moving at all or senseless movement will draw you somewhere far from your 
goal*

  -Sergio Cuellar

## Visualizing our data with ggplot2
In the last lesson, we created our phyloseq object, which contains the information 
of both of our samples: `JC1A` and `JP4D`. Let´s take a look again at the
 number of reads in our data.  
~~~
merged_metagenomes
sample_sums(merged_metagenomes)
~~~
{: .language-r}
~~~
otu_table()   OTU Table:         [ 3785 taxa and 2 samples ]
tax_table()   Taxonomy Table:    [ 3785 taxa by 7 taxonomic ranks ]

 JC1A   JP4D 
 18412 149590 
~~~
{: .output}
~~~
summary(merged_metagenomes@otu_table@.Data)
~~~
{: .language-r}
~~~
   JC1A              JP4D        
 Min.   :  0.000   Min.   :   0.00  
 1st Qu.:  0.000   1st Qu.:   3.00  
 Median :  0.000   Median :   8.00  
 Mean   :  4.864   Mean   :  39.52  
 3rd Qu.:  3.000   3rd Qu.:  23.00  
 Max.   :399.000   Max.   :6551.00
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

This **geoms** can be thought as layers that can be overlapped one over another, so special attention 
needs to be required to show useful information-layers to deliver a messagge. We are going to create an 
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
~~~
{: .output}

Now, we can do a figure with the three components mentioned(data, coordinates, and geom):
~~~
ggplot(data = deep, mapping = aes(x = Samples,y = Reads)) +
  geom_col()
~~~
{: .language-r}

<a href="https://user-images.githubusercontent.com/75807915/119749217-43e0b280-be5c-11eb-9eaa-7e7904b72361.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749217-43e0b280-be5c-11eb-9eaa-7e7904b72361.png" />
</a>

###### Figure 1. Sample read counts as bars in a plot

Unraveling the above code. We first called the `ggplot` function (*i.e. ggplot()*). This will tell R that we want to 
create a new plot and the parameters indicated inside this function will apply to all the layers of the plot. We 
gave two arguments to the `ggplot` code: (i) the data that we want to show in our figure (*i.e. data = deep*), 
that is the data inside `deep`, and (ii) we defined the `aes` function(*i.e. mapping = aes(x = Samples,y = Reads)*),
which will tell `ggplot` how the variables will be mapped in the figure. In in this case, **x** is the name of the 
samples and **y** the number of reads. It is noticiable that we did not need to express the entire path to access
to this columns to the `aes` function (*i.e.* x = deep[,"Samples"]), that is because the code is so well 
written taht it figures it out by itself. What would happend if we only call `ggplot` without the any **geom**(*i.e.* `geom_col`) is:

<a href="https://user-images.githubusercontent.com/67386612/119437234-4ff53480-bce3-11eb-8a0a-8c58e2079b23.png">
  <img src="https://user-images.githubusercontent.com/67386612/119437234-4ff53480-bce3-11eb-8a0a-8c58e2079b23.png" />
</a>

###### Figure 2. ggplot function result without a specified geom

We need to tell `ggplot` how we want to visually represent the data, which we did by adding a new geom layer. In this
example, we used `geom_col`, which tells `ggplot` we want to visually represent the relationship between **x** and
**y** as columns-bars:

<a href="https://user-images.githubusercontent.com/75807915/119749330-81ddd680-be5c-11eb-87a0-23d5551c41f9.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749330-81ddd680-be5c-11eb-87a0-23d5551c41f9.png" />
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
 FALSE:3785      FALSE:3785      FALSE:3657      FALSE:3776      FALSE:3733      FALSE:3646      FALSE:3342     
                                 TRUE :128       TRUE :9         TRUE :52        TRUE :139       TRUE :443      
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
 FALSE:3646      FALSE:3646      FALSE:3529      FALSE:3640      FALSE:3638      FALSE:3646      FALSE:3330     
                                 TRUE :117       TRUE :6         TRUE :8                         TRUE :316    
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
1060      32  420
1063     316 5733
2033869  135 1232
1850250  114  846
1061      42 1004
265       42  975
~~~
{: .output}
~~~
percentages  = transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
head(percentages@otu_table@.Data)
~~~
{: .language-r}
~~~
             JC1A      JP4D
1060    0.1876503 0.3066141
1063    1.8530464 4.1852825
2033869 0.7916496 0.8994014
1850250 0.6685041 0.6176084
1061    0.2462910 0.7329537
265     0.2462910 0.7117827
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

But first, we will duplicate one of the samples because we need, 
at least, 3 samples to generate an analysis of beta-diversity. Let's 
duplibate the `JP4D` sample, so we will extract our information from 
the OTU table inthe phyloseq object:
~~~
e.meta <- as.data.frame(percentages@otu_table@.Data)
head(e.meta)
~~~
{: .language-r} 
~~~
             JC1A       JP4D
356     1.7391304 0.75461648
41294   0.1086957 0.10209517
374     0.4347826 0.30184659
114615  0.3260870 0.03995028
722472  0.2173913 0.03995028
2057741 0.2173913 0.07102273
~~~
{: .output}

Now, we will add a new column to the data.frame `e.meta` which will have the `JP4D` information, but we will
named it differently to avoid misunderstandings:
~~~
e.meta$JP4D.2 <- e.meta$JP4D
head(e.meta)
~~~
{: .language-r} 
~~~
             JC1A       JP4D     JP4D.2
356     1.7391304 0.75461648 0.75461648
41294   0.1086957 0.10209517 0.10209517
374     0.4347826 0.30184659 0.30184659
114615  0.3260870 0.03995028 0.03995028
722472  0.2173913 0.03995028 0.03995028
2057741 0.2173913 0.07102273 0.07102273
~~~
{: .output}

Next, we will define a new object called `e.tax` which will save this information, but by the command `otu_table()`,
we will tell R that it will be part of a phyloseq object:
~~~
e.tax <- otu_table(e.meta, taxa_are_rows = TRUE)
~~~
{: .language-r}

With the `taxa_are_rows = TRUE`, we are indicating to R that the first row of the data-frame, have the names of the
OTUs.

Also, we need a tax table, which will save the information of which names of the OTUs, correspond to which taxonomical
assignation. We will use the same tax table that we have in our object `percentages`, since we only duplicated one
of the samples with no more OTU information 
~~~
e.otu <- tax_table(percentages@tax_table@.Data)
~~~
{: .language-r}
Finally, we will merge this two objects in a new phyloseq object called `e.metage`
~~~
e.metagen <- merge_phyloseq(e.tax, e.otu)
e.metagen
~~~
{: .language-r}
~~~
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 2736 taxa and 3 samples ]
tax_table()   Taxonomy Table:    [ 2736 taxa by 7 taxonomic ranks ]
~~~
{: .output}

**Let's keep this up!** We already have all that we need to begin the beta diversity analysis. We will use 
the `phyloseq` command `ordinate` to generate a new object where the distances between our samples will be 
allocated after they are calculated. For this command, we need to specify which method we will use to generate
a matrix. In this example, we will use Non-Metric Multidimensional Scaling or [NMDS](https://academic.oup.com/bioinformatics/article/21/6/730/199398). NMDS attempts to represent 
the pairwise dissimilarity between objects in a low-dimensional space, in this case a two dimensional plot.
~~~
> meta.ord <- ordinate(physeq = e.metagen, method = "NMDS", distance = "bray")
~~~
{: .language-r}
If you get some warning messages after running this script, fear not. This is because we have two "samples"
that are so alike and too little samples, that the algorithm displays a warning concerning the lack of difficulty 
in generating the distance matrix. 

By now, we just need the command `plot_ordination()`, to see the results from our beta diversity analysis:
~~~
plot_ordination(e.metagen, meta.ord)
~~~
{: .language-r}  

<a href="https://user-images.githubusercontent.com/67386612/120087795-9c0ff280-c0b0-11eb-8df8-a10008d39417.png">
  <img src="https://user-images.githubusercontent.com/67386612/120087795-9c0ff280-c0b0-11eb-8df8-a10008d39417.png" />
</a>

###### Figure 2. Beta diversity with NMDS of "three" samples

## Ploting our data

### Difference of our samples at specific taxonomic levels
 
In order to group all the OTUs that have the same taxonomy at a certain taxonomic rank,
we will use the function `tax_glom()`. 

~~~
glom <- tax_glom(percentages, taxrank = 'Phylum')
View(glom@tax_table@.Data)
~~~
{: .language-r}  

<a href="https://user-images.githubusercontent.com/75807915/119749409-acc82a80-be5c-11eb-81d5-d89d61dca68f.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749409-acc82a80-be5c-11eb-81d5-d89d61dca68f.png" />
</a>

###### Figure 3. Taxonomic-data table after agrupation at phylum level.

Another phyloseq function is `psmelt()`, which melts phyloseq objects into a `data.frame` 
to manipulate them with packages like `ggplot2` and `vegan`.
~~~
percentages <- psmelt(glom)
str(percentages)
~~~
{: .language-r}
~~~
'data.frame': 66 obs. of  5 variables:
 $ OTU      : chr  "1063" "1063" "1883" "1883" ...
 $ Sample   : chr  "JP4D" "JC1A" "JC1A" "JP4D" ...
 $ Abundance: num  85.08 73.44 19.05 6.74 4.02 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Proteobacteria" "Actinobacteria" "Actinobacteria" ...
~~~
{: .output}

Now, let's create another data-frame with the original data. This will help us to compare
both datasets.
~~~
raw <- psmelt(merged_metagenomes)
str(raw)
~~~
{: .language-r}
~~~
'data.frame': 7292 obs. of  10 variables:
 $ OTU      : chr  "1063" "2003315" "2023229" "1896196" ...
 $ Sample   : chr  "JP4D" "JP4D" "JP4D" "JP4D" ...
 $ Abundance: num  5733 3552 3070 2676 2249 ...
 $ Kingdom  : chr  "Bacteria" "Bacteria" "Bacteria" "Bacteria" ...
 $ Phylum   : chr  "Proteobacteria" "Proteobacteria" "Proteobacteria" "Proteobacteria" ...
 $ Class    : chr  "Alphaproteobacteria" "Alphaproteobacteria" "Alphaproteobacteria" "Alphaproteobacteria" ...
 $ Order    : chr  "Rhodobacterales" "Sphingomonadales" "Sphingomonadales" "Sphingomonadales" ...
 $ Family   : chr  "Rhodobacteraceae" "Erythrobacteraceae" "Erythrobacteraceae" "Erythrobacteraceae" ...
 $ Genus    : chr  "Rhodobacter" "Porphyrobacter" "Porphyrobacter" "Porphyrobacter" ...
 $ Species  : chr  "sphaeroides" "sp. CACIAM 03H1" "HT-58-2" "sp. LM 6" ...
~~~
{: .output}

With these objects and what we have learned regarding `ggplot2`, we can proceed to compare them
with a plot. First, let´s create the figure for the raw data (*i.e* `raw.plot` object)
~~~
raw.plot <- ggplot(data=raw, aes(x=Sample, y=Abundance, fill=Phylum))+ 
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

<a href="https://user-images.githubusercontent.com/75807915/119749676-3546cb00-be5d-11eb-8655-54240abb040f.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749676-3546cb00-be5d-11eb-8655-54240abb040f.png" />
</a>

###### Figure 4. Taxonomic diversity of absolute and relative abundance

At once, we can denote the difference between the two plots and how processing the data can 
enhance the display of important results. However, it is noticeable that we have too much taxa
to adequatly distinguish the color of each one of them, less of the ones that hold the greatest
abundance. In order to change that, we will use the power of data-frames and R. We will change
the identification of the OTUs whose relative abundance is less than 0.2%:
~~~
percentages$Phylum <- as.character(percentages$Phylum)
percentages$Phylum[percentages$Abundance < 0.4] <- "Phyla < 0.4% abund."
unique(percentages$Phylum)
~~~
{: .language-r}
~~~
[1] "Proteobacteria"      "Actinobacteria"     
[3] "Bacteroidetes"       "Firmicutes"         
[5] "Planctomycetes"      "Verrucomicrobia"    
[7] "Cyanobacteria"       "Phyla < 0.4% abund."
~~~
{: .output}

Let's ask R to display the figures again by re-running our code:
~~~
rel.plot <- ggplot(data=percentages, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")
raw.plot | rel.plot
~~~
{: .language-r}

<a href="https://user-images.githubusercontent.com/75807915/119749731-5d362e80-be5d-11eb-8f5a-57351ddff7f3.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749731-5d362e80-be5d-11eb-8f5a-57351ddff7f3.png" />
</a>


###### Figure 5. Taxonomic diversity of absolute and relative abundance with corrections

>## Exercise 2  
> 
> Go into groups and agglomerate the taxa in the raw data, so as to have
> a better visualization of the data. Remeber checking the data-classes inside
> your data-frame. According to the [ColorBrewer](https://github.com/axismaps/colorbrewer/) package
> it is recommended not to have more than 9 different colors in a plot. 
> Please, paste your result on the next [document](https://docs.google.com/document/d/1oFg3uUZUANf7S1Mh2KamzrcGhkKsXP5Mk1KxKv6k8wA/edit?usp=sharing), there you can find the Breakout room where you need to be 
> working with. がんばて!(ganbate; *good luck*):
>
>>## Solution
>> By reducing agglomerating the samples that have less than 30 reads, we can get a more decent plot.
>> Certainly, this will be difficult since each of our samples has constrasting number of reads.
>> raw.data$Phylum[raw.data$Abundance < 30] <- "Minoritary Phyla"
>> ![image](https://user-images.githubusercontent.com/67386612/119720017-17fb0800-be2f-11eb-8053-546119c78a2f.png)
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

Let's do a little review of all that we see today: **Transformation of the data; Manipulation of the 
information; and plotting**:
~~~
cyanos  = transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
glom <- tax_glom(cyanos, taxrank = "Genus")
g.cyanos <- psmelt(glom)
g.cyanos$Genus[g.cyanos$Abundance < 4] <- "Genera < 4.0% abund,"
p.cyanos <- ggplot(data=g.cyanos, aes(x=Sample, y=Abundance, fill=Genus))+ 
  geom_bar(aes(), stat="identity", position="stack")
p.cyanos
~~~
{: .language-r} 

<a href="https://user-images.githubusercontent.com/75807915/119749807-7fc84780-be5d-11eb-9e34-dcb0bd24f2fd.png">
  <img src="https://user-images.githubusercontent.com/75807915/119749807-7fc84780-be5d-11eb-9e34-dcb0bd24f2fd.png" />
</a>



###### Figure 6. Diversity of Cyanobacteria at genus level inside our samples.

> ## Exercise 3 
> 
> Go into groups and choose one phylum that is interesting for your
> group, and use the code learned to generate a plot where you can 
> show us the abundance in each of the sample.
> Please, paste your result on the next [document](https://docs.google.com/document/d/1oFg3uUZUANf7S1Mh2KamzrcGhkKsXP5Mk1KxKv6k8wA/edit?usp=sharing), there you can find 
> the Breakout room where you need to be working with. がんばて!(ganbate; *good luck*):
>> ## Solution
>> Change "Cyanobacteria" wherever it is needed to get a result for
>> other phylum, as an example, here is the solution for Proteobacteria:
>>proteo <- subset_taxa(merged_metagenomes, Phylum == "Proteobacteria")
>>proteo  = transform_sample_counts(proteo, function(x) x*100 / sum(x) )
>>glom <- tax_glom(proteo, taxrank = "genus")
>>g.proteo <- psmelt(glom)
>>proteo <- ggplot(data=g.proteo, aes(x=Sample, y=Abundance, fill=genus))+ 
>>  geom_bar(aes(), stat="identity", position="stack")
> {: .solution}
{: .challenge} 
                             

