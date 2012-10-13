RcppGO <- function(ObjectiveFunction, 			
                         Args, 			
                         Lower, 			
                         Upper,  		
                         n=20, 		
                         g=20, 		
                         Iterations=201,	
                         User=FALSE,	
                         Scale=0.1,		
                         Maximize=FALSE			
                         )
  {
    # first case: length(Lower) & length(Upper) == 1
    if((length(Lower) & length(Upper)) == 1)
      {
        Lower <- rep(Lower, Args)
        Upper <- rep(Upper, Args)
      }

    # second case: 
    if( (length(Lower) | length(Upper)) > 1)
      {
        if(length(Lower) != length(Upper))
          {
            stop("length(Lower) != length(Upper).")
          }
      }
      
            
    # correct parameters with value <= 0
    NullRectifier(n,20)
    NullRectifier(g,20)
    if (g > n) stop("g must be element of [1,n]")
    NullRectifier(Iterations,201)
    NullRectifier(Scale,0.1)
    NullRectifier(Args,2)
    
    # check binary variables
    BinaryRectifier(User)
    BinaryRectifier(Maximize)

   # check for 'Inf' and '-Inf'
    InfWarning(c(Args, Lower, Upper, n, g, Iterations, Scale))

    # check boundaries
    if(Lower > Upper)  stop("'Lower' > 'Upper'")
    
    result <- .Call("RcppGO",ObjectiveFunction, Args, Lower, Upper, n, g, Iterations, User, Scale, Maximize, Package="RcppGO")
    
    Names <- c(paste("x",1:Args,sep=""),"fn_x",paste("v_x",1:Args,sep=""),paste("F_x",1:Args, sep=""))
    dimnames(result$GravityParticles) <- list(c(paste(1:n)),Names)
    dimnames(result$GMemory) <- list(c(paste(1:n)),Names[1:(Args+1)])
    
    return(result)
  }
