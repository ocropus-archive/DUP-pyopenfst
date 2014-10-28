The OpenFST library implements algorithms on weighted finite state transducers. The PyOpenFST project contains bindings for the library.

The focus right now is on exposing the most important functionality and algorithms in a simple way. Later versions of the bindings will expose additional functionality, like different semi-rings, n-best paths, etc.

We'll try to keep the openfst package simple and as it is and then add additional packages for other kinds of transducers and additional functionality.

The pyfst-* scripts are a haphazard collection, not necessarily useful for any particular purpose. They'll keep changing over time. But you may find them useful to figure out the library. Unit tests are in test-openfst.py

Set up the package with the standard python setup.py install

This code is largely untested. Use at your own risk. If you find bugs, please report them to the Issue Tracker.
