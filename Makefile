prepare_kernel:
	git clone https://github.com/CamFlow/camflow-dev.git
	cd camflow-dev && git checkout tinkerbell && $(MAKE) prepare_kernel

prepare_pathexaminer2:
	git clone https://github.com/CamFlow/PathExaminer2

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
	sudo rm -f /usr/bin/g++
	sudo ln -s /usr/bin/g++-4.8 /usr/bin/g++

prepare_m4:
	sudo cp -f -a ./m4/. /usr/share/aclocal

prepare_yices:
	sudo add-apt-repository ppa:sri-csl/formal-methods -y
	sudo apt-get update
	sudo apt-get -y install yices2
	sudo apt-get -y install yices2-dev

prepare_callgraph:
	git clone https://github.com/CamFlow/callgraphs.git

prepare: prepare_pathexaminer2 prepare_callgraph prepare_gcc prepare_gpp prepare_m4 prepare_yices

config_pathexaminer2:
	cd PathExaminer2/ && autoreconf --install
	cd PathExaminer2/ && ./configure
	cd PathExaminer2/ && $(MAKE)
	cd PathExaminer2/ && sudo make install

config_callgraph:
	cd callgraphs/ && autoreconf --install
	cd callgraphs/ && ./configure
	cd callgraphs/ && $(MAKE)
	cd callgraphs/ && sudo make install

config_sqlite:
	cd ../linux-stable && touch create_db.sh
	cd ../linux-stable && echo '#!/bin/bash' >> create_db.sh
	cd ../linux-stable && echo 'cat <<EOF | sqlite3 db.sqlite' >> create_db.sh
	cd ../linux-stable && echo 'CREATE TABLE functions (Id INTEGER PRIMARY KEY, Name TEXT, File TEXT, Line INTEGER, Global INTEGER);' >> create_db.sh
	cd ../linux-stable && echo 'CREATE TABLE calls (Caller INTEGER, Callee INTEGER, PRIMARY KEY (Caller,Callee));' >> create_db.sh
	cd ../linux-stable && echo 'EOF' >> create_db.sh
	cd ../linux-stable && chmod u+x create_db.sh
	cd ../linux-stable && ./create_db.sh

config_kernel:
	cd camflow-dev/scripts && $(MAKE) config_kernel
	rm -rf build && mv camflow-dev/build .
	cd build && rm -rf information-flow-patch/ && rm -rf pristine/
	cd build/linux-stable && rm -rf .git

config: config_pathexaminer2 config_callgraph config_sqlite

compile:
	cd ../linux-stable && $(MAKE) CC=gcc HOSTCC=gcc EXTRA_CFLAGS="-fplugin=kayrebt_callgraphs -fplugin-arg-kayrebt_callgraphs-dbfile=db.sqlite"
