
---
title: "Amplicon metagenomics"
teaching: 30
exercises: 25
questions:
- "What is amplicon metagenomics?"
- "How can I analice 16s data?"
objectives:
- "Understand the difference between shotgun and amplicon metagenomics"
- "Use a workflow to visualice 16s data"
- " Understand the first steps to 16S sequence analysis"  
- " Understand what QIIME is and how we can use it  "

keypoints:
- "Amplicons are fragments of DNA that will be amplified"
- "16s and ITS allow you to explore diversity in bacteria and Fungi respectively"
---


## What is 16S amplicon sequencing?

16S amplicon sequencing is commonly used for identifying and classifying bacteria within a particular environment. It allows us to use a small region of DNA from the genome of each bacterium in a sample to determine which microbes are present and perform microbial diversity analyses to help us understand the microbial ecosystem.  


### 16S rRNA gene

The 16S ribosomal RNA gene (16S rRNA) is approximately 1,500 bp long, and contains nine variable regions separated by conserved regions. We use the variable regions of the gene to distinguish one bacterial type from another. One of the most commonly sequenced variable regions is the V3 - V4 region that spans approaximately 469 bp (Fadrosh et al. 2014. Microbiome).   

![16S rRNA Variable Regions (http://www.lcsciences.com/)](fig/16s-gene.png)

One reason this region is a popular sequencing target is the length. Often we use paired-end 250 bp sequencing, which allows us to span more than half of the V3-V4 region in each direction. This means we can stitch the paired reads together to produce a longer sequence read that increases the accuracy and specificity of our data.   


![16S Paired-End Sequencing (Illumina.com)](fig/paired_end.jpg)

## Workshop data

## Quality control of DNA sequences


## OTU picking

The processes of assigning sequences to operational taxonmic units (OTUs) is called OTU picking. Based on a similarity threshold, we determine which sequences belong to the same group. Often, the similarity threshold we use is 97%. This means that all sequences that are 97% similar will be denoted as the same OTU. We use the term OTU because OTUs can span different levels of the phylogenic tree. For example, one group of sequences that is 97% similar to one another (OTU) may represent Escherichia coli (species level), whereas another group of sequences 97% similar to one another (OTU) may represent Salmonella (genus level). There are 3 main methods to denote which microbes are within a sample, and we will cover these methods below.

#### De novo OTU picking

De novo OTU picking does not use a reference database. The sequences in your dataset are compared to one another and grouped based on the similarity threshold (97% identity). The resulting groups of sequences are then denoted as OTUs. De novo OTU picking utilizes all sequences from all samples in the analysis. Because it doesn't use a reference database, the taxonomy (name) associated with each OTU is not readily available. De novo OTU picking requires the most computational resources and time in comparison to the other OTU picking methods.

#### Closed reference OTU picking

Closed reference OTU picking utilizes a reference database of known 16S rRNA sequences. The sequences in your dataset are compared to the reference database and those meeting the 97% identity threshold are donated as the same OTU from the reference database. Closed reference OTU picking will remove all sequences that do not match the reference database within the set threshold (97% identity). The reference database is annotated with taxonomy, so the taxonomy of each OTU in your samples is readily available. Closed reference OTU picking requires the least computational resources and time in comparison to the other OTU picking methods.


#### Open reference OTU picking

Open reference OTU picking combines closed reference OTU picking and de novo OTU picking. First, sequences are compared to the reference database (closed reference OTU picking). Then, the sequences that fail to match the reference database are de novo clustered into new OTUs and combined with the closed-reference OTUs. Open reference OTU picking utilizes all the sequences from all samples in the analysis. Only sequences that align to the reference database will have taxonomy readily available for them. Open reference OTU picking requires more computational resources and time than closed reference OTU picking.

### Using NINJA for OTU picking

For this workshop we will use a closed reference OTU-picker called NINJA, which stands for NINJA Is Not Just Another aligner. NINJA requires the input to be a single fasta file that contains the clean sequences for each sample. SHI7 is designed to specifically produce the type of input file required by NINJA. The `combined_seqs.fna` file produced by SHI7 is also compatible with other OTU pickers. The default database used by NINJA is the GreenGenes 97% ID database. The full documentation for NINJA is located here: https://github.com/GabeAl/NINJA-OPS.

We can run NINJA with the following parameters: *Time estimate: 3 minutes*

```{r, eval=F}
ninja.py -i qc_reads/combined_seqs.fna -o ninja_otus -m normal -p 4 -z -d 2
```

`-i` Specifies the path to the combined_seqs.fna file  
`-o` Specifes the directory we'd like to create for our output  
`-m` Specifies the sensitivity mode to run with (normal is perfect for high quality data)  
`-p` Specifies the number of threads to use (to speed up the alignment)  
`-z` Specifies to search both directions  
`-d` Specifies the denoising level; 2 means discard any sequences appearing <2 times  

### NINJA outputs
The output of NINJA is a directory containing 2 files:  
* `ninja_log.txt` which is the log file for the OTU picking process  
* `ninja_otutable.biom` which is OTU table  

#### ninja_log.txt

This file contains all the commands and outputs from OTU picking. To open this file and look at the performance of OTU picking we can use `less`. 

``` {r, eval=F}
less ninja_log.txt
```

#### ninja_otutable.biom

This file is our OTU table in biom format. An OTU table contains the samples as columns, and OTUs as rows. The values in the table are the number of times an OTU was counted within each sample, as well as some corresponding metadata such as the taxonomy assocaited with each OTU. When in biom format, the file is not human readable. Biom is a way to package a lot of information in a way that doesn't take up too much space. If you call `head` on a biom file, the output will look mostly like gibberish. What is important is that QIIME and other microbiome softwares use biom files because they are smaller and fast to work with. If you want to put your OTU table in a human-readable format, you have to convert it to a tab-delimited file. We will cover how to do this later.

## Inspecting an OTU table

To double check if our OTU picking was successful and to run summary statistics on our OTU table, we can use the `summarize-table` command from `biom`. Biom is a package used by QIIME, and its commands can be used the same way as the QIIME commands.  The full documentation for biom is here: http://biom-format.org/  

### Biom summary
To create a summary file of our OTU table we can use the `biom summarize-table` command:
```{r ,eval=F}
biom summarize-table -i ninja_otus/ninja_otutable.biom -o otu_summary.txt
```  
`-i` Specifies the path to the OTU table created by NINJA  
`-o` Specifes the path to the summary file we'd like to create  

The summary file will contain:   
* The number of samples  
* The number of observations (OTUs)  
* The minimum, maximum, median, mode and standard deviations of the number of counts per sample  
* The taxonomy stored as the observation metadata  
* A list of the number of counts in each sample  

To open this file and look at the summary we can use `less`. 

``` {r, eval=F}
less OTU_summary.txt
```

## Converting an OTU table from .biom to .txt

Right now the OTU table we have is in biom format, which is not human readable. If we want the OTU table in a form easy to read and load into R, we can convert it to a tab separated text file with `biom convert`

### Biom convert
To create a .txt file of our OTU table we can use the `biom convert` command:
```{r ,eval=F}
biom convert -i ninja_otus/ninja_otutable.biom -o ninja_otus/ninja_otutable.txt --to-tsv --header-key taxonomy
```  
`-i` Specifies the path to the OTU table created by NINJA  
`-o` Specifes the path to the summary file we'd like to create  
`--to-tsv` Specifies that we want to make it a tab separated text file  
`--header-key` Specifies to include the taxonomy for each OTU  

The new OTU table will have:   
* OTUs as the rows 
* Samples as columns 
* An extra line at the top of the file 
* Taxonomy in the last column

To open this file we can use `less`. 

``` {r, eval=F}
less ninja_otutable.txt
```

## Exploratory analysis with QIIME

### What is QIIME?
QIIME stands for Quantitative Insights Into Microbial Ecology, and is pronounced 'chime'.   It is pipeline for performing microbiome analysis of DNA sequences.  Some of the things QIIME can do for us include:  

* Quality filtering
* OTU picking
* Assigning Taxonomy 
* Diversity analysis
* Visualizations
* Statistics  
  
QIIME uses a mix of other existing softwares and algorithms to perform its tasks.  Because of this we call it a 'wrapper'. That means it wraps up many other existing tools and algorithms in a package that works as one cohesive unit. QIIME has many commands to accomplish various tasks, and these commands can be found at the link below.  

 **QIIME Commands:    [http://qiime.org/scripts/](http://qiime.org/scripts/)**

Try going to this page and click some of the commands' links, for example click **`summarize_taxa.py`** and read what this command does, what the inputs are and the examples.

### Using QIIME
To determine how to run a command, we have to look up the documentation.  We can either go to the command webpage mentioned above and click on the command we want, or we can use the *help* flag for the command we are unsure about.  

By specifying `-h` the command will list the documentation associated with it.  This output will not be as comprehensive as what is available online, but will at least tell us all the possible inputs and outputs.  

### Example
This command uses the mapping file to collapse the OTU table.  
```{r eval=F}
collapse_samples.py -h
```

Online Documentation Page:
![](Fig5.png)


### Parameter file

Some of the commands in QIIME require a parameter file to specify some extra details. In this workshop we will create a parameters file that will house the parameters needed for alpha and beta diversity. We can create a text file with `nano`. We close the file with the commands located at the bottom of the nano-screen.

```{r, eval=F}
nano parameters.txt
beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac
alpha_diversity:metrics shannon,PD_whole_tree,observed_species
```

## Validating metadata

At different steps in the analysis we use metadata stored in a metadata file (also called a mapping file). This file must be properly formated to work with QIIME. In particular, the mapping file needs:  
1. To be a tab-delimited text file
2. The first column header to be `#SampleID`
3. To have samples as rows
4. A unique identifier for each sample
5. To contain no invalid characters (e.g. headers can be alphanumeric and underscore only)

### Validating metadata with QIIME
We can use QIIME to check our mapping file and ensure it contains data in a valid format. To do that, we can use the `validate_mapping_file.py` command with the following parameters:
```{r, eval=F}
validate_mapping_file.py -m mouse_mapfile.txt -o mapping_validation
```
`-m` Specifies the file path to the mapping file  
`-o` Specifies the path to the output directory we'd like to create    

### validate_mapping_file.py outputs
The command will generate a directory containing different files for us:
`mouse_mapfile_corrected.txt` A QIIME-correct version of the mapping file
`mouse_mapfile.html` `overlib.js` A web document that allows us to explore the mapping file and errors
`mouse_mapfile.log` A log of the errors found

**Note:** Because we are not using QIIME to clean the data or pick OTUs, not having the barcodes or adapters (linker sequences) listed in the mapping file will not be an issue.


## Rarefaction

### What is rarefaction?
In microbiome research, diversity represents the number OTUs within a data set. This number can be greatly impacted by sequencing depth.  For example, the deeper you sequence a sample, the more species you will find. This is a problem, especially if you sequence 50,000 reads from one sample and only 1,000 reads from another sample.  

To prevent any bias, we may see in our diversity analysis we can rarefy our data. A rarefaction is a random collection of sequences from a sample, with a specified number of sequences (depth). For example, a rarefaction with a depth of 1,000 reads per sample is a simulation of what your sequencing results would look like if you sequenced exactly 1,000 reads from each sample. By rarefying our OTU table we can fairly measure alpha diversity across samples.  

### Exploring rarefied data with QIIME
In QIIME, we can first explore our data by looking at alpha diversity across multiple different sequencing depths. This task is performed using the `alpha_rarefaction.py` command that takes your OTU table as input and generates multiple OTU tables, all of which are repeats of rarefactions at specific depths. The output of this command allows us to visualize how measurements in alpha diversity will change across a range of sequence depths per sample. Once we know how the diversity changes with depth, we can create one final rarefied table to use for our alpha diversity and beta diversity calculations.  

The command is run using these parameters: *time estimate: 27 minutes*
```{r eval=F,}
alpha_rarefaction.py -i ninja_otus/ninja_otutable.biom -o alpha_rare -m mouse_mapfile.txt -t 97_otus.tree -p qiime_parameters.txt --min_rare_depth 1000
```
`-i` Specifies the path to the OTU table  
`-o` Specifes the directory we'd like to create for our output   
`-m` Specifies the path to the metadata/mapping file   
`-t` Specifies the path to the phylogenic tree  
`-p` Specifies the path to the parameters file  
`-e` Specifies the maximum depth  
`--min_rare_depth` Specifies the minimum depth  

The `alpha_rarefaction.py` command will do multiple things:

1. Create multiple rarefied OTU tables at set increments starting at a minimum level of sequences and stopping at the maximum number of sequences per sample (if not set, it will end at the median).  
2. Run `alpha_diversity.py` on each of the rarefied OTU tables using the parameters set in the parameters file.  
3. Collate the results for each metric at the various depths into one table per metric, within the `alpha_div_collated/` subdirectory.  
4. Plot the different metrics for each category in the metadata file and place those within the `alpha_rarefaction_plots/` subdirectory.  
5. Delete all intermediate OTU tables it had generated to do the analysis.  
6. Create a log file and overall rarefaction plot within the main output directory.    

### alpha_rarefaction.py outputs
You will know `alpha_rarefaction.py` is done when you have the following files in your output directory (-o):  

`alpha_div_collated/`  (one table per metric in here)  
`alpha_rarefaction_plots/` (plots per metadata column)   
`log_##.txt`  (log file)  
`rarefaction_plots.html` (overall plot)  

To look at your plots, you can transfer the __entire__ `alpha_rarefaction.py` output folder to your local computer.  The `rarefaction_plots.html` file needs other information supplied within the subfolders. You can move through all of the plots by selecting different categories and diversity metrics.  

## Creating a rarefied OTU table

### How do you pick a depth?
You want to pick a depth that:  
1. Keeps as many samples as possible (isn’t too high)  
2. Isn’t so low that samples aren’t representative of the total diversity  

Any samples that do not have at least the number of sequences of our rarefaction depth will be dropped from the output OTU table.  Normally, we try to pick a depth where the rarefaction curves begin to level off, or the lowest value possible within the same order of magnitude as the sample with most sequences. 

### Creating your rarefied OTU table
Once you have picked a depth based on the `alpha_rarefaction.py` outputs, you are ready to create a rarefied OTU table.  To do this, we use the `single_rarefaction.py` command with the following parameters:  

```{r, eval=F}
single_rarefaction.py -i ninja_otus/ninja_otutable.biom -o otutable_r10k.biom -d 10000
```
`-i` Specifies the path to the OTU table  
`-o` Specifies the path to the rarefied OTU table  
`-d` Specifies the depth  

__The output of this command will be the OTU table you use for alpha and beta diversity calculations.__

## Alpha diveristy

### What is alpha diversity?

Alpha diversity measures how many different organisms are within a particular area or ecosystem, and is usually expressed by the number of species (i.e., species richness) in that ecosystem.  In our case, the ecosystem in question is the sample type we are analyzing. It's important to remember that alpha diversity is **within a sample**, which is what makes it different from beta diversity. The amount of diversity in any community is extremely important in determining ecological dynamics (e.g. community productivity, stability, and resilience).  

Different metrics have been developed to calculate alpha diversity. Some of these include:  

**Richness:**                  A measure of the number of OTUs present in a sample  
**Evenness:**                  How many of each OTU is present in a sample  
**Phylogenetic relationship:** Accounts for taxonomy and phylogenetic relationships  

### What are alpha diversity metrics?
Below are some common alpha diversity metrics used in microbiome research. There are numerous other metrics available in QIIME, but we won't cover all of them.

#### Observed species
The simplest diversity index; it is just the number of OTUs.  

#### Chao1 estimator
This is commonly used, and is based upon the number of rare OTUs found in a sample  The problem with this metric is that if a sample contains many singletons (OTUs that occur just once, usually by sequencing error) the Chao 1 index will estimate greater species richness than it would for a sample without rare OTUs. 

#### Shannon index
This index accounts for both abundance and evenness of the species present. It assumes all species are represented in a sample. 

#### Simpson index
The Simpson index is actually a similarity index, so the higher the value the lower the diversity in the sample. It gives more weight to common or dominant species. 

### Phylogenetic Distance (PD Whole Tree)
The phylogenetic distance metric used most often is PD whole tree. It is the sum of all phylogenetic branches connecting OTUs together within a community. 


**Summary of diversity metrics**  

**Metric** | **Measurement**
---------- | -----------------------
**Observed Species** | Richness
**Chao1** | Richness & Evenness
**Shannon** | Richness & Evenness
**Simpson** | Richness & Evenness
**PD Whole Tree** | Phylogeny


### Alpha diversity in QIIME
In QIIME, we can use our rarefied OTU table to calculate alpha diversity. Earlier we used alpha diversity metrics to determine a reasonable rarefaction depth or a reasonable sequencing depth as filtering cutoff. Now we will use the `alpha_diversity.py` command in QIIME to make a final alpha diversity calculation for each sample. The command is run using these parameters:

```{r, eval=F}
alpha_diversity.py -i otutable_r10k.biom -o alpha_diversity.txt -m shannon,simpson,observed_species,PD_whole_tree -t 97_otus.tree
```
`-i` Specifies the path to the rarefied OTU table  
`-o` Specifies the path to the output file we'd like to create  
`-m` Specifies which alpha diversity metrics to use  
`-t` Specifies the path to the phylogenic tree (needed for phylogenetic metrics)  

### alpha_diversity.py outputs
The output of the `alpha_diversity.py` is a table, where the columns are the different diversity metrics and the rows are samples.  We can use this table to make different alpha diversity plots in R.


## Beta diversity

### What is beta diversity?
In his 1972 publication in Taxon, "Evolution and Measurement of Species Diversity", R. H. Whittaker laid out the terms and concepts for how we think about and define biodiversity. His idea was that the total species diversity in a landscape (gamma-diversity) (e.g. ALL human gastrointestinal (GI) tracts) is determined by two different things:  

__1) Alpha diversity__  
* the mean species diversity at the habitat level     
* *e.g.* one person's GI tract  

__2) Beta diversity__   
* the differentiation among habitats  
* *e.g.* differences between 2 different GI tracts    
 
The total diversity, **gamma**, is alpha multiplied by beta:  gamma = alpha * beta  

Let's say you are comparing the biological communities of a 20m x 20m patch of the Great Barrier Reef (right) and a 20m x 20m plot of the Amazon rainforest (left).

![](Fig33.png)

Both of these habitats have very high alpha diversity. However, despite similarly high alpha diversity, if you were to compare the composition of these two communities at the macroscopic level, they are almost completely non-overlapping. Therefore, they would also have a very high beta diversity.

### What are beta diversity metrics?
There are multiple beta diversity metrics.  Below we will cover some of the most widely used distance metrics for beta diversity.  

#### UniFrac distance

The unique fraction metric, or UniFrac, measures the phylogenetic distance between sets of taxa in a phylogenetic tree. It counts the branch lengths of the tree that lead to taxa from either one environment or the other, but not both (Lozupone & Knight. 2005, Appl Environ Microbiol). This metric is sensitive, but also has emphasis on minor differences in the tree.


#### Weighted UniFrac distance
In the UniFrac metric, the relative abundances of taxa is not taken into consideration (referred to as unweighted UniFrac distance). There is a second metric known as weighted UniFrac distance, that weights each OTU based on it's relative abundance. Both metrics are criticized for giving either too much (unweighted) or too little (weighted) value to rare taxa, but both have value in showing different aspects of community diversity.  

#### Bray-Curtis dissimilarity  
Bray-Curtis is 1 minus the sum of the differences in OTU abundances over the sum of the total OTU abundances between samples. This metric does not take relatedness of the otus into consideration (phylogeny).  


**Summary of beta diversity metrics**  

**Metric** | **Measurement**
---------- | -----------------------
**Unweighted UniFrac** | phylogeny & presence/absence
**Weighted UniFrac** | phylogeny & abundance
**Bray Curtis** | presence/absence


### Exploring beta diversity with QIIME
We will use the `beta_diversity_through_plots.py` command in QIIME to calculate and visualize the beta diversities of our samples. We run this command with the following parameters: *time estimate: 7 minutes*

```{r, eval=F}
beta_diversity_through_plots.py -i otutable_r10k.biom -o beta_diversity -m mouse_mapfile.txt -t 97_otus.tree -p qiime_parameters.txt
```
`-i` Specifies the path to the rarefied OTU table  
`-o` Specifies the path to the output directory we'd like to create  
`-m` Specifies the path to the metadata/mapping file  
`-t` Specifies the path to the phylogenic tree (needed for phylogenetic metrics)  
`-p` Specifies the path to the parameters file  

The `beta_diversity_through_plots.py` command will do multiple things:  

1. Run `beta_diversity.py` for the diversity metrics wanted (specified with the parameters file via `-p`) and create distance matrices in the main output directory (`metric_dm.txt`).   
2. Perform a principal coordinates analysis on the result of Step 2 in the main output directory (`metric_pc.txt`).   
3. Generate 2D and 3D plots for all mapping fields in the `metric_emperor_pcoa_plot/` subdirectories.   
4. Delete all intermediate files generated to do the analysis.   
5. Create a log file and overall rarefaction plot (.html) within the main output directory.   

### beta_diversity_through_plots.py outputs
You will know `beta_diversity_through_plots.py` is done when you have the following files in your output directory (`-o`):  

`metric_pc.txt`   (one table per metric, 3 total)  
`metric_dm.txt`   (one table per metric, 3 total)  
`metric_emperor_pcoa_plot` /  (one per metric, 3 total)    
`log_##.txt`    (log file)  

To look at your plots, you can transfer the entire plot folder to your local computer. Note: The plot file needs other information supplied within the subfolders.  

## Summarizing taxa 
### What are taxa summaries?
Summarizing taxa is a way to visualize which taxa are found in our samples. When we summarize taxa we can use the various levels of taxonomy. The following levels are those denoted by GreenGenes for taxonomy.

**Level** | **Taxonomy**  | **Example**  
--------- | ------------- | -----------
**1** | Kingdom | Bacteria
**2** | Phylum | Actinobacteria
**3** | Class | Actinobacteria
**4** | Order | Actinomycetales
**5** | Family | Strepmycetacaea
**6** | Genus | Streptomyces
**7** | Species | mirabilis

In QIIME, we can use levels 2-6 to summarize taxa.  We can't use level 1, because that would result in no summary (all of our OTUs are bacteria).  We also cannot use level 7, because using 97% identity of a 16S gene cannot readily resolve species from one another.  We summarize taxa with the `summarize_taxa_through_plots.py` command in QIIME.  

### Taxa summaries in QIIME
In QIIME, this task is performed on your rarefied OTU table. The QIIME command `summarize_taxa_through_plots.py` takes your OTU table and collapses the table into the various taxonomic levels. It will then plot the taxa summaries for us.  

The command is run using these parameters:  *time estimate: 3 minutes*

``` {r, eval=F}
summarize_taxa_through_plots.py -i otutable_r10k.biom -o taxa_summary -m mouse_mapfile.txt -c Genotype
```
`-i` Specifies the path to the rarefied OTU table  
`-o` Specifies the path to the output directory we'd like to create  
`-m` Specifies the path to the metadata/mapping file  
`-t` Specifies column header in the mapping file to plot by 

### summarize_taxa_through_plots.py outputs  
The `summarize_taxa_through_plots.py` command will:  

1. Create an output directory named whatever you specified for `-o`  
2. Create OTU tables collapsed at each taxonomic level (2-6) with samples grouped according to your `-c` parameter   
3. Create taxa summary plots in a subdirectory called `taxa_summary_plots`  

## Differentiated taxa 
### What are differentiated taxa?
When we have discrete groups of data, we can test to see if certain taxa are differentially abundant between the groups. This would indicate a correlation of the amount of a specific taxon with the covariate defining the grouping. 

### Differential taxa in QIIME
In QIIME, this task is **NOT performed on your rarefied OTU table**. Instead, we must filter the full OTU table to remove any samples of low depth and any OTUs that are particularly rare. With this filtered OTU table, we can first normalize the data and then test for differences in bacterial abundance across groups. The QIIME commands we need for this are `filter_samples_from_otu_table.py`, `filter_otus_from_otu_table.py` and `differential_abundance.py`.   

Removing low depth samples from OTU table and metadata:  
``` {r, eval=F}
filter_samples_from_otu_table.py -i ninja_otus/ninja_otutable.biom -o 10ksamples_otu.biom -m mouse_mapfile.txt --output_mapping_fp 10k_mouse_map.txt -n 10000
```
`-i` Specifies the path to the full OTU table   
`-o` Specifies the path to the output OTU table   
`-m` Specifies the path to the metadata/mapping file  
`--output_mapping_fp`  Specifies the path to the output metadata/mapping file  
`-n` Specifies the minimum number of sequences needed to keep a sample  

Removing rare OTUs, keeping those with at least 5 counts and those in at least 10% of all samples (116 samples * 0.1) :  
``` {r, eval=F}
filter_otus_from_otu_table.py -i 10ksamples_otu.biom -o 10ksamples_keepotus.biom -n 10 -s 12
```
`-i` Specifies the path to the filtered OTU table   
`-o` Specifies the path to the output OTU table   
`-n` Specifies the number of counts an OTU needs to be retained  
`-s` Specifies the number of samples an OTU needs to be in to be retained  

Test for taxa differentially abundant between groups. The default is set to normalize the data with MetagenomeSeq’s fitZIG: *time estimate: 10 minutes*
```{r, eval=F}
differential_abundance.py -i 10ksamples_keepotus.biom -m 10k_mouse_map.txt -c BMI_Type -x normal -y overweight -o diff_otus.txt
```
`-i` Specifies the path to the filtered OTU table     
`-o` Specifies the path to the output table     
`-m` Specifies the path to the filtered map    
`-c` Specifies the metadata column   
`-x` Specifies the first group type in the column  
`-y` Specifies the second group type in the column  

### differential_abundance.py outputs  
The `differential_abundance.py` command will:  

1. Create an output table containing all the OTUs differentially abundant between the sample types    

This file can be used to plot the differences in abundance using the `group counts` and the `lower` and `upper` values for confidence intervals.  **As a note, you can also test for differences in abundance using a rarefied OTU table, with the `group_significance.py` command.**

# Cleaning Reads

## Trimmomatic Options

Trimmomatic has a variety of options to trim your reads. If we run the following command, we can see some of our options.

~~~
$ trimmomatic
~~~
{: .bash}

Which will give you the following output:
~~~
Usage: 
       PE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] [-validatePairs] [-basein <inputBase> | <inputFile1> <inputFile2>] [-baseout <outputBase> | <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>] <trimmer1>...
   or: 
       SE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] <inputFile> <outputFile> <trimmer1>...
   or: 
       -version
~~~
{: .output}


> ## Bonus Exercise (Advanced)
>
> Now that our samples have gone through quality control, they should perform
> better on the quality tests run by FastQC. Go ahead and re-run
> FastQC on your trimmed FASTQ files and visualize the HTML files
> to see whether your per base sequence quality is higher after
> trimming.
>
>> ## Solution
>>
>> In your AWS terminal window do:
>>
>> ~~~
>> $ fastqc ~/dc_workshop/data/trimmed_fastq/*.fastq*
>> ~~~
>> {: .bash}
>>
>> In a new tab in your terminal do:
>>
>> ~~~
>> $ mkdir ~/Desktop/fastqc_html/trimmed
>> $ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/data/trimmed_fastq/*.html ~/Desktop/fastqc_html/trimmed
>> ~~~
>> {: .bash}
>> 
>> Then take a look at the html files in your browser.
>> 
>> Remember to replace everything between the `@` and `:` in your scp
>> command with your AWS instance number.
>>
>> After trimming and filtering, our overall quality is much higher, 
>> we have a distribution of sequence lengths, and more samples pass 
>> adapter content. However, quality trimming is not perfect, and some
>> programs are better at removing some sequences than others. Trimmomatic 
>> did pretty well though, and its performance is good enough for our workflow.
> {: .solution}
{: .challenge}

> ## `.callout`
>
> An aside or other comment.
{: .callout}

> ## `.discussion`
>
> Discussion questions.
{: .discussion}
