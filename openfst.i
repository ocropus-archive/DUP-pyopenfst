// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%module(docstring="Python Bindings for the OpenFST Library") openfst
%feature("autodoc");
%include "typemaps.i"
%include "cstring.i"
%include "std_string.i"
%include "std_wstring.i"
%include "stl.i"
%include "std_vector.i"

namespace std {
%template(vector_int) vector<int>;
%template(vector_float) vector<float>;
%template(vector_double) vector<double>;
};

/* C++ header files for everything. */
%{
#include <fst/fstlib.h>
#include <fst/symbol-table.h>
#include <fst/arcsort.h>
#include <fst/encode.h>
#include <fst/matcher.h>
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

/* Encoding and decoding. */

enum EncodeType { ENCODE, DECODE };
static const uint32 kEncodeLabels      = 0x00001;
static const uint32 kEncodeWeights     = 0x00002;
static const uint32 kEncodeFlags       = 0x00003;  // All non-internal flags

template<class A> class EncodeMapper {
public:
    EncodeMapper(uint32 flags,EncodeType type);
};

/* More helper functions */

%inline %{
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

namespace std {
%template(vector_weight) vector<Weight>;
%template(vector_logweight) vector<LogWeight>;
};

/*****************************************************************
 * Macro for instantiating templates for all the different classes
 * and functions.  Note that you must arrange for
 *
 * to be explicitly defined beforehand.
 *****************************************************************/

%define INSTANTIATE_FST(PREFIX,ARCTYPE,WEIGHTTYPE,DESC)

/* Instantiate arc classes. */
%feature("docstring",
         "Standard arc class.") ARCTYPE;
%template(ARCTYPE) ArcTpl<WEIGHTTYPE>;

/* Instantiate Fst abstract base classes. */
%template(PREFIX ## Fst) Fst<ARCTYPE>;
%template(PREFIX ## MutableFst) MutableFst<ARCTYPE>;

/* Instantiate VectorFst implementation classes. */
%feature("docstring",
         "Standard FST class, using floating-point weights in the log semiring\n"
         "and an underlying implementation based on C++ vectors.") PREFIX ## VectorFst;
%feature("notabstract") VectorFst<ARCTYPE>;
%template(PREFIX ## VectorFst) VectorFst<ARCTYPE>;

/* Instantiate state iterators. */
%feature("docstring",
         "Underlying iterator class over states.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    ...\n") PREFIX ## StateIterator;
%template(PREFIX ## StateIterator) StateIterator<PREFIX ## Fst>;

/* Instantiate arc iterators. */
%feature("docstring",
         "Underlying iterator class over arcs.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.iterarcs(state):\n") ARCTYPE ## Iterator;
%template(ARCTYPE ## Iterator) ArcIterator<PREFIX ## Fst>;
%feature("docstring",
         "Underlying iterator class over arcs which allows changes to be\n"
         "made.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arciter in fst.mutable_iterarcs(state):\n"
         "        arc = arciter.Value()\n") PREFIX ## MutableArcIterator;
%template(PREFIX ## MutableArcIterator) MutableArcIterator<PREFIX ## MutableFst>;

/* Instantiate lazy composition FSTs. */
%feature("docstring",
         "Lazy composition of two FSTs.\n") PREFIX ## ComposeFst;
%feature("notabstract") ComposeFst<ARCTYPE>;
%template(PREFIX ## ComposeFst) ComposeFst<ARCTYPE>;
%template(PREFIX ## Matcher) Matcher<PREFIX ## Fst>;
%template(PREFIX ## RhoMatcher) RhoMatcher<PREFIX ## Matcher>;
%template(PREFIX ## RhoComposeOptions) ComposeFstOptions<ARCTYPE, PREFIX ## RhoMatcher>; // ARCTYPE or StdArc??
%template(PREFIX ## SigmaMatcher) SigmaMatcher<PREFIX ## Matcher>;
%template(PREFIX ## SigmaComposeOptions) ComposeFstOptions<ARCTYPE, PREFIX ## SigmaMatcher>;
%template(PREFIX ## PhiMatcher) PhiMatcher<PREFIX ## Matcher>;
%template(PREFIX ## PhiComposeOptions) ComposeFstOptions<ARCTYPE, PREFIX ## PhiMatcher>;

/* Instantiate template functions. */
%feature("docstring",
         "Compose two FSTs placing the result in a newly initialized FST.") Compose;
void Compose(PREFIX ## Fst const &fst1, PREFIX ## Fst const &fst2, PREFIX ## MutableFst *result);
%feature("docstring",
         "Connect an FST.") Connect;
void Connect(PREFIX ## MutableFst *fst);

%feature("docstring",
         "Determinize an FST, placing the result in a newly initialize FST.") Determinize;
void Determinize(PREFIX ## Fst const &inp, PREFIX ## MutableFst *out);
%feature("docstring",
         "Take the difference between two FSTs, placing the result in a\n"
         "newly initialized FST.") Difference;
void Difference(PREFIX ## Fst const &fst, PREFIX ## Fst const &fst2, PREFIX ## MutableFst *out);
%feature("docstring",
         "Intersect two FSTs, placing the result in a\n"
         "newly initialized FST.") Intersect;
void Intersect(PREFIX ## Fst const &fst,PREFIX ## Fst const &fst2,PREFIX ## MutableFst *out);
%feature("docstring",
         "Invert an FST.") Invert;
void Invert(PREFIX ## MutableFst *fst);
%feature("docstring",
         "Minimize an FST.") Minimize;
void Minimize(PREFIX ## MutableFst *fst);
%feature("docstring",
         "Prune an FST, removing all arcs above threshold") Prune;
void Prune(PREFIX ## MutableFst *fst,float threshold);
%feature("docstring",
         "??") RandEquivalent;
bool RandEquivalent(PREFIX ## Fst const &fst,PREFIX ## Fst const &fst2,int n);
%feature("docstring",
         "??") RandGen;
void RandGen(PREFIX ## Fst const &fst,PREFIX ## MutableFst *out);
// Replace
%feature("docstring",
         "Reverse an FST, placing result in a newly initialized FST.") Reverse;
void Reverse(PREFIX ## Fst const &fst,PREFIX ## MutableFst *out);
// Reweight
%feature("docstring",
         "Remove epsilon transitions from an FST.") RmEpsilon;
void RmEpsilon(PREFIX ## MutableFst *out);
%feature("docstring",
         "Find the (+) sum of all the paths from p to q.")
ShortestDistance;

const float kDelta =                   1.0F/1024.0F;
void ShortestDistance(PREFIX ## Fst const &fst, std::vector<WEIGHTTYPE> *distance,bool reverse=false, float delta=kDelta);
%feature("docstring",
         "Find N shortest paths in an FST placing results in a newly initialized FST.")
ShortestPath;
void ShortestPath(PREFIX ## Fst const &fst, PREFIX ## MutableFst *out,int n);
// Synchronize
%feature("docstring",
         "Topologically sort an FST.") TopSort;
void TopSort(PREFIX ## MutableFst *fst);
%feature("docstring",
         "Take the union of two FSTs, placing the result in the first argument.") Union;
void Union(PREFIX ## MutableFst *out,PREFIX ## Fst const &fst);
%feature("docstring",
         "Verify an FST.") Verify;
bool Verify(PREFIX ## Fst const &fst);

/******************************************************************/

%feature("docstring",
         "Get string starting at given state.") GetString;
char *GetString(PREFIX ## MutableFst *fst,int which=0);

%feature("docstring",
         "Get wide character string starting at given state.") WGetString;
wchar_t *WGetString(PREFIX ## MutableFst *fst,int which=0);

%feature("docstring",
         "Sort the arcs of an FST on the output labels.") ArcSortOutput;
void ArcSortOutput(PREFIX ## MutableFst *fst);

%feature("docstring",
         "Sort the arcs of an FST on the input labels.") ArcSortInput;
void ArcSortInput(PREFIX ## MutableFst *fst);

%feature("docstring",
         "Project an FST to an FSA using the input labels.") ProjectInput;
void ProjectInput(PREFIX ## MutableFst *result);

%feature("docstring",
         "Project an FST to an FSA using the output labels.") ProjectOutput;
void ProjectOutput(PREFIX ## MutableFst *result);

%feature("docstring",
         "Perform Kleene star closure on an FST.") ClosureStar;
void ClosureStar(PREFIX ## MutableFst *fst);

%feature("docstring",
         "Perform plus-closure on an FST.") ClosurePlus;
void ClosurePlus(PREFIX ## MutableFst *fst);

%feature("docstring",
         "Concatenate fst2 onto fst.") ConcatOnto;
void ConcatOnto(PREFIX ## MutableFst *fst,PREFIX ## Fst const &fst2);

%feature("docstring",
         "Concatenate fst onto fst2.") ConcatOntoOther;
void ConcatOntoOther(PREFIX ## Fst const &fst,PREFIX ## MutableFst *fst2);

%feature("docstring",
         "Epsilon normalize an FST on the input side.") EpsNormInput;
void EpsNormInput(PREFIX ## Fst const &fst, PREFIX ## MutableFst *out);

%feature("docstring",
         "Epsilon normalize an FST on the output side.") EpsNormOutput;
void EpsNormOutput(PREFIX ## Fst const &fst, PREFIX ## MutableFst *out);

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
void ConvertSymbols(PREFIX ## VectorFst *fst, SymbolTable const &symtab,
                   bool input, bool output);

%newobject Copy;
%feature("docstring", "Copy an FST.") Copy;
%inline %{
    PREFIX ## VectorFst *Copy(PREFIX ## VectorFst &fst) {
        // is there a method that does this directly?
        PREFIX ## VectorFst *result = new PREFIX ## VectorFst();
        Union(result,fst);
        return result;
    }
%}

%inline %{
typedef EncodeMapper<ARCTYPE> PREFIX ## EncodeMapper;
%}

%template(PREFIX ## EncodeMapper) EncodeMapper<ARCTYPE>;

%feature("docstring",
         "Encode the arcs of an FST.") Encode;
void Encode(PREFIX ## MutableFst *fst,PREFIX ## EncodeMapper *mapper);
%feature("docstring",
         "Decode the arcs of an FST.") Decode;
void Decode(PREFIX ## MutableFst *fst,const EncodeMapper<ARCTYPE> &mapper);

%enddef

INSTANTIATE_FST(Std,StdArc,Weight,"min/+ semiring");
INSTANTIATE_FST(Log,LogArc,LogWeight,"log semiring");
INSTANTIATE_FST(Log64,Log64Arc,Log64Weight,"log semiring (64bit)");

/* More convenience functions. */

%feature("docstring",
         "Convenience function to read a StdVectorFst from a file.") Read;
%inline %{
    StdVectorFst *Read(const char *s) {
        return StdVectorFst::Read(s);
    }
%}

%feature("docstring",
         "Convenience function to read a StdVectorFst from a file.") Read;
%inline %{
    LogVectorFst *ReadLogVectorFst(const char *s) {
        return LogVectorFst::Read(s);
    }
%}

