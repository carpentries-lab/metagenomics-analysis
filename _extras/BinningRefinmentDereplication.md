---
title: "Binning, Refinamiento y Desreplicación"
teaching: 2 h 
exercises: 3 h
questions:
- "Cómo podemos obtener MAGs de buena calidad?"
- "Cómo eliminamos redundancia?" 
objectives:
- "Obtener MAGs no redundantes de buena calidad"
keypoints:
- "Usar más de un programa de binning aumenta la probabilidad de agrupar más genomas"
- "Conjuntar y refinar los bins es esencial para aumentar la calidad de los genomas"
- "Eliminar redundancia genómica es necesario para describir bien la comunidad microbiana"
---

## Mapeo

En los [días anteriores](https://carpentries-lab.github.io/metagenomics-analysis/) aprendieron a evaluar la calidad de las lecturas, filtrarlas y ensamblarlas, por lo que este apartado comenzará con un ensamble ya generado.

De acuerdo con el flujo de análisis (Figura 1), debemos partir de un ensamble, mapear las lecturas y obtener un archivo de profundidad de cada contig en el ensamble.
<br>

> ## Archivos de profundidad
> El proceso de mapeo es demandante en tiempo de ejecución y recursos. Así que nos dimos a la tarea de generar el archivo de profundidad para comenzar directamente con el *binning*.
>
> El mapeo lo corrimos con [bowtie2](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#introduction) que es una herramienta confiable
> y muy utilizada para alinear lecturas cortas a una referencia, en nuestro caso, la referencia es el ensamble metagenómico de la muestra de 48hrs.
> Bowtie2 genera un archivo de mapeo (SAM) que debe convertirse a un formato binario (BAM), para esta conversión usamos [samtools](https://github.com/samtools/) que contiene multiples subherramientas para trabajar con archivos de mapeos.
> Para generar este archivo se utilizaron las siguientes lineas de código.
>> ~~~
>> # Formatear el ensamble
>> bowtie2-build results/02.ensambles/megahit/48hrs/48hrs.fasta results/03.profundidad/48hrs --threads 40
>> # Mapear las lecturas contra el ensamble
>> bowtie2 -x results/03.profundidad/48hrs -1 data/48hrs_sm_R1.fastq -2 data/48hrs_sm_R2.fastq -p 40 -S results/03.profundidad/48hrs.sam
>> # Convertir de SAM a BAM y ordenar
>> samtools view -Sb -O BAM -@ 40 results/03.profundidad/48hrs.sam | samtools sort -@ 40  -o results/03.profundidad/48hrs_sorted.bam
>> # Obtener el índice
>> samtools index results/03.profundidad/48hrs_sorted.bam
>> ~~~
>> {: .bash}
>>
>> Ya que generamos el archivo bam ordenado y el índice, obtuvimos un archivo con la información de cobertura de cada contig dentro del ensamble,
>> este **archivo de profundidad** se generó con `jgi_summarize_bam_contig_depths` que es una herramienta desarrollada por el JGI.
>>
>> ~~~
>> # Obtener el archivo de profundidad de cada contig
>> jgi_summarize_bam_contig_depths  --outputDepth results/03.profundidad/48hrs.mgh_depth.txt results/03.profundidad/48hrs_sorted.bam
>> ~~~
>> {: .bash}
> {: .callout}
>
> No las ejecutes, sólo son un ejemplo para que las puedas usar con tus propios datos en el futuro.
{: .callout}
<br>

> ## Ejercicio 1. ¿Qué información requieren los programas de binning? 
> Antes de comenzar, reúnete con tu equipo y juntos:
> * Revisen nuevamente el contenido de los directorios `02.ensambles` y `03.profundidad.txt`
> * En una diapositiva expliquen el `flujo teórico` que se siguió para obtener los archivos que están en esos directorios.
> Usa [esta](https://drive.google.com/drive/folders/1rg-zjuASg9D-goa2SlL3HXalqj3BQFNX?usp=sharing) liga de drive para ir trabajando durante el taller.
> Sólo un miembro de cada equipo escriba en la presentación
{: .challenge}

------------------------------------------------------------------------
## Binning

🧬 Ahora si, vamos a agrupar los contigs del metaensamble en *bins* ...

### Metabat2

[Metabat2](https://bitbucket.org/berkeleylab/metabat/src/master/) es una herramienta que agrupa los contigs tomando la cobertura de cada contig y calcula su composición nucleotídica.

<p style="text-align: center;">
  <a href="https://doi.org/10.7717/peerj.1165" target="_blank">
    <img src="{{ page.root }}/fig/extrasMAGs/04.Metabat.png" alt="Metabat2. Kang et al., 2015. DOI:10.7717/peerj.1165" width="573" />
  </a>
  <br>
  <em>Metabat2. Kang et al., 2015. DOI:10.7717/peerj.1165</em>
</p>
<br>
Para correr metabat necesitamos activar el [ambiente conda](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment) donde se aloja.
~~~
conda activate binning
~~~
{: .bash}
<br>
Ahora que ya tenemos el ambiente activado ejecutemos metabat:
~~~
metabat2 -i results/02.ensambles/48hrs.fasta -a results/03.profundidad/48hrs.mgh_depth.txt -o results/04.metabat/metabat -t 4 -m 1500 -seed 123
~~~
{: .bash}

Se sabe que el valor mínimo de contig para reducir errores es 2000, lo puedes ver en la [figura 6 de este artículo](https://static-content.springer.com/esm/art%3A10.1038%2Fnmeth.3103/MediaObjects/41592_2014_BFnmeth3103_MOESM187_ESM.pdf).

> ## Responde
> ¿Cuántos bins se formaron?
> ¿Qué parámetros cambiarías o agregarías?
>> ## Solución 
>> `ls results/04.metabat/`
>> `metabat2 –-help`
> {: .solution}
{: .challenge}

Ya que corrimos Metabat2 vamos a ejecutar MaxBin2, pero primero necesitamos desactivar el ambiente:
~~~
conda deactivate
~~~
{: .bash}


### MaxBin2

[MaxBin2](https://sourceforge.net/projects/maxbin/files/) agrupa los contigs de acuerdo a la información de cobertura, composición nucleotídica y genes **de marcadores de copia única**.

Vamos a ejecutarlo, activemos el [ambiente conda](#0) para maxbin.

::: callout-caution
## Activar ambiente para MaxBin2

-   betterlab

    ``` bash
    conda activate metagenomics
    ```
:::

[![MaxBin2. Wu et al., 2014. https://doi.org/10.1186/2049-2618-2-26](Figures/03.Maxbin.png){width="371"}](https://doi.org/10.1186/2049-2618-2-26)

Crea el directorio para los resultados de MaxBin2

``` bash
mkdir -p results/05.maxbin
```

Ahora si, vamos a ejecutarlo.

``` bash

run_MaxBin.pl -thread 4 -min_contig_length 1500 -contig results/02.ensambles/48hrs.fasta -out results/05.maxbin/48hrs_maxbin -abund results/03.profundidad/48hrs.mgh_depth.txt
```

::: {.callout-important collapse="true" title="Ejercicio:"}
1\. ¿Cuántos bins se formaron?

2\. ¿Qué porcentaje de completitud tienen??

::: {.callout-tip collapse="true" title="Solución"}
1.  `ls results/05.maxbin/*.fasta | wc -l`
2.  `cat results/05.maxbin/48hrs_maxbin.summary | column -t`
:::
:::

::: callout-caution
## Desactiva el ambiente

``` bash
conda deactivate
```
:::

### Vamb

[VAMB](https://vamb.readthedocs.io/en/latest/) utiliza una combinación de enfoques de aprendizaje profundo y técnicas de agrupamiento basándose en sus patrones de composición de nucleótidos y en la co-ocurrencia de sus frecuencias de cobertura.

::: callout-caution
## Activa el ambiente binning

-   betterlab

    ``` bash
    conda activate binning
    ```
:::

Vamos a correr vamb, pero primero crea el directorio de resultados

``` bash
mkdir -p results/06.vamb
```

Ejecutemos vamb:

``` bash
vamb --fasta results/02.ensambles/48hrs.fasta --jgi results/03.profundidad/48hrs.mgh_depth.txt --minfasta 500000 --outdir results/06.vamb/48hrs
```

::: callout-important
Si quisieras recuperar los genomas de virus ¿Qué parámetro cambiarías?
:::

::: callout-tip
## Otros programas para binning

Recientemente se publicó COMEBin, que utiliza un enfoque distinto a lo que hemos usado en este tutorial. En el siguiente [link](https://github.com/ziyewang/COMEBin) encontrarás el manual y una explicación general sobre su funcionamiento.
:::


> ## 🧠 Para tenerlo presente
> En bioinformática cualquier línea de comandos generará un resultado, de ahí a que esos resultados sean correctos puede haber una gran diferencia.
> En cada paso detente a revisar la información de cada programa, lee el manual, visita foros de ayuda y selecciona los argumentos que se ajusten a las necesidades de tus datos.
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
