---
title: "MAGs"
teaching: 10
exercises: 0
questions:
- "Style Guide: How are keyboard key combinations written?"
objectives:
- "Explain how a genome is reconstructed from a metagenome"
keypoints:
- "Keyboard keys need to use `<kbd>` HTML tag."
---
## Bining 
As the contigs that we obtain from the assembly come from different species, 
it is necessary to separate them by species to be able to analyze each species 
individually. This process is called binning.  

We can do binning based on the taxonomic assignment, or using characteristics 
of the contigs, such as their GC content, coverage or the use of tetranucleotides.

Binning dependent on taxonomy is relatively trivial, but there are different algorithms 
for binning independent of taxonomy. These algorithms can be based on composition or abundance,
Maxbin is a binning algorithm with an hybrid composition-abundance approach.  

> ## Bining strategies `.callout`
>
> Reads can be assembled into contigs according to two main strategies: composition and abbundance.
> Many binning algorithms uses a combination of both strategies.  
{: .callout}

## MAGs (Metagenome Assembly Genome)  
After doing the binning we can assemble MAGs, either by putting together the contigs 
that correspond to a single species or using the reads that were used to assemble 
those contigs to reassemble a genome using a traditional assembler
The quality of a MAG is highly dependent on the size of the genome of the species, 
its abundance in the community, and the depth at which we sequence. Anvio is a good program to see the quality of our MAGs
 
|-------------------+--------------------------------------------------------------------+--------------------------|
|   Keyboard key    |                             Style Note                             |         Example          |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Letters      |                          Always capital.                           |      `<kbd>A</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Numbers      |                                                                    |      `<kbd>1</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|  Punctuation mark |                                                                    |      `<kbd>*</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|     Function      |                 Capital F followed by the number.                  |     `<kbd>F12</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|        Alt        |                     Only first letter capital.                     |     `<kbd>Alt</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|     Backspace     |                     Only first letter capital.                     |  `<kbd>Backspace</kbd>`  |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Command      |                     Only first letter capital.                     |   `<kbd>Command</kbd>`   |
|-------------------+--------------------------------------------------------------------+--------------------------|
|       Ctrl        |                     Only first letter capital.                     |    `<kbd>Ctrl</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Delete       |                     Only first letter capital.                     |   `<kbd>Delete</kbd>`    |
|-------------------+--------------------------------------------------------------------+--------------------------|
|        End        |                     Only first letter capital.                     |     `<kbd>End</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|        Esc        |                     Only first letter capital.                     |     `<kbd>Esc</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|       Home        |                     Only first letter capital.                     |    `<kbd>Home</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Insert       |                     Only first letter capital.                     |   `<kbd>Insert</kbd>`    |
|-------------------+--------------------------------------------------------------------+--------------------------|
|     Page Down     |                            Use "PgDn".                             |    `<kbd>PgDn</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Page Up      |                            Use "PgUp".                             |    `<kbd>PgUp</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|   Print Screen    |                           Use "PrtScr".                            |   `<kbd>PrtScr</kbd>`    |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Return       |   Only first letter capital. We use "Return" instead of "Enter".   |   `<kbd>Return</kbd>`    |
|-------------------+--------------------------------------------------------------------+--------------------------|
|       Shift       |                     Only first letter capital.                     |    `<kbd>Shift</kbd>`    |
|-------------------+--------------------------------------------------------------------+--------------------------|
|      Spacebar     |                     Only first letter capital.                     |  `<kbd>Spacebar</kbd>`   |
|-------------------+--------------------------------------------------------------------+--------------------------|
|        Tab        |                     Only first letter capital.                     |     `<kbd>Tab</kbd>`     |
|-------------------+--------------------------------------------------------------------+--------------------------|
|    Down arrow     |               Use Unicode "Downwards arrow" (8595).                |      `<kbd>↓</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|    Left arrow     |               Use Unicode "Leftwards arrow" (8592).                |      `<kbd>←</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|    Right arrow    |               Use Unicode "Rightwards arrow" (8594).               |      `<kbd>→</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|
|     Up arrow      |                Use Unicode "Upwards arrow" (8593).                 |      `<kbd>↑</kbd>`      |
|-------------------+--------------------------------------------------------------------+--------------------------|


## Title Casing
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
                             



> ## `.discussion`
>
> Discussion questions.
{: .discussion}

                             
{% include links.md %}

