#!/usr/bin/env python

"""
setup.py file for SWIG example
"""

from distutils.core import setup, Extension

openfst = Extension('_openfst',
        libraries = ['fst'],
        swig_opts = ["-c++"],
        sources=['openfst.i'])

setup (name = 'openfst',
       version = '0.4',
       author      = "Thomas Breuel",
       description = """openfst library bindings""",
       ext_modules = [openfst],
       py_modules = ["openfst"],
       )
