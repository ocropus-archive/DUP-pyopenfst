// -*- C++ -*-

%{
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
#pragma GCC diagnostic ignored "-Wuninitialized"
%}

%module opfst_beam
%{
#include <fst/fstlib.h>
#include <vector>
#include <string>
#include <cstdlib>

using namespace fst;
using namespace std;
%}

%inline %{

    StdVectorFst *Read(const char *s) {
        return StdVectorFst::Read(s);
    }
    
    vector<int> intvector() {
        vector<int> v;
        return v;
    }
    vector<float> floatvector() {
        vector<float> v;
        return v;
    }
    
    void op_beamsearch(vector<int> &vertices1,
                     vector<int> &vertices2,
                     vector<int> &inputs,
                     vector<int> &outputs,
                     vector<float> &costs,
                     StdVectorFst *fst1,
                     StdVectorFst *fst2,
                     int B);
%}

%{
#include "op_beamsearch.cc"
%}
