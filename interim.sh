echo "Creating arkouda-dev environment"
cd projects/arkouda
conda env create --file=arkouda-env-dev.yml
pip install -e . --no-deps
echo "Now exit this shell and start a new one."
