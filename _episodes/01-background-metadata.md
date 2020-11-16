---
title: "Background and Metadata"
teaching: 10
exercises: 0
questions:
- "What data are we using?"  
- "Why is this experiment important?"  
objectives:
- "Why study cuatro Cienegas?."
- "What is the difference between shotgun and amplicon metagenomics?"  
- "Understand the data set."
keypoints:
- "It’s important to record and understand your experiment’s metadata."  
- "Shotgun metagenomics sequences genomes of all organisms in a community."     
- "Amplicon metagenomics amplifies and secuences a selected region of DNA."   
---

# Background  
A metagenomics study is one in which we study the genetic composition of various
species that coexist in a defined and preferably closed space. 

## What is cuatro Cienegas  
<a href="{{ page.root }}/fig/md-01-data-Stromatolites.jpeg">
  <img src="{{ page.root }}/fig/md-01-data-Stromatolites.jpeg" alt="Formatting Rules" />
</a>

 <a href="{{ page.root }}/fig/episode-format.png">
  <img src="{{ page.root }}/fig/episode-format.png" alt="Formatting Rules" />
</a>

Cuatro Cienegas is an oasis in the mexican desert that can be a model for a 
[lost world](https://elifesciences.org/articles/38278).  Cuatro Cienegas shows
high content of sulphur and magnesium but little phosphorus and nutrients, conditions 
that resemble the ones found in the ancient seas. Some of the few live stromatolite
can be found at the lagoons of the Basin.  
  
## Shotgun and Amplicons    
A metagenomic study goes from the sampling design to the statistical analysis of the data sequenced. 
Mainly, two types of studies are carried out: amplicons and whole-genome sequencing (WGS) or shotgun. 
In amplicon studies, a region typical of a community of microorganisms is amplified and sequenced, 
for example the hypervariable regions of 16S in Bacteria, or ITS in Fungi.  In shotgun, random fragments 
of all genomes of all organisms in the sample are amplified and sequenced. Which is the most suitable? 
That depends on the question of the study.  

> ## Amplicon or Shotgun? 
>
> Suppose you would like to compare the microbiome of sintomatic vs asintomatic pacients in certain disease.  
> Which type or metageomics would you choose?  
> If you would to investigate variation of a certain gene in a microorganisms community would you use Amplicon
> or shotgun metagenomics?
> In which cases would you use Shotgun metagenomics?  
{: .discussion}

## Data 
  - The data we are going to use are part of an [environmental study in perturbation of microbial mats](https://www.frontiersin.org/articles/10.3389/fmicb.2018.02606/full) led 
    by Valerie de Anda from the group of [Valeria souza](https://es.wikipedia.org/wiki/Valeria_Souza_Saldivar).  
   
   -The suty traces the responses to anthropogenic perturbation caused by water depletion in microbial mats 
   from Cuatro Cienegas Basin (CCB), Mexico, by using a time-series spatially resolved analysis.  
   
  - Results indicate that microbial mats from CCB contain an enormous taxonomic diversity with at least 
  100 phyla, mainly represented by members of the rare biosphere (RB).  
  
  - Data were deposited at MG-RAST database in the project 
  [mgp80319](https://www.mg-rast.org/mgmain.html?mgpage=project&project=mgp80319)   

> ## Metagenomic databases
>
> MG-RAST is not the only one metagenomic database, there is also [MGnify](https://www.ebi.ac.uk/metagenomics/), 
> [Marine Metagenomics Portal](https://mmp.sfb.uit.no/), [Terrestrial Metagenome DB](https://webapp.ufz.de/tmdb/)  
> and the [GM Repo](https://gmrepo.humangut.info/home).   
{: .callout}


## Understanding the dataset  
This metadata describes information on the *Ara-3* clones and the columns represent:

| Column           | Description                                |
|------------------|--------------------------------------------|
| file_name	          | PR3_R.fastq				|
| investigation_type	       | metagenome		|
| seq_meth            | illumina	|
| project_description	        |  16s Amplicon from red ponds at Cuatro Cienegas Basin			|
| collection_date       | 2013-03-25 |
| country          | Mexico |
| feature         | pond water |
| latitude              | 26.8717055555556	|
| longitude        | .102.021061111111 |

~~~
---
variable: value
other_variable: other_value
---
...stuff in the page...
~~~
{: .source}

