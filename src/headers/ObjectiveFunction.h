/*
* @title:  ObjectiveFunction
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Evaluates the R function.
*/
void ObjectiveFunction(cube & GravityParticles, Function & RFun, const int & Args, const int & n, double & k)
{
  mat PosTmp = GravityParticles.subcube(0,0,k, n-1,Args-1,k);
  mat X(PosTmp.begin(), n , Args, false);
  NumericVector  FunValTmp = RFun(wrap(X));
  cube GPTmp(FunValTmp.begin(), n, 1, 1, false);
  GravityParticles.subcube(0,Args,k, n-1, Args,k) = GPTmp;
}
