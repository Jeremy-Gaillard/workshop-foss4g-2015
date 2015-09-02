Cuardo
======

Introduction
------------

Cesium Buildings is the Javascript library and client application that we will use to have a 3D visualization of our data.
It is based on the popular Cesium globe application.

Installing Cesium Buildings 
-----------------

We are going to install Cesium Buildings locally and study the examples.

```bash
cd data/www
git clone https://github.com/Oslandia/cesium-buildings.git
cd cesium-buildings
git fetch origin workshop:workshop
git checkout workshop
```

Does it work ?
* Open [http://localhost/w/cesium-buildings/Example.html](http://localhost/w/cesium-buildings/Example.html)





client.html
-----------

This is the main application of Cuardo. It is a webpage mainly composed of a WebGL container and javascript code that deals with user interactions and Three.JS to setup the 3D scene.

It is designed to read a particular configuration file that contain the description of the 3D scene to setup: what layers to load and with what symbology.

Examples
--------

In the 'examples' directory, we can find some examples of scene files. Scene files are written in Javascript and are mostly descriptive.
They must be passed as HTTP argument to client.html, without the .js extension
* Open for instance [http://localhost/w/cuardo/client.html?examples/example1](http://localhost/w/cuardo/client.html?examples/example1)

We will now study each example to have an overview of the various features already built-in.

Debugging
---------

We will be manipulating Javascript files and modifications are not error prone. Modern browsers tend to hide Javascript errors from the final user by default.
We will open the Javascript console (Firefox: F12) during development of our scenes to make sure we know if an error occurs.
