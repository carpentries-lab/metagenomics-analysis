---
title: "Clasificación taxonómica y metabolismo"
teaching: 15 
exercises: 15
questions:
- "Cómo podemos obtener MAGs de buena calidad? " 
objectives:
- "Tener una visión global sobre como reconstruir genomas de buena calidad a partir de metagenomas"
---

## Genomas a partir de metagenomas

La metagenómica hace referencia al estudio de todo el ADN de los organismos que se encuentran en un ambiente. La secuenciación de este material genético produce lecturas que pueden ensamblarse para conocer la diversidad microbiana y sus funciones.

Típicamente los metagenomas pueden estudiarse mediante dos aproximaciones:

* La clasificación taxonómica de contigs o lecturas y la inferencia metabólica de los contigs.
* La reconstrucción de genomas a a partir de metagenomas (MAGs), clasificación taxonómica y la inferencia metabólica de los MAGs.
  
En este apartado nos enfocaremos en la segunda aproximación. Los **MAGs** se reconstruyen a partir de un **ensamble metagenómico**, los contigs de dicho ensamble se agrupan mediante la información de **cobertura y frecuencia de tetranucleótidos**. Esta agrupación puede generar errores, por lo que es indispensable evaluar la calidad de los MAGs mediante la completitud y redundancia de genes de copia única [MerenLab y col.](https://anvio.org/vocabulary/)

Para obtener MAGs podemos seguir el siguiente flujo de análisis:

<a href="{{ page.root }}/fig/extrasMAGs/01.MAGs_workflow.png">
  <img src="{{ page.root }}/fig/extrasMAGs/01.MAGs_workflow.png" alt="Flujo de trabajo para Metagenómica Centrada en Genomas" />
</a>

Ya que discutimos como seguir un flujo de análisis para reconstruir genomas entremos en acción, para ello analizaremos el metagenoma del pozol.
 
## El pozol

**El pozol** es un alimento ácido, fermentado a partir de maíz nixtamalizado, de importancia económica y cultural, 
se consume desde tiempos prehispánicos y se ha estudiado desde los años 50s.

<a href="{{ page.root }}/fig/extrasMAGs/02.Pozolhistoria.png">
  <img src="{{ page.root }}/fig/extrasMAGs/02.Pozolhistoria.png" alt="Proceso de elaboración del pozol" />
</a>

Algunos puntos importantes que conocemos son:

<FONT COLOR="blue">

-   No se inocula y al final de su fermentación tiene alta diversidad microbiana.

-   Es muy nutritivo, tiene un alto contenido de aminoácidos esenciales.

-   Es considerado como **prebiótico**, contiene fibras solubles y microorganismos benéficos para la salud intestinal humana.

</FONT>

------------------------------------------------------------------------

🧬🔊🦠 Imaginemos que se quiere impulsar la producción de esta bebida y para ello necesitan saber todo acerca de su naturaleza microbiana.

Una importante industria alimenticia los contacta como **expertos en ecología microbiana** y les pide ayuda para descubrir los siguientes puntos:

<FONT COLOR="darkblue">

-   ¿Qué actores microbianos están presentes durante el proceso de fermentación?

-   ¿Cómo ocurre la bioconversión del maíz durante la fermentación, quién participa y cómo lo hace? ¿Qué funciones metabólicas están ocurriendo?

-   ¿Cambia la comunidad microbiana a lo largo del proceso?

</FONT>

La empresa secuenció cuatro puntos de fermentación de muestras que se obtuvieron en un mercado de Tabasco. Las muestras se secuenciaron con Illumina NextSeq500 con lecturas pareadas de 75 pb. Los datos están públicos bajo el Bioproject: [PRJNA648868](https://www.ebi.ac.uk/ena/browser/view/PRJNA648868)

<a href="{{ page.root }}/fig/extrasMAGs/03.Pozol_fermentation.png">
  <img src="{{ page.root }}/fig/extrasMAGs/03.Pozol_fermentation.png" alt="Puntos de fermentación" />
</a>


> ## Importante
>
> Como las muestras contienen maíz, es indispensable remover las lecturas que correspondan a su genoma,
> no hacerlo producirá un ensamble muy fragmentado, mayoritariamente del maíz y poco microbiano.

> El autor del artículo amablemente nos proporcionó sus muestras libres del maíz y el código que usó
> para ello está disponible en un repositorio público de [GitHub](https://github.com/RafaelLopez-Sanchez/pozol_shotgun).
> 
> El artículo: López-Sánchez et al., 2023. Analysing the dynamics of the bacterial community in pozol,
> a Mexican fermented corn dough. [10.1099/mic.0.001355](https://www.microbiologyresearch.org/content/journal/micro/10.1099/mic.0.001355) 
{: .importante}


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
