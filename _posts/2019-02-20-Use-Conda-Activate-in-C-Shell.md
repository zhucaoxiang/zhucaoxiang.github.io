[Conda](https://conda.io/en/latest/) is one of the most popular package, dependency and environment management for python.
I use [Anaconda](https://www.anaconda.com/distribution/) to manage my python environments.
It is a great software.
This only issue I have is that switching environment by `conda actiavte ENV_NAME` or `conda deactivate` in non-bash shells, 
like C-shell that I am using right now, is not working.

Per this [pull request](https://github.com/conda/conda/pull/3175) on Conda's GitHub repository, the developer team has added supports to C-based shells after version 4.3.
Somehow, the version 4.6.4 that I am currently using still doesn't support C-shell.
Here are the error I have if I try to switch environments in C-shell.
```
$ conda env list
conda env list
# conda environments:
#
maya                     /p/share/.conda/envs/maya
py37                     /p/share/.conda/envs/py37
base                  *  /p/share/Anaconda2

$conda activate maya

CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
To initialize your shell, run

    $ conda init <SHELL_NAME>

Currently supported shells are:
  - bash
  - fish
  - tcsh
  - xonsh
  - zsh
  - powershell

See 'conda init --help' for more information and options.

IMPORTANT: You may need to close and restart your shell after running 'conda init'.


$ conda init tcsh
# >>>>>>>>>>>>>>>>>>>>>> ERROR REPORT <<<<<<<<<<<<<<<<<<<<<<

    Traceback (most recent call last):
      File "/p/share/Anaconda2/lib/python2.7/site-packages/conda/exceptions.py", line 1002, in __call__
        return func(*args, **kwargs)
      File "/p/share/Anaconda2/lib/python2.7/site-packages/conda/cli/main.py", line 84, in _main
        exit_code = do_call(args, p)
      File "/p/focus/Anaconda2/lib/python2.7/site-packages/conda/cli/conda_argparse.py", line 82, in do_call
        exit_code = getattr(module, func_name)(args, parser)
      File "/p/share/Anaconda2/lib/python2.7/site-packages/conda/cli/main_init.py", line 52, in execute
        anaconda_prompt)
      File "/p/share/Anaconda2/lib/python2.7/site-packages/conda/core/initialize.py", line 105, in initialize
        plan2 = make_initialize_plan(conda_prefix, shells, for_user, for_system, anaconda_prompt)
      File "/p/share/Anaconda2/lib/python2.7/site-packages/conda/core/initialize.py", line 466, in make_initialize_plan
        raise NotImplementedError()
    NotImplementedError
```

Or I could try to specify the location of activate script by
```
$ source /p/share/Anaconda2/bin/activate maya
_CONDA_ROOT=/p/focus/share/Anaconda2: Command not found.
_CONDA_ROOT: Undefined variable.
```
Still it doesn't work. One solution I can com up with is to open bash and use everything in bash. But it's really not a solution.

Recently, I found a very useful script online. 
Here is the [original link](https://gist.github.com/mikecharles/f09486e884a0b41e1e8f) (author: mikecharles).
In the above gist, the author doesn't write down an instruction.
Here is a simple one I write.
You could do the following steps to smoothly switch python envs in C-shell.
1. Download the `activate.csh` and `deactivate.csh` files to your directory, in my case `/p/share/Anaconda2/bin/`.
2. Specify you environment path, like `setenv CONDA_ENVS_PATH /p/share/.conda/envs/`.
3. Activate envs by `source PATH_TO_activate.csh ENV_NAME`, e.g. `source /p/share/Anaconda2/bin/activate.csh maya`.
4. Deactivate by `source PATH_TO_deactivate.csh`.

You could also put the variable CONDA_ENVS_PATH in your `.cshrc` file and make alias to the commands.
For you convenience, here are links to the two scripts: [activate.csh](/assets/files/activate.csh) and [deactivate.csh](/assets/files/deactivate.csh).

__UPDATE:__ By doing so, when you use `conda install ` to install packages, there is a possibility that you will install it under the default env rather than the current one.
