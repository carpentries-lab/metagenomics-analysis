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
**El pozol** es un alimento ácido, fermentado a partir de maíz nixtamalizado, de importancia económica y cultural, se consume desde tiempos prehispánicos y se ha estudiado desde los años 50s.

Algunos puntos importantes que conocemos son:

<FONT COLOR="blue">

-   No se inocula y al final de su fermentación tiene alta diversidad microbiana.

-   Es muy nutritivo, tiene un alto contenido de aminoácidos esenciales.

-   Es considerado como **prebiótico,** contiene fibras solubles y microorganismos benéficos para la salud intestinal humana**.**

</FONT>
## On Metadata

Once we have chosen an adequate methodology for our study, 
we must take extensive notes on the origin of our samples and how we treated them. These notes constitute the **metadata**, or data about our data, 
and they are crucial to understanding and interpreting the results we will obtain later in our metagenomic analysis. Most of the time, 
the differences that we observe when comparing metagenomes can be 
correlated to the metadata, which is why we must devote a whole section 
of our experimental design to the metadata we expect to collect and record carefully. 

> ## Discussion #1: 1.  Responde
>
> ¿Cuántos bins se formaron? 
> ¿Qué parámetros cambiarías o agregarías? 
> 
>> ## Solution
>> 1.  `ls results/04.metabat/`
>> 2.  `metabat2 –-help`
> {: .solution}  
{: .discussion}

## Cuatro Ciénegas  
<a href="{{ page.root }}/fig/03-01-02.jpeg">
  <img src="{{ page.root }}/fig/03-01-02.jpeg" alt="Photography of a pond in Cuatro Ciénegas" />
</a>

> ## Quality of large datasets
>
> Explore [MultiQC](https://multiqc.info/) if you want a tool that can show the quality of many samples at once.
{: .callout}


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

~~~
conda deactivate
~~~
{: .bash}

~~~
@MISEQ-LAB244-W7:156:000000000-A80CV:1:1101:12622:2006 1:N:0:CTCAGA
~~~
{: .output}
