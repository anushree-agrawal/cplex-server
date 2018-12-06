using CP;
{string} Flows = ...;
{string} Jobs = ...;
// Generate this in Scala, but not dependent on actual data
int AllowedFlows[Flows][Flows] = ...;

//int AllowedFlows[Flows][Flows] = [[1, 1, 1, 1],
//                  [1, 1, 1, 1],
//                  [1, 1, 1, 1],
//                  [1, 1, 1, 1]];                  

// change to m -> read from data
int numConstraints = ...;                 
range Constraints = 1 .. numConstraints;

int A[Constraints][Flows] = ... ;
              
//int C[Constraints] = [5, 10, 7, 10, 9];             
int C[Constraints] = ...;


dvar int+ B[Flows]; //flattened
dvar boolean I[Flows][Jobs];
dvar boolean Iflat[Flows];
dvar int BI[Flows];
dvar int BIjobs[Jobs];

minimize
  // 7c
  // No incentive to minimize any other values other than max tj
  max(j in Jobs)
    1 / BIjobs[j];
    
subject to {

  // 7d
  forall(c in Constraints)
    ct:
    sum(f in Flows)
      A[c][f] * BI[f] <= C[c];
      
  forall(f in Flows)
      Iflat[f]==sum (j in Jobs) I[f][j];
      
  forall(f in Flows)
    (Iflat[f]==1) => (BI[f]==B[f]);
  forall(f in Flows)
    (Iflat[f]==0) => (BI[f]==0);
  
  // 7b
  forall(j in Jobs)
    sum (f in Flows) I[f][j] == 1;
    
  
  forall(j in Jobs)
    forall(f in Flows)
      (I[f][j]==1) => (BIjobs[j]==BI[f]);
      
  forall(f in Flows)
      forall(f2 in Flows)
        ctFlows:
        Iflat[f] * Iflat[f2] <= AllowedFlows[f][f2];
//      

//  forall(j in Jobs)
//      forall(f in Flows)
//      (BI[f] != 0) => (BIjobs[j]=>)
//      

//  count(all(f in Flows) I[f], false) == 0;
}
execute DISPLAY {
  writeln("BIJobs = ", BIjobs);
  writeln("I = ", I);
};