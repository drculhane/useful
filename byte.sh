# install chapel prerequisites.  This will vary per Linux distro.  These are for Alma.
echo "Getting chapel prerequisites."
sudo dnf upgrade
sudo dnf install gcc gcc-c++ m4 perl python3 python3-devel bash make gawk git cmake
sudo dnf install which diffutils
sudo dnf install llvm-devel clang clang-devel
# get the chapel source
echo "Getting chapel"
cd ~
curl -LO https://github.com/chapel-lang/chapel/releases/download/2.6.0/chapel-2.6.0.tar.gz
tar xvf chapel-2.6.0.tar.gz
# make chapel
echo "Making chapel, etc."
cd ~/chapel-2.0.6
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
echo "Making arkouda"
cd $ARKOUDA_HOME
make register-commands
make
