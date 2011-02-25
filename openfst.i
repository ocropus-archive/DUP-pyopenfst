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
#include <fst/encode.h>
using namespace fst;
%}

/* C++ exception handling (FIXME: this doesn't really seem to work right)  */
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
const int kNoLabel;

/* Match types. */
enum MatchType {
    MATCH_INPUT,
    MATCH_OUTPUT,
    MATCH_BOTH,
    MATCH_NONE,
    MATCH_UNKNOWN
};

/* FST properties. */
%include "openfst_properties.i"
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

%template(StdMatcher) Matcher<StdFst>;
%template(LogMatcher) Matcher<LogFst>;

%template(StdRhoMatcher) RhoMatcher<StdMatcher>;
%template(LogRhoMatcher) RhoMatcher<LogMatcher>;
%template(StdRhoComposeOptions) ComposeFstOptions<StdArc, StdRhoMatcher>;
%template(LogRhoComposeOptions) ComposeFstOptions<StdArc, LogRhoMatcher>;

%template(StdSigmaMatcher) SigmaMatcher<StdMatcher>;
%template(LogSigmaMatcher) SigmaMatcher<LogMatcher>;
%template(StdSigmaComposeOptions) ComposeFstOptions<StdArc, StdSigmaMatcher>;
%template(LogSigmaComposeOptions) ComposeFstOptions<StdArc, LogSigmaMatcher>;

%template(StdPhiMatcher) PhiMatcher<StdMatcher>;
%template(LogPhiMatcher) PhiMatcher<LogMatcher>;
%template(StdPhiComposeOptions) ComposeFstOptions<StdArc, StdPhiMatcher>;
%template(LogPhiComposeOptions) ComposeFstOptions<StdArc, LogPhiMatcher>;

/* Instantiate template functions. */
%feature("docstring",
         "Compose two FSTs placing the result in a newly initialized FST.") Compose;
void Compose(StdFst const &fst1, StdFst const &fst2, StdMutableFst *result);
void Compose(LogFst const &fst1, LogFst const &fst2, LogMutableFst *result);
%feature("docstring",
         "Connect an FST.") Connect;
void Connect(StdMutableFst *fst);
void Connect(LogMutableFst *fst);

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

/* A whole bunch of custom and convenience functions. */
%feature("docstring",
         "Convenience function to read a StdVectorFst from a file.") Read;
%inline %{
    StdVectorFst *Read(const char *s) {
        return StdVectorFst::Read(s);
    }

    template<class A>
    char *GetString(MutableFst<A> *fst,int which=0) {
        char result[100000];
        size_t index = 0;
        typename A::StateId state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if (fst->Final(state) != A::Weight::Zero()) break;
            ArcIterator< MutableFst<A> > iter(*fst,state);
            iter.Seek(which);
            A arc(iter.Value());
            if (arc.olabel != 0)
                result[index++] = arc.olabel;
            if (index >= (sizeof(result)/sizeof(result[0])) - 1)
                throw "string too long";
            typename A::StateId nstate = arc.nextstate;
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

    template<class A>
    wchar_t *WGetString(MutableFst<A> *fst,int which=0) {
        wchar_t result[100000];
        size_t index = 0;
        typename A::StateId state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if(fst->Final(state) != A::Weight::Zero()) break;
            ArcIterator< MutableFst<A> > iter(*fst,state);
            iter.Seek(which);
            A arc(iter.Value());
            if (arc.olabel != 0)
                result[index++] = arc.olabel;
            if (index >= (sizeof(result)/sizeof(result[0])) - 1)
                throw "string too long";
            typename A::StateId nstate = arc.nextstate;
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

    template<class A>
    void ArcSortOutput(MutableFst<A> *fst) {
        ArcSort(fst,OLabelCompare<A>());
    }

    template<class A>
    void ArcSortInput(MutableFst<A> *fst) {
        ArcSort(fst,ILabelCompare<A>());
    }

    template<class A>
    void ProjectInput(MutableFst<A> *result) {
        Project(result,PROJECT_INPUT);
    }

    template<class A>
    void ProjectOutput(MutableFst<A> *result) {
        Project(result,PROJECT_OUTPUT);
    }

    template<class A>
    void ClosureStar(MutableFst<A> *fst) {
        Closure(fst,CLOSURE_STAR);
    }

    template<class A>
    void ClosurePlus(MutableFst<A> *fst) {
        Closure(fst,CLOSURE_PLUS);
    }

    template<class A>
    void ConcatOnto(MutableFst<A> *fst,Fst<A> const &fst2) {
        Concat(fst,fst2);
    }

    template<class A>
    void ConcatOntoOther(Fst<A> const &fst,MutableFst<A> *fst2) {
        Concat(fst,fst2);
    }

    template<class A>
        void EpsNormInput(Fst<A> const &fst,MutableFst<A> *out) {
        EpsNormalize(fst,out,EPS_NORM_INPUT);
    }

    template<class A>
        void EpsNormOutput(Fst<A> const &fst,MutableFst<A> *out) {
        EpsNormalize(fst,out,EPS_NORM_OUTPUT);
    }

    template<class A>
        void ConvertSymbols(VectorFst<A> *fst, SymbolTable const &symtab,
                           bool input=true, bool output=true) {
        SymbolTable const *pisym = fst->InputSymbols();
        SymbolTable const *posym = fst->OutputSymbols();
        typename A::StateId s;

        for (s = 0; s < fst->NumStates(); ++s) {
            MutableArcIterator< VectorFst<A> > itor(fst, s);
            while (!itor.Done()) {
                A arc = itor.Value();
                if (input) {
                    string isym = pisym->Find(arc.ilabel);
                    arc.ilabel = symtab.Find(isym);
                    if (arc.ilabel == -1)
                        throw "Unknown word in input symbols";
                }
                if (output) {
                    string osym = posym->Find(arc.olabel);
                    arc.olabel = symtab.Find(osym);
                    if (arc.olabel == -1)
                        throw "Unknown word in output symbols";
                }
                itor.SetValue(arc);
                itor.Next();
            }
        }
        if (input)
            fst->SetInputSymbols(&symtab);
        if (output)
            fst->SetOutputSymbols(&symtab);
    }
%}

%feature("docstring",
         "Get string starting at given state.") GetString;
char *GetString(StdMutableFst *fst,int which=0);
char *GetString(LogMutableFst *fst,int which=0);

%feature("docstring",
         "Get wide character string starting at given state.") WGetString;
wchar_t *WGetString(StdMutableFst *fst,int which=0);
wchar_t *WGetString(StdMutableFst *fst,int which=0);

%feature("docstring",
         "Sort the arcs of an FST on the output labels.") ArcSortOutput;
void ArcSortOutput(StdMutableFst *fst);
void ArcSortOutput(LogMutableFst *fst);

%feature("docstring",
         "Sort the arcs of an FST on the input labels.") ArcSortInput;
void ArcSortInput(StdMutableFst *fst);
void ArcSortInput(LogMutableFst *fst);

%feature("docstring",
         "Project an FST to an FSA using the input labels.") ProjectInput;
void ProjectInput(StdMutableFst *result);
void ProjectInput(LogMutableFst *result);

%feature("docstring",
         "Project an FST to an FSA using the output labels.") ProjectOutput;
void ProjectOutput(StdMutableFst *result);
void ProjectOutput(LogMutableFst *result);

%feature("docstring",
         "Perform Kleene star closure on an FST.") ClosureStar;
void ClosureStar(StdMutableFst *fst);
void ClosureStar(LogMutableFst *fst);

%feature("docstring",
         "Perform plus-closure on an FST.") ClosurePlus;
void ClosurePlus(StdMutableFst *fst);
void ClosurePlus(LogMutableFst *fst);

%feature("docstring",
         "Concatenate fst2 onto fst.") ConcatOnto;
void ConcatOnto(StdMutableFst *fst,StdFst const &fst2);
void ConcatOnto(LogMutableFst *fst,LogFst const &fst2);

%feature("docstring",
         "Concatenate fst onto fst2.") ConcatOntoOther;
void ConcatOntoOther(StdFst const &fst,StdMutableFst *fst2);
void ConcatOntoOther(LogFst const &fst,LogMutableFst *fst2);

%feature("docstring",
         "Epsilon normalize an FST on the input side.") EpsNormInput;
void EpsNormInput(StdFst const &fst, StdMutableFst *out);
void EpsNormInput(LogFst const &fst, LogMutableFst *out);

%feature("docstring",
         "Epsilon normalize an FST on the output side.") EpsNormOutput;
void EpsNormOutput(StdFst const &fst, StdMutableFst *out);
void EpsNormOutput(LogFst const &fst, LogMutableFst *out);

%feature("docstring",
         "Switch output and/or input symbol table and renumber arcs to match.\n\n"
         "Throws an exception if no mapping can be found for a symbol in C{fst}.\n"
         "@param fst: FST to modify.\n"
         "@type symtab: openfst.MutableFst\n"
         "@param symtab: New symbol table to use.\n"
         "@type symtab: openfst.SymbolTable\n"
         "@param input: Convert input symbols.\n"
         "@type input: bool\n"
         "@param output: Convert output symbols.\n"
         "@type output: bool\n") ConvertSymbols;
void ConvertSymbols(StdVectorFst *fst, SymbolTable const &symtab,
                   bool input, bool output);
void ConvertSymbols(LogVectorFst *fst, SymbolTable const &symtab,
                   bool input, bool output);

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

/* Encoding and decoding. */

enum EncodeType { ENCODE, DECODE };
static const uint32 kEncodeLabels      = 0x00001;
static const uint32 kEncodeWeights     = 0x00002;
static const uint32 kEncodeFlags       = 0x00003;  // All non-internal flags

template<class A> class EncodeMapper {
public:
    EncodeMapper(uint32 flags,EncodeType type);
};
%inline %{
typedef EncodeMapper<StdArc> StdEncodeMapper;
%}

%template(StdEncodeMapper) EncodeMapper<StdArc>;

%feature("docstring",
         "Encode the arcs of an FST.") Encode;
void Encode(StdMutableFst *fst,StdEncodeMapper *mapper);
%feature("docstring",
         "Decode the arcs of an FST.") Decode;
void Decode(StdMutableFst *fst,const EncodeMapper<StdArc> &mapper);

