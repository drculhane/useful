cd ~
echo "Making directories"
mkdir tinkering
mkdir projects
mkdir misc
# create the arkouda directory and clone the main
cd projects
echo "Getting arkouda"
git clone https://github.com/drculhane/arkouda.git
cd arkouda
git remote add upstream https://github.com/Bears-R-Us/arkouda.git
git config --global user.name drculhane
git config --global user.email drculhane@users.noreply.github.com
cp  ~/useful/Makefile.paths ~/projects/arkouda
# get miniconda, but don't install it yet
echo "Getting miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# install chapel prerequisites.  This will vary per Linux distro.  These are for Ubuntu.
echo "Getting chapel prerequisites."
sudo apt-get update
sudo apt-get install gcc g++ m4 perl python3 python3-dev bash make mawk git pkg-config cmake
sudo apt-get install llvm-dev llvm clang libclang-dev libclang-cpp-dev libedit-dev
# get the chapel source
echo "Getting chapel"
cd ~
curl -LO https://github.com/chapel-lang/chapel/releases/download/2.6.0/chapel-2.6.0.tar.gz
tar xvf chapel-2.6.0.tar.gz
echo "Got the stuff"
