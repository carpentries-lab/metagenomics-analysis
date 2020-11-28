---
title: "Automating an Assembly Workflow"
teaching: 30
exercises: 15
questions:
- "How can I make my workflow more efficient and less error-prone?"
objectives:
- "Write a shell script with multiple variables."
- "Incorporate a `for` loop into a shell script."
keypoints:
- "We can combine multiple commands into a shell script to automate a workflow."
- "Use `echo` statements within your scripts to get an automated progress update."
---
# What is a shell script?

You wrote a simple shell script in a [previous lesson](http://www.datacarpentry.org/shell-genomics/05-writing-scripts/) that we used to extract bad reads from our
FASTQ files and put them into a new file. 

Here's the script you wrote:

~~~
grep -B1 -A2 NNNNNNNNNN *.fastq > scripted_bad_reads.txt

echo "Script finished!"
~~~
{: .bash}

That script was only two lines long, but shell scripts can be much more complicated
than that and can be used to perform a large number of operations on one or many 
files. This saves you the effort of having to type each of those commands over for
each of your data files and makes your work less error-prone and more reproducible. 
For example, the variant calling workflow we just carried out had about eight steps
where we had to type a command into our terminal. Most of these commands were pretty 
long. If we wanted to do this for all six of our data files, that would be forty-eight
steps. If we had 50 samples (a more realistic number), it would be 400 steps! You can
see why we want to automate this.

We've also used `for` loops in previous lessons to iterate one or two commands over multiple input files. 
In these `for` loops, the filename was defined as a variable in the `for` statement, which enabled you to run the loop on multiple files. We will be using variable assignments like this in our new shell scripts.

Here's the `for` loop you wrote for unzipping `.zip` files: 

~~~
$ for filename in *.zip
> do
> unzip $filename
> done
~~~
{: .bash}

And here's the one you wrote for running Trimmomatic on all of our `.fastq` sample files:

~~~
$ for infile in *_1.fastq.gz
> do
>   base=$(basename ${infile} _1.fastq.gz)
>   trimmomatic PE ${infile} ${base}_2.fastq.gz \
>                ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
>                ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
>                SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
> done
~~~
{: .bash}

Notice that in this `for` loop, we used two variables, `infile`, which was defined in the `for` statement, and `base`, which was created from the filename during each iteration of the loop.

> ## Creating Variables
> Within the Bash shell you can create variables at any time (as we did
> above, and during the 'for' loop lesson). Assign any name and the
> value using the assignment operator: '='. You can check the current
> definition of your variable by typing into your script: echo $variable_name.
{: .callout}

In this lesson, we'll use two shell scripts to automate the variant calling analysis: one for FastQC analysis (including creating our summary file), and a second for the remaining variant calling. To write a script to run our FastQC analysis, we'll take each of the commands we entered to run FastQC and process the output files and put them into a single file with a `.sh` extension. The `.sh` is not essential, but serves as a reminder to ourselves and to the computer that this is a shell script.

# Analyzing Quality with FastQC

We will use the command `touch` to create a new file where we will write our shell script. We will create this script in a new
directory called `scripts/`. Previously, we used
`nano` to create and open a new file. The command `touch` allows us to create a new file without opening that file.

~~~
$ mkdir -p ~/dc_workshop/scripts
$ cd ~/dc_workshop/scripts
$ touch read_qc.sh
$ ls 
~~~
{: .bash}

~~~
read_qc.sh
~~~
{: .output}

We now have an empty file called `read_qc.sh` in our `scripts/` directory. We will now open this file in `nano` and start
building our script.

~~~
$ nano read_qc.sh
~~~
{: .bash}

**Enter the following pieces of code into your shell script (not into your terminal prompt).**

Our first line will ensure that our script will exit if an error occurs, and is a good idea to include at the beginning of your scripts. The second line will move us into the `untrimmed_fastq/` directory when we run our script.

~~~
set -e
cd ~/dc_workshop/data/untrimmed_fastq/
~~~
{: .output}

These next two lines will give us a status message to tell us that we are currently running FastQC, then will run FastQC
on all of the files in our current directory with a `.fastq` extension. 

~~~
echo "Running FastQC ..."
fastqc *.fastq*
~~~
{: .output}

Our next line will create a new directory to hold our FastQC output files. Here we are using the `-p` option for `mkdir` again. It is a good idea to use this option in your shell scripts to avoid running into errors if you don't have the directory structure you think you do.

~~~
mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads
~~~
{: .output}

Our next three lines first give us a status message to tell us we are saving the results from FastQC, then moves all of the files
with a `.zip` or a `.html` extension to the directory we just created for storing our FastQC results. 

~~~
echo "Saving FastQC results..."
mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads/
mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads/
~~~
{: .output}

The next line moves us to the results directory where we've stored our output.

~~~
cd ~/dc_workshop/results/fastqc_untrimmed_reads/
~~~
{: .output}

The next five lines should look very familiar. First we give ourselves a status message to tell us that we're unzipping our ZIP
files. Then we run our for loop to unzip all of the `.zip` files in this directory.

~~~
echo "Unzipping..."
for filename in *.zip
    do
    unzip $filename
    done
~~~
{: .output}

Next we concatenate all of our summary files into a single output file, with a status message to remind ourselves that this is 
what we're doing.

~~~
echo "Saving summary..."
cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt
~~~
{: .output}

> ## Using `echo` statements
> 
> We've used `echo` statements to add progress statements to our script. Our script will print these statements
> as it is running and therefore we will be able to see how far our script has progressed.
>
{: .callout}

Your full shell script should now look like this:

~~~
set -e
cd ~/dc_workshop/data/untrimmed_fastq/

echo "Running FastQC ..."
fastqc *.fastq*

mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads

echo "Saving FastQC results..."
mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads/
mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads/

cd ~/dc_workshop/results/fastqc_untrimmed_reads/

echo "Unzipping..."
for filename in *.zip
    do
    unzip $filename
    done

echo "Saving summary..."
mkdir -p ~/dc_workshop/docs
cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt
~~~
{: .output}

Save your file and exit `nano`. We can now run our script:

~~~
$ bash read_qc.sh
~~~
{: .bash}

~~~
Running FastQC ...                                                                                         
Started analysis of JC1ASEDIMENT120627_R1.fastq.gz                                                      
Approx 5% complete for JC1ASEDIMENT120627_R1.fastq.gz                                                   
Approx 10% complete for JC1ASEDIMENT120627_R1.fastq.gz                                                   
Approx 15% complete for JC1ASEDIMENT120627_R1.fastq.gz                                                  
Approx 20% complete for JC1ASEDIMENT120627_R1.fastq.gz                                                  
Approx 25% complete for JC1ASEDIMENT120627_R1.fastq.gz                                                  
Approx 30% complete for JC1ASEDIMENT120627_R1.fastq.gz   
. 
. 
. 
~~~
{: .output}
