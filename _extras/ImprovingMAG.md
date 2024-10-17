---
title: "Starting a Metagenomics Project"
teaching: 15 
exercises: 15
questions:
- "How do you plan a metagenomics experiment?" 
objectives:
- "Learn the differences between shotgun and metabarcoding (amplicon metagenomics) techniques."
keypoints:    
- "Shotgun metagenomics can be used for taxonomic and functional studies." 
- "Metabarcoding can be used for taxonomic studies."
---

## Metagenomics 
Metagenomes are collections of genomic 
sequences from various (micro)organisms that coexist in any 
given space. They are like snapshots that can give us information 
about the taxonomic and even metabolic or functional composition 
of the communities we decide to study. Thus, metagenomes 
are usually employed to investigate the ecology of defining 
charac
## On Metadata

Once we have chosen an adequate methodology for our study, 
we must take extensive notes on the origin of our samples and how we treated them. These notes constitute the **metadata**, or data about our data, 
and they are crucial to understanding and interpreting the results we will obtain later in our metagenomic analysis. Most of the time, 
the differences that we observe when comparing metagenomes can be 
correlated to the metadata, which is why we must devote a whole section 
of our experimental design to the metadata we expect to collect and record carefully. 

> ## Discussion #1: Choosing amplicon or shotgun sequencing? 
>
> Suppose you want to find the source of a nasty gut infection in people. Which type of sequencing methodology would you choose?  
> Which type of metadata would be helpful to record?
> 
>> ## Solution
>> For a first exploration, 16S is a better idea since you could detect known pathogens by knowing the taxons in the community.
>> Nevertheless, if the disease is the consequence of a viral infection, the pathogen can only be discovered with shotgun metagenomics (that was the case of SARS-CoV 2). 
>> Also, metabarcoding does not provide insights into the genetic basis of the pathogenic phenotypes.
>> Metadata will depend on the type of experiment. For this case, some helpful metadata could be sampling methodology, 
>> date, place (country, state, region, city, etc.), patient's sex and age, the anatomical origin of the sample, symptoms, medical history, diet, lifestyle, and environment. 
>> 
> {: .solution}  
{: .discussion}

## Cuatro Ciénegas  
<a href="{{ page.root }}/fig/03-01-02.jpeg">
  <img src="{{ page.root }}/fig/03-01-02.jpeg" alt="Photography of a pond in Cuatro Ciénegas" />
</a>


> ## Exercise 1: Reviewing metadata 
> 
> According to the results described for this CCB study.
> 1. What kind of sequencing method do you think they used, and why do you think so?  
>  A) Metabarcoding   
>  B) Shotgun metagenomics   
>  C) Genomics of axenic cultures  
>
>  2. In the table [samples treatment information](https://github.com/carpentries-incubator/metagenomics/blob/gh-pages/files/Samples_treatment_information.tsv), what was the most critical piece of metadata that the authors took?  
> 
>> ## Solution
>> A) Metabarcoding. False. With this technique, usually, only one region of the genome is amplified.   
>> B) Shotgun Metagenomics. True. Only shotgun metagenomics could have been used to investigate the total number of tRNA genes.    
>> C) Genomics of axenic cultures. False. Information on the microbial community cannot be fully obtained with axenic cultures.    
>>  
>> The most crucial thing to know about our data is which community was and was not supplemented with fertilizers.  
>> However, any differences in the technical parts of the study, such as the DNA extraction protocol,
>> could have affected the results, so tracking those is also essential.
>> 
> {: .solution}
{: .challenge}
