---
title: "Metagenomic Cloud services"
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


## Cloud pipelines can be web or command-line based
The cloud is that place where our files lives outside from our local computers. 
There are web and command line cloud services. Through this lesson we will run a 
full example using the command line, nevertheless there are also metagenomic web 
services available. For example, MG Rast is an on line metagenomic plataform where 
you can upload your raw data with its corresponding metadata and obtain a full run
of their pipeline. MgRAST is a great resource as a public repository for your datasets. 
Although command line workflows are more flexible and adaptable to individual needs, 
automatized web servers can give us a preliminar idea of the content of our data. 
Cuatro cienegas data used in this tutorial are available at MG RAST 
as [mgp96823](https://www.mg-rast.org/mgmain.html?mgpage=project&project=mgp96823). 

## Cuatro cienegas in MgRAST  
Lets explore some of the MgRAST results to our data. First we can see the metabolic content
of our data in a metabolic piechart. Since our Cuatro Cienegas data come from a shotgun experiment, 
the distribution of the metaboliccontent of its genes can be known, even without knowin from which 
taxonomical lineage those genes are comming. Here it is shown that the genetic material of 
this sample is mainly devoted to metabolism.  

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_cog.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_cog.png" alt="Cog Metagenome" />
</a>

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_subsystems.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_subsystems.png" alt="Subsystems" />
</a>

 <a href="{{ page.root }}/fig/md-02-mgm4913055.3_predicted_features.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_predicted_features.png" alt="Predicted features" />
</a>
 
<a href="{{ page.root }}/fig/md-02-mgm4913055.3_source_hits_distribution.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_source_hits_distribution.png" alt="Source Hits" />
</a>

After metabolic features, there is some information about the taxonomixal distribution of the 
sample. First we can see that according to MgRAST the predominant taxonomic lineage of this sample is bacteria.  

<a href="{{ page.root }}/fig/md-02-mgm4913055.3_domain.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_domain.png" alt="Domain" />
</a>

 And the most abundant taxon is *Erythrobacter*. 
 <a href="{{ page.root }}/fig/md-02-mgm4913055.3_genus.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_genus.png" alt="Genus" />
</a>

Going deeply in taxonomy, we can see that the mos abundant phylum is Proteobacteria.  
<a href="{{ page.root }}/fig/md-02-mgm4913055.3_phylum.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_phylum.png" alt="Phylum" />
</a>

> ## Exercise
> 
> According to MgRAST which family is the most abundant?
> 
> 
>> ## Solution
>>  The piechart from MgRAST shows Rodhobacteraceae as the most abundant family. 
>> 
> {: .solution}
{: .challenge}


<a href="{{ page.root }}/fig/md-02-mgm4913055.3_sequence_breakdown.png">
  <img src="{{ page.root }}/fig/md-02-mgm4913055.3_sequence_breakdown.png" alt="Sequence breakdown" />
</a>



## AWS is a command line cloud server. 
The machine that you are going to use is provided by amazon web services, it is equiped with all 
command line nd metagenomic tools needed fot this workshop. Lets practice log in this service and 
copy files from your local computer to your remote instance of AWS.  

~~~
$ ssh dcuser@ec2-3-238-253-45.compute-1.amazonaws.com 
~~~
{: .bash} 

~~~
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.13.0-48-generic x86_64)                                                                                                     * 
Documentation:  https://help.ubuntu.com/                                                                                                                             
System information as of Fri Nov 27 06:29:17 UTC 2020 
~~~
{: .output}

You can ask the remote AWS machine to print working directory with `pwd` .
~~~
$ pwd 
~~~
{: .bash}
  
And it will will show you that you are in dcuser.  
~~~
$ /home/dcuser  
~~~
{: .output}

Data have been loaded for you over there
Please decompress them 

To log out from your remote machine you can use `exit`.  
~~~
$ exit
~~~
{: .bash}

If you now ask the terminal to print the working directory with `pwd` 
it will show some local directory in your local computer. 
You can copy files from you locarl to your remote machine and viceversa. 
A general guideline using the command secure copy (`scp`) would be as follows: 
~~~
$ scp <where is the file> <where you want the file to be>  
~~~
{: .output}  

For example, you have the metadata file `MGRAST _MetaData_JP.xlsx` in your remote machine. 
This file is located at the directory `/home/dcuser/dc_workshop/metadata/`.  To copy this file
into our local machine lets use `scp` command. 

~~~
$ scp dcuser@ec2-3-238-253-45.compute-1.amazonaws.com:/home/dcuser/dc_workshop/metadata/MGRAST_MetaData_JP.xlsx .
~~~
{: .data}  

~~~
MGRAST_MetaData_JP.xlsx                          100%   53KB 164.8KB/s   00:00  
~~~
{: output}  


> ## Exercise copy local files into AWS remote instance
> 
> What would be the correctsinatx to upload some local file named `APJ4_MetaData_JP.xlsx.` 
> into you AWS remote instance?
>   a) ssh dcuser@ec2-3-238-253-45.compute-1.amazonaws.com:/home/dcuser/. APJ4_MetaData_JP.xlsx.
>   b) ssh APJ4_MetaData_JP.xlsx dcuser@ec2-3-238-253-45.compute-1.amazonaws.com:/home/dcuser/.
>   c) scp APJ4_MetaData_JP.xlsx dcuser@ec2-3-238-253-45.compute-1.amazonaws.com:/home/dcuser/.
>> ## Solution
>> ~~~
>> $  scp APJ4_MetaData_JP.xlsx dcuser@ec2-3-238-253-45.compute-1.amazonaws.com:/home/dcuser/.
>> ~~~
>> {: .bash}
>> 
>> ~~~
>> {: .output}
>> 
>> c option is the only one that uses secure copy command.  
>> 
> {: .solution}
{: .challenge}




Ejercicio 2 que dicen el metadato profundidad


Ejercicio 3 Sube a tu cuenta de mgrast este metadata y tu genoma en /home/dcuse/dc_workshop/assembly/JP4DASH2120627WATERAMPRESIZED.fasta 
> ## `.discussion`
>
> 
{: .discussion}
 Open the excell file in your local computer. 
 
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

