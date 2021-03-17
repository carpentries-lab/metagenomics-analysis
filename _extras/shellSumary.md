---
title: "Introducing the Shell"
teaching: 30
exercises: 20
questions:
- "What is a command shell and why would I use one?"
- "How can I move around on my computer?"
- "How can I see what files and directories I have?"
- "How can I specify the location of a file or directory on my computer?"
- "How can I view and search file contents?"
- "How can I create, copy and delete files and directories?"
- "How can I control who has permission to modify a file?"
- "How can I search within files?"
- "How can I combine existing commands to do new things?"
objectives:
- "Describe key reasons for learning shell."
- "Navigate your file system using the command line."
- "Access and read help files for `bash` programs and use help files to identify useful command options."
- "Demonstrate the use of tab completion, and explain its advantages."
- "Work with hidden directories and hidden files."
- "Interconvert between absolute and relative paths."
- "Employ navigational shortcuts to move around your file system."
- "View, search within, copy, move, and rename files. Create new directories."
- "Use wildcards (`*`) to perform operations on multiple files."
keypoints:
- "The shell gives you the ability to work more efficiently by using keyboard commands rather than a GUI."
- "Useful commands for navigating your file system include: `ls`, `pwd`, and `cd`."
- "Most commands take options (flags) which begin with a `-`."
- "Tab completion can reduce errors from mistyping and make work more efficient in the shell."
- "The `/`, `~`, and `..` characters represent important navigational shortcuts."
- "Hidden files and directories start with `.` and can be viewed using `ls -a`."
- "Relative paths specify a location starting from the current location, while absolute paths specify a location from the root of the file system."
- "The commands `cp`, `mv`, and `mkdir` are useful for manipulating existing files and creating new directories."
- "You can view file permissions using `ls -l` and change permissions using `chmod`."
---



## What is a shell and why should I care?

A *shell* is a computer program that presents a command line interface
which allows you to control your computer using commands entered
with a keyboard instead of controlling graphical user interfaces
(GUIs) with a mouse/keyboard combination.

There are many reasons to learn about the shell.

* Many bioinformatics tools can only be used through a command line interface, or 
have extra capabilities in the command line version that are not available in the GUI.
This is true, for example, of BLAST, which offers many advanced functions only accessible
to users who know how to use a shell.  
* The shell makes your work less boring. In bioinformatics you often need to do
the same set of tasks with a large number of files. Learning the shell will allow you to
automate those repetitive tasks and leave you free to do more exciting things.  
* The shell makes your work less error-prone. When humans do the same thing a hundred different times
(or even ten times), they're likely to make a mistake. Your computer can do the same thing a thousand times
with no mistakes.  
* The shell makes your work more reproducible. When you carry out your work in the command-line 
(rather than a GUI), your computer keeps a record of every step that you've carried out, which you can use 
to re-do your work when you need to. It also gives you a way to communicate unambiguously what you've done, 
so that others can check your work or apply your process to new data.  
* Many bioinformatic tasks require large amounts of computing power and can't realistically be run on your
own machine. These tasks are best performed using remote computers or cloud computing, which can only be accessed
through a shell.

In this lesson you will learn how to use the command line interface to move around in your file system. 

## How to access the shell

On a Mac or Linux machine, you can access a shell through a program called Terminal, which is already available
on your computer. If you're using Windows 10, you'll need to customize the setting on your computer and give PowerShell
(which is the predetermined terminal for Windows) permissions to work. The other option is to download a separate
program to access the shell-

We will spend most of our time learning about the basics of the shell
by manipulating some experimental data. Some of the data we're going to be working with is quite large, and
we're also going to be using several bioinformatics packages in later
lessons to work with this data. To avoid having to spend time 
downloading the data and downloading and installing all of the software,
we're going to be working with data on a remote server. 

You can log-in to the remote server using the instructions 
[here](http://www.datacarpentry.org/cloud-genomics/02-logging-onto-cloud/#logging-onto-a-cloud-instance). 
Your instructor will supply the `ip_address` and password that you need to login.

Each of you will have a different `ip_address`. This will 
prevent us from accidentally changing each other's files as we work through the
exercises. The password will be the same for everyone. 

After logging in, you will see a screen showing something like this: 

~~~
Welcome to Ubuntu 14.04.3 LTS (GNU/Linux 3.13.0-48-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Sat Feb  2 00:08:17 UTC 2019

  System load: 0.0                Memory usage: 5%   Processes:       82
  Usage of /:  29.9% of 98.30GB   Swap usage:   0%   Users logged in: 0

  Graph this data and manage this system at:
    https://landscape.canonical.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

597 packages can be updated.
444 updates are security updates.

New release '16.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Feb  1 22:34:53 2019 from c-73-116-43-163.hsd1.ca.comcast.net
~~~
{: .output}

This provides a lot of information about the remote server that you're logging in to. We're not going to use most of this information for
our workshop, so you can clear your screen using the `clear` command. 

~~~
$ clear
~~~
{: .bash}

This will scroll your screen down to give you a fresh screen and will make it easier to read. 
You haven't lost any of the information on your screen. If you scroll up, you can see everything that has been output to your screen
up until this point.

## Navigating your file system

The part of the operating system responsible for managing files and directories
is called the **file system**.
It organizes our data into files,
which hold information,
and directories (also called "folders"),
which hold files or other directories.

Several commands are frequently used to create, inspect, rename, and delete files and directories.

~~~
$
~~~
{: .bash}

The dollar sign is a **prompt**, which shows us that the shell is waiting for input;
your shell may use a different character as a prompt and may add information before
the prompt. When typing commands, either from these lessons or from other sources,
do not type the prompt, only the commands that follow it.

Let's find out where we are by running a command called `pwd`
(which stands for "print working directory").
At any moment, our **current working directory**
is our current default directory,
i.e.,
the directory that the computer assumes we want to run commands in
unless we explicitly specify something else.
Here,
the computer's response is `/home/dcuser`,
which is the top level directory within our cloud system:

~~~
$ pwd
~~~
{: .bash}

~~~
/home/dcuser
~~~
{: .output}

Let's look at how our file system is organized. We can see what files and subdirectories are in this directory by running `ls`,
which stands for "listing":

~~~
$ ls
~~~
{: .bash}

~~~
16s  R  r_data  shell_data
~~~
{: .output}

`ls` prints the names of the files and directories in the current directory in
alphabetical order,
arranged neatly into columns. 
We'll be working within the `shell_data` subdirectory, and creating new subdirectories, throughout this workshop.  

The command to change locations in our file system is `cd` followed by a
directory name to change our working directory.
`cd` stands for "change directory".

Let's say we want to navigate to the `shell_data` directory we saw above.  We can
use the following command to get there:

~~~
$ cd shell_data
~~~
{: .bash}

Let's look at what is in this directory:

~~~
$ ls
~~~
{: .bash}

~~~
sra_metadata  untrimmed_fastq
~~~
{: .output}

We can make the `ls` output more comprehensible by using the **flag** `-F`,
which tells `ls` to add a trailing `/` to the names of directories:

~~~
$ ls -F
~~~
{: .bash}

~~~
sra_metadata/  untrimmed_fastq/
~~~
{: .output}

Anything with a "/" after it is a directory. Things with a "*" after them are programs. If
there are no decorations, it's a file.

`ls` has lots of other options. To find out what they are, we can type:

~~~
$ man ls
~~~
{: .bash}

Some manual files are very long. You can scroll through the file using
your keyboard's down arrow or use the <kbd>Space</kbd> key to go forward one page
and the <kbd>b</kbd> key to go backwards one page. When you are done reading, hit <kbd>q</kbd>
to quit.

> ## Challenge
> Use the `-l` option for the `ls` command to display more information for each item 
> in the directory. What is one piece of additional information this long format
> gives you that you don't see with the bare `ls` command?
>
> > ## Solution
> > ~~~
> > $ ls -l
> > ~~~
> > {: .bash}
> > 
> > ~~~
> > total 8
> > drwxr-x--- 2 dcuser dcuser 4096 Jul 30  2015 sra_metadata
> > drwxr-xr-x 2 dcuser dcuser 4096 Nov 15  2017 untrimmed_fastq
> > ~~~
> > {: .output}
> > 
> > The additional information given includes the name of the owner of the file,
> > when the file was last modified, and whether the current user has permission
> > to read and write to the file.
> > 
> {: .solution}
{: .challenge}

No one can possibly learn all of these arguments, that's why the manual page
is for. You can (and should) refer to the manual page or other help files
as needed.

Let's go into the `untrimmed_fastq` directory and see what is in there.

~~~
$ cd untrimmed_fastq
$ ls -F
~~~
{: .bash}

~~~
SRR097977.fastq  SRR098026.fastq
~~~
{: .output}

This directory contains two files with `.fastq` extensions. FASTQ is a format
for storing information about sequencing reads and their quality.
We will be learning more about FASTQ files in a later lesson.

### Shortcut: Tab Completion

Typing out file or directory names can waste a
lot of time and it's easy to make typing mistakes. Instead we can use tab complete 
as a shortcut. When you start typing out the name of a directory or file, then
hit the <kbd>Tab</kbd> key, the shell will try to fill in the rest of the
directory or file name.

Return to your home directory:

~~~
$ cd
~~~
{: .bash}

then enter:

~~~
$ cd she<tab>
~~~
{: .bash}

The shell will fill in the rest of the directory name for
`shell_data`.

Now change directories to `untrimmed_fastq` in `shell_data`

~~~
$ cd shell_data
$ cd untrimmed_fastq
~~~
{: .bash}

Using tab complete can be very helpful. However, it will only autocomplete
a file or directory name if you've typed enough characters to provide
a unique identifier for the file or directory you are trying to access.

If we navigate back to our `untrimmed_fastq` directory and try to access one
of our sample files:

~~~
$ ls SR<tab>
~~~
{: .bash}

The shell auto-completes your command to `SRR09`, because all file names in 
the directory begin with this prefix. When you hit
<kbd>Tab</kbd> again, the shell will list the possible choices.

~~~
$ ls SRR09<tab><tab>
~~~
{: .bash}

~~~
SRR097977.fastq  SRR098026.fastq
~~~
{: .output}

Tab completion can also fill in the names of programs, which can be useful if you
remember the beginning of a program name.

~~~
$ pw<tab><tab>
~~~
{: .bash}

~~~
pwd         pwd_mkdb    pwhich      pwhich5.16  pwhich5.18  pwpolicy
~~~
{: .output}

Displays the name of every program that starts with `pw`. 



## Moving around the file system

We've learned how to use commands like `cd` to change locations and `ls` to list the contents
of a directory. Now we're going to learn some additional commands for moving around 
within our file system.

> ## Finding hidden directories
>
> First navigate to the `shell_data` directory. There is a hidden directory within this directory. Explore the options for `ls` to 
> find out how to see hidden directories. List the contents of the directory and 
> identify the name of the text file in that directory.
> 
> Hint: hidden files and folders in Unix start with `.`, for example `.my_hidden_directory`
>
> > ## Solution
> > 
> > First use the `man` command to look at the options for `ls`. 
> > ~~~
> > $ man ls
> > ~~~
> > {: .bash}
> > 
> > The `-a` option is short for `all` and says that it causes `ls` to "not ignore
> > entries starting with ." This is the option we want. 
> > 
> > ~~~
> > $ ls -a
> > ~~~
> > {: .bash}
> > 
> > ~~~
> > .  ..  .hidden	sra_metadata  untrimmed_fastq
> > ~~~
> > {: .output}
> > 
> > The name of the hidden directory is `.hidden`. We can navigate to that directory
> > using `cd`. 
> > 
> > ~~~
> > $ cd .hidden
> > ~~~
> > {: .bash}
> > 
> > And then list the contents of the directory using `ls`. 
> > 
> > ~~~
> > $ ls
> > ~~~
> > {: .bash}
> > 
> > ~~~
> > youfoundit.txt
> > ~~~
> > {: .output}
> > 
> > The name of the text file is `youfoundit.txt`.
> {: .solution}
{: .challenge}

In most commands the flags can be combined together in no particular order to obtain the desired results/output.
~~~
$ ls -Fa
$ ls -laF
~~~
{: .bash}

> ## Relative path resolution
> 
> Using the filesystem diagram below, if `pwd` displays `/Users/thing`,
> what will `ls ../backup` display?
> 
> 1.  `../backup: No such file or directory`
> 2.  `2012-12-01 2013-01-08 2013-01-27`
> 3.  `2012-12-01/ 2013-01-08/ 2013-01-27/`
> 4.  `original pnas_final pnas_sub`
> 
> ![File System for Challenge Questions](../fig/filesystem-challenge.svg)
> 
> > ## Solution
> >  1. No: there *is* a directory `backup` in `/Users`.
> >  2. No: this is the content of `Users/thing/backup`,
> >   but with `..` we asked for one level further up.
> >  3. No: see previous explanation.
> >    Also, we did not specify `-F` to display `/` at the end of the directory names.
> >  4. Yes: `../backup` refers to `/Users/backup`.
> {: .solution}
{: .challenge} 

You can usually use either a full path or a relative path
depending on what is most convenient. If we are in the home directory,
it is more convenient to enter the relative path since it
involves less typing.

A relative path is like getting directions from someone on the street. They tell you to
"go right at the stop sign, and then turn left on Main Street". That works great if
you're standing there together, but not so well if you're trying to tell someone how to
get there from another country. A full path is like GPS coordinates. It tells you exactly
where something is no matter where you are right now.

Over time, it will become easier for you to keep a mental note of the
structure of the directories that you are using and how to quickly
navigate amongst them.

## Working with files

### Our data set: FASTQ files

Now that we know how to navigate around our directory structure, lets
start working with our sequencing files. We did a sequencing experiment and 
have two results files, which are stored in our `untrimmed_fastq` directory. 

### Wildcards

Navigate to your `untrimmed_fastq` directory.

~~~
$ cd ~/shell_data/untrimmed_fastq
~~~
{: .bash}

We are interested in looking at the FASTQ files in this directory. We can list
all files with the .fastq extension using the command:

~~~
$ ls *.fastq
~~~
{: .bash}

~~~
SRR097977.fastq  SRR098026.fastq
~~~
{: .output}

The `*` character is a special type of character called a wildcard, which can be used to represent any number of any type of character. 
Thus, `*.fastq` matches every file that ends with `.fastq`. 

This command: 

~~~
$ ls *977.fastq
~~~
{: .bash}

~~~
SRR097977.fastq
~~~
{: .output}

lists only the file that ends with `977.fastq`.

This command:

~~~
$ ls /usr/bin/*.sh
~~~
{: .bash}

~~~
/usr/bin/amuFormat.sh  /usr/bin/gettext.sh  /usr/bin/gvmap.sh
~~~
{: .output}

Lists every file in `/usr/bin` that ends in the characters `.sh`.

> ## Home vs. Root
> 
> The `/` character is another navigational shortcut and refers to your root directory.
> The root directory is the highest level directory in your file system and contains
> files that are important for your computer to perform its daily work, but which you usually won't
> have to interact with directly. In our case,
> the root directory is two levels above our home directory, so `cd` or `cd ~` will take you to `/home/dcuser`
> and `cd /` will take you to `/`, which is equivalent to `~/../../`. Try not to worry if this is confusing,
> it will all become clearer with practice.
> 
> While you will be using the root at the beginning of your absolute paths, it is important that you avoid 
> working with data in these higher-level directories, as your commands can permanently alter files that the 
> operating system needs to function. In many cases, trying to run commands in root directories will require 
> special permissions which are not discussed here, so it's best to avoid it and work within your home directory.
{: .callout}

## Command History

If you want to repeat a command that you've run recently, you can access previous
commands using the up arrow on your keyboard to go back to the most recent
command. Likewise, the down arrow takes you forward in the command history.

A few more useful shortcuts: 

- <kbd>Ctrl</kbd>+<kbd>C</kbd> will cancel the command you are writing, and give you a 
fresh prompt.
- <kbd>Ctrl</kbd>+<kbd>R</kbd> will do a reverse-search through your command history.  This
is very useful.
- <kbd>Ctrl</kbd>+<kbd>L</kbd> or the `clear` command will clear your screen.

You can also review your recent commands with the `history` command, by entering:

~~~
$ history
~~~
{: .bash}

to see a numbered list of recent commands. You can reuse one of these commands
directly by referring to the number of that command.

For example, if your history looked like this:

~~~
259  ls *
260  ls /usr/bin/*.sh
261  ls *R1*fastq
~~~
{: .output}

then you could repeat command #260 by entering:

~~~
$ !260
~~~
{: .bash}

Type `!` (exclamation point) and then the number of the command from your history.
You will be glad you learned this when you need to re-run very complicated commands.

## Examining Files

We now know how to switch directories, run programs, and look at the
contents of directories, but how do we look at the contents of files?

One way to examine a file is to print out all of the
contents using the program `cat`. 

Enter the following command from within the `untrimmed_fastq` directory: 

~~~
$ cat SRR098026.fastq
~~~
{: .bash}

This will print out all of the contents of the `SRR098026.fastq` to the screen.


> ## Exercise
> 
> 1. Print out the contents of the `~/shell_data/untrimmed_fastq/SRR097977.fastq` file. What is the last line of the file? 
> 2.  From your home directory, and without changing directories,
> use one short command to print the contents of all of the files in
> the `~/shell_data/untrimmed_fastq` directory.
> 
> > ## Solution
> > 1. The last line of the file is `C:CCC::CCCCCCCC<8?6A:C28C<608'&&&,'$`.
> > 2. `cat ~/shell_data/untrimmed_fastq/*`
> {: .solution}
{: .challenge}

`cat` is a terrific program, but when the file is really big, it can
be annoying to use. The program, `less`, is useful for this
case. `less` opens the file as read only, and lets you navigate through it. The navigation commands
are identical to the `man` program.

Enter the following command:

~~~
$ less SRR097977.fastq
~~~
{: .bash}

Some navigation commands in `less`

| key     | action |
| ------- | ---------- |
| <kbd>Space</kbd> | to go forward |
|  <kbd>b</kbd>    | to go backward |
|  <kbd>g</kbd>    | to go to the beginning |
|  <kbd>G</kbd>    | to go to the end |
|  <kbd>q</kbd>    | to quit |

`less` also gives you a way of searching through files. Use the
"/" key to begin a search. Enter the word you would like
to search for and press `enter`. The screen will jump to the next location where
that word is found. 

**Shortcut:** If you hit "/" then "enter", `less` will  repeat
the previous search. `less` searches from the current location and
works its way forward. Note, if you are at the end of the file and search
for the sequence "CAA", `less` will not find it. You either need to go to the
beginning of the file (by typing `g`) and search again using `/` or you
can use `?` to search backwards in the same way you used `/` previously.

For instance, let's search forward for the sequence `TTTTT` in our file. 
You can see that we go right to that sequence, what it looks like,
and where it is in the file. If you continue to type `/` and hit return, you will move 
forward to the next instance of this sequence motif. If you instead type `?` and hit 
return, you will search backwards and move up the file to previous examples of this motif.

> ## Exercise
>
> What are the next three nucleotides (characters) after the first instance of the sequence quoted above?
> 
> > ## Solution
> > `CAC`
> {: .solution}
{: .challenge}

Remember, the `man` program actually uses `less` internally and
therefore uses the same commands, so you can search documentation
using "/" as well!

There's another way that we can look at files, and in this case, just
look at part of them. This can be particularly useful if we just want
to see the beginning or end of the file, or see how it's formatted.

The commands are `head` and `tail` and they let you look at
the beginning and end of a file, respectively.

~~~
$ head SRR098026.fastq
~~~
{: .bash}

~~~
@SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
NNNNNNNNNNNNNNNNCNNNNNNNNNNNNNNNNNN
+SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
!!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
@SRR098026.2 HWUSI-EAS1599_1:2:1:0:312 length=35
NNNNNNNNNNNNNNNNANNNNNNNNNNNNNNNNNN
+SRR098026.2 HWUSI-EAS1599_1:2:1:0:312 length=35
!!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
@SRR098026.3 HWUSI-EAS1599_1:2:1:0:570 length=35
NNNNNNNNNNNNNNNNANNNNNNNNNNNNNNNNNN
~~~
{: .output}

~~~
$ tail SRR098026.fastq
~~~
{: .bash}

~~~
+SRR098026.247 HWUSI-EAS1599_1:2:1:2:1311 length=35
#!##!#################!!!!!!!######
@SRR098026.248 HWUSI-EAS1599_1:2:1:2:118 length=35
GNTGNGGTCATCATACGCGCCCNNNNNNNGGCATG
+SRR098026.248 HWUSI-EAS1599_1:2:1:2:118 length=35
B!;?!A=5922:##########!!!!!!!######
@SRR098026.249 HWUSI-EAS1599_1:2:1:2:1057 length=35
CNCTNTATGCGTACGGCAGTGANNNNNNNGGAGAT
+SRR098026.249 HWUSI-EAS1599_1:2:1:2:1057 length=35
A!@B!BBB@ABAB#########!!!!!!!######
~~~
{: .output}

The `-n` option to either of these commands can be used to print the
first or last `n` lines of a file. 

~~~
$ head -n 1 SRR098026.fastq
~~~
{: .bash}

~~~
@SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
~~~
{: .output}

~~~
$ tail -n 1 SRR098026.fastq
~~~
{: .bash}

~~~
A!@B!BBB@ABAB#########!!!!!!!######
~~~
{: .output}

## Details on the FASTQ format

Although it looks complicated (and it is), it's easy to understand the
[fastq](https://en.wikipedia.org/wiki/FASTQ_format) format with a little decoding. Some rules about the format
include...

|Line|Description|
|----|-----------|
|1|Always begins with '@' and then information about the read|
|2|The actual DNA sequence|
|3|Always begins with a '+' and sometimes the same info in line 1|
|4|Has a string of characters which represent the quality scores; must have same number of characters as line 2|

We can view the first complete read in one of the files our dataset by using `head` to look at
the first four lines.

~~~
$ head -n 4 SRR098026.fastq
~~~
{: .bash}

~~~
@SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
NNNNNNNNNNNNNNNNCNNNNNNNNNNNNNNNNNN
+SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
!!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
~~~
{: .output}

All but one of the nucleotides in this read are unknown (`N`). This is a pretty bad read!

Line 4 shows the quality for each nucleotide in the read. Quality is interpreted as the 
probability of an incorrect base call (e.g. 1 in 10) or, equivalently, the base call 
accuracy (e.g. 90%). To make it possible to line up each individual nucleotide with its quality
score, the numerical score is converted into a code where each individual character 
represents the numerical quality score for an individual nucleotide. For example, in the line
above, the quality score line is: 

~~~
!!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
~~~
{: .output}

The `#` character and each of the `!` characters represent the encoded quality for an 
individual nucleotide. The numerical value assigned to each of these characters depends on the 
sequencing platform that generated the reads. The sequencing machine used to generate our data 
uses the standard Sanger quality PHRED score encoding, Illumina version 1.8 onwards.
Each character is assigned a quality score between 0 and 42 as shown in the chart below.

~~~
Quality encoding: !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJK
                  |         |         |         |         |
Quality score:    0........10........20........30........40..                          
~~~
{: .output}

Each quality score represents the probability that the corresponding nucleotide call is
incorrect. This quality score is logarithmically based, so a quality score of 10 reflects a
base call accuracy of 90%, but a quality score of 20 reflects a base call accuracy of 99%. 
These probability values are the results from the base calling algorithm and dependent on how 
much signal was captured for the base incorporation. 

Looking back at our read: 

~~~
@SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
NNNNNNNNNNNNNNNNCNNNNNNNNNNNNNNNNNN
+SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
!!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
~~~
{: .output}

we can now see that the quality of each of the `N`s is 0 and the quality of the only
nucleotide call (`C`) is also very poor (`#` = a quality score of 2). This is indeed a very
bad read. 


## Creating, moving, copying, and removing

Now we can move around in the file structure, look at files, and search files. But what if we want to copy files or move
them around or get rid of them? Most of the time, you can do these sorts of file manipulations without the command line,
but there will be some cases (like when you're working with a remote computer like we are for this lesson) where it will be
impossible. You'll also find that you may be working with hundreds of files and want to do similar manipulations to all 
of those files. In cases like this, it's much faster to do these operations at the command line.

### Copying Files

When working with computational data, it's important to keep a safe copy of that data that can't be accidentally overwritten or deleted. 
For this lesson, our raw data is our FASTQ files.  We don't want to accidentally change the original files, so we'll make a copy of them
and change the file permissions so that we can read from, but not write to, the files.

First, let's make a copy of one of our FASTQ files using the `cp` command. 

Navigate to the `shell_data/untrimmed_fastq` directory and enter:

~~~
$ cp SRR098026.fastq SRR098026-copy.fastq
$ ls -F
~~~
{: .bash}

~~~
SRR097977.fastq  SRR098026-copy.fastq  SRR098026.fastq
~~~
{: .output}

We now have two copies of the `SRR098026.fastq` file, one of them named `SRR098026-copy.fastq`. We'll move this file to a new directory
called `backup` where we'll store our backup data files.

### Creating Directories

The `mkdir` command is used to make a directory. Enter `mkdir`
followed by a space, then the directory name you want to create.

~~~
$ mkdir backup
~~~
{: .bash}

### Moving / Renaming 

We can now move our backup file to this directory. We can
move files around using the command `mv`. 

~~~
$ mv SRR098026-copy.fastq backup
$ ls backup
~~~
{: .bash}
 
~~~
SRR098026-copy.fastq
~~~
{: .output}

The `mv` command is also how you rename files. Let's rename this file to make it clear that this is a backup.

~~~
$ cd backup
$ mv SRR098026-copy.fastq SRR098026-backup.fastq
$ ls
~~~
{: .bash}

~~~
SRR098026-backup.fastq
~~~
{: .output}

### File Permissions

We've now made a backup copy of our file, but just because we have two copies doesn't make us safe. We can still accidentally delete or 
overwrite both copies. To make sure we can't accidentally mess up this backup file, we're going to change the permissions on the file so
that we're only allowed to read (i.e. view) the file, not write to it (i.e. make new changes).

View the current permissions on a file using the `-l` (long) flag for the `ls` command. 

~~~
$ ls -l
~~~
{: .bash}

~~~
-rw-r--r-- 1 dcuser dcuser 43332 Nov 15 23:02 SRR098026-backup.fastq
~~~
{: .output}

The first part of the output for the `-l` flag gives you information about the file's current permissions. There are ten slots in the
permissions list. The first character in this list is related to file type, not permissions, so we'll ignore it for now. The next three
characters relate to the permissions that the file owner has, the next three relate to the permissions for group members, and the final
three characters specify what other users outside of your group can do with the file. We're going to concentrate on the three positions
that deal with your permissions (as the file owner). 

![Permissions breakdown](../fig/rwx_figure.svg)

Here the three positions that relate to the file owner are `rw-`. The `r` means that you have permission to read the file, the `w` 
indicates that you have permission to write to (i.e. make changes to) the file, and the third position is a `-`, indicating that you 
don't have permission to carry out the ability encoded by that space (this is the space where `x` or executable ability is stored, we'll 
talk more about this in [a later lesson](http://www.datacarpentry.org/shell-genomics/05-writing-scripts/)).

Our goal for now is to change permissions on this file so that you no longer have `w` or write permissions. We can do this using the `chmod` (change mode) command and subtracting (`-`) the write permission `-w`. 

~~~
$ chmod -w SRR098026-backup.fastq
$ ls -l 
~~~
{: .bash}

~~~
-r--r--r-- 1 dcuser dcuser 43332 Nov 15 23:02 SRR098026-backup.fastq
~~~
{: .output}

### Removing

To prove to ourselves that you no longer have the ability to modify this file, try deleting it with the `rm` command.

~~~
$ rm SRR098026-backup.fastq
~~~
{: .bash}

You'll be asked if you want to override your file permissions.

~~~
rm: remove write-protected regular file ‘SRR098026-backup.fastq’? 
~~~
{: .output}

You should enter `n`for no. If you enter `n` (for no), the file will not be deleted. If you enter `y`, you will delete the file. This gives us an extra 
measure of security, as there is one more step between us and deleting our data files.

**Important**: The `rm` command permanently removes the file. Be careful with this command. It doesn't
just nicely put the files in the Trash. They're really gone.

By default, `rm` will not delete directories. You can tell `rm` to
delete a directory using the `-r` (recursive) option. Let's delete the backup directory
we just made. 

Enter the following command:

~~~
$ cd ..
$ rm -r backup
~~~
{: .bash}

This will delete not only the directory, but all files within the directory. If you have write-protected files in the directory, 
you will be asked whether you want to override your permission settings. 

> ## Exercise
>
> Starting in the `shell_data/untrimmed_fastq/` directory, do the following:
> 1. Make sure that you have deleted your backup directory and all files it contains.  
> 2. Create a copy of each of your FASTQ files. (Note: You'll need to do this individually for each of the two FASTQ files. We haven't 
> learned yet how to do this
> with a wildcard.)  
> 3. Use a wildcard to move all of your backup files to a new backup directory.   
> 4. Change the permissions on all of your backup files to be write-protected.  
>
> > ## Solution
> >
> > 1. `rm -r backup`  
> > 2. `cp SRR098026.fastq SRR098026-backup.fastq` and `cp SRR097977.fastq SRR097977-backup.fastq`  
> > 3. `mkdir backup` and `mv *-backup.fastq backup`
> > 4. `chmod -w backup/*-backup.fastq`   
> > It's always a good idea to check your work with `ls -l backup`. You should see something like: 
> > 
> > ~~~
> > -r--r--r-- 1 dcuser dcuser 47552 Nov 15 23:06 SRR097977-backup.fastq
> > -r--r--r-- 1 dcuser dcuser 43332 Nov 15 23:06 SRR098026-backup.fastq
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

## Searching files

We discussed in a previous episode how to search within a file using `less`. We can also
search within files without even opening them, using `grep`. `grep` is a command-line
utility for searching plain-text files for lines matching a specific set of 
characters (sometimes called a string) or a particular pattern 
(which can be specified using something called regular expressions). We're not going to work with 
regular expressions in this lesson, and are instead going to specify the strings 
we are searching for.
Let's give it a try!

> ## Nucleotide abbreviations
> 
> The four nucleotides that appear in DNA are abbreviated `A`, `C`, `T` and `G`. 
> Unknown nucleotides are represented with the letter `N`. An `N` appearing
> in a sequencing file represents a position where the sequencing machine was not able to 
> confidently determine the nucleotide in that position. You can think of an `N` as being aNy 
> nucleotide at that position in the DNA sequence. 
> 
{: .callout}

We'll search for strings inside of our fastq files. Let's first make sure we are in the correct 
directory.

~~~
$ cd ~/shell_data/untrimmed_fastq
~~~
{: .bash}

Suppose we want to see how many reads in our file have really bad segments containing 10 consecutive unknown nucleotides (Ns).

> ## Determining quality
> 
> In this lesson, we're going to be manually searching for strings of `N`s within our sequence
> results to illustrate some principles of file searching. It can be really useful to do this
> type of searching to get a feel for the quality of your sequencing results, however, in your 
> research you will most likely use a bioinformatics tool that has a built-in program for
> filtering out low-quality reads. You'll learn how to use one such tool in 
> [a later lesson](https://datacarpentry.org/wrangling-genomics/02-quality-control/index.html).
> 
{: .callout}

Let's search for the string NNNNNNNNNN in the SRR098026 file.
~~~
$ grep NNNNNNNNNN SRR098026.fastq
~~~
{: .bash}

This command returns a lot of output to the terminal. Every single line in the SRR098026 
file that contains at least 10 consecutive Ns is printed to the terminal, regardless of how long or short the file is. 
We may be interested not only in the actual sequence which contains this string, but 
in the name (or identifier) of that sequence. We discussed in a previous lesson 
that the identifier line immediately precedes the nucleotide sequence for each read
in a FASTQ file. We may also want to inspect the quality scores associated with
each of these reads. To get all of this information, we will return the line 
immediately before each match and the two lines immediately after each match.

We can use the `-B` argument for grep to return a specific number of lines before
each match. The `-A` argument returns a specific number of lines after each matching line. Here we want the line *before* and the two lines *after* each 
matching line, so we add `-B1 -A2` to our grep command.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
~~~
{: .bash}

One of the sets of lines returned by this command is: 

~~~
@SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
+SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
~~~
{: .output}

> ## Exercise
>
> 1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
> 
> 2. Search for the sequence `AAGTT` in both FASTQ files.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
> 
> > ## Solution  
> > 1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`  
> > 2. `grep -B1 AAGTT *.fastq`
> >
> {: .solution}
{: .challenge}

## Redirecting output

`grep` allowed us to identify sequences in our FASTQ files that match a particular pattern. 
All of these sequences were printed to our terminal screen, but in order to work with these 
sequences and perform other operations on them, we will need to capture that output in some
way. 

We can do this with something called "redirection". The idea is that
we are taking what would ordinarily be printed to the terminal screen and redirecting it to another location. 
In our case, we want to print this information to a file so that we can look at it later and 
use other commands to analyze this data.

The command for redirecting output to a file is `>`.

Let's try out this command and copy all the records (including all four lines of each record) 
in our FASTQ files that contain 
'NNNNNNNNNN' to another file called `bad_reads.txt`.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
~~~
{: .bash}

## Keep looking into our files

We can check the number of lines in our new file using a command called `wc`. 
`wc` stands for **word count**. This command counts the number of words, lines, and characters
in a file. 

~~~
$ wc bad_reads.txt
~~~
{: .bash}

~~~
  537  1073 23217 bad_reads.txt
~~~
{: .output}

This will tell us the number of lines, words and characters in the file. If we
want only the number of lines, we can use the `-l` flag for `lines`.

~~~
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
537 bad_reads.txt
~~~
{: .output}

Because we asked `grep` for all four lines of each FASTQ record, we need to divide the output by
four to get the number of sequences that match our search pattern.

> ## Exercise
>
> How many sequences in `SRR098026.fastq` contain at least 3 consecutive Ns?
>
>> ## Solution
>>  
>>
>> ~~~
>> $ grep NNN SRR098026.fastq > bad_reads.txt
>> $ wc -l bad_reads.txt
>> ~~~
>> {: .bash}
>> 
>> ~~~
>> 249
>> ~~~
>> {: .output}
>>
> {: .solution}
{: .challenge}

We might want to search multiple FASTQ files for sequences that match our search pattern.
However, we need to be careful, because each time we use the `>` command to redirect output
to a file, the new output will replace the output that was already present in the file. 
This is called "overwriting" and, just like you don't want to overwrite your video recording
of your kid's first birthday party, you also want to avoid overwriting your data files.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
537 bad_reads.txt
~~~
{: .output}

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq > bad_reads.txt
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
0 bad_reads.txt
~~~
{: .output}

Here, the output of our second  call to `wc` shows that we no longer have any lines in our `bad_reads.txt` file. This is 
because the second file we searched (`SRR097977.fastq`) does not contain any lines that match our
search sequence. So our file was overwritten and is now empty.

We can avoid overwriting our files by using the command `>>`. `>>` is known as the "append redirect" and will 
append new output to the end of a file, rather than overwriting it.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
537 bad_reads.txt
~~~
{: .output}

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
537 bad_reads.txt
~~~
{: .output}

The output of our second call to `wc` shows that we have not overwritten our original data. 

We can also do this with a single line of code by using a wildcard. 

~~~
$ grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.txt
$ wc -l bad_reads.txt
~~~
{: .bash}

~~~
537 bad_reads.txt
~~~
{: .output}

Since we might have multiple different criteria we want to search for, 
creating a new output file each time has the potential to clutter up our workspace. We also
so far haven't been interested in the actual contents of those files, only in the number of 
reads that we've found. We created the files to store the reads and then counted the lines in 
the file to see how many reads matched our criteria. There's a way to do this, however, that
doesn't require us to create these intermediate files - the pipe command (`|`).

This is probably not a key on
your keyboard you use very much, so let's all take a minute to find that key. 
What `|` does is take the output that is
scrolling by on the terminal and uses that output as input to another command. 
When our output was scrolling by, we might have wished we could slow it down and
look at it, like we can with `less`. Well it turns out that we can! We can redirect our output
from our `grep` call through the `less` command.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | less
~~~
{: .bash}

We can now see the output from our `grep` call within the `less` interface. We can use the up and down arrows 
to scroll through the output and use `q` to exit `less`.

Redirecting output is often not intuitive, and can take some time to get used to. Once you're 
comfortable with redirection, however, you'll be able to combine any number of commands to
do all sorts of exciting things with your data!

None of the command line programs we've been learning
do anything all that impressive on their own, but when you start chaining
them together, you can do some really powerful things very
efficiently. 

## Writing for loops

Loops are key to productivity improvements through automation as they allow us to execute commands repeatedly. 
Similar to wildcards and tab completion, using loops also reduces the amount of typing (and typing mistakes). 
Loops are helpful when performing operations on groups of sequencing files, such as unzipping or trimming multiple
files. We will use loops for these purposes in subsequent analyses, but will cover the basics of them for now.

When the shell sees the keyword `for`, it knows to repeat a command (or group of commands) once for each item in a list. 
Each time the loop runs (called an iteration), an item in the list is assigned in sequence to the **variable**, and 
the commands inside the loop are executed, before moving on to  the next item in the list. Inside the loop, we call for 
the variable's value by putting `$` in front of it. The `$` tells the shell interpreter to treat the **variable**
as a variable name and substitute its value in its place, rather than treat it as text or an external command. In shell programming, this is usually called "expanding" the variable.

Sometimes, we want to expand a variable without any whitespace to its right.
Suppose we have a variable named `foo` that contains the text `abc`, and would
like to expand `foo` to create the text `abcEFG`.

~~~
$ foo=abc
$ echo foo is $foo
foo is abc
$ echo foo is $fooEFG      # doesn't work
foo is
~~~
{: .bash}

The interpreter is trying to expand a variable named `fooEFG`, which (probably)
doesn't exist. We can avoid this problem by enclosing the variable name in 
braces (`{` and `}`, sometimes called "squiggle braces").

~~~
$ foo=abc
$ echo foo is $foo
foo is abc
$ echo foo is ${foo}EFG      # now it works!
foo is abcEFG
~~~
{: .bash}

Let's write a for loop to show us the first two lines of the fastq files we downloaded earlier and also saves
the information into a file. You will notice shell prompt changes from `$` to `>` and back again as we were typing in our loop. The second prompt, `>`, is different to remind us that we haven’t finished typing a complete command yet. A semicolon, `;`, can be used to separate two commands written on a single line.

~~~
$ cd ../untrimmed_fastq/
~~~
{: .bash}

~~~
$ for filename in *.fastq
> do
> head -n 2 ${filename} >> seq_info.txt
> done
~~~
{: .bash}

The for loop begins with the formula `for <variable> in <group to iterate over>`. In this case, the word `filename` is designated 
as the variable to be used over each iteration. In our case `SRR097977.fastq` and `SRR098026.fastq` will be substituted for `filename` 
because they fit the pattern of ending with .fastq in directory we've specified. The next line of the for loop is `do`. The next line is 
the code that we want to execute. We are telling the loop to print the first two lines of each variable we iterate over. Finally, the
word `done` ends the loop.

Note that we are using `>>` to append the text to our `seq_info.txt` file. If we used `>`, the `seq_info.txt` file would be rewritten
every time the loop iterates, so it would only have text from the last variable used. Instead, `>>` adds to the end of the file.

> ## Exercise
>
> Print the file prefix of all of the `.txt` files in our current directory.
>
>> ## Solution
>>  
>>
>> ~~~
>> $ for filename in *.txt
>> > do
>> > name=$(basename ${filename} .txt)
>> > echo ${name}
>> > done
>> ~~~
>> {: .bash}
>>
> {: .solution}
{: .challenge}














<script language="javascript" type="text/javascript">
function set_page_view_defaults() {
    document.getElementById('div_win').style.display = 'block';
    document.getElementById('div_unix').style.display = 'none';
};

function change_content_by_platform(form_control){
    if (!form_control || document.getElementById(form_control).value == 'win') {
        set_page_view_defaults();
    } else if (document.getElementById(form_control).value == 'unix') {
        document.getElementById('div_win').style.display = 'none';
        document.getElementById('div_unix').style.display = 'block';
    } else {
        alert("Error: Missing platform value for 'change_content_by_platform()' script!");
    }
}

window.onload = set_page_view_defaults;
</script>


## Writing files

We've been able to do a lot of work with files that already exist, but what if we want to write our own files. We're not going to type in a FASTA file, but we'll see as we go through other tutorials, there are a lot of reasons we'll want to write a file, or edit an existing file.

To add text to files, we're going to use a text editor called Nano. We're going to create a file to take notes about what we've been doing with the data files in `~/shell_data/untrimmed_fastq`.

This is good practice when working in bioinformatics. We can create a file called a `README.txt` that describes the data files in the directory or documents how the files in that directory were generated.  As the name suggests it's a file that we or others should read to understand the information in that directory.

Let's change our working directory to `~/shell_data/untrimmed_fastq` using `cd`,
then run `nano` to create a file called `README.txt`:

~~~
$ cd ~/shell_data/untrimmed_fastq
$ nano README.txt
~~~
{: .bash}

You should see something like this: 

![nano201711.png](../img/nano201711.png)

The text at the bottom of the screen shows the keyboard shortcuts for performing various tasks in `nano`. We will talk more about how to interpret this information soon.

> ## Which Editor?
>
> When we say, "`nano` is a text editor," we really do mean "text": it can
> only work with plain character data, not tables, images, or any other
> human-friendly media. We use it in examples because it is one of the 
> least complex text editors. However, because of this trait, it may 
> not be powerful enough or flexible enough for the work you need to do
> after this workshop. On Unix systems (such as Linux and Mac OS X),
> many programmers use [Emacs](http://www.gnu.org/software/emacs/) or
> [Vim](http://www.vim.org/) (both of which require more time to learn), 
> or a graphical editor such as
> [Gedit](http://projects.gnome.org/gedit/). On Windows, you may wish to
> use [Notepad++](http://notepad-plus-plus.org/).  Windows also has a built-in
> editor called `notepad` that can be run from the command line in the same
> way as `nano` for the purposes of this lesson.  
>
> No matter what editor you use, you will need to know where it searches
> for and saves files. If you start it from the shell, it will (probably)
> use your current working directory as its default location. If you use
> your computer's start menu, it may want to save files in your desktop or
> documents directory instead. You can change this by navigating to
> another directory the first time you "Save As..."
{: .callout}

Let's type in a few lines of text. Describe what the files in this
directory are or what you've been doing with them.
Once we're happy with our text, we can press <kbd>Ctrl</kbd>-<kbd>O</kbd> (press the <kbd>Ctrl</kbd> or <kbd>Control</kbd> key and, while
holding it down, press the <kbd>O</kbd> key) to write our data to disk. You'll be asked what file we want to save this to:
press <kbd>Return</kbd> to accept the suggested default of `README.txt`.

Once our file is saved, we can use <kbd>Ctrl</kbd>-<kbd>X</kbd> to quit the editor and
return to the shell.

> ## Control, Ctrl, or ^ Key
>
> The Control key is also called the "Ctrl" key. There are various ways
> in which using the Control key may be described. For example, you may
> see an instruction to press the <kbd>Ctrl</kbd> key and, while holding it down,
> press the <kbd>X</kbd> key, described as any of:
>
> * `Control-X`
> * `Control+X`
> * `Ctrl-X`
> * `Ctrl+X`
> * `^X`
> * `C-x`
>
> In `nano`, along the bottom of the screen you'll see `^G Get Help ^O WriteOut`.
> This means that you can use <kbd>Ctrl</kbd>-<kbd>G</kbd> to get help and <kbd>Ctrl</kbd>-<kbd>O</kbd> to save your
> file.
{: .callout}

Now you've written a file. You can take a look at it with `less` or `cat`, or open it up again and edit it with `nano`.

> ## Exercise
>
> Open `README.txt` and add the date to the top of the file and save the file. 
>
> > ## Solution
> > 
> > Use `nano README.txt` to open the file.  
> > Add today's date and then use <kbd>Ctrl</kbd>-<kbd>X</kbd> to exit and `y` to save.
> >
> {: .solution}
>
{: .challenge}

## Writing scripts

A really powerful thing about the command line is that you can write scripts. Scripts let you save commands to 
run them and also lets you put multiple commands together. Though writing scripts may require an additional time 
investment initially, this can save you time as you run them repeatedly. Scripts can also address the challenge of 
reproducibility: if you need to repeat an analysis, you retain a record of your command history within the script.

One thing we will commonly want to do with sequencing results is pull out bad reads and write them to a file to
see if we can figure out what's going on with them. We're going to look for reads with long sequences of N's like
we did before, but now we're going to write a script, so we can run it each time we get new sequences, rather than
type the code in by hand each time.

We're going to create a new file to put this command in. We'll call it `bad-reads-script.sh`. The `sh` isn't 
required, but using that extension tells us that it's a shell script.

~~~
$ nano bad-reads-script.sh
~~~
{: .bash}

Bad reads have a lot of N's, so we're going to look for  `NNNNNNNNNN` with `grep`. We want the whole FASTQ
record, so we're also going to get the one line above the sequence and the two lines below. We also want to look
in all the files that end with `.fastq`, so we're going to use the `*` wildcard.

~~~
grep -B1 -A2 NNNNNNNNNN *.fastq > scripted_bad_reads.txt
~~~
{: .bash}

Type your `grep` command into the file and save it as before. Be careful that you did not add the `$` at the 
beginning of the line.

Now comes the neat part. We can run this script. Type:

~~~
$ bash bad-reads-script.sh
~~~
{: .bash}

It will look like nothing happened, but now if you look at `scripted_bad_reads.txt`, you can see that there 
are now reads in the file.


> ## Exercise
>
> We want the script to tell us when it's done.  
> 1. Open `bad-reads-script.sh` and add the line `echo "Script finished!"` after the `grep` command and save the file.  
> 2. Run the updated script.
{: .challenge}

## Making the script into a program

We had to type `bash` because we needed to tell the computer what program to use to run this script. Instead 
we can turn this script into its own program. We need to tell it that it's a program by making it executable. 
We can do this by changing the file permissions. We talked about permissions in 
[an earlier episode](http://www.datacarpentry.org/shell-genomics/03-working-with-files/).

First, let's look at the current permissions.

~~~
$ ls -l bad-reads-script.sh
~~~
{: .bash}

~~~
-rw-rw-r-- 1 dcuser dcuser 0 Oct 25 21:46 bad-reads-script.sh
~~~
{: .output}

We see that it says `-rw-r--r--`. This shows that the file can be read by any user and written to by the 
file owner (you). We want to change these permissions so that the file can be executed as a program. We use the
command `chmod` like we did earlier when we removed write permissions. Here we are adding (`+`) executable 
permissions (`+x`).

~~~
$ chmod +x bad-reads-script.sh
~~~
{: .bash}

Now let's look at the permissions again.

~~~
$ ls -l bad-reads-script.sh
~~~
{: .bash}

~~~
-rwxrwxr-x 1 dcuser dcuser 0 Oct 25 21:46 bad-reads-script.sh
~~~
{: .output}

Now we see that it says `-rwxr-xr-x`. The `x`'s that are there now tell us we can run it as a program. 
So, let's try it! We'll need to put `./` at the beginning so the computer knows to look here in this directory
for the program.

~~~
$ ./bad-reads-script.sh
~~~
{: .bash}

The script should run the same way as before, but now we've created our very own computer program!

You will learn more about writing scripts in 
[a later lesson](https://datacarpentry.org/wrangling-genomics/05-automation/index.html).

## Moving and Downloading Data

So far, we've worked with data that is pre-loaded on the instance in the cloud. Usually, however,
most analyses begin with moving data onto the instance. Below we'll show you some commands to 
download data onto your instance, or to move data between your computer and the cloud.

### Getting data from the cloud

There are two programs that will download data from a remote server to your local
(or remote) machine: ``wget`` and ``curl``. They were designed to do slightly different
tasks by default, so you'll need to give the programs somewhat different options to get
the same behaviour, but they are mostly interchangeable.

 - ``wget`` is short for "world wide web get", and it's basic function is to *download*
 web pages or data at a web address.

 - ``cURL`` is a pun, it is suppose to be read as "see URL", so it's basic function is
 to *display* webpages or data at a web address.

Which one you need to use mostly depends on your operating system, as most computers will
only have one or the other installed by default.

Let's say you want to download some data from Ensembl. We're going to download a very small
tab-delimited file that just tells us what data is available on the Ensembl bacteria server.
Before we can start our download, we need to know whether we're using ``curl`` or ``wget``.

To see which program you have type:
 
~~~
$ which curl
$ which wget
~~~
{: .bash}

``which`` is a BASH program that looks through everything you have
installed, and tells you what folder it is installed to. If it can't
find the program you asked for, it returns nothing, i.e. gives you no
results.

On Mac OSX, you'll likely get the following output:

~~~
$ which curl
~~~
{: .bash}

~~~
/usr/bin/curl
~~~
{: .output}

~~~
$ which wget
~~~
{: .bash}

~~~
$
~~~
{: .output}

This output means that you have ``curl`` installed, but not ``wget``.

Once you know whether you have ``curl`` or ``wget`` use one of the
following commands to download the file:

~~~
$ cd
$ wget ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~
{: .bash}

or

~~~
$ cd
$ curl -O ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~
{: .bash}

Since we wanted to *download* the file rather than just view it, we used ``wget`` without
any modifiers. With ``curl`` however, we had to use the -O flag, which simultaneously tells ``curl`` to
download the page instead of showing it to us **and** specifies that it should save the
file using the same name it had on the server: species_EnsemblBacteria.txt

It's important to note that both ``curl`` and ``wget`` download to the computer that the
command line belongs to. So, if you are logged into AWS on the command line and execute
the ``curl`` command above in the AWS terminal, the file will be downloaded to your AWS
machine, not your local one.

### Moving files between your laptop and your instance

What if the data you need is on your local computer, but you need to get it *into* the
cloud? There are also several ways to do this, but it's *always* easier
to start the transfer locally. **This means if you're typing into a terminal, the terminal
should not be logged into your instance, it should be showing your local computer. If you're
using a transfer program, it needs to be installed on your local machine, not your instance.**

## Transferring Data Between your Local Machine and the Cloud

These directions are platform specific so please follow the instructions for your system:

**Please select the platform you wish to use for the exercises: <select id="id_platform" name="platformlist" onchange="change_content_by_platform('id_platform');return false;"><option value="unix" id="id_unix" selected> UNIX </option><option value="win" id="id_win" selected> Windows </option></select>**



<div id="div_unix" style="display:block" markdown="1">

### Uploading Data to your Virtual Machine with scp

`scp` stands for 'secure copy protocol', and is a widely used UNIX tool for moving files
between computers. The simplest way to use `scp` is to run it in your local terminal,
and use it to copy a single file:

~~~
scp <file I want to move> <where I want to move it>
~~~
{: .bash}

Note that you are always running `scp` locally, but that *doesn't* mean that
you can only move files from your local computer. A command like:

~~~
$ scp <local file> <AWS instance>
~~~
{: .bash}

To move it back, you just re-order the to and from fields:

~~~
$ scp <AWS instance> <local file>
~~~
{: .bash}

#### Uploading Data to your Virtual Machine with scp

1. Open the terminal and use the `scp` command to upload a file (e.g. local_file.txt) to the dcuser home directory:

~~~
$  scp local_file.txt dcuser@ip.address:/home/dcuser/
~~~
{: .bash}

#### Downloading Data from your Virtual Machine with scp

Let's download a text file from our remote machine. You should have a file that contains bad reads called ~/shell_data/scripted_bad_reads.txt.

**Tip:** If you are looking for another (or any really) text file in your home directory to use instead try

~~~
$ find ~ -name *.txt
~~~
{: .bash}


1. Download the bad reads file in ~/shell_data/scripted_bad_reads.txt to your home ~/Download directory using the following command **(make sure you use substitute dcuser@ ip.address with your remote login credentials)**:

~~~
$ scp dcuser@ip.address:/home/dcuser/shell_data/untrimmed_fastq/scripted_bad_reads.txt. ~/Downloads
~~~
{: .bash}

Remember that in both instances, the command is run from your local machine, we've just flipped the order of the to and from parts of the command.
</div>


<div id="div_win" style="display:block" markdown="1">

### Uploading Data to your Virtual Machine with PSCP

If you're using a PC, we recommend you use the *PSCP* program. This program is from the same suite of
tools as the PuTTY program we have been using to connect.

1. If you haven't done so, download pscp from [http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe](http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe)
2. Make sure the *PSCP* program is somewhere you know on your computer. In this case,
your Downloads folder is appropriate.
3. Open the windows [PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell);
go to your start menu/search enter the term **'cmd'**; you will be able to start the shell
(the shell should start from C:\Users\your-pc-username>).
4. Change to the download directory

~~~
> cd Downloads
~~~
{: .bash}

5. Locate a file on your computer that you wish to upload (be sure you know the path). Then upload it to your remote machine **(you will need to know your AMI instance address (which starts with ec2), and login credentials)**. You will be prompted to enter a password, and then your upload will begin. **(make sure you use substitute 'your-pc-username' for your actual pc username and 'ec2-54-88-126-85.compute-1.amazonaws.com' with your AMI instance address)**

~~~
C:\User\your-pc-username\Downloads> pscp.exe local_file.txt dcuser@ec2-3-237-40-20.compute-1.amazonaws.com:/home/dcuser/
~~~
{: .bash}

### Downloading Data from your Virtual Machine with PSCP

1. Follow the instructions in the Upload section to download (if needed) and access the *PSCP* program (steps 1-3)
2. Download the text file using the following command **(make sure you use substitute 'your-pc-username' for your actual pc 
3. username and 'ec2-3-237-40-20.compute-1.amazonaws.com' with your AMI instance address)**

~~~
C:\User\your-pc-username\Downloads> pscp.exe dcuser@ec2-3-237-40-20.compute-1.amazonaws.com:/home/dcuser/shell_data/untrimmed_fastq/scripted_bad_reads.txt.

C:\User\your-pc-username\Downloads
~~~
{: .bash}

</div>



## Summary

We now know how to move around our file system using the command line.
This gives us an advantage over interacting with the file system through
a GUI as it allows us to work on a remote server, carry out the same set of operations 
on a large number of files quickly, and opens up many opportunities for using 
bioinformatics software that is only available in command line versions. 

In the next few episodes, we'll be expanding on these skills and seeing how 
using the command line shell enables us to make our workflow more efficient and reproducible.
