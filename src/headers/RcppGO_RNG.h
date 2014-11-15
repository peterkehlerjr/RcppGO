/*
* @title:  MyRunif
* @author: Peter Kehler
* @date:   15.08.2012
* @description: runif for vectorized 'Lower' / 'Upper' values.
*/
void MyRunif(cube & GravityParticles, const NumericVector & Lower, const NumericVector  & Upper, const int & Args, const int & n)
{
  for (int j = 0; j < Args; j++)
    {
      for(int i = 0; i < n; i++)
	{
	  vec RunifTmp = Lower(j) + (Upper(j) - Lower(j)) * randu<vec>(1);
	  GravityParticles(i,j,0) = RunifTmp(0);
	}
    }
}
