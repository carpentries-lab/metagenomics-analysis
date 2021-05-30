---
title: "Instructor Notes"
---

## Resouces for Instructors
We have an [onboarding video](https://www.youtube.com/watch?v=zgdutO5tejo) available to prepare Instructors to teach these lessons. 
The slides presented in this video are available: [https://tinyurl.com/y27swdvo](https://tinyurl.com/y27swdvo). 
After watching this video, please contact [team@carpentries.org](mailto: team@carpentries.org) so that we can record 
your status as an onboarded Instructor. Instructors who have completed onboarding will be given priority status for teaching at 
centrally-organized Carpentries workshops.

## Workshop Structure

[Instructors, please add notes on your experience with the workshop structure here.]


The instructor notes should provide additional discussion useful to instructors,
but not appropriate for inclusion in the main lessons. The following structure
provides a consistent way for instructors to both prepare for a workshop and
quickly find necessary information during a workshop.

Please remember not to overload on details, and to keep the comments here positive!

## Lesson motivation and learning objectives

These concepts should be highlighted in the main lesson material, but ideas for
explaining these concepts further can be placed here.

## Lesson design

Most lessons contain more material than can be taught in a single workshop.
Describe a general narrative (with time estimates) for teaching either a half day
or full day with this lesson material. You may also choose to include multiple
options for lesson design, or what material can be skipped while teaching.
This section may also include recommendations for how this lesson fits into
the overall workshop.

## Technical tips and tricks

In episode [Starting a metagenomics project](https://carpentries-incubator.github.io/metagenomics/01-background-metadata/index.html)
of the block [Data processing and visualization for metagenomics](https://carpentries-incubator.github.io/metagenomics/) 
we suggest to use a zoom of first image while explaining what is metagenomics. The image can be zoomed in by clicking on it. 



## Technical tips and tricks

#### Installation

This workshop is designed to be run on pre-imaged Amazon Web Services (AWS) instances. See the 
[Setup page](https://datacarpentry.org/genomics-workshop/setup.html) for complete setup instructions. If you are
teaching these lessons, and would like an AWS instance to practice on, please contact [team@carpentries.org](mailto: team@carpentries.org).

## Common problems

This workshop introduces an analysis pipeline, where each step in that pipeline is dependent on the previous step.
If a learner gets behind, or one of the steps doesn't work for them, they may not be able to catch up with the rest of the class. 
To help ensure that all learners are able to work through the whole process, we provide the solution files. This includes all
of the output files for each step in the data processing pipeline, as well as the scripts that the learners write collaboratively
with the Instructors throughout the workshop. These files are available on the AMI in `dcuser/.solutions`. 

Similarly, if the learners aren't able to pull the data files that are pulled in the lesson directly from the SRA (e.g. due to
unstable internet), those files are available in the hidden backup directory (`dcuser/.backup`).

Make sure to tell your helpers about the `.solutions` and `.backup` directories so that they can use these resources to help
learners catch up during the workshop. 




