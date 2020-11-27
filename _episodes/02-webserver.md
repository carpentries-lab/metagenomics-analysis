---
title: "Metagenomic web services"
teaching: 5
exercises: 0
questions:
- "Checking and Previewing: How can lesson formatting be checked?"
- "How can lessons be previewed?"
objectives:
- "Run the lesson checking script and interpret its output correctly."
- "Preview a lesson locally."
keypoints:
- "Lessons are checked by running `make lesson-check`."
- "The checker uses the same Markdown parser as Jekyll."
- "Lessons can be previewed by running `make serve`."
---


## Pipelines can be web or command-line based
Through this lesson we will run a full example using the command line, nevertheless there are also metagenomic web services available. For example, MG Rast is an on line metagenomic plataform where you can upload your raw data with its corresponding metadata and obtain a full run of their pipeline. MgRAST is a great resource as a public repository for your datasets. Although command line workflows are more flexible and adaptable to individual needs, automatized web servers can give us a preliminar idea of the content of our data. Cuatro cienegas data used in this tutorial are available at MG RAST as [mgp96823](https://www.mg-rast.org/mgmain.html?mgpage=project&project=mgp96823). 


Lets explore some of the MgRAST results to our data. First we can see a metabolic piechart. Since it 
 
 <a href="{{ page.root }}/fig/md-02-mgm4913055.3_cog.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_cog.png" alt="Cog Metagenome" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_domain.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_domain.png" alt="Domain" />
</a>

 
 <a href="{{ page.root }}/fig/md-02-mgm4913055.3_genus.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_genus.png" alt="Genus" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_phylum.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_phylum.png" alt="Phylum" />
</a>

 
 <a href="{{ page.root }}/fig/md-02-mgm4913055.3_predicted_features.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_predicted_features.png" alt="Predicted features" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_sequence_breakdown.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_sequence_breakdown.png" alt="Sequence breakdown" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_source_hits_distribution.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_source_hits_distribution.png" alt="Source Hits" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_subsystems.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_subsystems.png" alt="Subsystems" />
</a>


> ## `.callout`
>
> To analize data from a metagenome experiment web and command line based strategies are available, the can complement each other.
{: .callout}


> ## `.discussion`
>
> If you have to analize data from 200 metagenomic samples which kind of strategy would you use.
{: .discussion}

