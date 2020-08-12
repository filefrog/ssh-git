filefrog/ssh-git
================

I [like](https://github.com/jhunt) GitHub; I really do!

But sometimes, I just need to run a dumb, throwaway SSH+git
containers somewhere on the k8s cluster / docker-compose recipe,
for plumbing purposes.

That's what this image is for.

[See it on Docker Hub!][1]


Running it on Docker
--------------------

To run this in your local Docker daemon:

    docker run --rm -d --name my-ssh-git \
      -p 2222:22 -e SSH_USER=$USER -e SSH_UID=$UID
      filefrog/ssh-git

The OpenSSH `sshd` daemon is now spinning in the background.

To use this, you'll first need to exec into the container and run
some `git init`'s:

    docker exec my-ssh-git -- mkdir -p /repos
    docker exec my-ssh-git -- git init --bare /repos/some-repo.git

Then, you can push to it.  From a pre-existing git working copy:

    git remote add my-ssh-git ssh://localhost:2222/repos/some-repo.git
    git push my-ssh-git master

Tada!


Running it on Kubernetes
------------------------

In many ways, this is a lot easier in Kuberenetes.  You can use an
init container to pre-initialize the persistent volume with the
git repos on it.  I've included a deployment manifest, in
`deploy/k8s/ssh-git.yml` that shows off some basic tricks.


Building (and Publishing) to Docker Hub
---------------------------------------

The Makefile handles building pushing.  For jhunt's:

    make push

Is all that's needed for release.  If you want to build it
locally, you can instead use:

    make build

If you want to tag it to your own Dockerhub username:

    IMAGE=you-at-dockerhub/mbsync make build push

By default, the image is tagged `latest`.  You can supply your own
tag via the `TAG` environment variable:

   IMAGE=... TAG=$(date +%Y%m%d%H%M%S) make build push

Happy Hacking!


[1]: https://hub.docker.com/r/filefrog/mbsync
