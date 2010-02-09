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

%pythoncode %{
class IteratorProxy(object):
    "Base class for Pythonic proxies of OpenFst iterators."
    def __init__(self, itor):
        self.first = True
        self.itor = itor

    def __iter__(self):
        return self.__class__(self.itor)

    def get(self):
        "Method to be overriden which returns the iterator's value"
        return self.itor

    def next(self):
        if self.first:
            self.first = False
        else:
            self.itor.Next()
        if self.itor.Done():
            raise StopIteration
        return self.get()

class SymbolTable_iter(IteratorProxy):
    def get(self):
        return self.itor.Symbol(), self.itor.Value()

class Fst_state_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class Fst_arc_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class Fst_mutable_arc_iter(IteratorProxy):
    pass
%}

/* Actually I think it's possible to template these. */
%extend Fst<StdArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdArcIterator(self, stateid))
%}
}
%extend Fst<LogArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(LogStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogArcIterator(self, stateid))
%}
}
%extend ComposeFst<StdArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdArcIterator(self, stateid))
%}
}
%extend ComposeFst<LogArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(LogStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogArcIterator(self, stateid))
%}
}
%extend MutableFst<StdArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdMutableArcIterator(self, stateid))
%}
}
%extend MutableFst<LogArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(LogStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogMutableArcIterator(self, stateid))
%}
}
%extend VectorFst<LogArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(LogStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(LogMutableArcIterator(self, stateid))
%}

    %feature("docstring","Convenience function to test if a state is final.\n"
             "Use this instead of the Final() method\n") IsFinal;
    bool IsFinal(int state) {
        return $self->Final(state)!=LogWeight::Zero();
    }
}
%extend VectorFst<StdArc> {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return Fst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return Fst_arc_iter(StdMutableArcIterator(self, stateid))
%}

    %feature("docstring","Convenience function to test if a state is final.\n"
             "Use this instead of the Final() method\n") IsFinal;
    bool IsFinal(int state) {
        return $self->Final(state)!=Weight::Zero();
    }
    %feature("docstring", "Add nodes and arcs to recognize a character string.") AddString;
    void AddString(const char *s,float icost=0.0,float fcost=0.0,float ccost=0.0) {
        int state = $self->Start();
        if(state<0) {
            state = $self->AddState();
            $self->SetStart(state);
        }
        for(int i=0;s[i];i++) {
            int nstate = $self->AddState();
            float xcost = ccost + (i==0?icost:0);
            int c = s[i];
            if(c<0 || c>10000000)
                throw "AddString: bad character";
            $self->AddArc(state,StdArc(c,c,xcost,nstate));
            state = nstate;
        }
        $self->SetFinal(state,fcost);
    }
    %feature("docstring", "Add nodes and arcs to recognize a wide character string.")
         AddWString;
    void AddWString(const wchar_t *s,float icost=0.0,float fcost=0.0,float ccost=0.0) {
        int state = $self->Start();
        if(state<0) {
            state = $self->AddState();
            $self->SetStart(state);
        }
        for(int i=0;s[i];i++) {
            int nstate = $self->AddState();
            float xcost = ccost + (i==0?icost:0);
            $self->AddArc(state,StdArc(s[i],s[i],xcost,nstate));
            state = nstate;
        }
        $self->SetFinal(state,fcost);
    }
    %feature("docstring", "Add nodes and arcs to transduce one string into another.")
         AddTranslation;
    void AddTranslation(const char *in,const char *out,float icost=0.0,float fcost=0.0,float ccost=0.0) {
        int state = $self->Start();
        if(state<0) {
            state = $self->AddState();
            $self->SetStart(state);
        }
        for(int i=0;in[i];i++) {
            int nstate = $self->AddState();
            float xcost = ccost + (i==0?icost:0);
            $self->AddArc(state,StdArc(in[i],epsilon,xcost,nstate));
            state = nstate;
        }
        for(int i=0;out[i];i++) {
            int nstate = $self->AddState();
            $self->AddArc(state,StdArc(epsilon,out[i],ccost,nstate));
            state = nstate;
        }
        $self->SetFinal(state,fcost);
    }
    %feature("docstring",
             "Add nodes and arcs to transduce one wide character string into another.")
         AddWTranslation;
    void AddWTranslation(const wchar_t *in,const wchar_t *out,float icost=0.0,float fcost=0.0,float ccost=0.0) {
        int state = $self->Start();
        if(state<0) {
            state = $self->AddState();
            $self->SetStart(state);
        }
        const int OEPS = 0;
        const int IEPS = 0;
        for(int i=0;in[i];i++) {
            int nstate = $self->AddState();
            float xcost = ccost + (i==0?icost:0);
            $self->AddArc(state,StdArc(in[i],OEPS,xcost,nstate));
            state = nstate;
        }
        for(int i=0;out[i];i++) {
            int nstate = $self->AddState();
            $self->AddArc(state,StdArc(IEPS,out[i],ccost,nstate));
            state = nstate;
        }
        $self->SetFinal(state,fcost);
    }
    %feature("docstring",
             "Get the final weight for the given state.  Use this instead of\n"
             "the Final() method.")
         FinalWeight;
    float FinalWeight(int state) {
        return $self->Final(state).Value();
    }
    %feature("docstring",
             "Convenience method which adds an arc without the need to\n"
             "explicitly create a StdArc object.")
         AddArc;
    void AddArc(int from,int ilabel,int olabel,float weight,int to) {
        $self->AddArc(from,StdArc(ilabel,olabel,weight,to));
    }
    %feature("docstring",
             "Convenience method which returns the jth arc exiting state i.")
         GetArc;
    StdArc GetArc(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value();
    }
    %feature("docstring",
             "Convenience method which returns the input label for the jth\n"
             "arc exiting state i.")
         GetInput;
    int GetInput(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().ilabel;
    }
    %feature("docstring",
             "Convenience method which returns the output label for the jth\n"
             "arc exiting state i.")
         GetOutput;
    int GetOutput(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().olabel;
    }
    %feature("docstring",
             "Convenience method which returns the weight for the jth\n"
             "arc exiting state i.")
         GetWeight;
    float GetWeight(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().weight.Value();
    }
    %feature("docstring",
             "Convenience method which returns the target state for the jth\n"
             "arc exiting state i.")
         GetNext;
    int GetNext(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().nextstate;;
    }
}

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

%feature("docstring",
         "Compose two FSTs placing the result in a newly initialized FST.") Compose;
void Compose(StdFst const &fst1, StdFst const &fst2, StdMutableFst *result);
%feature("docstring",
         "Connect an FST.") Connect;
void Connect(StdMutableFst *fst);
// Decode
// Encode
%feature("docstring",
         "Determinize an FST, placing the result in a newly initialize FST.") Determinize;
void Determinize(StdFst const &in, StdMutableFst *out);
%feature("docstring",
         "Take the difference between two FSTs, placing the result in a\n"
         "newly initialized FST.") Difference;
void Difference(StdFst const &fst, StdFst const &fst2, StdMutableFst *out);
%feature("docstring",
         "Intersect two FSTs, placing the result in a\n"
         "newly initialized FST.") Intersect;
void Intersect(StdFst const &fst,StdFst const &fst2,StdMutableFst *out);
%feature("docstring",
         "Invert an FST.") Invert;
void Invert(StdMutableFst *fst);
%feature("docstring",
         "Minimize an FST.") Minimize;
void Minimize(StdMutableFst *fst);
%feature("docstring",
         "Prune an FST, removing all arcs above threshold") Prune;
void Prune(StdMutableFst *fst,float threshold);
%feature("docstring",
         "??") RandEquivalent;
bool RandEquivalent(StdFst const &fst,StdFst const &fst2,int n);
%feature("docstring",
         "??") RandGen;
void RandGen(StdFst const &fst,StdMutableFst *out);
// Replace
%feature("docstring",
         "Reverse an FST, placing result in a newly initialized FST.") Reverse;
void Reverse(StdFst const &fst,StdMutableFst *out);
// Reweight
%feature("docstring",
         "Remove epsilon transitions from an FST.") RmEpsilon;
void RmEpsilon(StdMutableFst *out);
// ShortestDistance
%feature("docstring",
         "Find N shortest paths in an FST placing results in a newly initialized FST.")
ShortestPath;
void ShortestPath(StdFst const &fst, StdMutableFst *out,int n);
// Synchronize
%feature("docstring",
         "Topologically sort an FST.") TopSort;
void TopSort(StdMutableFst *fst);
%feature("docstring",
         "Take the union of two FSTs, placing the result in the first argument.") Union;
void Union(StdMutableFst *out,StdFst const &fst);
%feature("docstring",
         "Verify an FST.") Verify;
void Verify(StdFst const &fst);

%newobject Copy;
%feature("docstring", "Copy an FST.") Copy;
%inline %{
    StdVectorFst *Copy(StdVectorFst &fst) {
        // is there a method that does this directly?
        StdVectorFst *result = new StdVectorFst();
        Union(result,fst);
        return result;
    }
%}
