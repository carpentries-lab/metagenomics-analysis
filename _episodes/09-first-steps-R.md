---
title: "First Steps on R"
teaching: 60
exercises: 0
questions:
- "What is R and why is it important to learn it?"
- "What types of data does R language have?"
- "Data-frames. What they are and how to manage them? "
- "How do I use R tools to manage an R object?"
objectives:
- "Undestand why R is important."
- "Learn the types of data that we can manage in R."
- "Understand what is a data-frame and manipulate it."
- "Use the help command to get more insight on R functions."
keypoints:
- "RStudio is just one of the myriad of tools to work with data."
- "Every hability, as programming in R, needs practice."
---

# RStudio: First steps of a wonderful journey 
*It takes courage to sail in uncharted waters*
  -Snoopy
 
## RStudio setup 

### What is R and what can it be used for?

"R" is used to refer to a programming language and the software that reads and 
interprets what is it on the scripts of this language. It is specialized on statistical computing and graphics. 
RStudio is the most popular program to write
scripts and interact with the R software.

R uses a series of written commands, that is great, believe us! When you rely on clicking, 
pointing, and remembering where and why to point here or click there, mistakes
are prone to occur. Moreover, if you manage to get more data, it is easier to just
*re-run* your script to obtain results. Also, working with scripts makes the steps 
you follow for your analysis clear and shareable. Here are some of the advantages
for working with R:
- R code is reproducible
- R produces high-quality graphics
- R has a large community
- R is interdisciplinary 
- R works on data of all colors and sizes
- R is free!

### A nautical chart of RStudio 
Abel: I would recommend explaining that R also allows us to create other types of documents.
RStudio is an [Integrated Development Environment(IDE)](https://en.wikipedia.org/wiki/Integrated_development_environment#:~:text=An%20integrated%20development%20environment%20(IDE,automation%20tools%20and%20a%20debugger.)) 
which we will use to write code,
navigate the files from our computer/cloud, try code, inspect the variables we are 
going to create, and visualize our plots.

Here is what you may look at the first time you open RStudio:
![image](https://user-images.githubusercontent.com/67386612/118720027-ba433c00-b7ee-11eb-87e5-7496fde5763e.png)
###### Figure 1. RStudio interface screenshot. The three windows that appear on the screen provide us with a space in which we can see our console (left side window) where the orders we want to execute are written, observe the generated variables (upper right), and a series of subtabs (lower right): **Files** shows us files that we have used, **Plots** shows us graphics that we are generating, **Packages** shows the packages that we have downloaded, **Help** it gives us the information of packages, commands and/or functions that we do not know, but works only with internet conection, and **Viewer** shows a results preview in R markdown files.

If we click in the option `File` :arrow_right: `New File` :arrow_right: `R Script`, we open up a script and
we get what we can call a _RStudio nautical chart_

![image](https://user-images.githubusercontent.com/67386612/112203976-c046e300-8bd8-11eb-9ee6-72c95f9134f3.png)
###### Figure 2. RStudio interface screenshot. Clockwise from top left: Source, Environment/History, Files/Plots/Packages/Help/Viewer, Console.

You can enter your online RStudio to see your own environment. Let's copy your instance address into your browser
(Chrome or Firefox) and login into Rstudio.  
The address should look like:  `http://ec2-3-235-238-92.compute-1.amazonaws.com:8787/`  

Although data are already stored in your instance, in case you need to you can donwload them [here](https://drive.google.com/file/d/15dW1sQCIhtmCUvS0IUOMPBH5m1gqNB0m/view?usp=sharing).

### Review of the setup

As we have revisited throughout the lesson, maintaining related data in a single folder
is desirable. In RStudio, this folder is called the **working directory**. It is where R will be looking 
for and saving your files. If you need to check where your working directory is located use `getwd()`.
If your working directory is not what you expected, it can always be changed by clicking on the blue 
gear icon:![image](https://user-images.githubusercontent.com/67386612/118722611-f7f59400-b7f1-11eb-8ca9-a72561f9c529.png) on the `Files` tab, and pick the option _Set As Working Directory_. Alternatively, you can use the `setwd()` command for changing it.

Let's use this commands to set our working directoiry where we have stored our files from the previous 
lessons:

~~~
> setwd("~/dc_workshop/results/")
~~~
{: .language-r}

## Having a dialogue with R

There are two main paths to interact with R in RStudio:
* Using the console.
* Creating and editing script files.

The console is where commands can be typed and executed immediately and where the 
results from executed commands will be shown (like in the Unix shell). If R is ready to accept commands, the R console shows
the `>` prompt. You can type instructions directly into the console and press "Enter", but they will 
be forgotten when you close the session.

For example, let's do some math and save it in R objects. We can store values in variables by
ussing the assignment operator `<-`:
~~~ 
> 4+3
> suma <- 4+3
> resta <- 2+1
> total <- suma -resta
> total
~~~
{: .language-r}

What would happend if you tap `ctrl` + `l`? Without the lesson page, can you remember what numbers the sum is made of in the variable `suma`?.
**Reproducibility** is in our minds when we program (and when we do science). For this purpose, 
is convenient to type the commands we want to save, in the script editor, and save the script periodically. 
We can run our code lines in the script by the shortcut `ctrl` + `Enter` 
(on Mac, `Cmd` + `Return` will work). Thus, the command on the current line, or the instructions
in the currently selected text will be sent to the console and will be executed.

Time can be the enemy or ally of memory. We want to be sure to remember why we wrote the commands
in our scripts, so we can leave comments(lines of no executable text) by beggining a line with `#`:
~~~
# Let's do some math in RStudio. How many times a year do the supermarkets change the bread that they use for
# display?, if they change it every 15 days:
> 356/15
~~~
{: .language-r}
~~~
[1] 23.73333
~~~
{: .output}

### Types of data

We already used numbers to generate a result. But this is not the only type of data that RStudio 
can manage. We can use the command `typeof()` to corroborate the data type of our object `suma`:

~~~
> typeof(suma)
~~~
{: .language-r}

~~~
> [1] "double"
~~~
{: .output}

There are five types of data in RStudio:
* Double
* [Integer](https://stackoverflow.com/questions/23660094/whats-the-difference-between-integer-class-and-numeric-class-in-r#:~:text=R%20handles%20the%20differences%20between,for%20you%20in%20the%20background.&text=(Putting%20capital%20'L'%20after,a%20subset%20of%20%22numeric%22.&text=Integers%20only%20go%20to%20a,numerics%20can%20be%20much%20bigger.))
* Complex
* Logical
* Character

~~~
> typeof(5L) #Integer type can contain only whole numbers and followed by a capital L
~~~
{: .language-r}
~~~
[1] "integer"
~~~
{: .output}

~~~
> typeof(72+5i)
~~~
{: .language-r}
~~~
[1] "complex"
~~~
{: .output}

~~~
> suma == resta
~~~
{: .language-r}
~~~
[1] FALSE
~~~
{: .output}

~~~
> typeof(suma == resta)
~~~
{: .language-r}
~~~
[1] "logical"
~~~
{: .output}

~~~
> resultado <- "4 and 3 are not the same in Earth. In Mars maybe... "
> typeof(resultado)
~~~
{: .language-r}
~~~
[1] "character"
~~~
{: .output}

No matter how complicated our analysis can become, all data in R will be allocated as one of this
five data types. On their own, data types are important because we want to know "who is who, and 
what is what". But this concept will help us learn one of the most powerful tools in R, which is 
the manipulation of different types of data at the same time in a data-frame.

### Data-frames: The power of interdisciplinarity 
Let's beggin by creating a mock data set:
~~~
> musician <- data.frame(people = c("Medtner", "Radwimps", "Shakira"),
						 pieces = c(722,187,68),
 						 likes = c(0,1,1))
> musician
~~~
{: .language-r}
The content of our new object:
~~~
    people pieces likes
1  Medtner    722     0
2 Radwimps    187     1
3  Shakira     68     1
~~~
{: .output}

We have just created our first data-frame. We can see if this is true by the `class()` command:
~~~
> class(musician)
~~~
{: .language-r}
~~~
[1] "data.frame"
~~~
{: .language-r}
A data-frame is a collection of vectors, a list, whose components must be of the same data type within
each vector. Whereas, a data-frame can save vectors of different data types:
![image](https://user-images.githubusercontent.com/67386612/118735756-b4595500-b806-11eb-8bd6-d189b9463eca.png)
######Figure 3. Structure of the created data-frame.

We can begin to explore our new object by pulling out columns by the `$` operator:
~~~
> musician$people
~~~
{: .language-r}
~~~
[1] "Medtner"  "Radwimps" "Shakira" 
~~~
{: .output}

We can do operations with our columns 
~~~
> musician$pieces + 20
~~~
{: .language-r}
~~~
[1] 742 207  88
~~~
{: .output}

Also, we can change the data type of one of the columns. By the next code we can see if the musicians are 
popular or not:
~~~
> typeof(musician$likes)
~~~
{: .language-r}
~~~
[1] "double"
~~~
{: .output}

~~~
> musician$likes <- as.logical(musician$likes)
> paste("Is",musician$people, "popular? :", musician$likes, sep = " ")
~~~
{: .language-r}
~~~
[1] "Is Medtner popular? : FALSE" "Is Radwimps popular? : TRUE" "Is Shakira popular? : TRUE"
~~~
{: .output}

Finally, we can extract from a specific place in our data:
~~~
> musician[1,2]  # The number of pieces that Nikolai Medtner composed
~~~
{: .language-r}
~~~
[1] 722
~~~
{: .output}

### Seeking help

If you face some trouble with some function, let's say `summary()`, you can always type `?summary()`
and a help page will be displayed with useful information for the function use. Furthermore, if you
already know what you want to do, but you do not know which function to use, you can type `??` 
following your inquiry, for example `??barplot` will open a help files in the RStudio's help
panel in the lower right corner.

With this, we have the needed tools to begin our exploration of diversity with R. Let's see what this
journey has to offer.


