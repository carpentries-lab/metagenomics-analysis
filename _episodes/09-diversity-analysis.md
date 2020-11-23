---
source: md
title: "Diversity analysis"
teaching: 10
exercises: 2
questions:
- "How to write a lesson using RMarkdown?"
objectives:
- "Understand α diversity"
- "Understand β diversity"
keypoints:
- "Edit the .Rmd files not the .md files"
---


[Rstudio cloud](https://rstudio.cloud/) and select "GET STARTED FOR FREE"

~~~
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phyloseq")
~~~
{: .lenguage-R}

{% include links.md %}
