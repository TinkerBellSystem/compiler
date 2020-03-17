# LSM
This repository contains code and scripts to configure and compile `CamFlow`-enbaled Linux Kernel 
using two additional GCC plugins: `Kayrebt::PathExaminer2` and `Kayrebt::CallGraphs`. 
Information regarding these two tools can be found [here](http://kayrebt.gforge.inria.fr/index.html).

Our latest execution of this repository (March 2020) on a Linux Ubuntu x86-64 16.04.1 physical machine 
with a 4.15.0-76-generic kernel was successful.

### Run
Using our `Makefile`, we can easily run the code in this repository.

Start with some basic tool and code preparation. You will notice that the plugins work only for a specific old version of GCC.
(This is unfortunate, but we will have to deal with it.) 
Therefore, during this step, we also prepare the GCC in addition to the GCC plugins:
```
make prepare
```
We then configure and install the GCC plugins as well as the Linux Kernel:
```
make config
```
Lastly, we compile the Kernel with the plugin enabled:
```
make compile
```
Compiling kernel is time consuming and it is even slower with our GCC plugin enabled. Please be patient.
