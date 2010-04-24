// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%inline %{
typedef TropicalWeight Weight;

/* Since some types are already defined in OpenFST, we just have to
 * make them known to SWIG below (outside the %inline).  This is
 * something to do with namespaces, which may be resolved in the
 * future. */
// typedef Fst<StdArc> StdFst;
typedef Fst<LogArc> LogFst;

// typedef ArcTpl<Weight> StdArc;
// typedef ArcTpl<LogWeight> LogArc;

// typedef MutableFst<StdArc> StdMutableFst;
typedef MutableFst<LogArc> LogMutableFst;

// typedef VectorFst<StdArc> StdVectorFst;
typedef VectorFst<LogArc> LogVectorFst;

typedef StateIterator<StdFst> StdStateIterator;
typedef StateIterator<LogFst> LogStateIterator;

typedef ArcIterator<StdFst> StdArcIterator;
typedef ArcIterator<LogFst> LogArcIterator;

typedef MutableArcIterator<StdMutableFst> StdMutableArcIterator;
typedef MutableArcIterator<LogMutableFst> LogMutableArcIterator;

typedef ComposeFst<StdArc> StdComposeFst;
typedef ComposeFst<LogArc> LogComposeFst;

typedef StateIterator<StdFst> StdStateIterator;
typedef StateIterator<LogFst> LogStateIterator;

typedef ArcIterator<StdFst> StdArcIterator;
typedef ArcIterator<LogFst> LogArcIterator;

typedef MutableArcIterator<StdMutableFst> StdMutableArcIterator;
typedef MutableArcIterator<LogMutableFst> LogMutableArcIterator;

typedef Matcher<StdFst> StdMatcher;
typedef Matcher<LogFst> LogMatcher;

typedef SigmaMatcher<StdMatcher> StdSigmaMatcher;
typedef SigmaMatcher<LogMatcher> LogSigmaMatcher;

typedef RhoMatcher<StdMatcher> StdRhoMatcher;
typedef RhoMatcher<LogMatcher> LogRhoMatcher;

typedef PhiMatcher<StdMatcher> StdPhiMatcher;
typedef PhiMatcher<LogMatcher> LogPhiMatcher;

%}

typedef Fst<StdArc> StdFst;
typedef ArcTpl<Weight> StdArc;
typedef ArcTpl<LogWeight> LogArc;
typedef MutableFst<StdArc> StdMutableFst;
typedef VectorFst<StdArc> StdVectorFst;
