# install chapel prerequisites.  This will vary per Linux distro.  These are for Alma.
sudo dnf upgrade
sudo dnf install gcc gcc-c++ m4 perl python3 python3-devel bash make gawk git cmake
sudo dnf install which diffutils
sudo dnf install llvm-devel clang clang-devel
# make chapel
cd $CHPL_HOME
make
# do the rest
make frontend-shared
cd third-party/chpl-venv
make clobber
cd ../../tools/chapel-py
pip install -e . --no-deps
cd $CHPL_HOME
make chpldoc
# now make arkouda
cd $ARKOUDA_HOME
make register-commands
make
