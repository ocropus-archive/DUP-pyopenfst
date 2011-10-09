#include <fst/fstlib.h>
#include <vector>
#include <string>
#include <cstdlib>
using namespace fst;
using namespace std;

typedef int StateId;
typedef TropicalWeight Weight;
typedef pair<int, float> mypair;


namespace{
    template <class M>
        class RSP3: public RhoMatcher< SigmaMatcher< PhiMatcher< M > > >
    {
    public:
        typedef typename M::FST FST;
        typedef typename M::Arc Arc;
        typedef typename Arc::StateId StateId;
        typedef typename Arc::Label Label;
        typedef typename Arc::Weight Weight;

        RSP3(const RSP3<M> &matcher, bool safe = false)
            : RhoMatcher< SigmaMatcher< PhiMatcher< M > > >(matcher, safe)
            {}

        virtual RSP3<M> *Copy(bool safe = false) const {
            return new RSP3<M>(*this, safe);
        }

        virtual ~RSP3() {
            delete matcher_;
        }

        RSP3(const FST &fst,
             MatchType match_type)
            :           RhoMatcher< SigmaMatcher< PhiMatcher< M > > >
                        (fst, match_type, -3, MATCHER_REWRITE_ALWAYS,
                         new SigmaMatcher< PhiMatcher< M> >
                         (fst, match_type, -2, MATCHER_REWRITE_ALWAYS,
                          new PhiMatcher< M >
                          (fst, match_type, -1, MATCHER_REWRITE_ALWAYS)))
            {}


        M *matcher_;

    };

    void successors(StdComposeFst f, StateId s,multimap<int, float> &myvec){


        multimap<int, float> m;
        vector<double> temp;
        for(ArcIterator< StdComposeFst > iter(f,s); !iter.Done(); iter.Next()) {

            StdArc arc = iter.Value();
            temp.push_back(arc.weight.Value());
            myvec.insert ( pair<int,float>(arc.nextstate,arc.weight.Value()) );

        }


    }

    bool ss(const mypair &lhs, const mypair &rhs) {
        return lhs.first < rhs.first;
    }
    bool ss1(const mypair &lhs, const mypair &rhs) {
        return lhs.second < rhs.second;

    }


    void pickbest(list<mypair> &myvec)
    {

        list<mypair>::iterator it;

        myvec.sort(ss);

        for (it=myvec.begin(); it!=myvec.end(); ++it){

            if( (*it).first == (*(++it)).first){
                --it;
                if( (*it).second > (*(++it)).second ){
                    --it;
                    myvec.remove((*it));

                }else{

                    myvec.remove((*it));

                }

            }
            --it;
        }


        myvec.sort(ss1);

    }
}

void op_beamsearch(vector<int> &vertices1,
                   vector<int> &vertices2,
                   vector<int> &inputs,
                   vector<int> &outputs,
                   vector<float> &costs,
                   StdVectorFst *fst1,
                   StdVectorFst *fst2,
                   int B) {

    typedef RhoMatcher< SortedMatcher<StdFst> > RM;
    typedef SigmaMatcher< SortedMatcher<StdFst> > SM;
    typedef PhiMatcher< SortedMatcher<StdFst> > PM;
    typedef RSP3< SortedMatcher<StdFst> > RSP5;

    ComposeFstOptions <StdArc, RSP5> opts;


    opts.matcher1 = new RSP5(*fst1, MATCH_OUTPUT);
    opts.matcher2 = new RSP5(*fst2, MATCH_INPUT);


    StdComposeFst result(*fst1, *fst2, opts);


    StdVectorFst r = (StdVectorFst)result;
    r.Write("result.fst");

    int g = 0;
    vector<int> hash_table;
    hash_table.push_back(result.Start());

    vector<int> BEAM;
    BEAM.push_back(result.Start());


    multimap<int, int> track;
    multimap<int, float> another_set;


    while(BEAM.size()){

        list<mypair> SET;                                   // the empty set

        for(int i=0;i<BEAM.size();i++){

            StateId state = BEAM[i];
            multimap<int, float> temp;

            successors(result, state, temp);

            for(multimap<int, float>::iterator it=temp.begin(); it!=temp.end(); ++it){

                track.insert( pair<int,int>( (*it).first, BEAM[i] ));
                SET.push_back(*it);
                another_set.insert(pair<int,float>( (*it).first, it->second ) );

            }

        }

        pickbest(SET);

        BEAM.erase(BEAM.begin(),BEAM.begin()+BEAM.size());
        g = g + 1;

        while((SET.size()) && (B > BEAM.size())){
            // set is not empty and the number of nodes in BEAM is less than B

            int state = SET.front().first;
            SET.pop_front();

            bool isPresent = (std::find(hash_table.begin(), hash_table.end(), state) != hash_table.end());

            if(!isPresent){
                hash_table.push_back(state);
                BEAM.push_back(state);
            }

        }

    }

    vector<int> path;
    vector<float> cost;
    int i=0;
    multimap<int, int>::iterator pos;

    pos=track.end();
    --pos;

    path.push_back(pos->first);
    path.push_back(pos->second);

    for(multimap<int, int>::iterator it=pos; it->second!=0;){

        it=track.find(it->second);

        path.push_back(it->second);

        i++;

    }

    int z=0;
    multimap<int, float>::iterator c;
    for(int i=path.size()-1;i>=0;i--){
        if(z!=0){

            c = another_set.find(z);
            cost.push_back(c->second);

        }
        z++;
    }

    float final_cost=0;


    for(int i=0;i<cost.size();i++){
        final_cost=final_cost+cost[i];
    }


    for(int i=path.size()-1;i>0;i--){

        int z1 =path[i];
        int z2 =path[i-1];


        for(ArcIterator< StdVectorFst > iter(r,z1); !iter.Done(); iter.Next()) {

            StdArc arc = iter.Value();
            int x =iter.Value().nextstate;

            if(x==z2){
                cout<<char(arc.olabel);
            }

        }

    }
}

