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
typedef StateIterator<StdFst> StdStateIterator;
typedef ArcIterator<StdFst> StdArcIterator;
typedef MutableArcIterator<StdMutableFst> StdMutableArcIterator;
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
         "Standard weight class, using floating-point values in the tropical semiring.") Weight;
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
         "Standard arc class, using floating-point weights in the tropical semiring.") StdArc;
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
         "Symbol table class, map input/output symbol IDs to and from strings.") SymbolTable;
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
         "    print \"symbol %s has id %d\" % (symbol, id)\n") SymbolTableIterator;
struct SymbolTableIterator {
    SymbolTableIterator(SymbolTable const & symtab);
    bool Done(void);
    const char * Symbol(void);
    long long Value(void);
    void Next(void);
    void Reset(void);
};

class StdFst {
    %feature("docstring",
             "Get the start state ID of this FST.");
    virtual int Start() const = 0;
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    virtual Weight Final(int stateid) const = 0;
    %feature("docstring", "Returns the number of states in this FST.");
    virtual int NumStates() const = 0;
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    virtual int NumArcs(int stateid) const = 0;
};

class StdMutableFst : public StdFst {
    %feature("docstring",
             "Get the start state ID of this FST.");
    virtual int Start() const = 0;
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    virtual Weight Final(int stateid) const = 0;
    %feature("docstring", "Returns the number of states in this FST.");
    virtual int NumStates() const = 0;
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    virtual int NumArcs(int stateid) const = 0;
    %feature("docstring",
             "Add a new state to this FST.  Returns the ID of this new state.");
    virtual int AddState() const = 0;
    %feature("docstring", "Set the start state.");
    virtual void SetStart(int stateid) = 0;
    %feature("docstring",
             "Add an outgoing arc from the given state.  Symbols and weight are\n"
             "given in the constructor to StdArc().");
    virtual void AddArc(int stateid, const StdArc & arc) const = 0;
    // DeleteStates, DeleteArcs
    %feature("docstring",
             "Mark the given state as final, with the specified weight.");
    virtual void SetFinal(int stateid, float weight) const = 0;
    %feature("docstring", "Returns the input symbol table.");
    virtual SymbolTable * InputSymbols() = 0;
    %feature("docstring", "Returns the output symbol table.");
    virtual SymbolTable * OutputSymbols() = 0;
    %feature("docstring",
             "Sets the input symbol table.  Because of the semantics of SWIG, this\n"
             "incurs a copy, and thus you should call it just before writing the FST\n"
             "to a file, or any changes you may have made to the given symbol table\n"
             "will not be reflected in the output file.");
    virtual void SetInputSymbols(SymbolTable const * symtab) = 0;
    %feature("docstring",
             "Sets the output symbol table.  Because of the semantics of SWIG, this\n"
             "incurs a copy, and thus you should call it just before writing the FST\n"
             "to a file, or any changes you may have made to the given symbol table\n"
             "will not be reflected in the output file.");
    virtual void SetOutputSymbols(SymbolTable const * symtab) = 0;
};

%feature("docstring",
         "Standard FST class, using floating-point weights in the tropical semiring\n"
         "and an underlying implementation based on C++ vectors.") StdVectorFst;
%feature("notabstract") StdVectorFst;
class StdVectorFst : public StdMutableFst {
public:
    %feature("docstring", "constructor");
    StdVectorFst();
    StdVectorFst(StdFst const &fst);
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
         "    ...\n") StdStateIterator;
struct StdStateIterator {
    %feature("docstring", "constructor");
    StdStateIterator(StdFst const & fst);
    %feature("docstring", "Advance the iterator.");
    void Next();
    %feature("docstring", "Reset the iterator.");
    void Reset();
    %feature("docstring", "Returns true if the iterator is done.");
    bool Done() const;
    %feature("docstring", "Get the state ID the iterator is currently pointing to.");
    int Value() const;
};

%feature("docstring",
         "Underlying iterator class over arcs.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.iterarcs(state):\n") StdArcIterator;
struct StdArcIterator {
    %feature("docstring", "constructor");
    StdArcIterator(StdFst const & fst, int stateid);
    %feature("docstring", "Advance the iterator.");
    void Next();
    %feature("docstring", "Reset the iterator.");
    void Reset();
    %feature("docstring", "Seek to position.");
    void Seek(unsigned long pos);
    %feature("docstring", "Get current position.");
    unsigned long Position() const;
    %feature("docstring", "Returns true if the iterator is done.");
    bool Done() const;
    %feature("docstring", "Get the arc the iterator is currently pointing to.");
    const StdArc & Value() const;
};

%feature("docstring",
         "Underlying iterator class over arcs which allows changes to be\n"
         "made.  Use Python iterator\n"
         "syntax instead, e.g.:\n\n"
         "for state in fst:\n"
         "    for arc in fst.mutable_iterarcs(state):\n") StdMutableArcIterator;
struct StdMutableArcIterator {
    %feature("docstring", "constructor");
    StdMutableArcIterator(StdMutableFst *fst, int stateid);
    %feature("docstring", "Advance the iterator.");
    void Next();
    %feature("docstring", "Reset the iterator.");
    void Reset();
    %feature("docstring", "Seek to position.");
    void Seek(unsigned long pos);
    %feature("docstring", "Get current position.");
    unsigned long Position() const;
    %feature("docstring", "Returns true if the iterator is done.");
    bool Done() const;
    %feature("docstring", "Get the arc the iterator is currently pointing to.");
    const StdArc & Value() const;
    %feature("docstring", "Modify the arc the iterator is currently pointing to.");
    void SetValue(StdArc const & arc);
};

%feature("docstring",
         "Lazy composition of two FSTs.\n") StdComposeFst;
%feature("notabstract") StdComposeFst;
struct StdComposeFst : public StdFst {
    %feature("docstring",
             "Construct a lazy composition of FSTs A and B.");
    StdComposeFst(StdFst const &fst1, StdFst const &fst2);
    %feature("docstring",
             "Get the start state ID of this FST.");
    int Start();
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    Weight Final(int stateid);
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    int NumArcs(int stateid);
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

class StdFst_state_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class StdFst_arc_iter(IteratorProxy):
    def get(self):
        return self.itor.Value()

class StdFst_mutable_arc_iter(IteratorProxy):
    pass
%}

%extend SymbolTable {
    %pythoncode %{
def __iter__(self):
    return SymbolTable_iter(SymbolTableIterator(self))
%}
}

%extend StdFst {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return StdFst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdArcIterator(self, stateid))
%}
}

%extend StdComposeFst {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return StdFst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdArcIterator(self, stateid))
%}
}

%extend StdMutableFst {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return StdFst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdMutableArcIterator(self, stateid))
%}
}

%extend StdVectorFst {
    %pythoncode %{
def __iter__(self):
    """Return an iterator over state IDs."""
    return StdFst_state_iter(StdStateIterator(self))

def iterarcs(self, stateid):
    """Return an iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdArcIterator(self, stateid))

def mutable_iterarcs(self, stateid):
    """Return a mutable iterator over outgoing arcs from stateid."""
    return StdFst_arc_iter(StdMutableArcIterator(self, stateid))
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
