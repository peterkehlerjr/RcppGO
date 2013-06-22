demo.RcppGO <- function()
  { 
    wait <- function(){
      t <- readline("\nPlease 'q' to quit the demo or any other key to continue...\n")
      if (t == "q") TRUE else FALSE
    }

    # min at -0.352386, X in [-10,10]^2
    AluffiPentiny <- function(X)
      {
        1/4*X[,1]^4 - 1/2*X[,1]^2 + 1/10*X[,1] + 1/2*X[,2]^2
      }

    demo01 <- function()
      {
        cat("\n--------------***--------------\n")
        cat("Running the optimization process on a Aluffi-Pentiny function:\n\n")
        print(AluffiPentiny)
        demo <- RcppGO(ObjectiveFunction=AluffiPentiny, Args=2, Lower = -10, Upper = 10, User=FALSE, Scale=0.1)
        print(demo$GMemory)
        cat("\n--------------***--------------\n")
      }

    str.stop <- "\nend of the demo\n"
    print(demo01)
    if (wait()) stop(str.stop) else print(demo01())

    cat(str.stop)
  }


demo.RcppGO()
