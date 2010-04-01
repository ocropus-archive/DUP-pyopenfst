import unittest
import openfst

class Creation(unittest.TestCase):
    def testCreateStd(self):
        fst = openfst.StdVectorFst()
        self.assert_(fst)
        st = fst.AddState()
        self.assertEquals(st, 0)
        self.assertEquals(fst.NumStates(), 1)
        nst = fst.AddState()
        fst.AddArc(st, 42, 69, 55, nst);
        self.assertEquals(fst.NumArcs(st), 1)

    def testCreateLog(self):
        fst = openfst.LogVectorFst()
        self.assert_(fst)
        st = fst.AddState()
        self.assertEquals(st, 0)
        self.assertEquals(fst.NumStates(), 1)
        nst = fst.AddState()
        fst.AddArc(st, 42, 69, 55, nst);
        self.assertEquals(fst.NumArcs(st), 1)

class Iteration(unittest.TestCase):
    def testStateIterators(self):
        fst = openfst.StdVectorFst()
        for i in range(5):
            fst.AddState()
        seen = set()
        for state in fst:
            self.assert_(state >= 0)
            self.assert_(state < 5)
            seen.add(state)
        self.assertEquals(len(seen), 5)

    def testArcIterators(self):
        fst = openfst.StdVectorFst()
        st = fst.AddState()
        nst = fst.AddState()
        for i in range(5):
            fst.AddArc(st, i, i, i, nst);
        seen = set()
        for arc in fst.iterarcs(st):
            self.assertEquals(arc.nextstate, nst)
            self.assertEquals(arc.ilabel, arc.olabel)
            self.assert_(arc.weight.Value() >= 0)
            self.assert_(arc.weight.Value() < 5)
            seen.add(arc)
        self.assertEquals(len(seen), 5)

class ConvertSyms(unittest.TestCase):
    def testConvertSymbols(self):
        syms1 = openfst.SymbolTable("syms1")
        syms1.AddSymbol("&epsilon;");
        syms1.AddSymbol("foo", 1);
        syms1.AddSymbol("bar", 2);
        syms2 = openfst.SymbolTable("syms2")
        syms2.AddSymbol("&epsilon;");
        syms2.AddSymbol("bar", 1);
        syms2.AddSymbol("foo", 2);
        self.assertEquals(syms1.Find("foo"), 1)
        self.assertEquals(syms2.Find("foo"), 2)
        self.assertEquals(syms1.Find(1), "foo")
        self.assertEquals(syms2.Find(2), "foo")
        fst = openfst.StdVectorFst()
        st = fst.AddState()
        nst = fst.AddState()
        fst.AddArc(st, 1, 1, 0, nst)
        arc = fst.GetArc(st, 0)
        self.assertEquals(arc.ilabel, 1)
        self.assertEquals(arc.olabel, 1)
        fst.SetInputSymbols(syms1)
        fst.SetOutputSymbols(syms1)
        openfst.ConvertSymbols(fst, syms2, True, True)
        arc = fst.GetArc(st, 0)
        self.assertEquals(arc.ilabel, 2)
        self.assertEquals(arc.olabel, 2)
        openfst.ConvertSymbols(fst, syms1, True, False)
        arc = fst.GetArc(st, 0)
        self.assertEquals(arc.ilabel, 1)
        self.assertEquals(arc.olabel, 2)
        fst.AddArc(st, 42, 69, 0, nst)
        try:
            openfst.ConvertSymbols(fst, syms2, True, False)
        except:
            pass
        else:
            self.Fail("expected failure for unknown symbol")
        
if __name__ == "__main__":
    unittest.main()
