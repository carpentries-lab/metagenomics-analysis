---
title: "Metagenome Assembly"
teaching: 10
exercises: 0
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


<a href="{{ page.root }}/fig/episode-format.png">
  <img src="{{ page.root }}/fig/episode-format-small.png" alt="Formatting Rules" />
</a>

## Assembling reads



> ## Activating metagenomic environment  
>
>conda activate metagenomics /home/ubuntu/.conda/envs/metagenomics  
{: .code}


{% raw %}
    [link text]({{ page.root }}{% link _episodes/dd-subject.md %})
{% endraw %}

i.e., use [Jekyll's tag link](https://jekyllrb.com/docs/templates/#links) and the name of the file.


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
    ./megahit -1 SAMPLE_1.fastq  -2 SAMPLE_2.fastq  -m 0.5  -t 12  -o megahit_result
~~~
{: .source}


The class specified at the bottom using an opening curly brace and colon,
the class identifier with a leading dot,
and a closing curly brace.
The [template]({{ site.template_repo }}) provides three styles for code blocks:



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

                                             
{% include links.md %}
