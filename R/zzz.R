.onAttach<- function(libname, pkgname)
{
    packageStartupMessage(paste("Now loading:",
    				"RcppGO: global optimization algorithm using the laws of gravity and motion",
    				"Author: Peter Kehler",
    				"Based on the CSS algorithm described in:",
			   	  "  A novel heuristic optimization method: charged system search", 
			     	"  Acta Mechanica 213, p. 267-289 (2010)",
		        "  by A. Kaveh and S. Talatahari",
				sep="\n")
			 	)
}
