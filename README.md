# HelmSnake
A Snake clone built on the [[http://helm-engine.org/][Helm]] game engine.

## Building

### Docker
The helmsnake docker image currently depends on a Helm docker image produced
by the [[https://github.com/mainehaskell][MaineHaskell Github Organization]].
Build that image with the following commands:

    $ git clone https://github.com/mainehaskell/Dockerfiles.git maine-haskell-dockerfiles
    $ cd maine-haskell-dockerfiles
    $ docker build . -t mainehaskell/helm

Then, build the helmsnake docker image as follows:

    $ cd <this-projects-directory>
    $ docker build . -t mainehaskell/helmsnake

## Running
To allow the helmsnake container to open a window on the host machine, execute
the following (being sure to replace `<user` with your username):

    $ sudo xhost +local:<user>

Finally, run the container with:

    $ docker run \
      -e DISPLAY=unix$DISPLAY \
      -v /etc/machine-id:/etc/machine-id:ro \
      -v /etc/localtime:/etc/localtime:ro \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -it mainehaskell/helmsnake

## Playing
Currently, the game does not work!  All you can do is move the snake around the
board using the arrow keys!