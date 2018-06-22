---
layout: post
title:  "Use Personal Access Token with Git"
date:   2018-06-22
categories: git
tags: Gitlab
---

This post is to introduce an easy way to use personal access token with git (GitHub, GitLab, Bitbucket or whatever), such that you don't have to enter your username and password when you push any commit.
The only usage of personal access token in this post is to authorize git operations, like `git push`.
Other usages are not discussed.
I'm going to use osti@gitlab as an example.
Other websites should be similar.

## Generating a personal access token
1. Go to `your profile -> settings -> Access Tokens`([link](http://gitlab.osti.gov/profile/personal_access_tokens)), fill a name and experiation data (optional) and then click `create personal access token`. (Remember to click 'api' option)
![](/assets/images/post_20180622_1_01.jpg)

2. Save the new token. As an example, my new token is `yLVVsT8PbM-zxhrFRryM` (I will revoke it after posting this post).
![](/assets/images/post_20180622_1_02.jpg)

## Using your token
The OSTI GitLab repository service use Two-Factor Authentication (2FA).
The personal access tokens are the only accepted passwords.
For example, I have test repository at [test_at_osti](https://gitlab.osti.gov/czhu/test_at_osti).
I cannot push any commits after I made some changes on my local system.

```
git clone http://gitlab.osti.gov/czhu/test_at_osti.git
touch README.md
git add README.md
git commit -m "add README"
git push origin master
```

The output error is

```
Username for 'https://gitlab.osti.gov': czhu
Password for 'https://czhu@gitlab.osti.gov': ****
remote: HTTP Basic: Access denied
remote: You must use a personal access token with 'api' scope for Git over HTTP.
remote: You can generate one at http://gitlab.osti.gov/profile/personal_access_tokens
fatal: Authentication failed for 'https://gitlab.osti.gov/czhu/test_at_osti.git/'
```

Here, I typed my login password.
What you should use is actually the created personal access token.
Once you typed your token, you can successfully push the commits.

```
cxzhu:~/Documents/gits/test_at_osti$ git push origin master
Username for 'https://gitlab.osti.gov': czhu
Password for 'https://czhu@gitlab.osti.gov': yLVVsT8PbM-zxhrFRryM
warning: redirecting to https://gitlab.osti.gov/czhu/test_at_osti.git/
Counting objects: 3, done.
Writing objects: 100% (3/3), 236 bytes | 236.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To http://gitlab.osti.gov/czhu/test_at_osti.git
 * [new branch]      master -> master
```

But it is not a good idea to type the token everytime, especially it is a nonsense combination of characters.

## Saving your token
The clever way is to save your personal access token by using [curl](https://curl.haxx.se/), or other tools like [git credentials](https://git-scm.com/docs/gitcredentials).
Here I'm going to introduce the easiest way using `curl`.
I got the idea from [here](https://stackoverflow.com/questions/18935539/authenticate-with-github-using-token).

1. Save your token with `curl`

   ```
   curl -H 'Authorization: token yLVVsT8PbM-zxhrFRryM' https://czhu@gitlab.osti.gov
   ```

2. Add/replace your repository with authorizations
   You can clone a repository with authorization, like
   
   ```
   git clone https://czhu:yLVVsT8PbM-zxhrFRryM@gitlab.osti.gov/czhu/test_at_osti.git
   ```
   
   Since I have created a remote origin already, I can just replace it.
   
   ```
   git remote rm origin
   git remote add origin https://czhu:yLVVsT8PbM-zxhrFRryM@gitlab.osti.gov/czhu/test_at_osti.git
   ```
   
   And now you can easily push all your commits, without typing the token everytime.

## Using ssh keys
When I use GitHub, I prefer to use ssh keys. 
You can find a detailed instruction on [GitHub Help](https://help.github.com/articles/connecting-to-github-with-ssh/). 
It's the most convenient and safest way. 
There are only two tips I would like to share.

1. Using ssh keys on MAC
   
   To successfully add the key to ssh-agent, you can follow [this page ](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/). 
   But I found there is one additional step, at least on my macbook.
   That is you have to manually add `github.com` in `known_hosts` file, by typing
   
   ```bash
   ssh-keyscan github.com >> ~/.ssh/known_hosts
   ```
   
2. Using ssh keys on Linux
   
   On the GitHub Help [Linux page](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#platform-linux), all the commands are suitable for `bash shell`.
   But if you are using other shells, like I use `TC-shell` on PPPL cluster, you have to replace the last two commands with the following ones.
   
   ```bash
    ssh-agent /bin/sh
    ssh-add ~/.ssh/id_rsa
   ```
   
