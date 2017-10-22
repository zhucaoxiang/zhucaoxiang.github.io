---
layout: post
title:  "Create STL model for 3D printing using python"
date:   2017-10-22
categories: python
tags: mayavi; paraview
---

This post is to introduce a practical method of producing the standard STL model, which can be used for 3D
printing or CAD softwares, for complicated surfaces/volumes from analytical equations.
It uses `Mayavi` to generate a *vtk* file, and `Paraview` to convert *vtk* file into *STL* file.
It is helpful if you want to import a complicate line/surface/volume model into CAD softwares.

## Description of the model
I want to 3D print the model of [NCSX](https://en.wikipedia.org/wiki/National_Compact_Stellarator_Experiment) plasma.
The equations to describe the shape of the outmost surface are
\\[ R = \sum Rbc_{m,n} \, \cos(m\theta - n\phi) +  Rbs_{m,n} \, \sin(m\theta - n\phi), \\]
\\[ Z = \sum Zbc_{m,n} \, \cos(m\theta - n\phi) + Zbs_{m,n} \, \sin(m\theta - n\phi) . \\]
Here, the surface is expressed in the cylinder coordinate $(R, \phi, Z)$.
Once the Fourier coefficients $Rbc_{m,n}$, $Rbs_{m,n}$, $Zbc_{m,n}$ and $Zbs_{m,n}$ are determined, we can plot the surface.

## Using Mayavi to plot the surface
I have a python script to plot the surface using `Mayavi`.
The basic idea is to discretize the surface and plot the mesh data with ([*mlab mesh*](http://docs.enthought.com/mayavi/mayavi/auto/mlab_helper_functions.html#mayavi.mlab.mesh))

```python
fig  = mlab.figure(bgcolor=(1,1,1),fgcolor=(0,0,0),size=(600,600))
surf = mlab.mesh(x[0:npol, 0:ntor],y[0:npol, 0:ntor],z[0:npol, 0:ntor],color=(1,0,0))
```

The output figure is as shown below,
![](/assets/images/post_20171022_1_01.jpg)

Save the *GridSource* as a *vtk* file.
![](/assets/images/post_20171022_1_02.jpg)

## Convert vtk file into STL file
[Paraview](https://www.paraview.org/) is is an open-source, multi-platform data analysis and visualization application.
I'm trying to move to Paraview and abandon `Mayavi` due to lacking of maintains.
Using `Paraview`, we can directly open the *vtk* file saved previously.
And we can also convert it into *STL* file format by clicking `File` - `Save Data...` - `Files of type -> *.stl`.

## 3D print it!
Now we have the standard *STL* file and it can be imported to any popular CAD softwares or just used for 3D printing.
Since there are no 3D printers in my lab, I contacted a commercial company through [Taobao](https://detail.tmall.com/item.htm?id=43406893416&spm=a1z09.2.0.0.169149bb7gIbgl&_u=mk3ght6e0e6) and paid ¥289.00 ($42.41) with a size of `106mm x 103mm x 38mm`.
After one week, the item was delivered.
The final photo is as below
![](/assets/images/post_20171022_1_03.jpg)

## Other solutions
Actually, the easiest way is to use `Paraview` for both plotting and converting.
However, I have `Mayavi` plotting scripts available such that I don't have to write a new plotting script.
Of course, this is not the only solution to generate CAD model with complicated shapes.
For example, there is a [*stlwrite*](https://www.mathworks.com/matlabcentral/fileexchange/20922-stlwrite-filename--varargin-) package in Matlab, although it didn't work well on my computer when I tried it.
