Windows Virtual Environment Installers
=============================================

These scripts provide a simple way to set up a virtual environment for easy project installation on Windows. There are three different variants of the script, each using a different package manager (Micromamba, Micromamba/Conda and Miniconda)

There are versions of each for both Batch (CMD.exe) and Powershell.

Usage:
-----

In each of the script folders there are two scripts:

### Install script
This script will download the relevent package manager and use it to create a virtual environment that is independent of the system's package manager or Python installations.

These scripts can be easily modified to perform the tasks needed for your specific project. I have tried to keep the relevent variables for modification towards the top of the scripts as well as provide a clearly defined section for task-specific commands. I have also tried to format the scripts to provide context for how they may be modified so that those not familiar with Batch or Powershell may still make adequate use of them.

These scripts have been tested for use on Windows 10+.
They may or may not work on Windows 7 as it is not officially supported by any of the utilized package managers. These scripts make use of `curl`, which is not included by default with Windows 7/8.

### venv-cli script
This script will open a command-line with the virtual environment activated for easy modification and troubleshooting.

run-ps-script.cmd
-----------------
Within the Powershell folder is an example Batch script that executes a Powershell script.

This script provides an easy way for executing a Powershell script on systems using the default `Restricted` Powershell script execution policy. Powershell will not allow scripts to be directly executed when that policy is set to `Restricted`. For details on changing that policy, see here: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy

Which script to choose?
-----------------------
It depends on your specific needs and preferences. The three variants of the script each have their own strengths and weaknesses. For example, if you want a simple and lightweight package manager, Micromamba might be the best choice for you. If you need more advanced features or want to use a different package manager, you may prefer one of the other options.

### Micromamba:
+ Is lightweight and tends to be faster then Conda due to it's use of Mamba.
+ Does not require installation, merely needing to download a small executable to set up the environment.
- I've noticed that it tends to be inconsistent across different systems.
- For reasons that I am unsure of, it will, on rare occasion, not work on a particular system.

### Micromamba-Conda-bootstrap:
+ Uses Micromamba to create an environment containing Python and Conda.
+ Uses Conda for package management after installation.
+ Due to this, the end setup is contained within a single folder, simplifying the folder structure.
+ Should be portable.
- Is slower to set up and install packages
- Is the least tested of the scripts, though it has not failed me yet.
- Initial setup uses Micromamba, and later uses Conda, resulting in this method being subjected to the weaknesses of both.

### Miniconda:
+ Creates a local, independent installation of Miniconda for environment creation and package management.
+ Is the most consistent and reliable of the scripts.
- Uses more disk space than the other methods.
- Uses Conda for package management which is noticeably slower than Mamba.
- Requires additional time to set up due to the installation of Miniconda.
- Miniconda will fail to install under a path containing spaces. This is due to the use of silent installation.

#### All of these package managers will have problems with long paths, especially on Windows 11.
