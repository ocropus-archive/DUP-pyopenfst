// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%module(docstring="Python Bindings for the OpenFST Library") openfst
%feature("autodoc");
%include "typemaps.i"
%include "cstring.i"
%include "std_string.i"
%include "std_wstring.i"

/* C++ header files for everything. */
%{
#include <fst/fstlib.h>
#include <fst/symbol-table.h>
#include <fst/arcsort.h>
using namespace fst;
%}

/* C++ exception handling */
%exception {
    try {
        $action
    }
    catch(const char *s) {
        PyErr_SetString(PyExc_IndexError,s);
        return NULL;
    }
    catch(...) {
        PyErr_SetString(PyExc_IndexError,"unknown exception in openfst");
        return NULL;
    }
}

/* Universal epsilon arc constant. */
%inline %{
const int epsilon = 0;
%}

/* Templates for the class hierarchy. */
%include "openfst_templates.i"
/* Human-friendly typedefs for all the various templated classes. */
%include "openfst_typedefs.i"
/* Basic weight types. */
%include "openfst_weights.i"
/* Symbol tables. */
%include "openfst_symtab.i"
/* Pythonic iterators. */
%include "openfst_iterators.i"

/* Instantiate arc classes. */
%feature("docstring",
         "Standard arc class, using floating-point weights in the tropical semiring.") StdArc;
%template(StdArc) ArcTpl<Weight>;
%feature("docstring",
         "Standard arc class, using floating-point weights in the log semiring.") LogArc;
%template(LogArc) ArcTpl<LogWeight>;

/* Instantiate Fst abstract base classes. */
%template(StdFst) Fst<StdArc>;
%template(LogFst) Fst<LogArc>;
%template(StdMutableFst) MutableFst<StdArc>;
%template(LogMutableFst) MutableFst<LogArc>;

/* Instantiate VectorFst implementation classes. */
%feature("docstring",
         "Standard FST class, using floating-point weights in the tropical semiring\n"
         "and an underlying implementation based on C++ vectors.") StdVectorFst;
%feature("notabstract") VectorFst<StdArc>;
%template(StdVectorFst) VectorFst<StdArc>;
%feature("docstring",
         "Standard FST class, using floating-point weights in the log semiring\n"
         "and an underlying implementation based on C++ vectors.") LogVectorFst;
%feature("notabstract") VectorFst<LogArc>;
%template(LogVectorFst) VectorFst<LogArc>;

/* Instantiate state iterators. */
%feature("docstring",
         "Underlying iterator class over states.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    ...\n") StdStateIterator;
%template(StdStateIterator) StateIterator<StdFst>;
%feature("docstring",
         "Underlying iterator class over states.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    ...\n") LogStateIterator;
%template(LogStateIterator) StateIterator<LogFst>;

/* Instantiate arc iterators. */
%feature("docstring",
         "Underlying iterator class over arcs.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.iterarcs(state):\n") StdArcIterator;
%template(StdArcIterator) ArcIterator<StdFst>;
%feature("docstring",
         "Underlying iterator class over arcs.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.iterarcs(state):\n") LogArcIterator;
%template(LogArcIterator) ArcIterator<LogFst>;
%feature("docstring",
         "Underlying iterator class over arcs which allows changes to be\n"
         "made.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arciter in fst.mutable_iterarcs(state):\n"
         "        arc = arciter.Value()\n") StdMutableArcIterator;
%template(StdMutableArcIterator) MutableArcIterator<StdMutableFst>;
%feature("docstring",
         "Underlying iterator class over arcs which allows changes to be\n"
         "made.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arciter in fst.mutable_iterarcs(state):\n"
         "        arc = arciter.Value()\n") StdMutableArcIterator;
%template(LogMutableArcIterator) MutableArcIterator<LogMutableFst>;

/* Instantiate lazy composition FSTs. */
%feature("docstring",
         "Lazy composition of two FSTs.\n") StdComposeFst;
%feature("notabstract") ComposeFst<StdArc>;
%template(StdComposeFst) ComposeFst<StdArc>;
%feature("docstring",
         "Lazy composition of two FSTs.\n") LogComposeFst;
%feature("notabstract") ComposeFst<LogArc>;
%template(LogComposeFst) ComposeFst<LogArc>;

/* Instantiate template functions. */
%feature("docstring",
         "Compose two FSTs placing the result in a newly initialized FST.") Compose;
void Compose(StdFst const &fst1, StdFst const &fst2, StdMutableFst *result);
void Compose(LogFst const &fst1, LogFst const &fst2, LogMutableFst *result);
%feature("docstring",
         "Connect an FST.") Connect;
void Connect(StdMutableFst *fst);
void Connect(LogMutableFst *fst);

// Decode
// Encode
%feature("docstring",
         "Determinize an FST, placing the result in a newly initialize FST.") Determinize;
void Determinize(StdFst const &in, StdMutableFst *out);
void Determinize(LogFst const &in, LogMutableFst *out);
%feature("docstring",
         "Take the difference between two FSTs, placing the result in a\n"
         "newly initialized FST.") Difference;
void Difference(StdFst const &fst, StdFst const &fst2, StdMutableFst *out);
void Difference(LogFst const &fst, LogFst const &fst2, LogMutableFst *out);
%feature("docstring",
         "Intersect two FSTs, placing the result in a\n"
         "newly initialized FST.") Intersect;
void Intersect(StdFst const &fst,StdFst const &fst2,StdMutableFst *out);
void Intersect(LogFst const &fst,LogFst const &fst2,LogMutableFst *out);
%feature("docstring",
         "Invert an FST.") Invert;
void Invert(StdMutableFst *fst);
void Invert(LogMutableFst *fst);
%feature("docstring",
         "Minimize an FST.") Minimize;
void Minimize(StdMutableFst *fst);
void Minimize(LogMutableFst *fst);
%feature("docstring",
         "Prune an FST, removing all arcs above threshold") Prune;
void Prune(StdMutableFst *fst,float threshold);
void Prune(LogMutableFst *fst,float threshold);
%feature("docstring",
         "??") RandEquivalent;
bool RandEquivalent(StdFst const &fst,StdFst const &fst2,int n);
bool RandEquivalent(LogFst const &fst,LogFst const &fst2,int n);
%feature("docstring",
         "??") RandGen;
void RandGen(StdFst const &fst,StdMutableFst *out);
void RandGen(LogFst const &fst,LogMutableFst *out);
// Replace
%feature("docstring",
         "Reverse an FST, placing result in a newly initialized FST.") Reverse;
void Reverse(StdFst const &fst,StdMutableFst *out);
void Reverse(LogFst const &fst,LogMutableFst *out);
// Reweight
%feature("docstring",
         "Remove epsilon transitions from an FST.") RmEpsilon;
void RmEpsilon(StdMutableFst *out);
void RmEpsilon(LogMutableFst *out);
// ShortestDistance
%feature("docstring",
         "Find N shortest paths in an FST placing results in a newly initialized FST.")
ShortestPath;
void ShortestPath(StdFst const &fst, StdMutableFst *out,int n);
void ShortestPath(LogFst const &fst, LogMutableFst *out,int n);
// Synchronize
%feature("docstring",
         "Topologically sort an FST.") TopSort;
void TopSort(StdMutableFst *fst);
void TopSort(LogMutableFst *fst);
%feature("docstring",
         "Take the union of two FSTs, placing the result in the first argument.") Union;
void Union(StdMutableFst *out,StdFst const &fst);
void Union(LogMutableFst *out,LogFst const &fst);
%feature("docstring",
         "Verify an FST.") Verify;
void Verify(StdFst const &fst);
void Verify(LogFst const &fst);

/* A whole bunch of custom functions for OCRopus (I think) */
/* SWIG gets upset if these are inside an %inline block. */
%feature("docstring",
         "Get string starting at given state.") GetString;
%feature("docstring",
         "Get wide character string starting at given state.") WGetString;
%feature("docstring",
         "Convenience function to read a StdVectorFst from a file.") Read;
%feature("docstring",
         "Sort the arcs of an FST on the output labels.") ArcSortOutput;
%feature("docstring",
         "Sort the arcs of an FST on the input labels.") ArcSortInput;
%feature("docstring",
         "Project an FST to an FSA using the input labels.") ProjectInput;
%feature("docstring",
         "Project an FST to an FSA using the output labels.") ProjectOutput;
%feature("docstring",
         "Perform Kleene star closure on an FST.") ClosureStar;
%feature("docstring",
         "Perform plus-closure on an FST.") ClosurePlus;
%feature("docstring",
         "Concatenate fst2 onto fst.") ConcatOnto;
%feature("docstring",
         "Concatenate fst onto fst2.") ConcatOntoOther;
%feature("docstring",
         "Epsilon normalize an FST on the input side.") EpsNormInput;
%feature("docstring",
         "Epsilon normalize an FST on the output side.") EpsNormOutput;
%inline %{
    char *GetString(StdMutableFst *fst,int which=0) {
        char result[100000];
        int index = 0;
        int state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if(fst->Final(state)!=Weight::Zero()) break;
            ArcIterator<StdMutableFst> iter(*fst,state);
            iter.Seek(which);
            StdArc arc(iter.Value());
            if (arc.olabel != 0)
                result[index++] = arc.olabel;
            if(index>=-1+sizeof result/sizeof result[0])
                throw "string too long";
            int nstate = arc.nextstate;
            if(nstate==state)
                throw "malformed string fst (state==nstate)";
            if(state<0)
                throw "malformed string fst (no final, no successor)";
            state = nstate;
            which = 0;
        }
        result[index++] = 0;
        return strdup(result);
    }
    wchar_t *WGetString(StdMutableFst *fst,int which=0) {
        wchar_t result[100000];
        int index = 0;
        int state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if(fst->Final(state)!=Weight::Zero()) break;
            ArcIterator<StdMutableFst> iter(*fst,state);
            iter.Seek(which);
            StdArc arc(iter.Value());
            if (arc.olabel != 0)
                result[index++] = arc.olabel;
            if(index>=-1+sizeof result/sizeof result[0])
                throw "string too long";
            int nstate = arc.nextstate;
            if(nstate==state)
                throw "malformed string fst (state==nstate)";
            if(state<0)
                throw "malformed string fst (no final, no successor)";
            state = nstate;
            which = 0;
        }
        result[index++] = 0;
        wchar_t *p = (wchar_t *)malloc(index*sizeof *result);
        memcpy(p,result,index*sizeof *result);
        return p;
    }
    StdVectorFst *Read(const char *s) {
        return StdVectorFst::Read(s);
    }
    void ArcSortOutput(StdMutableFst *fst) {
        ArcSort(fst,StdOLabelCompare());
    }
    void ArcSortInput(StdMutableFst *fst) {
        ArcSort(fst,StdILabelCompare());
    }
    void ProjectInput(StdMutableFst *result) {
        Project(result,PROJECT_INPUT);
    }
    void ProjectOutput(StdMutableFst *result) {
        Project(result,PROJECT_OUTPUT);
    }
    void ClosureStar(StdMutableFst *fst) {
        Closure(fst,CLOSURE_STAR);
    }
    void ClosurePlus(StdMutableFst *fst) {
        Closure(fst,CLOSURE_PLUS);
    }
    void ConcatOnto(StdMutableFst *fst,StdFst const &fst2) {
        Concat(fst,fst2);
    }
    void ConcatOntoOther(StdFst const &fst,StdMutableFst *fst2) {
        Concat(fst,fst2);
    }
    void EpsNormInput(StdFst const &fst,StdMutableFst *out) {
        EpsNormalize(fst,out,EPS_NORM_INPUT);
    }
    void EpsNormOutput(StdFst const &fst,StdMutableFst *out) {
        EpsNormalize(fst,out,EPS_NORM_OUTPUT);
    }
%}

%newobject Copy;
%feature("docstring", "Copy an FST.") Copy;
%inline %{
    StdVectorFst *Copy(StdVectorFst &fst) {
        // is there a method that does this directly?
        StdVectorFst *result = new StdVectorFst();
        Union(result,fst);
        return result;
    }
    LogVectorFst *Copy(LogVectorFst &fst) {
        // is there a method that does this directly?
        LogVectorFst *result = new LogVectorFst();
        Union(result,fst);
        return result;
    }
%}
