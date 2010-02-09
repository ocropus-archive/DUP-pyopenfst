// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

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

    %extend {
        %pythoncode %{
            def __iter__(self):
                return SymbolTable_iter(SymbolTableIterator(self))
        %}
    }

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
