---
title: "Hands on R"
teaching: 30
exercises: 25
questions:
- "What is R and why is important to be learned?"
- "How do I use R tools to manage an R object?"
objectives:
- "Undestand why R is important"
- "Use the help command to get more insight on R functions."
- "Understand how taxonomy is used to obtain abundance tables."
keypoints:
- "Abundance can be obtain either before or after the assembly process."
- "A bash script can automate this work."
---

## First steps into R 
*It takes courage to sail in uncharted waters*
  -Snoopy
  
### What is R and for what can it be used for?

"R" is used to refer to the programming language and the software that reads and 
interpets what is it on the scripst. RStudio is the most popular program to write
scripts and interact with the R software.

R use a series of written commands and that is great! When you rely in clicking 
and pointing, and in remembering where and why to point here or click that, mistakes
are prone to occur. Moreover, if you manage to get more data, it is easier to just
re-run your script to obtain results. Also, working with scripts makes the steps 
you follow for your analysis clear and shareable. Here are some of the advantages
for working with R:
- R code is reproducible
- R produce high-quality graphics
- R has a large community
- R is interdisciplinary 
- R works on data of all colors and sizes
- R is free!

### A nautical chart of RStudio

RStudio is an Integrated Development Environment(IDE) which we will use to write code,
navigate the files from our computer/cloud, try code, inspect the variables we are 
going to create, and visualize our contribed plots.

![image](https://user-images.githubusercontent.com/67386612/112203976-c046e300-8bd8-11eb-9ee6-72c95f9134f3.png)
Figure 1. RStudio interface screenshot. Clockwise from top left: Source, Environment/History, 
Files/Plots/Packages/Help/Viewer, Console.

You can enter your online RStudio to see your own environment. Let's copy your instance address into your browser
(Chrome or Firefox) and login into R studio.  
The address should look like:  `http://ec2-3-235-238-92.compute-1.amazonaws.com:8787/`  
Your credencials are **user**:dcuser **pass**:data4Carp.  

Although data are already stored in your instance, in case you need it you can donwload it [here](https://drive.google.com/file/d/15dW1sQCIhtmCUvS0IUOMPBH5m1gqNB0m/view?usp=sharing).

### Review of the set-up

As we have revisited throughout the lesson, maintaining related data, analyses in a single folder
is desireable. In R, this folder is called **Working directory**. Here is where R will be looking 
for and saving the files. If you need to check where your working directory is located use `getwd()`.
If your working directory is not what you expected, always can be changed by clicking on the blue 
gear icon and pick the option "Set As Working Directory". Alternatively, you can use the `setwd()`
command for changing it.

Let's use this commands to set or working directiry where we have stored our files from the previos 
lessons:

~~~
$ setwd("~/dc_workshop/results/")
~~~
{: .language-r}

### Having a dialogue with R

There are two main paths to interact with R:(i) by using the console or (ii)by using script files.
The console is where commands can be typed and executed immediately by the software and where the 
results from executed commands will be shown. If R is ready to accept commands, the R console shows
a > prompt. You can type instructions directly into the console and press "Enter", but they will 
be forgotten when you close the session.

For example, let's do some math and save it in R objects:
~~~ 
$ 4+3
$ suma <- 4+3
$ resta <- 2+1
$ total <- suma -resta
$ total
~~~

What would happend if you tap `ctrl` + `l`. Without the lesson page, could you remember of which 
sum of numbers is `suma` made?. Reproducibility is in our minds when we program. For this purpose, 
is convenient to type the commands we want in the script editor, and save the script periodically. 
We can run our code lines in the script by the shortcut `ctrl` + `Enter` 
(on Macs, `Cmd` + `Return` will work). Thus, the command on the current line, or the instructions
in the currently selected text will be sent to the console and will be executed.

### Seeking help

If you face some trouble with some function, let's say `summary()`, you can always type `?summary()`
and a help page will be displayed with useful information for the function use. Furthermore, if you
already know what you want to do, but you do not know which function to use, you can type `??` 
following your inquiry, for example `??barplot` will open a help files in the RStudio's help
panel in the lower right corner.



