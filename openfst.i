// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%module(docstring="Python Bindings for the OpenFST Library") openfst
%feature("autodoc");
%include "typemaps.i"
%include "cstring.i"
%include "std_string.i"
%include "std_wstring.i"
%{
#include <fst/fstlib.h>
#include <fst/symbol-table.h>
#include <fst/arcsort.h>
using namespace fst;
typedef TropicalWeight Weight;
typedef ArcIterator<StdVectorFst> StdVectorArcIterator;
typedef MutableArcIterator<StdVectorFst> StdVectorMutableArcIterator;
typedef StateIterator<StdVectorFst> StdVectorStateIterator;
%}

%inline %{
const int epsilon = 0;
%}

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

%feature("docstring",
         "Standard weight class, using floating-point values in the tropical semiring.");
struct Weight {
    %feature("docstring", "Get the floating-point value of a weight.");
    float Value();
    %feature("docstring",
             "Returns the zero weight for this semiring.  This is the weight which\n"
             "acts as an annihilator for multiplication and an identity for addition.\n"
             "For the standard weight class, its value is positive infinity.");
    static Weight const Zero();
    %feature("docstring",
             "Returns the one value for this semiring.  This is the weight which\n"
             "acts as an identity for multiplication.\n"
             "For the standard weight class, its value is zero.");
    static Weight const One();
};

%feature("docstring",
         "Standard arc class, using floating-point weights in the tropical semiring.");
struct StdArc {
    %feature("docstring", "Numeric ID of the input label for this arc.");
    int ilabel;
    %feature("docstring", "Numeric ID of the output label for this arc.");
    int olabel;
    %feature("docstring", "Destination state ID for this arc.");
    int nextstate;
    %feature("docstring", "Weight associated with this arc.");
    Weight weight;
    %feature("docstring", "Create a new arc with specified input and output labels,\n"
             "weight, and target state.  Use 0 as the label for epsilon arcs.");
    StdArc(int ilabel, int olabel, float weight, int nextstate);
};

%feature("docstring",
         "Symbol table class, map input/output symbol IDs to and from strings.");
struct SymbolTable {
    %feature("docstring", "Create a new symbol table with identifying name.");
    SymbolTable(std::string const & name);
    %feature("docstring", "Add a symbol to the symbol table, optionally with a specific\n"
             "numeric ID.  Returns the numeric ID assigned to this symbol (which may\n"
             "already exist).");
    long long AddSymbol(std::string const & name, long long id);
    long long AddSymbol(std::string const & name);
    %feature("docstring", "Merge the contents of another symbol table into this one.");
    void AddTable(SymbolTable const & symtab);
    %feature("docstring", "Returns the identifying name of this symbol table.");
    std::string const & Name() const;
    std::string CheckSum() const;
    %feature("docstring", "Return a copy of this symbol table.");
    SymbolTable *Copy() const;
    %feature("docstring", "Read entries from a text file.");
    static SymbolTable* ReadText(std::string const & filename,
                                 bool allow_negative = false);
    %feature("docstring", "Write entries to a text file.");
    bool WriteText(std::string const & filename) const;
    %feature("docstring", "Read entries from a binary file.");
    static SymbolTable *Read(std::string const & filename);
    %feature("docstring", "Write entries to a binary file.");
    bool Write(std::string const & filename) const;
    %feature("docstring",
             "Look up a symbol or numeric ID in the table.  If called with a string,\n"
             "returns the ID for that string or -1 if not found.  If called with an\n"
             "integer, returns the string for that ID, or the empty string if not found.");
    std::string Find(long long id) const;
    long long Find(std::string const & name);
    %feature("docstring",
             "Returns the next automatically-assigned symbol ID.");
    long long AvailableKey(void) const;
    %feature("docstring",
             "Returns the number of unique symbols in this table.");
    unsigned long NumSymbols(void) const;
};


%feature("docstring",
         "Underlying iterator class over SymbolTable objects.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for symbol, id in symtab:\n"
         "    print \"symbol %s has id %d\" % (symbol, id)\n");
struct SymbolTableIterator {
    SymbolTableIterator(SymbolTable const & symtab);
    bool Done(void);
    const char * Symbol(void);
    long long Value(void);
    void Next(void);
    void Reset(void);
};

%feature("docstring",
         "Standard FST class, using floating-point weights in the tropical semiring\n"
         "and an underlying implementation based on C++ vectors.");
struct StdVectorFst {
    %feature("docstring",
             "Add a new state to this FST.  Returns the ID of this new state.");
    int AddState();
    %feature("docstring",
             "Get the start state ID of this FST.");
    int Start();
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    Weight Final(int stateid);
    %feature("docstring", "Returns the number of states in this FST.");
    int NumStates();
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    int NumArcs(int stateid);
    %feature("docstring", "Set the start state.");
    void SetStart(int stateid);
    %feature("docstring",
             "Add an outgoing arc from the given state.  Symbols and weight are\n"
             "given in the constructor to StdArc().");
    void AddArc(int stateid, const StdArc & arc);
    %feature("docstring",
             "Mark the given state as final, with the specified weight.");
    void SetFinal(int stateid, float weight);
    %feature("docstring",
             "Reserve space for new states up to the given ID.");
    void ReserveStates(int stateid);
    %feature("docstring",
             "Reserve space for n arcs leaving the given state ID.");
    void ReserveArcs(int stateid, int n);
    %feature("docstring", "Returns the input symbol table.");
    SymbolTable * InputSymbols();
    %feature("docstring", "Returns the output symbol table.");
    SymbolTable * OutputSymbols();
    %feature("docstring",
             "Sets the input symbol table.  Because of the semantics of SWIG, this\n"
             "incurs a copy, and thus you should call it just before writing the FST\n"
             "to a file, or any changes you may have made to the given symbol table\n"
             "will not be reflected in the output file.");
    void SetInputSymbols(SymbolTable const * symtab);
    %feature("docstring",
             "Sets the output symbol table.  Because of the semantics of SWIG, this\n"
             "incurs a copy, and thus you should call it just before writing the FST\n"
             "to a file, or any changes you may have made to the given symbol table\n"
             "will not be reflected in the output file.");
    void SetOutputSymbols(SymbolTable const * symtab);

    %feature("docstring", "Read an FST from a binary file.");
    static StdVectorFst* Read(std::string const & filename);
    %feature("docstring", "Write this FST to a binary file.");
    bool Write(std::string const &filename);
    %feature("docstring", "Returns a copy of this FST.");
    StdVectorFst* Copy(bool reset = false) const;
};

%feature("docstring",
         "Underlying iterator class over states.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    ...\n");
struct StdVectorStateIterator {
    StdVectorStateIterator(StdVectorFst const & fst);
    void Next();
    void Reset();
    bool Done() const;
    int Value() const;
};

%feature("docstring",
         "Underlying iterator class over arcs.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.iterarcs(state):\n");
struct StdVectorArcIterator {
    StdVectorArcIterator(StdVectorFst const & fst, int stateid);
    void Next();
    void Reset();
    void Seek(unsigned long pos);
    unsigned long Position() const;
    bool Done() const;
    const StdArc & Value() const;
};

%feature("docstring",
         "Underlying iterator class over arcs which allows changes to be\n"
         "made.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.mutable_iterarcs(state):\n");
struct StdVectorMutableArcIterator {
    StdVectorMutableArcIterator(StdVectorFst * fst, int stateid);
    void Next();
    void Reset();
    void Seek(unsigned long pos);
    unsigned long Position() const;
    bool Done() const;
    const StdArc & Value() const;
    void SetValue(StdArc const & arc);
};

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

class StdVectorFst_state_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class StdVectorFst_arc_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class StdVectorFst_mutable_arc_iter(IteratorProxy):
    pass
%}

%extend SymbolTable {
    %pythoncode %{
def __iter__(self):
    return SymbolTable_iter(SymbolTableIterator(self))
%}
}

%extend StdVectorFst {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return StdVectorFst_state_iter(StdVectorStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return StdVectorFst_arc_iter(StdVectorArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return StdVectorFst_arc_iter(StdVectorMutableArcIterator(self, stateid))
%}
    %feature("docstring","Convenience function to test if a state is final.\n"
             "Use this instead of the Final() method\n");
    bool IsFinal(int state) {
        return $self->Final(state)!=Weight::Zero();
    }
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
    float FinalWeight(int state) {
        return $self->Final(state).Value();
    }
    void AddArc(int from,int ilabel,int olabel,float weight,int to) {
        $self->AddArc(from,StdArc(ilabel,olabel,weight,to));
    }
    StdArc GetArc(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value();
    }
    int GetInput(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().ilabel;
    }
    int GetOutput(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().olabel;
    }
    float GetWeight(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().weight.Value();
    }
    int GetNext(int i,int j) {
        ArcIterator<StdVectorFst> iter(*$self,i);
        iter.Seek(j);
        return iter.Value().nextstate;;
    }
}

%inline %{
    char *GetString(StdVectorFst *fst,int which=0) {
        char result[100000];
        int index = 0;
        int state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if(fst->Final(state)!=Weight::Zero()) break;
            ArcIterator<StdVectorFst> iter(*fst,state);
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
    wchar_t *WGetString(StdVectorFst *fst,int which=0) {
        wchar_t result[100000];
        int index = 0;
        int state = fst->Start();
        if(state<0) return 0;
        for(;;) {
            if(fst->Final(state)!=Weight::Zero()) break;
            ArcIterator<StdVectorFst> iter(*fst,state);
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
    void ArcSortOutput(StdVectorFst *fst) {
        ArcSort(fst,StdOLabelCompare());
    }
    void ArcSortInput(StdVectorFst *fst) {
        ArcSort(fst,StdILabelCompare());
    }
    void ProjectInput(StdVectorFst *result) {
        Project(result,PROJECT_INPUT);
    }
    void ProjectOutput(StdVectorFst *result) {
        Project(result,PROJECT_OUTPUT);
    }
    void ClosureStar(StdVectorFst *fst) {
        Closure(fst,CLOSURE_STAR);
    }
    void ClosurePlus(StdVectorFst *fst) {
        Closure(fst,CLOSURE_PLUS);
    }
    void ConcatOnto(StdVectorFst *fst,StdVectorFst &fst2) {
        Concat(fst,fst2);
    }
    void ConcatOntoOther(StdVectorFst &fst,StdVectorFst *fst2) {
        Concat(fst,fst2);
    }
    void EpsNormInput(StdVectorFst &fst,StdVectorFst *out) {
        EpsNormalize(fst,out,EPS_NORM_INPUT);
    }
    void EpsNormOutput(StdVectorFst &fst,StdVectorFst *out) {
        EpsNormalize(fst,out,EPS_NORM_OUTPUT);
    }
%}

void Compose(StdVectorFst &fst1,StdVectorFst &fst2,StdVectorFst *result);
void Connect(StdVectorFst *fst);
// Decode
// Encode
void Determinize(StdVectorFst &in,StdVectorFst *out);
void Difference(StdVectorFst &fst,StdVectorFst &fst2,StdVectorFst *out);
void Intersect(StdVectorFst &fst,StdVectorFst &fst2,StdVectorFst *out);
void Invert(StdVectorFst *fst);
void Minimize(StdVectorFst *fst);
void Prune(StdVectorFst *fst,float threshold);
bool RandEquivalent(StdVectorFst &fst,StdVectorFst &fst2,int n);
void RandGen(StdVectorFst &fst,StdVectorFst *out);
// Replace
void Reverse(StdVectorFst &fst,StdVectorFst *out);
// Reweight
void RmEpsilon(StdVectorFst *out);
// ShortestDistance
void ShortestPath(StdVectorFst &fst,StdVectorFst *out,int n);
// Synchronize
void TopSort(StdVectorFst *fst);
void Union(StdVectorFst *out,StdVectorFst &fst);
void Verify(StdVectorFst &fst);

%newobject Copy;
%inline %{
    StdVectorFst *Copy(StdVectorFst &fst) {
        // is there a method that does this directly?
        StdVectorFst *result = new StdVectorFst();
        Union(result,fst);
        return result;
    }
%}
