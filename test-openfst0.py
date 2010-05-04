import unittest
import openfst

class narray(unittest.TestCase):
    def testRead(self):
        fst = openfst.Read("dict-1000words.fst")
        openfst.Verify(fst)
    def testAddString(self):
        fst = openfst.StdVectorFst()
        fst.AddString("hello")
        fst.AddString("world")
    def testAddGetString(self):
        fst = openfst.StdVectorFst()
        fst.AddString("hello")
        assert "hello"==openfst.GetString(fst)
    def testFinal(self):
        fst = openfst.StdVectorFst()
        s = [fst.AddState() for i in range(4)]
        fst.SetStart(s[0])
        fst.SetFinal(s[3],73.0)
        for i in range(3):
            fst.AddArc(s[i],10+i,20+i,90+i,s[i+1])
        assert fst.IsFinal(s[3])
        assert abs(fst.FinalWeight(s[3])-73.0)<1e-10

if __name__ == "__main__":
    unittest.main()
