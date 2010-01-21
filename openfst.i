// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%module openfst
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

class Weight {
    float Value();
};

struct StdArc {
    int ilabel;
    int olabel;
    int nextstate;
    Weight weight;
    StdArc(int,int,float,int);
};

struct SymbolTable {
    SymbolTable(std::string const &);
    long long AddSymbol(std::string const &, long long);
    long long AddSymbol(std::string const &);
    void AddTable(SymbolTable const &);
    std::string const & Name() const;
    std::string CheckSum() const;
    SymbolTable *Copy() const;
    static SymbolTable* ReadText(std::string const & filename,
                                 bool allow_negative = false);
    bool WriteText(std::string const & filename) const;
    static SymbolTable *Read(std::string const & filename);
    bool Write(std::string const & filename) const;
    std::string Find(long long) const;
    long long Find(std::string const &);
    long long AvailableKey(void) const;
    unsigned long NumSymbols(void) const;
};

struct SymbolTableIterator {
    SymbolTableIterator(SymbolTable const &);
    bool Done(void);
    const char * Symbol(void);
    long long Value(void);
    void Next(void);
    void Reset(void);
};

struct StdVectorFst {
    int AddState();
    int Start();
    Weight Final(int);
    int NumStates();
    int NumArcs(int);
    void SetStart(int);
    void AddArc(int,const StdArc &);
    void SetFinal(int,float);
    void ReserveStates(int);
    void ReserveArcs(int,int);
    SymbolTable * InputSymbols();
    SymbolTable * OutputSymbols();
    void SetInputSymbols(SymbolTable const *);
    void SetOutputSymbols(SymbolTable const *);

    static StdVectorFst* Read(std::string const & filename);
    bool Write(std::string const &filename);
    StdVectorFst* Copy(bool reset = false) const;
};

%pythoncode %{
class SymbolTable_iter(object):
    def __init__(self, itor):
        self.first = True
        self.itor = itor

    def __iter__(self):
        return self.__class__(self.itor)

    def next(self):
        if self.first:
            self.first = False
        else:
            self.itor.Next()
        if self.itor.Done():
            raise StopIteration
        return self.itor
%}

%extend SymbolTable {
    %pythoncode %{
def __iter__(self):
    return SymbolTable_iter(SymbolTableIterator(self))
%}
}

%extend StdVectorFst {
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
