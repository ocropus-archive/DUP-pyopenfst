// -*- mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

typedef unsigned long long uint64;

const uint64 kExpanded;
const uint64 kMutable;
const uint64 kAcceptor;
const uint64 kNotAcceptor;
const uint64 kIDeterministic;
const uint64 kNonIDeterministic;
const uint64 kODeterministic;
const uint64 kNonODeterministic;
const uint64 kEpsilons;
const uint64 kNoEpsilons;
const uint64 kIEpsilons;
const uint64 kNoIEpsilons;
const uint64 kOEpsilons;
const uint64 kNoOEpsilons;
const uint64 kILabelSorted;
const uint64 kNotILabelSorted;
const uint64 kOLabelSorted;
const uint64 kNotOLabelSorted;
const uint64 kWeighted;
const uint64 kUnweighted;
const uint64 kCyclic;
const uint64 kAcyclic;
const uint64 kInitialCyclic;
const uint64 kInitialAcyclic;
const uint64 kTopSorted;
const uint64 kNotTopSorted;
const uint64 kAccessible;
const uint64 kNotAccessible;
const uint64 kCoAccessible;
const uint64 kNotCoAccessible;
const uint64 kString;
const uint64 kNotString;
const uint64 kNullProperties;
const uint64 kCopyProperties;
const uint64 kSetStartProperties;
const uint64 kSetFinalProperties;
const uint64 kAddStateProperties;
const uint64 kAddArcProperties;
const uint64 kSetArcProperties;
const uint64 kDeleteStatesProperties;
const uint64 kDeleteArcsProperties;
const uint64 kStateSortProperties;
const uint64 kArcSortProperties;
const uint64 kILabelInvariantProperties;
const uint64 kOLabelInvariantProperties;
const uint64 kWeightInvariantProperties;
const uint64 kAddSuperFinalProperties;
const uint64 kRmSuperFinalProperties;

const uint64 kBinaryProperties;
const uint64 kTrinaryProperties;

const uint64 kPosTrinaryProperties;
const uint64 kNegTrinaryProperties;

const uint64 kFstProperties;

uint64 ClosureProperties(uint64 inprops, bool star, bool delayed = false);
uint64 ComplementProperties(uint64 inprops);
uint64 ComposeProperties(uint64 inprops1, uint64 inprops2);
uint64 ConcatProperties(uint64 inprops1, uint64 inprops2,
                        bool delayed = false);
uint64 DeterminizeProperties(uint64 inprops, bool has_subsequential_label);
uint64 DifferenceProperties(uint64 inprops1, uint64 inprops2);
uint64 FactorWeightProperties(uint64 inprops);
uint64 IntersectProperties(uint64 inprops1, uint64 inprops2);
uint64 InvertProperties(uint64 inprops);
uint64 ProjectProperties(uint64 inprops, bool project_input);
uint64 RelabelProperties(uint64 inprops);
uint64 ReplaceProperties(const vector<uint64>& inprops,
                         ssize_t root,
                         bool epsilon_on_replace,
                         bool no_empty_fst);
uint64 ReverseProperties(uint64 inprops);
uint64 ReweightProperties(uint64 inprops);
uint64 RmEpsilonProperties(uint64 inprops, bool delayed = false);
uint64 SynchronizeProperties(uint64 inprops);
uint64 UnionProperties(uint64 inprops1, uint64 inprops2, bool delayed = false);

%inline %{
const char *PropertyBitName(int bit)
{
	if (bit > 63)
		return NULL;
	else
		return PropertyNames[bit];
}
%}
