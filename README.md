# BORSCHT

![](http://i.imgur.com/oG1dzp5.jpg)

Borscht shows you your manifest

![](http://i.imgur.com/ciw9OUg.png)

## Installation

First you need [meteor](http://meteor.com)

```
> curl https://install.meteor.com/ | sh
```

Then clone this repo

```
> git clone git@github.com:peterellisjones/borscht.git
```

Now start Borscht with the environment variables `RELEASE_PATH` (the root-level directory of your bosh release) and `MANIFEST_PATH` (the bosh manifest file used for the release) using the `meteor` command inside the borscht directory.

```
> cd borscht
> export RELEASE_PATH=/Users/pivotal/workspace/cf-redis-release
> export MANIFEST_PATH=/Users/pivotal/workspace/cf-redis-release/manifests/cf-redis-lite.yml
> meteor
[[[[[ ~/workspace/borscht ]]]]]

=> Started proxy.
=> Started MongoDB
...
```

This will start Borscht on [http://localhost:3000](http://localhost:3000)
