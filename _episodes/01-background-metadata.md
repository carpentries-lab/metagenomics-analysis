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
Databases [MGnify](https://www.ebi.ac.uk/metagenomics/)    
          [Marine Metagenomics Portal](https://mmp.sfb.uit.no/)    
          [GM Repo](https://gmrepo.humangut.info/home)   
          [Terrestrial Metagenome DB](https://webapp.ufz.de/tmdb/)  

[Valeria souza](https://es.wikipedia.org/wiki/Valeria_Souza_Saldivar)  

[mgp2321](https://www.mg-rast.org/mgmain.html?mgpage=project&project=mgp2321)  
[MG RAST analysis of this data](https://www.mg-rast.org/mgmain.html?mgpage=overview&metagenome=mgm4442467.3)
[Basin 1](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3426886/), [Basin 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3426889/)  
Other references 

Visit our [new curriculum development guide](https://carpentries.github.io/curriculum-development/).
https://www.mg-rast.org/mgmain.html?mgpage=download&metagenome=mgm4442467.3

> ## Teaching Tools
>
> We do *not* prescribe what tools instructors should use when actually teaching:
> the [Jupyter Notebook][jupyter],
> [RStudio][rstudio],
> and the good ol' command line are equally welcome up on stage.
> All we specify is the format of the lesson notes.
{: .callout}

## Jekyll

GitHub uses [Jekyll][jekyll] to turn Markdown into HTML.
It looks for text files that begin with a header formatted like this:

~~~
---
variable: value
other_variable: other_value
---
...stuff in the page...
~~~
{: .source}

and inserts the values of those variables into the page when formatting it.
The three dashes that start the header *must* be the first three characters in the file:
even a single space before them will make [Jekyll][jekyll] ignore the file.

The header's content must be formatted as [YAML][yaml],
and may contain Booleans, numbers, character strings, lists, and dictionaries of name/value pairs.
Values from the header are referred to in the page as `page.variable`.
For example,
this page:

~~~
---
name: Science
---
{% raw %}Today we are going to study {{page.name}}.{% endraw %}
~~~
{: .source}

is translated into:

~~~
<html>
  <body>
    <p>Today we are going to study Science.</p>
  </body>
</html>
~~~
{: .html}

> ## Back in the Day...
>
> The previous version of our template did not rely on Jekyll,
> but instead required authors to build HTML on their desktops
> and commit that to the lesson repository's `gh-pages` branch.
> This allowed us to use whatever mix of tools we wanted for creating HTML (e.g., [Pandoc][pandoc]),
> but complicated the common case for the sake of uncommon cases,
> and didn't model the workflow we want learners to use.
{: .callout}

