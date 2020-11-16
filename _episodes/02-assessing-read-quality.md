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

> ## Why Doesn't My Site Appear?
>
> If the root directory of a repository contains a file called `.nojekyll`,
> GitHub will *not* generate a website for that repository's `gh-pages` branch.
{: .callout}

We write lessons in Markdown because it's simple to learn

$ gunzip FB1NV1SS26_S4_L001_R1.fastq.gz

Output
FB1NV1SS26_S4_L001_R1.fastq

There is an option to decompress all the files in a folder that share a combination of strings in their file names:

$ gunzip *.fastq.gz

 Here the rest of the files that have “.fastq.gz” at the end of their names will be decompressed

Output
FB1NV1SS26_S4_L001_R2.fastq
FB1NV1SS26_S4_L002_R1.fastq
FB1NV1SS26_S4_L002_R2.fastq
FB1NV1SS26_S4_L003_R1.fastq
FB1NV1SS26_S4_L003_R2.fastq
FB1NV1SS26_S4_L004_R1.fastq
FB1NV1SS26_S4_L004_R2.fastq

> ## Why Doesn't My Site Appear?
>
> If the root directory of a repository contains a file called `.nojekyll`,
> GitHub will *not* generate a website for that repository's `gh-pages` branch.
{: .callout}

We write lessons in Markdown because it's simple to learn
and isn't tied to any specific language.
(The ReStructured Text format popular in the Python world,
for example,
is a complete unknown to R programmers.)
If authors want to write lessons in something else,
such as [R Markdown][r-markdown],
they must generate HTML or Markdown that [Jekyll][jekyll] can process
and commit that to the repository.
A [later episode]({{ page.root }}/04-formatting/) describes the Markdown we use.

> ## Teaching Tools
>
> We do *not* prescribe what tools instructors should use when actually teaching:
> the [Jupyter Notebook][jupyter],
> [RStudio][rstudio],
> and the good ol' command line are equally welcome up on stage.
> All we specify is the format of the lesson notes.
{: .callout}

## Jekyll

GitHub uses [Jekyll][jekyll] to turn Markdown into HTML.
It looks for text files that begin with a header formatted like this:

~~~
---
variable: value
other_variable: other_value
---
...stuff in the page...
~~~
{: .source}

and inserts the values of those variables into the page when formatting it.
The three dashes that start the header *must* be the first three characters in the file:
even a single space before them will make [Jekyll][jekyll] ignore the file.

The header's content must be formatted as [YAML][yaml],
and may contain Booleans, numbers, character strings, lists, and dictionaries of name/value pairs.
Values from the header are referred to in the page as `page.variable`.
For example,
this page:

~~~
---
name: Science
---
{% raw %}Today we are going to study {{page.name}}.{% endraw %}
~~~
{: .source}

is translated into:

~~~
<html>
  <body>
    <p>Today we are going to study Science.</p>
  </body>
</html>
~~~
{: .html}

> ## Back in the Day...
>
> The previous version of our template did not rely on Jekyll,
> but instead required authors to build HTML on their desktops
> and commit that to the lesson repository's `gh-pages` branch.
> This allowed us to use whatever mix of tools we wanted for creating HTML (e.g., [Pandoc][pandoc]),
> but complicated the common case for the sake of uncommon cases,
> and didn't model the workflow we want learners to use.
{: .callout}

## Configuration

[Jekyll][jekyll] also reads values from a configuration file called `_config.yml`,
which are referred to in pages as `site.variable`.
The [lesson template]({{ site.template_repo }}) does *not* include `_config.yml`,
since each lesson will change some of its value,
which would result in merge collisions each time the lesson was updated from the template.
Instead,
the [template]({{ site.template_repo }}) contains a script called `bin/lesson_initialize.py`
which should be run *once* to create an initial `_config.yml` file
(and a few other files as well).
The author should then edit the values in the top half of the file.

## Collections

If several Markdown files are stored in a directory whose name begins with an underscore,
[Jekyll][jekyll] creates a [collection][jekyll-collection] for them.
We rely on this for both lesson episodes (stored in `_episodes`)
and extra files (stored in `_extras`).
For example,
putting the extra files in `_extras` allows us to populate the "Extras" menu pulldown automatically.
To clarify what will appear where,
we store files that appear directly in the navigation bar
in the root directory of the lesson.
[The next episode]({{ page.root }}/03-organization/) describes these files.

{% include links.md %}
