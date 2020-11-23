---
title: "Taxonomic Assignation"
teaching: 30
exercises: 15
questions:
- "How can I assign a taxonomy to my contigs?"
objectives:
- "Understand how taxonomic assignation works"
keypoints:
- "A database with previous knowledge is needed for taxonomic assignation"
- "Kraken2 is a program for taxonomic assignation"
---

¿How does taxonomic assignators work?

https://github.com/DerrickWood/kraken2/wiki/Manual#installation   
https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html  
https://www.biostars.org/p/221964/  

~~~
kraken2 
~~~
{: .code}

kraken 
~~~
C	k141_0	1365647	416	0:1 1365647:5 2:5 1:23 0:348
U	k141_1411	0	411	0:377
U	k141_1	0	425	0:391
C	k141_1412	1484116	478	0:439 1484116:3 0:2
C	k141_2	72407	459	0:350 2:3 0:50 2:6 72407:5 0:3 72407:2 0:6
U	k141_1413	0	335	0:301
U	k141_3	0	302	0:268
C	k141_1414	2072936	347	0:138 2:5 1224:5 2:5 0:33 252514:1 0:121 2072936:5
U	k141_4	0	447	0:413
U	k141_5	0	303	0:269
U	k141_1415	0	443	0:409
U	k141_1416	0	304	0:270
C	k141_6	1	413	1:379

~~~
{: .output}

kraken report  
~~~
 62.10	1748	1748	U	0	unclassified
 37.90	1067	8	R	1	root
 37.48	1055	0	R1	131567	  cellular organisms
 37.48	1055	33	D	2	    Bacteria
 27.99	788	40	P	1224	      Proteobacteria
 17.05	480	32	C	28211	        Alphaproteobacteria
  6.32	178	16	O	356	          Rhizobiales
  1.17	33	1	F	41294	            Bradyrhizobiaceae
  0.75	21	4	G	374	              Bradyrhizobium
  0.11	3	3	S	114615	                Bradyrhizobium sp. ORS 278
  0.07	2	2	S	722472	                Bradyrhizobium lablabi
  0.07	2	2	S	2057741	                Bradyrhizobium sp. SK17
  0.07	2	2	S	1437360	                Bradyrhizobium erythrophlei
~~~
{: .output}

## Visualization of taxonomic assignation results  
[Krona](https://github.com/marbl/Krona/wiki) is a hierarchical data visualization software. Krona allows data to be explored with zooming, multi-layered pie charts and includes support for several bioinformatics tools and raw data formats. 

~~~
krona updateTaxonomy.sh
~~~

~~~
cut -f2,3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken >  krona.input
ktImportTaxonomy krona.input -o krona.out.html
scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/results/krona*html . 
~~~
:{ .bash}


~~~
grep -v $'\t'0 krona.input >krona.input2  
ktImportTaxonomy krona.input2 -o krona2.out.html
scp dcuser@ec2-3-235-238-92.compute-1.amazonaws.com:~/dc_workshop/results/krona*html . 
~~~
:{ .bash}

~~~
cut -f2,3 JP4DASH2120627WATERAMPRESIZED_kraken.kraken >  krona.input
ktImportTaxonomy krona.input -o krona.out.html
~~~
:{ .bash}


<a href="{{ page.root }}/fig/snapshot.svg">
  <img src="{{ page.root }}/fig/snapshot.svg" alt="Krona Visualization" />
</a>

Kraken, Centrifuge and MetaPhlAn. Pavian should be locally installed using R and Shiny, but we can try the [Pavian demo WebSite](https://fbreitwieser.shinyapps.io/pavian/) to visualize our results.  

<a href="{{ page.root }}/fig/uploadPavian.PNG">
  <img src="{{ page.root }}/fig/uploadPavian.PNG" alt="upload Pavian" />
</a>

<a href="{{ page.root }}/fig/sample.PNG">
  <img src="{{ page.root }}/fig/sample.PNG" alt="sample" />
</a>

<a href="{{ page.root }}/fig/SampleSelected.PNG">
  <img src="{{ page.root }}/fig/SampleSelected.PNG" alt="Sample Selected" />
</a>

<a href="{{ page.root }}/fig/Comparison.PNG">
  <img src="{{ page.root }}/fig/Comparison.PNG" alt="Comparison" />
</a>

{% include links.md %}
