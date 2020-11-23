---
title: "Metagenome Assembly"
teaching: 30
exercises: 10
questions:
- "Formatting: How are The Carpentries lessons formatted?"
objectives:
- "Explain the header of each episode."
- "Explain the overall structure of each episode."
- "Explain why blockquotes are used to format parts of episodes."
- "Explain the use of code blocks in episodes."
keypoints:
- "Lesson episodes are stored in _episodes/dd-subject.md."
- "Each episode's title must include a title, time estimates, motivating questions, lesson objectives, and key points."
- "Episodes should not use sub-titles or HTML layout."
- "Code blocks can have the source, regular output, or error class."
- "Special sections are formatted as blockquotes that open with a level-2 header and close with a class identifier."
- "Special sections may be callouts or challenges; other styles are used by the template itself."
---


## Assembling reads



## Activating metagenomic environment  
~~~
conda activate /home/ubuntu/.conda/envs/metagenomics  
~~~
{: .code}


## Megahit options  

> ## Assembling genomes
>
> When metagenomics is shotgun instead of amplicon metagenomics an extra assembly step must be run
> [documentation](https://kramdown.gettalong.org/converter/html.html#auto-ids),
> (like [this](#linking-section-ids)). For example, the instructor might copy the link to
> the etherpad, so that the lesson opens in learners' web browser directly at the right spot.
{: .callout}


MEGAHIT is a NGS de novo assembler for assembling large and complex metagenomics data in a 
time- and cost-efficient manner.  

~~~
    megahit -1 SAMPLE_1.fastq  -2 SAMPLE_2.fastq  -m 0.5  -t 12  -o megahit_result
~~~
{: .source}



~~~
.output: ls megahit_result/final.contigs.fa
~~~
{: .output}

~~~
.error: error messages.
~~~
{: .error}


## Special Blockquotes

~~~
    megahit -1 JP4DASH2120627WATERAMPRESIZED_R1.trim.fastq.gz \
             -2 JP4DASH2120627WATERAMPRESIZED_R2.trim.fastq.gz \
             -m 0.5 -t 12 -o megahit_result 
~~~
{: .source}

~~~
2020-11-21 05:33:32 - MEGAHIT v1.2.9                                                        
2020-11-21 05:33:32 - Maximum number of available CPU thread is 2.                          
2020-11-21 05:33:32 - Number of thread is reset to the 2.                                   
2020-11-21 05:33:32 - Using megahit_core with POPCNT and BMI2 support                       
2020-11-21 05:33:32 - Convert reads to binary library                                       
2020-11-21 05:33:38 - b'INFO  sequence/io/sequence_lib.cpp  :   77 - Lib 0 (/home/dcuser/dc_workshop/data/trimmed_fastq/JP4DASH2120627WATERAMPRESIZED_R1.trim.fastq.gz,/home/dcuser/dc_workshop/data/trimmed_fastq/JP4DASH2120627WATERAMPRESIZED_R2.trim.fastq.gz): pe, 1502854 reads, 251 max length'                                                                          
2020-11-21 05:33:38 - b'INFO  utils/utils.h:152 - Real: 6.0234\tuser: 2.1600\tsys: 0.4680\tmaxrss: 160028'                          
2020-11-21 05:33:38 - k-max reset to: 141                                                   
2020-11-21 05:33:38 - Start assembly. Number of CPU threads 2                               
2020-11-21 05:33:38 - k list: 21,29,39,59,79,99,119,141                                     
2020-11-21 05:33:38 - Memory used: 2070839296                                               
2020-11-21 05:33:38 - Extract solid (k+1)-mers for k = 21                                   
2020-11-21 05:34:39 - Build graph for k = 21                                                
2020-11-21 05:35:58 - Assemble contigs from SdBG for k = 21                                 
2020-11-21 05:39:58 - Local assembly for k = 21                                             
2020-11-21 05:41:00 - Extract iterative edges from k = 21 to 29                             
2020-11-21 05:41:37 - Build graph for k = 29                                                
2020-11-21 05:42:19 - Assemble contigs from SdBG for k = 29                                 
2020-11-21 05:44:58 - Local assembly for k = 29                                             
2020-11-21 05:46:53 - Extract iterative edges from k = 29 to 39                             
2020-11-21 05:47:14 - Build graph for k = 39          
~~~
{: .bash}
                             
> ## Exercise
> 
> Ejercicio `ERR2143795/JP4DASH2120627WATERAMPRESIZED_R1.fastq ` file? How confident
> 
>> ## Solution
>> ~~~
>> $ tail 
>> ~~~
>> {: .bash}
>> 
>> ~~~
>> texto
>> ~~~
>> {: .output}
>> 
>> soluion
>> 
> {: .solution}
{: .challenge}                             
                             
{% include links.md %}
