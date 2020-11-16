---
title: "Assessing Read Quality"
teaching: 30
exercises: 15
questions:
- "How can the quality of a sequencing process be evaluated? "
- "It is possible to know if my sequenced organisms are the desired ones? "
objectives:
- "Explain how it is possible to measure the quality from a fastq file"  
- "Learn the main tool to evaluate reads quality: FastQC"  
- "Interpret a FastQC output."  

keypoints:
- "Lessons are stored in Git repositories on GitHub."
- "Lessons are written in Markdown."
- "Jekyll translates the files in the gh-pages branch into HTML for viewing."
- "The site's configuration is stored in _config.yml."
- "Each page's configuration is stored at the top of that page."
- "Groups of files are stored in collection directories whose names begin with an underscore."
---

As was remarked by Plato among other philosophers, it is important to be intertwined 
in a process to unravel all the essential details concerning the desired results. 
In this sense, the second step in working with high-throughput sequencing data is
to evaluate how accurate the sequencer worked in generating the desired information. 
The location of the assessment of quality inside a metagenome workflow is exampled 
in the next picture (Figure 1)  

## Repositories on GitHub
Hans on the data
What a sequencing process will deliver are raw reads: sets of files in “fastq” format (i.e the file name will end with a “.fastq” label):

FB1NV1SS26_S4_L001_R1.fastq.gz
FB1NV1SS26_S4_L001_R2.fastq.gz
FB1NV1SS26_S4_L002_R1.fastq.gz
FB1NV1SS26_S4_L002_R2.fastq.gz
FB1NV1SS26_S4_L003_R1.fastq.gz
FB1NV1SS26_S4_L003_R2.fastq.gz
FB1NV1SS26_S4_L004_R1.fastq.gz
FB1NV1SS26_S4_L004_R2.fastq.gz

Is commun that the files are in a compress format, which is why all the files end with “.gz” making them faster to transfer and easy to handle. To uncompress these files the gunzip command will be used as follows:

~~~
    $ gunzip FB1NV1SS26_S4_L001_R1.fastq.gz
~~~
{: .source}

~~~
    $ FB1NV1SS26_S4_L001_R1.fastq
~~~
{: .output}


There is an option to decompress all the files in a folder that share a combination of strings in their file names:

~~~
   $ gunzip *.fastq.gz
   $ ls
~~~
{: .source}


 Here the rest of the files that have “.fastq.gz” at the end of their names will be decompressed

~~~
FB1NV1SS26_S4_L001_R2.fastq
FB1NV1SS26_S4_L002_R1.fastq
FB1NV1SS26_S4_L002_R2.fastq
FB1NV1SS26_S4_L003_R1.fastq
FB1NV1SS26_S4_L003_R2.fastq
FB1NV1SS26_S4_L004_R1.fastq
FB1NV1SS26_S4_L004_R2.fastq
~~~
{: .output}

> ## Why Doesn't My Site Appear?
>
> If the root directory of a repository contains a file called `.nojekyll`,
> GitHub will *not* generate a website for that repository's `gh-pages` branch.
{: .callout}
