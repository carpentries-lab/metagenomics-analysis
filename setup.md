---
layout: page
title: Setup
---

# Overview

This workshop is designed to be run on pre-imaged Amazon Web Services (AWS)
instances. With the exception of a spreadsheet program, all of the command line software and data used in the workshop are hosted on an Amazon 
Machine Image (AMI). Please follow the instructions below to prepare your computer for the workshop:



## Required  software

This lesson requires a working spreadsheet program. If you don't have a spreadsheet program already, you can use LibreOffice. It's a free, open source spreadsheet program.  Directions to install are included for each Windows, Mac OS X, and Linux systems below. For Windows, you will also need to install Git Bash, PuTTY, or the Ubuntu Subsystem.

> ## Windows
> - Download the [Git for Windows installer](https://git-for-windows.github.io/). Run the installer and follow the steps below:
>   + Click on "Next" four times (two times if you've previously installed Git). You don't need to change anything in the Information, location, components, and start menu screens.
>   + Select "Use the nano editor by default" and click on "Next".
>   + Keep "Use Git from the Windows Command Prompt" selected and click on "Next". If you forgot to do this programs that you need for the workshop will not work properly. If this happens rerun the installer and select the appropriate option.
>   + Click on "Next".
>   + Keep "Checkout Windows-style, commit Unix-style line endings" selected and click on "Next".
>   + Select "Use Windows' default console window" and click on "Next".
>   + Click on "Install".
>   + Click on "Finish".
>   + If your "HOME" environment variable is not set (or you don't know what this is):
>   + Open command prompt (Open Start Menu then type `cmd` and press [Enter])
>   + Type the following line into the command prompt window exactly as shown: `setx HOME "%USERPROFILE%"`
>   + Press [Enter], you should see `SUCCESS: Specified value was saved.`
>   + Quit command prompt by typing `exit` then pressing [Enter]
> - An **alternative option** is to install PuTTY by going to the [the installation page](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html). For most newer computers, click on putty-64bit-X.XX-installer.msi to download the 64-bit version. If you have an older laptop, you may need to get the 32-bit version putty-X.XX-installer.msi. If you aren't sure whether you need the 64 or 32 bit version, you can check your laptop version by following [the instructions here](https://support.microsoft.com/en-us/help/15056/windows-32-64-bit-faq). Once the installer is downloaded, double click on it, and PuTTY should install.
> - **Another alternative option** is to use the Ubuntu Subsystem for Windows. This option is only available for Windows 10 - detailed [instructions are available here](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
{: .solution}

> ## Mac OS X
> -  The default shell in some versions of macOS is Bash, and Bash is available in all versions, so no need to install anything. You access Bash from the Terminal (found in /Applications/Utilities). See the Git [installation video tutorial](https://www.youtube.com/watch?v=9LQhwETCdwY) for an example on how to open the Terminal. You may want to keep Terminal in your dock for this workshop.
{: .solution}

> ## Linux
>  - The default shell is usually Bash and there is usually no need to install anything. To see if your default shell is Bash type echo $SHELL in a terminal and press the Enter key. If the message printed does not end with '/bash' then your default is something else and you can run Bash by typing bash.
{: .solution}


## Using the lessons with Amazon Web Services (AWS)

If you are signed up to take a Metaggenomics Data Carpentry workshop, you do *not* need to worry about setting up an AMI instance. The Carpentries
staff will create an instance for you and this will be provided to you at no cost. This is true for both self-organized and centrally-organized workshops. Your Instructor will provide instructions for connecting to the AMI instance at the workshop.

If you would like to work through these lessons independently, outside of a workshop, you will need to start your own AMI instance. 
Follow these [instructions on creating an Amazon instance](https://datacarpentry.org/genomics-workshop/AMI-setup/). Use the AMI `ami-0478bdae4d294d131` (Metagenomics (The Carpentries Incubator)(April 2019)) listed on the Community AMIs page. Please note that you must set your location as `N. Virginia` in order to access this community AMI. You can change your location in the upper right corner of the main AWS menu bar. The cost of using this AMI for a few days, with the t2.medium instance type is very low (about USD $1.50 per user, per day). Data Carpentry has *no* control over AWS pricing structure and provides this cost estimate with no guarantees. Please read AWS documentation on pricing for up-to-date information. 

If you're an Instructor or Maintainer or want to contribute to these lessons, please get in touch with us [team@carpentries.org](mailto:team@carpentries.org) and we will start instances for you. 

After the genomic instace is setup you need to addition the metagenomics environment. First create the file `metagenomics.yml`
with the following content:  
~~~
$ cat metagenomics.yml
~~~
{: .bash}
~~~
name: metagenomics                                                                
dependencies:                                      
  - kraken2 
  - krona             
  - maxbin2
  - taxonkit
  - spades
  - kraken-biom
  - checkm-genome

~~~
{: .output}

Then create the metagenomics conda environment using the metagenomics.yml file.  
~~~
$ conda env create -f metagenomics.yml
~~~
{: .bash}  

Finally execute some remaining installation scripts.  
~~~
bash /home/dcuser/.miniconda3/envs/metagenomics/opt/krona/updateTaxonomy.sh                                
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz 
tar -xzf taxdump.tar.gz 
mkdir .taxonkit
cp names.dmp nodes.dmp delnodes.dmp merged.dmp /home/dcuser/.taxonkit
rm *dmp readme.txt taxdump.tar.gz gc.prt 
~~~
{: .bash}  

### Data

The data used in this workshop are available on Zenodo. Because this workshop works with real data, be aware that file sizes for the data are large. Please read the Zenodo page linked below for information about the data and access to the data files. 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4285901.svg)](https://doi.org/10.5281/zenodo.4285901)


More information about these data will be presented in the [first lesson of the workshop](https://carpentries-incubator.github.io/metagenomics/01-background-metadata/index.html).
