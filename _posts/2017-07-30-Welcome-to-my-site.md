---
layout: post
title:  "Welcome to my site"
date:   2017-07-30
categories: GitHub
tags: [HTML, CSS, GitHub, Jekyll]
---
Welcome to my site.
This is the first post of my site.
I will talk about how this site comes from and what contents it will have.

## How it comes?
I come up with the idea to build my website for quite a long time.
But I always evade with the excuse that I'm too busy.
I started to use **GitHub** from this March when I wanted to use git for managing my code [**FOCUS**](https://princetonuniversity.github.io/FOCUS/).
As you can see, I'm also building a project site for my code.
So I learned how GitHub pages work and found it's really powerful.
The idea of building my own website came up again.
And this time, I said to myself that I should finish it.

Firstly, I searched online and found a page of [Jerkll Themes](https://github.com/jekyll/jekyll/wiki/Themes).
I chose one theme that I think it's the best -- Yummy - ([source](https://github.com/DONGChuan/Yummy-Jekyll), [demo](http://dongchuan.github.io/)).
I forked it and added my personal contents.
There was one problem that I got stuck for hours when I was trying to build the pages locally.
It was about failing to `gem install json -v '1.8.3'`.
But I already forgot how I solved this (that's why I need a place to record my stuffs).

Anyway, I edited the template and added contents I like.
Right, there is one thing someone might be interested.
I need to use MathJax for displaying equations.
So I searched and found a solution [here](http://www.christopherpoole.net/using-mathjax-on-githubpages.html).
But there is one "deficiency" that I don't like.
In that solution, you have to use `\[ ... \]` and `\( ... \)` for inline or displayed mathematics.
However, I prefer *LaTex*-like format.
So here is my solution.
Put this in *head.html* under the *_includes* directory (or similar place you need).

```html
 <script type="text/x-mathjax-config"> MathJax.Hub.Config({ TeX: { equationNumbers: { autoNumber: "all" } } }); </script>
  <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      tex2jax: {
        inlineMath: [ ['$','$'] ],
        processEscapes: true
      }
    });
  </script>
  <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
```

Now I can use *LaTex*-like mathematics, like $\alpha = \beta^2+\sqrt{\gamma}$.

## What contents it will have?
There are four parts in this site.

- [Research](/research) is a gallery of my presentations and publications.
- [Blog](/blog) contains all the posts I have made. The topics include learning notes, technical solutions and sharing tips.
- [Bookmark](/bookmark) lists all the links I'm using or recommend.
- [About](/about) is just a brief introduction of myself. You can also find my CV there.

## At the end
I'm willing to learn new stuffs and during the process, I have faced and solved a lot of questions.
The pleasure of solving problems, just as debugging, is really special and I would like to share.

I will try to keep updating the site, although I'm really busy (Everyone is busy).
I expect this site would be deserted.
But I would be more than happy if I succesfully pushed myself to record down everything meaningful.

At last, there are no warrenties.
Please take care.
You are always welcome to comment and exchange ideas.
