
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
# get miniconda, but don't install it yet
echo "Getting miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# get other tools I use a lot
echo "Getting useful tools."
cd ~
git clone https://github.com/drculhane/useful.git
cd useful
read -n 1 -s -r -p "Press any key to continue..."
mv Makefile.paths ~/projects/arkouda/Makefile.paths
mv bashrc ~/.bashrc
mv chhunt.sh ~/misc
mv pyhunt.sh ~/misc
mv vimrc ~/.vimrc
mv -r vimstuff ~/.vim
echo "Installing miniconda"
# install miniconda
cd
sh miniconda.sh
echo "Time to close this shell and make a new one."
