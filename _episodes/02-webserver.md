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

 > ## Exercise
> 
> Which phylum is more abundant?
> 
> 
>> ## Solution
>> ~~~
>> $ head metadata
>> ~~~
>> {: .bash}
>> 
>> ~~~
>> $linea 1
>>##########################################################################          
>> ~~~
>> {: .output}
>> 
>> This read has more consistent quality at its first than at the end
>> but still has a range of quality scores, 
>> most of them low. We will look at variations in position-based quality
>> in just a moment.
>> 
> {: .solution}
{: .challenge}

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

## AWS is a command line cloud server. 
The machine that you are going to use is provided by amazon web services, it is equiped with all 
command line nd metagenomic tools needed fot this workshop. Lets practice log in this service and 
copy files from your local computer to your remote instance of AWS.  

~~~
$ ssh dcuser@ec2-3-238-253-45.compute-1.amazonaws.com 
~~~
:{} 

~~~
$ pwd 
~~~
{: .bash}

~~~
$ /home/dcuser  
~~~
{: .output}


~~~
$ exit
$pwd
~~~
{: .bash}

~~~
$ /myadress
~~~
{: .output}

~~~
$ scp adress :/home/dcuser/execll .
~~~
{: .output}

 Open the excell file 
 
> ## Exercise copy local files into remote instance
> 
> What is the last read in the `JP4DASH2120627WATERAMPRESIZED_R1.fastq ` file? How confident
> are you in this read? 
> 
>> ## Solution
>> ~~~
>> $ tail -n 4 JP4DASH2120627WATERAMPRESIZED_R1.fastq
>> ~~~
>> {: .bash}
>> 
>> ~~~
>>@MISEQ-LAB244-W7:156:000000000-A80CV:1:2114:17866:28868 1:N:0:CTCAGA
>>
>>CCCGTTCTCCACCTCGGCGCGCGCCAGCTGCGGCTCGTCCTTCCACAGGAACTTCCACGTCGCCGTCAGCCGCGACACGTTCTCCCCCCTCGCATGCTCGTCCTGTCTCTCGTGCTTGGCCGACGCCTGCGCCTCGCACTGCGCCCGCTCGGTGTCGTTCATGTTGATCTTCACCGTGGCGTGCATGAAGCGGTTCCCGGCCTCGTCGCCACCCACGCCATCCGCGTCGGCCAGCCACTCTCACTGCTCGC
>>
>>+
>>
>>AA11AC1>3@DC1F1111000A0/A///BB#############################################################################################################################################################################################################################          
>> ~~~
>> {: .output}
>> 
>> This read has more consistent quality at its first than at the end
>> but still has a range of quality scores, 
>> most of them low. We will look at variations in position-based quality
>> in just a moment.
>> 
> {: .solution}
{: .challenge}


> ## `.callout`
>
> To analize data from a metagenome experiment web and command line based strategies are available, the can complement each other.
{: .callout}


> ## `.discussion`
>
> If you have to analize data from 200 metagenomic samples which kind of strategy would you use.
{: .discussion}

