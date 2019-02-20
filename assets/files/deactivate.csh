#!/bin/csh

# Make sure the $CONDA_ENVS_PATH env var is defined
if ( ! $?CONDA_ENVS_PATH ) then
	echo ""
	echo 'You must set the environment variable $CONDA_ENVS_PATH to point to the parent directory containing your Anaconda environments\n'
	exit 2
endif

# Make sure the $CONDA_ENVS_PATH env var isn't empty
if ( "$CONDA_ENVS_PATH" == "" ) then
	echo ""
	echo "You must set the environment variable \$CONDA_ENVS_PATH to point to the parent directory containing your Anaconda environments\n\n"
	exit 2
endif

# Make sure the $CONDA_PROD_ENV_BIN env var is defined
if ( ! $?CONDA_PROD_ENV_BIN ) then
	echo ""
	echo 'Something went wrong with your Python environment. Try opening a new terminal to start with a fresh environment.\n'
	exit 2
endif

# Make sure the $CONDA_PROD_ENV_BIN env var isn't empty
if ( "$CONDA_PROD_ENV_BIN" == "" ) then
	echo ""
	echo "Something went wrong with your Python environment. Try opening a new terminal to start with a fresh environment.\n\n"
	exit 2
endif

# Get the current python binary
set python_path=`which python`

# See if the current python binary is found under $CONDA_ENVS_PATH, exit if not
set test=`echo $python_path | awk -v test="$CONDA_ENVS_PATH" '$0 ~ test { print "MATCH" }'`
if ( $test != "MATCH" ) then
	echo "You're not currently using a conda environment"
	exit 0
endif

# Remove all occurrences of this python binary path from the $PATH
if ( $test == "MATCH" ) then
	set python_bin_dir=`echo $python_path | sed 's|/python$||'`
	setenv PATH `echo $PATH | sed -e 's|^'$python_bin_dir':||' -e 's|:'$python_bin_dir':|:|' -e 's|:'$python_bin_dir'$||'`
endif

# Add the production conda environment to the $PATH
setenv PATH ${CONDA_PROD_ENV_BIN}:${PATH}

# Get the name of the current conda environment
set conda_env=`echo $python_path | sed -e 's|^'$CONDA_ENVS_PATH'/||' -e 's|/bin/python$||'`

# Remove the name of the conda environment from the prompt
if ( $?prompt_saved ) then
	set prompt="$prompt_saved"
else
	# This version looses any trailing spaces.
	set prompt=`echo "$prompt" | sed 's|^('$conda_env')||'`
endif

# Print help info
echo "Your Python environment has been reset. Here's the active version of Python:"
which python
python --version
