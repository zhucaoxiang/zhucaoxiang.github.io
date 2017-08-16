---
layout: post
title:  "Use amsmath together with iopart in LaTeX"
date:   2017-08-16
categories: LaTeX
tags: LaTeX
---

If you are preparing a manuscript submitted to the IOP (Institute of Physics), IOP [guidelines](http://ioppublishing.org/img/landingPages/guidelines-and-policies/author-guidelines.html) recommend using its official LaTeX template `iopart`.
But it's really unfortunate that the `iopart` class is not compatible with the [`amsmath`](https://www.ctan.org/pkg/amsmath) package, which I think is one of the most popular packages.

Here is a solution from [StackExchange](https://tex.stackexchange.com/questions/95817/how-can-i-use-align-environment-in-conjuction-with-iopart-cls-class).

> Put the following two lines before just before `\usepackage{amsmath}`

> ```Latex
> \expandafter\let\csname equation*\endcsname\relax
> \expandafter\let\csname endequation*\endcsname\relax
> ```

It actually works perfect.
