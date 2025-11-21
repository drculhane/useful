
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
