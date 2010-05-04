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
    return Fst_mutable_arc_iter(StdMutableArcIterator(self, stateid))
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
    return Fst_mutable_arc_iter(LogMutableArcIterator(self, stateid))
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
    return Fst_mutable_arc_iter(LogMutableArcIterator(self, stateid))
%}
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
    return Fst_mutable_arc_iter(StdMutableArcIterator(self, stateid))
%}
}
