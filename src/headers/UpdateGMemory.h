/*
* @title: UpdateGMemory 
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Updates the particle positions in GMemory 
*/
void UpdateGMemory(cube & GravityParticles, double & k, const int & n, const int & g, mat & GMemory, const int & Args, const bool & Maximize) 
{
  uvec sortet;

  if (k == 0)
    {
      GMemory = GravityParticles.slice(0);
    }
  else 
    {
      /* merge GMemory & GravityParticles.Slice(k) into Aux for sorting*/
      mat Merger(n+g,3*Args+1);
      Merger.submat(0,0, n-1,3*Args) = GMemory;           
      Merger.submat(n,0, (n+g-1),3*Args) = GravityParticles.slice(k);   
      
      if (Maximize == false)
	{
	  sortet = sort_index(Merger.col(Args),0); // "0" := smallest value first
	}
      else 
	{
	   sortet = sort_index(Merger.col(Args),1); // "1" := largest value first
	}
      
      for (int j = 0; j <= (3*Args); j++)
	{
	  vec ColTmp = Merger.col(j);
	  Merger.col(j) = ColTmp.elem(sortet);
	}

      GMemory = Merger.rows(0, n-1);  // update GMemory
    }
}
