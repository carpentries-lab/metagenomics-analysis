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

Next, lets visualize the first read of one of the files by the next commando:

$ head -n 4 FB1NV1SS26_S4_L001_R1.fastq

Output
@FB1NV1SS26_S4_L001_R1 HWI-ST957:244:H73TDADXX:1:1101:4712:2181/1
TTCACATCCTGACCATTCAGTTGAGCAAAATAGTTCTTCAGTGCCTGTTTAACCGAGTCACGCAGGGGTTTTTGGGTTACCTGATCCTGAGAGTTAACGGTAGAAACGGTCAGTACGTCAGAATTTACGCGTTGTTCGAACATAGTTCTG
+
CCCFFFFFGHHHHJIJJJJIJJJIIJJJJIIIJJGFIIIJEDDFEGGJIFHHJIJJDECCGGEGIIJFHFFFACD:BBBDDACCCCAA@@CA@C>C3>@5(8&>C:9?8+89<4(:83825C(:A#########################

At first,  the information displayed can be overwhelming, although it is complicated, the fastq format can be decoded by hoarding knowledge regarding its main characteristics, the code lines which composed this type of files are the following:
The first line always begins with a “@” and this specified information regarding the equipment used for the generation of the reads
The nucleotide information
A separation line that begins with a “+” symbol and sometimes brings the same information as in line 1.
A string of characters representing the quality score where each character corresponds to the quality of its respective nucleotide.

Line 4 shows the quality of each nucleotide in the read. To make it possible that only one character corresponds to one base, the numerical score is converted into a code where each character equals the numerical quality score between 0 and 41. The numerical value of each character depends in the sequencing platform that generates the reads and is the result of the base-calling algorithm which depend how much signal was captured in the base incorporation. For the most used Illumina version 1.8 and onwards the assignation is as follows:

Quality encoding: !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ
                   |         |         |         |         |
Quality score:    01........11........21........31........41   
 

This probability can be interpreted as a base-calling error probability or the base call accuracy. So for example, a nucleotide with a base with a score of 10 will means a probability of base call of 1 in 10:

Phred Error-rate     Accuracy
 10 	1 of 10        90%   	 # very low quality
 20 	1 of 100 	   99%   	 # minimum quality for many tools
 30 	1 of 1000      99.9% 	 # reasonable good quality
 40 	1 of 10000     99.99%	 # high quality
 50 	1 of 100000    99.999%   # very high quality

Returning to the first read of the FB1NV1SS26_S4_L001_R1.fastq file:

$ head -n 4 FB1NV1SS26_S4_L001_R1.fastq

Output
@FB1NV1SS26_S4_L001_R1 HWI-ST957:244:H73TDADXX:1:1101:4712:2181/1
TTCACATCCTGACCATTCAGTTGAGCAAAATAGTTCTTCAGTGCCTGTTTAACCGAGTCACGCAGGGGTTTTTGGGTTACCTGATCCTGAGAGTTAACGGTAGAAACGGTCAGTACGTCAGAATTTACGCGTTGTTCGAACATAGTTCTG
+
CCCFFFFFGHHHHJIJJJJIJJJIIJJJJIIIJJGFIIIJEDDFEGGJIFHHJIJJDECCGGEGIIJFHFFFACD:BBBDDACCCCAA@@CA@C>C3>@5(8&>C:9?8+89<4(:83825C(:A#########################

It is evident that the nucleotides in the read have a range of quality scores, and that there are sites of the read where the sequence has poor results (i.e. #=02)

Assessing quality using FastQC

It will be a sisyphean task to evaluate manually the quality of all the reads inside a single file. Luckily there are programs contrived to assess the read quality in order to decide which of them can be keeped or discarded. The canonical program for the evaluation and visualization of read quality is FastQC. By providing a summary of the different characteristics of the reads, FastQC gives information regarding issues like quality, %GC, presence of adapters, among others that will be helpful to consider before moving forward with other analyses. Let's take a look at the different options that the program FastQC offers:

$ fastqc -h

Output
           FastQC - A high throughput sequence QC analysis tool

SYNOPSIS

        fastqc seqfile1 seqfile2 .. seqfileN

    fastqc [-o output dir] [--(no)extract] [-f fastq|bam|sam]
           [-c contaminant file] seqfile1 .. seqfileN

DESCRIPTION

    FastQC reads a set of sequence files and produces from each one a quality
    control report consisting of a number of different modules, each one of
    which will help to identify a different potential type of problem in your
    data.

    If no files to process are specified on the command line then the program
    will start as an interactive graphical application.  If files are provided
    on the command line then the program will run with no user interaction
    required.  In this mode it is suitable for inclusion into a standardised
    analysis pipeline.

    The options for the program as as follows:

    -h --help       Print this help file and exit

    -v --version    Print the version of the program and exit

    -o --outdir     Create all output files in the specified output directory.                                                                                    
                    Please note that this directory must exist as the program
                    will not create it.  If this option is not set then the
                    output file for each sequence file is created in the same
                    directory as the sequence file which was processed.

    --casava        Files come from raw casava output. Files in the same sample
                    group (differing only by the group number) will be analysed
                    as a set rather than individually. Sequences with the filter
                    flag set in the header will be excluded from the analysis.
                    Files must have the same names given to them by casava
                    (including being gzipped and ending with .gz) otherwise they
                    won't be grouped together correctly.

    --nano          Files come from naopore sequences and are in fast5 format. In
                    this mode you can pass in directories to process and the program
                    will take in all fast5 files within those directories and produce
                    a single output file from the sequences found in all files.

    --nofilter      If running with --casava then don't remove read flagged by
                    casava as poor quality when performing the QC analysis.

    --extract       If set then the zipped output file will be uncompressed in
                    the same directory after it has been created.  By default
                    this option will be set if fastqc is run in non-interactive
                    mode.

    -j --java       Provides the full path to the java binary you want to use to
                    launch fastqc. If not supplied then java is assumed to be in
                    your path.

    --noextract     Do not uncompress the output file after creating it.  You
                    should set this option if you do not wish to uncompress
                    the output when running in non-interactive mode.

    --nogroup       Disable grouping of bases for reads >50bp. All reports will
                    show data for every base in the read.  WARNING: Using this
                    option will cause fastqc to crash and burn if you use it on
                    really long reads, and your plots may end up a ridiculous size.
                    You have been warned!

    -f --format     Bypasses the normal sequence file format detection and
                    forces the program to use the specified format.  Valid
                    formats are bam,sam,bam_mapped,sam_mapped and fastq

    -t --threads    Specifies the number of files which can be processed
                    simultaneously.  Each thread will be allocated 250MB of
                    memory so you shouldn't run more threads than your
                    available memory will cope with, and not more than
                    6 threads on a 32 bit machine

    -c              Specifies a non-default file which contains the list of
    --contaminants  contaminants to screen overrepresented sequences against.
                    The file must contain sets of named contaminants in the
                    form name[tab]sequence.  Lines prefixed with a hash will
                    be ignored.

    -a              Specifies a non-default file which contains the list of
    --adapters      adapter sequences which will be explicity searched against
                    the library. The file must contain sets of named adapters
                    in the form name[tab]sequence.  Lines prefixed with a hash
                    will be ignored.
	
    -l              Specifies a non-default file which contains a set of criteria
    --limits        which will be used to determine the warn/error limits for the
                    various modules.  This file can also be used to selectively
                    remove some modules from the output all together.  The format
                    needs to mirror the default limits.txt file found in the
                    Configuration folder.

   -k --kmers       Specifies the length of Kmer to look for in the Kmer content
                    module. Specified Kmer length must be between 2 and 10. Default
                    length is 7 if not specified.

   -q --quiet       Supress all progress messages on stdout and only report errors.

   -d --dir         Selects a directory to be used for temporary files written when
                    generating report images. Defaults to system temp directory if
                    not specified.

BUGS

    Any bugs in fastqc should be reported either to simon.andrews@babraham.ac.uk
    or in www.bioinformatics.babraham.ac.uk/bugzilla/

If an error like this is displayed in place of the above lines, FastQC is not installed or is incorrectly installed:

The program 'fastqc' is currently not installed. You can install it by typing:
sudo apt-get install fastqc

Check with your instructor before you proceed.

As it is displayed at the begging, several files can be examined in a single run; the -o flag is used to indicate where the output files will be delivered; the -f parameter is useful if your files are in other format then fastq; other flags as --contaminants and --adapters are used to so the program can locate a priori undesirable strings in the reads; and parameters like --threads, --noextract, among others, are useful to instruct the program to obtain a desired output.  
