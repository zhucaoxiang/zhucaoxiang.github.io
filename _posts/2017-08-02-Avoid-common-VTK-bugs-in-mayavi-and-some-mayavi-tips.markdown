---
layout: post
title:  "Avoid common VTK bugs in mayavi and some mayavi tips"
date:   2017-08-02
categories: python
tags: mayavi
---

[Mayavi](http://docs.enthought.com/mayavi/mayavi/) is a 3D scientific data visualization and plotting package in Python.
It's incorporated with Python and really powerful in 3D plotting.
However, it's also suffering considerable amount of bugs and conflicts.
And it seems that it's lacking official supporting.
Maybe, in the future, I will move to another plotting tool.
Anyway, this post is about avoiding one of its bugs that I hated most.
And an example of using it making animations.

## About the bug
Mayavi can be used for animating the data.
A simple example like:

```python
from mayavi import mlab
pts = mlab.points3d([0,1], [0,1], [0,1])
pts.mlab_source.set(x=[0,2])
```

When running this example, there was a error message pop-out.

```
ERROR: In /home/ilan/minonda/conda-bld/work/VTK-6.3.0/Common/ExecutionModel/vtkExecutive.cxx, line 784
vtkCompositeDataPipeline (0x2d140550): Algorithm vtkAssignAttribute(0x1c5bc6d0) returned failure for request: vtkInformation (0x2ec16c50)
  Debug: Off
  Modified Time: 5666470
  Reference Count: 1
  Registered Events: (none)
  Request: REQUEST_DATA_OBJECT
  FORWARD_DIRECTION: 0
  ALGORITHM_AFTER_FORWARD: 1
```

But actually, it plots out the figure normally.
This error message is annoying, especially when I need to animate data hundreds or even thousands times.

## Solution
I searched the internet and found an [issue](https://github.com/enthought/mayavi/issues/3) in Mayavi's GitHub repository.
Interestingly, it was created in 2011 and it's still unsolved.
But, in that discussion, **solarjoe** pointed out that using *scalars* option could eliminate this error.
I tested it and it worked.
[`np.ones_like()`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ones_like.html) function would be a good idea when you don't need any scalars, like:

```python
plt = mlab.points3d(x, y, z, np.ones_like(x), color=(1,0,0))
```

## Example for making animations
There is an easy way to make movies using **MoviePy**.
Here is the [link](http://zulko.github.io/blog/2014/11/29/data-animations-with-python-and-moviepy/).
However, it depends on several packages and a software **FFMPEG**, which would be not convenient for cluster using.
Currently, I'm using the [animate](http://docs.enthought.com/mayavi/mayavi/auto/mlab_other_functions.html#mayavi.mlab.animate) function in Mayavi.
And for making *gif*, I use [Imagemagick](https://www.imagemagick.org/script/index.php) to convert multiple *png* files into a *gif*.
Here is a full example:

```python
import numpy as np
from mayavi import mlab
import subprocess

# Data preparing
n_mer, n_long = 6, 11
pi = np.pi
dphi = pi/1000.0
phi = np.arange(0.0, 2*pi + 0.5*dphi, dphi, 'd')
mu = phi*n_mer
x = np.cos(mu)*(1+np.cos(n_long*mu/n_mer)*0.5)
y = np.sin(mu)*(1+np.cos(n_long*mu/n_mer)*0.5)
z = np.sin(n_long*mu/n_mer)*0.5

# View it.
l = mlab.plot3d(x, y, z, np.sin(mu), tube_radius=0.025, colormap='Spectral')

# Now animate the data.
ms = l.mlab_source
aniname = 'fun'
fps = 10

@mlab.show
@mlab.animate(delay=250)
def anim():
    """Animate the lines"""
    for i in range(10):
		#animating the data
        x = np.cos(mu)*(1+np.cos(n_long*mu/n_mer + np.pi*(i+1)/5.)*0.5)
        scalars = np.sin(mu + np.pi*(i+1)/5)
        ms.set(x=x, scalars=scalars)
		
		# Save figures into individual pngs
        pngname = aniname + '_' + str(i).zfill(3) + '.png'
        mlab.savefig(filename=pngname)
				
        yield
    mlab.close(mlab.clf())

# Run the animation.
anim()

# Convert to gif
cmd = 'convert -delay {} -loop 0 {} {}'.format(10.0/fps, aniname+'_*.png', aniname+'.gif')
subprocess.call(cmd, shell=True)
subprocess.call("rm -f "+aniname+'_*.png', shell=True)

print "Finished. Please view ", aniname+'.gif'
```

*After making animations, you might get stuck if you have opened matplotlib windows.*
*It will be fixed if you closed all the matplotlib windows.*
*Annoying, but I have no better solutions.*

## Other tips

There are also some other tips I gathered when I was using Mayavi.

- Use mayavi in ipython

  If you want to use `mayavi.mlab` in ipython, you need to specify using *PyQt* engine.
  Put these in your environmental file (cshell like)
  
  ```shell
  setenv QT_API pyqt
  setenv ETS_TOOLKIT qt4
  ```
  
  And then start ipython with just typing `ipython`.

- Mayavi conflicts with matplotlib

  [Matplotlib](https://matplotlib.org/) is the most popular plotting tool in Python.
  But it's not good enough for 3D plotting.
  So, I usually use matplotlib for 2D plotting and mayavi for 3D.
  Unfortunately, mayavi and matplotlib have a lot of conflicts.
  The two main conflicts are 
	  * different PyQt versions
		Mayavi and matplotlib are using different versions of PyQt.
		Luckily, matplotlib has more capabilities.
		So the solution is always import mayavi first.
		Especially, if you want to use ipython, do not start with `ipython --pylab`.
		Try `ipython`, then `from mayavi import mlab` and then `%pylab`.
	  * mlab naming confliction
		Matplotlib also has a package name mlab.
		Do not use the same shortcut for both `matplotlib.mlab` and `mayavi.mlab`.

- `mlab.savefig()` saves empty figure

  If the function `mlab.savefig` exports empty figures, you may need to turn on the offscreen vendering before you call it.
  
  ```python
  mlab.options.offscreen = True
  ```
  
