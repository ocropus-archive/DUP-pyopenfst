INC=/usr/local/include
PYINC=/usr/include/python2.5

all: _openfst.so

_openfst.so: openfst.i
	swig -I$(INC) -python -c++ openfst.i 
	g++ -g -fPIC -I$(INC) -I$(PYINC) -shared openfst_wrap.cxx -o _openfst.so \
            -lfst

clean:
	rm -f *.so *.cxx *.o openfst.py ocropus.py
