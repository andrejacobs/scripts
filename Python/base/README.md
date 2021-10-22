## New Python project starter

I use the following scripts to setup a new Python 3 based project using a virtual environment.

To create a new project:

* Create a new directory.

* Copy all the files from this directory into the new directory. [You can delete the README.md, this file].

* Run `./new-project.sh`.
	* This will create a new Python virtual environment as well as update pip3.

Install the dependencies you want to use with pip. For example `pip3 install click`.

Develop and test your code.

Update the `requirements.txt` file so it is easy to install the project somewhere else.

* Run `./update-requirements.sh` 

Installing the project:

* Copy the directory to the new location / machine
* Run `./new-project.sh`
* Run `./install-requirements.sh`