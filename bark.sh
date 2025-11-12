cd ~
mkdir tinkering
mkdir projects
mkdir misc
# get the chapel source
curl -LO https://github.com/chapel-lang/chapel/releases/download/2.6.0/chapel-2.6.0.tar.gz
tar xvf chapel-2.6.0.tar.gz
# create the arkouda directory and clone the main
cd projects
git clone https://github.com/drculhane/arkouda.git
git remote add upstream https://github.com/Bears-R-Us/arkouda.git
git config --global user.name drculhane
git config --global user.email drculhane@users.noreply.github.com
# get miniconda, but don't install it yet
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# get other tools I use a lot
echo "Getting useful tools."
cd ~
git clone https://github.com/drculhane/useful.git
cd useful
mv Makefile.paths ~/projects/arkouda/Makefile.paths
mv bashrc ~/.bashrc
mv chhunt.sh ~/misc
mv pyhunt.sh ~/misc
mv vimrc ~/.vimrc
mv -r vimstuff ~/.vim
# install miniconda
cd
sh miniconda.sh
# now create the virtual environment
cd $ARKOUDA_HOME
conda env create --file=arkouda-env-dev.yml
pip install -e . --no-deps
echo "Time to close this shell and make a new one."
