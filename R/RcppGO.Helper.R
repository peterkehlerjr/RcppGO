RcppGO.Plot.Wrapper <- function(fn)
{
  
  fnString <- deparse(fn)
  fnString <- gsub(" ","",fnString,fixed=TRUE)
  fnString <- paste(fnString,sep="",collapse="")
  
  fnString <- gsub("(X)","(x,y)",fnString,fixed=TRUE)
  fnString <- gsub("X[,1]","x",fnString,fixed=TRUE)
  fnString <- gsub("X[,2]","y",fnString,fixed=TRUE)
  
  return(eval(parse(text=fnString)))
}


NullRectifier <- function(Var,default)
{
   # cat("\tChecking null boundary for \"", substitute(Var),"\"... ",sep="")
   if ( is.numeric(Var) & Var <= 0 )
   {
     warning("\n Warning: '", substitute(Var),"' <= 0! '", substitute(Var),"' will be set to ", default,".\n", immediate. = TRUE)
     eval.parent(substitute(Var <- default))
   }
  # else
  # {
  #   cat("Proceeding.\n")
  # }
}


BinaryRectifier <- function(Input)
{
  # cat("\tChecking binary variable \"", substitute(Input),"\"... ",sep="")
  if(!is.logical(Input) )
    {
      warning("\n Warning: '", substitute(Input),"' has to be of type logical. '", substitute(Input),"' will be set to 0.\n", immediate. = TRUE)
      eval.parent(substitute(Input <- 0))
    }
  # else
  #  {
  #    cat("Proceeding.\n")
  #  }
}


InfWarning <- function(Var)
{
  if (any(Var == Inf | Var == -Inf))
    {
      warning("\n \t One or more values of '",substitute(Var),"' are assigned 'Inf' or '-Inf'. This may cause unexpected results.\n", immediate. = TRUE)
    }
  
  if(any(Var == Inf))
    {      
      cat("The following components of '", substitute(Var),"' are set to 'Inf':\n")
      print(which(Var== Inf))
    }
  if(any(Var == -Inf))
    {
      cat("The following components of '", substitute(Var),"' are set to '-Inf':\n")
      print(which(Var== -Inf))
    }
}


PackageRectifier <- function(Package, Fun)
{
  if(is.character(Package) & is.character(Fun))
    {
      if(Package %in% installed.packages()[,1])
        {
          require(Package,character.only=TRUE)
          #cat("\tPackage \"",Package,"\" found. Proceeding...\n",sep="")
        }
      else
        {
          warning("Package ", Package," is required. Do you want to install it now?\n")
          cat("Select: y for [yes] or n for [no].\n",sep="")
          answer <- scan(what="character",nmax=1,quiet=TRUE)
          if(answer == "y")
            {
              install.packages(quote(Package))
              require(lattice)
            }
          else
            {
              cat("\nPlease install", Package,"to use",Fun,".\n",sep="")
            }
        }
    }
  else
    {
      stop("Arguments have to be of type character.")
    }
}


panel.3d.contour <- function(x,
                             y,
                             z,
                             rot.mat,
                             distance,
                             nlevels=20,
                             zlim.scaled,
                             side=1,			# 1 = bottom, 2 = ceiling
                             ...
                             )
{
  add.line <- trellis.par.get("add.line")
  panel.3dwire(x,y,z,rot.mat,distance,zlim.scaled=zlim.scaled,...)
  
  clines <- contourLines(x,y,matrix(z,nrow=length(x),byrow=TRUE),nlevels=nlevels)
  
  for(ll in clines)
    {
      m <- ltransform3dto3d(rbind(ll$x,ll$y,zlim.scaled[side]),rot.mat, distance) 
      panel.lines(m[1,],m[2,],col=add.line$col,lty=add.line$lty,lwd=add.line$lwd)
    }
}

circles <- function(x, y, r, col = rep(0, length(x)),border = rep(1, length(x)), ...)
{
  
  circle <- function(x, y, r, ...)
    {
      ang <- seq(0, 2*pi, length = 100)
      xx <- x + r * cos(ang)
      yy <- y + r * sin(ang)
      polygon(xx, yy, ...)
    }
  
  for(i in 1:length(x))
    {
      circle(x[i], y[i], r[i], col = col[i], border = border[i], ...)
    }
}
