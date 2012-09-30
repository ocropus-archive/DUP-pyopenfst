// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

%inline %{
#include <fst/matcher.h>

typedef TropicalWeight Weight;

/* Since some types are already defined in OpenFST, we just have to
 * make them known to SWIG below (outside the %inline).  This is
 * something to do with namespaces, which may be resolved in the
 * future. */
// typedef Fst<StdArc> StdFst;
typedef Fst<LogArc> LogFst;
typedef Fst<Log64Arc> Log64Fst;

// typedef ArcTpl<Weight> StdArc;
// typedef ArcTpl<LogWeight> LogArc;

// typedef MutableFst<StdArc> StdMutableFst;
typedef MutableFst<LogArc> LogMutableFst;
typedef MutableFst<Log64Arc> Log64MutableFst;

// typedef VectorFst<StdArc> StdVectorFst;
typedef VectorFst<LogArc> LogVectorFst;
typedef VectorFst<Log64Arc> Log64VectorFst;

typedef StateIterator<StdFst> StdStateIterator;
typedef StateIterator<LogFst> LogStateIterator;
typedef StateIterator<Log64Fst> Log64StateIterator;

typedef ArcIterator<StdFst> StdArcIterator;
typedef ArcIterator<LogFst> LogArcIterator;
typedef ArcIterator<Log64Fst> Log64ArcIterator;

typedef MutableArcIterator<StdMutableFst> StdMutableArcIterator;
typedef MutableArcIterator<LogMutableFst> LogMutableArcIterator;
typedef MutableArcIterator<Log64MutableFst> Log64MutableArcIterator;

typedef ComposeFst<StdArc> StdComposeFst;
typedef ComposeFst<LogArc> LogComposeFst;
typedef ComposeFst<Log64Arc> Log64ComposeFst;

typedef StateIterator<StdFst> StdStateIterator;
typedef StateIterator<LogFst> LogStateIterator;
typedef StateIterator<Log64Fst> Log64StateIterator;

typedef ArcIterator<StdFst> StdArcIterator;
typedef ArcIterator<LogFst> LogArcIterator;
typedef ArcIterator<Log64Fst> Log64ArcIterator;

typedef MutableArcIterator<StdMutableFst> StdMutableArcIterator;
typedef MutableArcIterator<LogMutableFst> LogMutableArcIterator;
typedef MutableArcIterator<Log64MutableFst> Log64MutableArcIterator;

typedef Matcher<StdFst> StdMatcher;
typedef Matcher<LogFst> LogMatcher;
typedef Matcher<Log64Fst> Log64Matcher;

typedef SigmaMatcher<StdMatcher> StdSigmaMatcher;
typedef SigmaMatcher<LogMatcher> LogSigmaMatcher;
typedef SigmaMatcher<Log64Matcher> Log64SigmaMatcher;

typedef RhoMatcher<StdMatcher> StdRhoMatcher;
typedef RhoMatcher<LogMatcher> LogRhoMatcher;
typedef RhoMatcher<Log64Matcher> Log64RhoMatcher;

typedef PhiMatcher<StdMatcher> StdPhiMatcher;
typedef PhiMatcher<LogMatcher> LogPhiMatcher;
typedef PhiMatcher<Log64Matcher> Log64PhiMatcher;

typedef ArcTpl<Log64Weight> Log64Arc;
%}

typedef Fst<StdArc> StdFst;
typedef ArcTpl<Weight> StdArc;
typedef ArcTpl<LogWeight> LogArc;
typedef MutableFst<StdArc> StdMutableFst;
typedef VectorFst<StdArc> StdVectorFst;
