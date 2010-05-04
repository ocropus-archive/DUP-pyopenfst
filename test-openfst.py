import unittest
import openfst

class narray(unittest.TestCase):
    def testAddString(self):
        fst = openfst.StdVectorFst()
        fst.AddString("hello")
        fst.AddString("world")
    def testRead(self):
        fst = openfst.StdVectorFst()
        fst.AddString("hello")
        fst.AddString("world")
        fst.Write("_test.fst")
        fst2 = openfst.Read("_test.fst")
        openfst.Verify(fst2)
        # might check for equivalence here
    def testAddGetString(self):
        fst = openfst.StdVectorFst()
        fst.AddString("hello")
        assert "hello"==openfst.GetString(fst)
    def testAddGetWString(self):
        fst = openfst.StdVectorFst()
        fst.AddWString(u"hello")
        fst.Write("temp.fst")
        assert u"hello"==openfst.WGetString(fst)
    def testFinal(self):
        fst = openfst.StdVectorFst()
        s = [fst.AddState() for i in range(4)]
        fst.SetStart(s[0])
        fst.SetFinal(s[3],73.0)
        for i in range(3):
            fst.AddArc(s[i],10+i,20+i,90+i,s[i+1])
        assert fst.IsFinal(s[3])
        assert abs(fst.FinalWeight(s[3])-73.0)<1e-10
    def testTranslation(self):
        input = openfst.StdVectorFst()
        input.AddString("aaba")
        fst = openfst.StdVectorFst()
        fst.AddTranslation("a","A")
        fst.AddTranslation("b","B")
        openfst.ClosureStar(fst)
        result = openfst.StdVectorFst()
        openfst.Compose(input,fst,result)
        shortest = openfst.StdVectorFst()
        openfst.ProjectOutput(result)
        openfst.RmEpsilon(result)
        openfst.ShortestPath(result,shortest,1)
        shortest.Write("temp.fst")
        assert "AABA"==openfst.GetString(shortest)

if __name__ == "__main__":
    unittest.main()
