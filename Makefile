prepare_kernel:
	git clone https://github.com/CamFlow/camflow-dev.git
	cd camflow-dev && $(MAKE) prepare_kernel

prepare_pathexaminer2:
	git clone https://scm.gforge.inria.fr/anonscm/git/kayrebt/PathExaminer2.git

prepare_autotools:
	sudo apt-get -y install ruby
	sudo apt-get -y install uncrustify
	sudo apt-get -y install bison
	sudo apt-get -y install flex
	sudo apt-get -y install zsh
	sudo apt-get -y install libncurses5-dev libncursesw5-dev
	sudo apt-get -y install bc
	sudo apt-get -y install libssl-dev
	sudo apt-get -y install libelf-dev
	sudo apt-get -y install autoconf automake
	sudo apt-get -y install libtool

prepare_gcc:
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/gcc-4.8-base_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i gcc-4.8-base_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libasan0_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i libasan0_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/c/cloog/libcloog-isl4_0.18.4-1_amd64.deb
	sudo dpkg -i libcloog-isl4_0.18.4-1_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/cpp-4.8_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i cpp-4.8_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libgcc-4.8-dev_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i libgcc-4.8-dev_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/libstdc++-4.8-dev_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i libstdc++-4.8-dev_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/gcc-4.8_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i gcc-4.8_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/g++-4.8_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i g++-4.8_4.8.5-4ubuntu2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/main/g/gmp/libgmpxx4ldbl_6.1.0+dfsg-2_amd64.deb
	sudo dpkg -i libgmpxx4ldbl_6.1.0+dfsg-2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/main/g/gmp/libgmp-dev_6.1.0+dfsg-2_amd64.deb
	sudo dpkg -i libgmp-dev_6.1.0+dfsg-2_amd64.deb
	wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-4.8/gcc-4.8-plugin-dev_4.8.5-4ubuntu2_amd64.deb
	sudo dpkg -i gcc-4.8-plugin-dev_4.8.5-4ubuntu2_amd64.deb
	sudo apt-get -f install -y
	rm *.deb
	sudo rm /usr/bin/gcc
	sudo ln -s /usr/bin/gcc-4.8 /usr/bin/gcc

prepare_gpp:
	sudo ln -s /usr/bin/g++-4.8 /usr/bin/g++

prepare_m4:
	sudo cp -f -a ./m4/. /usr/share/aclocal

prepare_yices:
	sudo add-apt-repository ppa:sri-csl/formal-methods
	sudo apt-get update
	sudo apt-get -y install yices2
	sudo apt-get -y install yices2-dev

prepare_config:
	cd PathExaminer2/ && autoreconf --install

prepare: prepare_kernel prepare_pathexaminer2 prepare_autotools prepare_gcc prepare_gpp prepare_m4 prepare_yices prepare_config

config_pathexaminer2:
	cd PathExaminer2/ && ./configure
	cd PathExaminer2/ && make
	cd PathExaminer2/ && sudo make install

config_kernel:
	cd camflow-dev/scripts && $(MAKE) config_kernel

