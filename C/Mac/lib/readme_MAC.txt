I was finally able to also compile the Mac gcc with static linked libraries.

No worries about below libaries anymore.
I leave the text in for anyone interested in "historic steps" :-)


----

To run GCC needs the libraries mpfr and gmp installed.

There are three methods this can be acchieved.

1) the good way
Install the libraries using a package manager

2) the bad way
Just copy the libs to the folder they belong to

3) the middle way
Add the libraries that come with Vide to the library search path.


The preferred way is to install the „naturally“ using an installer (see -> the good way).


1. The good way!
--------------
If not installed - install the the package manager „hombrew“.
Go to the internet site: 
	https://brew.sh 

and follow the instructions.
(you will need a admin password for „sudo“)

Depending on your preconditions installing will take a bit.

After installing type: 
 brew install mpfr
 brew install gmp

Than both libraries are installed correctly.


2. the bad way
-----------
If such an install is in someway not possible, one can copy the folders 
„mpfr" and „gmp“ to

/usr/local/opt

To do this possibly one needs admin rights, or a sudo command.


3. the middle way
--------------
The libraries contained in this directory C/Mac/lib are added to the library search path.
As of now Vide does this non optional. While calling gcc it adds to the environment variable
DYLD_LIBRARY_PATH the paths to both libraries.

This seems to work ok, though I don't know if it may cause trouble with other Mac-Systems.
Feedback on this is welcome.

