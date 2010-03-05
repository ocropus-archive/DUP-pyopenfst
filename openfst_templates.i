// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%include "std_vector.i"

/* Template for Arc classes. */
template <class W> class ArcTpl {
public:
    typedef W Weight;
    %feature("docstring", "Numeric ID of the input label for this arc.");
    int ilabel;
    %feature("docstring", "Numeric ID of the output label for this arc.");
    int olabel;
    %feature("docstring", "Destination state ID for this arc.");
    int nextstate;
    %feature("docstring", "Weight associated with this arc.");
    W weight;
    %feature("docstring", "Create a new arc with specified input and output labels,\n"
             "weight, and target state.  Use 0 as the label for epsilon arcs.");
    ArcTpl(int ilabel, int olabel, float weight, int nextstate);
};

/* Template for abstract Fst base class. */
template<class A> class Fst {
    %feature("docstring",
             "Get the start state ID of this FST.");
    virtual int Start() const = 0;
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    virtual typename A::Weight Final(int stateid) const = 0;
    %feature("docstring", "Returns the number of states in this FST.");
    virtual int NumStates() const = 0;
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    virtual int NumArcs(int stateid) const = 0;
public:
    typedef A Arc;
};

/* Template for abstract MutableFst base class. */
template<class A> class MutableFst : public Fst<A> {
    %feature("docstring",
             "Get the start state ID of this FST.");
    virtual int Start() const = 0;
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    virtual typename A::Weight Final(int stateid) const = 0;
    %feature("docstring", "Returns the number of states in this FST.");
    virtual int NumStates() const = 0;
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    virtual int NumArcs(int stateid) const = 0;
    %feature("docstring",
             "Add a new state to this FST.  Returns the ID of this new state.");
    virtual int AddState()  = 0;
    %feature("docstring", "Set the start state.");
    virtual void SetStart(int stateid) = 0;
    %feature("docstring",
             "Add an outgoing arc from the given state.  Symbols and weight are\n"
             "given in the constructor for arc.");
    virtual void AddArc(int stateid, const A & arc) = 0;
    %feature("docstring",
             "Delete a list of states from this FST.");
    virtual void DeleteStates(const vector<int>&) = 0;
    %feature("docstring",
             "Delete all states from this FST.");
    virtual void DeleteStates() = 0;
    %feature("docstring",
             "Delete the first n outgoing arcs from a state.");
    virtual void DeleteArcs(int stateid, size_t n) = 0;
    %feature("docstring",
             "Delete all outgoing arcs from a state.");
    virtual void DeleteArcs(int stateid) = 0;
    %feature("docstring",
             "Mark the given state as final, with the specified weight.");
    virtual void SetFinal(int stateid, float weight) = 0;
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
public:
    typedef A Arc;
};

/* Template for VectorFst implementation class. */
template<class A> class VectorFst : public MutableFst<A> {
public:
    typedef A Arc;

    %feature("docstring", "constructor");
    VectorFst();
    VectorFst(Fst<A> const &fst);
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
    typename A::Weight Final(int stateid);
    %feature("docstring", "Returns the number of states in this FST.");
    int NumStates();
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    int NumArcs(int stateid);
    %feature("docstring", "Set the start state.");
    void SetStart(int stateid);
    %feature("docstring",
             "Add an outgoing arc from the given state.  Symbols and weight are\n"
             "given in the constructor to arc.");
    void AddArc(int stateid, const A & arc);
    %feature("docstring",
             "Delete a list of states from this FST.");
    void DeleteStates(const vector<int>&);
    %feature("docstring",
             "Delete all states from this FST.");
    void DeleteStates();
    %feature("docstring",
             "Delete the first n outgoing arcs from a state.");
    void DeleteArcs(int stateid, size_t n);
    %feature("docstring",
             "Delete all outgoing arcs from a state.");
    void DeleteArcs(int stateid);
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
    VectorFst<A>* Copy(bool reset = false) const;

    %feature("docstring","Convenience function to test if a state is final.\n"
             "Use this instead of the Final() method\n") IsFinal;
    %extend {
        bool IsFinal(int state) {
            return $self->Final(state)!=A::Weight::Zero();
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
            $self->AddArc(from,A(ilabel,olabel,weight,to));
        }
        %feature("docstring",
                 "Convenience method which returns the jth arc exiting state i.")
             GetArc;
        A GetArc(int i,int j) {
            ArcIterator<VectorFst<A > > iter(*$self,i);
            iter.Seek(j);
            return iter.Value();
        }
        %feature("docstring",
                 "Convenience method which returns the input label for the jth\n"
                 "arc exiting state i.")
             GetInput;
        int GetInput(int i,int j) {
            ArcIterator<VectorFst<A > > iter(*$self,i);
            iter.Seek(j);
            return iter.Value().ilabel;
        }
        %feature("docstring",
                 "Convenience method which returns the output label for the jth\n"
                 "arc exiting state i.")
             GetOutput;
        int GetOutput(int i,int j) {
            ArcIterator<VectorFst<A > > iter(*$self,i);
            iter.Seek(j);
            return iter.Value().olabel;
        }
        %feature("docstring",
                 "Convenience method which returns the weight for the jth\n"
                 "arc exiting state i.")
             GetWeight;
        float GetWeight(int i,int j) {
            ArcIterator<VectorFst<A > > iter(*$self,i);
            iter.Seek(j);
            return iter.Value().weight.Value();
        }
        %feature("docstring",
                 "Convenience method which returns the target state for the jth\n"
                 "arc exiting state i.")
             GetNext;
        int GetNext(int i,int j) {
            ArcIterator<VectorFst<A > > iter(*$self,i);
            iter.Seek(j);
            return iter.Value().nextstate;;
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
                $self->AddArc(state,A(c,c,xcost,nstate));
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
                $self->AddArc(state,A(s[i],s[i],xcost,nstate));
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
                $self->AddArc(state,A(in[i],epsilon,xcost,nstate));
                state = nstate;
            }
            for(int i=0;out[i];i++) {
                int nstate = $self->AddState();
                $self->AddArc(state,A(epsilon,out[i],ccost,nstate));
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
                $self->AddArc(state,A(in[i],OEPS,xcost,nstate));
                state = nstate;
            }
            for(int i=0;out[i];i++) {
                int nstate = $self->AddState();
                $self->AddArc(state,A(IEPS,out[i],ccost,nstate));
                state = nstate;
            }
            $self->SetFinal(state,fcost);
        }
    }
};

/* Template for lazy composition FSTs. */
template<class A> class ComposeFst : public Fst<A> {
public:
    %feature("docstring",
             "Construct a lazy composition of FSTs A and B.");
    ComposeFst(Fst<A> const &fst1, Fst<A> const &fst2);
    %feature("docstring",
             "Get the start state ID of this FST.");
    int Start();
    %feature("docstring",
             "Check if the given state is a final state.  Returns its weight if\n"
             "it is final, otherwise returns Weight.Zero() = inf.  Use IsFinal()\n"
             "instead if all you are interested in doing is checking for finality.");
    typename A::Weight Final(int stateid);
    %feature("docstring", "Returns the number of arcs leaving the given state.");
    int NumArcs(int stateid);
};

/* Template for state iterators. */
template<class F> class StateIterator {
public:
    %feature("docstring", "constructor");
    StateIterator(F const & fst);
    %feature("docstring", "Advance the iterator.");
    void Next();
    %feature("docstring", "Reset the iterator.");
    void Reset();
    %feature("docstring", "Returns true if the iterator is done.");
    bool Done() const;
    %feature("docstring", "Get the state ID the iterator is currently pointing to.");
    int Value() const;
};

/* Templates for arc iterators. */
template<class F> class ArcIterator {
public:
    typedef typename F::Arc Arc;
    %feature("docstring", "constructor");
    ArcIterator(F const & fst, int stateid);
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
    const Arc & Value() const;
};
template<class F> class MutableArcIterator {
public:
    typedef typename F::Arc Arc;
    %feature("docstring", "constructor");
    MutableArcIterator(F *fst, int stateid);
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
    const Arc & Value() const;
    %feature("docstring", "Modify the arc the iterator is currently pointing to.");
    void SetValue(Arc const & arc);
};
