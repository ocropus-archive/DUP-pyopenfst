install:
	python setup.py build
	sudo python setup.py install

all: _openfst.so

_openfst.so: openfst.i
	swig -Wall -I$(INC) -python -c++ openfst.i 
	g++ -g -fPIC -I$(INC) -I$(PYINC) -shared openfst_wrap.cxx -o _openfst.so -lfst

lua: openfst.i
	swig -I$(INC) -lua -c++ openfst.i 
#	g++ -g -fPIC -I$(INC) -I$(PYINC) -shared openfst_wrap.cxx -o _openfst.so -lfst

clean:
	rm -f *.so *.cxx *.cpp *.o openfst.py ocropus.py
# DO NOT DELETE
