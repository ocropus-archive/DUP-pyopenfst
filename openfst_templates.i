// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

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
    virtual int AddState() const = 0;
    %feature("docstring", "Set the start state.");
    virtual void SetStart(int stateid) = 0;
    %feature("docstring",
             "Add an outgoing arc from the given state.  Symbols and weight are\n"
             "given in the constructor for arc.");
    virtual void AddArc(int stateid, const A & arc) const = 0;
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
};

/* Template for lazy composition FSTs. */
template<class A> class ComposeFst : public Fst<A> {
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
