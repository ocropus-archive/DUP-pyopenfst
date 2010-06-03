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
        self.assertEquals(fst.Properties(openfst.kFstProperties, True)
                          & openfst.kNotAcceptor,
                          openfst.kNotAcceptor)

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

class Composition(unittest.TestCase):
    def testCompose(self):
        a = openfst.StdVectorFst()
        a.AddState()
        a.AddState()
        a.AddArc(0, 1, 2, 0, 1)
        a.AddArc(0, 2, 3, 0, 1)
        a.AddArc(0, 3, 3, 1, 1)
        a.SetStart(0)
        a.SetFinal(1, 0)
        b = openfst.StdVectorFst()
        b.AddState()
        b.AddState()
        b.AddArc(0, 1, 2, 0, 1)
        b.AddArc(0, 2, 3, 0, 1)
        b.AddArc(0, 3, 3, 1, 1)
        b.SetStart(0)
        b.SetFinal(1, 0)
        c = openfst.StdComposeFst(a, b)
        for s in c:
            for arc in c.iterarcs(s):
                self.assertEquals(arc.nextstate, 1)
                if arc.ilabel == 1:
                    self.assertEquals(arc.olabel, 3)
                if arc.ilabel == 2:
                    self.assertEquals(arc.olabel, 3)
                    self.assertEquals(arc.weight.Value(), 1)
                if arc.ilabel == 3:
                    self.assertEquals(arc.olabel, 3)
                    self.assertEquals(arc.weight.Value(), 2)

    def testComposeSigma(self):
        a = openfst.StdVectorFst()
        a.AddState()
        a.AddState()
        a.AddArc(0, 2, 2, 0, 1)
        a.AddArc(0, 3, 3, 0, 1)
        a.SetStart(0)
        a.SetFinal(1, 0)
        # Build an FST that matches everything adding weight 1
        b = openfst.StdVectorFst()
        b.AddState()
        b.AddArc(0, 1, 1, 1, 0)
        b.SetStart(0)
        b.SetFinal(0, 0)
        opts = openfst.StdSigmaComposeOptions()
        opts.matcher2 = openfst.StdSigmaMatcher(b, openfst.MATCH_INPUT, 1)
        # This is necessary for reasons I do not understand
        opts.matcher1 = openfst.StdSigmaMatcher(a, openfst.MATCH_NONE)
        c = openfst.StdComposeFst(a, b, opts)
        for s in c:
            for arc in c.iterarcs(s):
                self.assertEquals(arc.nextstate, 1)
                self.assertEquals(arc.weight.Value(), 1)
                self.assertEquals(arc.ilabel, arc.olabel)

    def testComposeRho(self):
        a = openfst.StdVectorFst()
        a.AddState()
        a.AddState()
        a.AddArc(0, 2, 2, 0, 1)
        a.AddArc(0, 3, 3, 0, 1)
        a.AddArc(0, 4, 4, 0, 1)
        a.SetStart(0)
        a.SetFinal(1, 0)
        # Build an FST that matches 2 with no weight and everything
        # else adding weight 1
        b = openfst.StdVectorFst()
        b.AddState()
        b.AddArc(0, 1, 1, 1, 0)
        b.AddArc(0, 2, 2, 0, 0)
        b.SetStart(0)
        b.SetFinal(0, 0)
        opts = openfst.StdRhoComposeOptions()
        opts.matcher2 = openfst.StdRhoMatcher(b, openfst.MATCH_INPUT, 1)
        # This is necessary for reasons I do not understand
        opts.matcher1 = openfst.StdRhoMatcher(a, openfst.MATCH_NONE)
        c = openfst.StdComposeFst(a, b, opts)
        for s in c:
            for arc in c.iterarcs(s):
                self.assertEquals(arc.nextstate, 1)
                if arc.ilabel == 2:
                    self.assertEquals(arc.weight.Value(), 0)
                else:
                    self.assertEquals(arc.weight.Value(), 1)

    def testComposePhi(self):
        a = openfst.StdVectorFst()
        a.AddState()
        a.AddState()
        a.AddArc(0, 2, 2, 0, 1)
        a.AddArc(0, 3, 3, 0, 1)
        a.AddArc(0, 4, 4, 0, 1)
        a.SetStart(0)
        a.SetFinal(0, 0)
        b = openfst.StdVectorFst()
        b.AddState()
        b.AddState()
        b.AddArc(0, 1, 1, 1, 1)
        b.AddArc(0, 2, 2, 0, 0)
        b.AddArc(1, 3, 3, 0, 1)
        b.AddArc(1, 4, 4, 0, 1)
        b.SetStart(0)
        b.SetFinal(0, 0)
        b.SetFinal(1, 0)
        opts = openfst.StdPhiComposeOptions()
        opts.matcher2 = openfst.StdPhiMatcher(b, openfst.MATCH_INPUT, 1)
        # This is necessary for reasons I do not understand
        opts.matcher1 = openfst.StdPhiMatcher(a, openfst.MATCH_NONE)
        c = openfst.StdComposeFst(a, b, opts)
        for s in c:
            for arc in c.iterarcs(s):
                if arc.ilabel == 2:
                    self.assertEquals(arc.weight.Value(), 0)
                    self.assertEquals(arc.nextstate, 1)
                elif arc.ilabel == 3 or arc.ilabel == 4:
                    self.assertEquals(arc.weight.Value(), 1)
                    self.assertEquals(arc.nextstate, 2)


if __name__ == "__main__":
    unittest.main()
