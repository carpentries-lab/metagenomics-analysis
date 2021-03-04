
---
title: "Amplicon metagenomics"
teaching: 30
exercises: 25
questions:
- "What is amplicon metagenomics?"
- "How can I analice 16s data?"
objectives:
- "Understand the difference between shotgun and amplicon metagenomics"
- "Use a workflow to visualice 16s data"
keypoints:
- "Amplicons are fragments of DNA that will be amplified"
- "16s and ITS allow you to explore diversity in bacteria and Fungi respectively"
---

# Cleaning Reads

## Trimmomatic Options

Trimmomatic has a variety of options to trim your reads. If we run the following command, we can see some of our options.

~~~
$ trimmomatic
~~~
{: .bash}

Which will give you the following output:
~~~
Usage: 
       PE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] [-validatePairs] [-basein <inputBase> | <inputFile1> <inputFile2>] [-baseout <outputBase> | <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>] <trimmer1>...
   or: 
       SE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] <inputFile> <outputFile> <trimmer1>...
   or: 
       -version
~~~
{: .output}


> ## Bonus Exercise (Advanced)
>
> Now that our samples have gone through quality control, they should perform
> better on the quality tests run by FastQC. Go ahead and re-run
> FastQC on your trimmed FASTQ files and visualize the HTML files
> to see whether your per base sequence quality is higher after
> trimming.
>
>> ## Solution
>>
>> In your AWS terminal window do:
>>
>> ~~~
>> $ fastqc ~/dc_workshop/data/trimmed_fastq/*.fastq*
>> ~~~
>> {: .bash}
>>
>> In a new tab in your terminal do:
>>
>> ~~~
>> $ mkdir ~/Desktop/fastqc_html/trimmed
>> $ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/data/trimmed_fastq/*.html ~/Desktop/fastqc_html/trimmed
>> ~~~
>> {: .bash}
>> 
>> Then take a look at the html files in your browser.
>> 
>> Remember to replace everything between the `@` and `:` in your scp
>> command with your AWS instance number.
>>
>> After trimming and filtering, our overall quality is much higher, 
>> we have a distribution of sequence lengths, and more samples pass 
>> adapter content. However, quality trimming is not perfect, and some
>> programs are better at removing some sequences than others. Trimmomatic 
>> did pretty well though, and its performance is good enough for our workflow.
> {: .solution}
{: .challenge}

> ## `.callout`
>
> An aside or other comment.
{: .callout}

> ## `.discussion`
>
> Discussion questions.
{: .discussion}
