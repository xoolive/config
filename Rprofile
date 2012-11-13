# Automatic selection of Lyon 1 repository
options(repos=c("http://cran.univ-lyon1.fr"))
# Delete the continuation character and be able to copy-paste commands
options(continue="    ")
# Leave me one core free when you do your shit
options(mc.cores=3)

# Dynamic prompt with current time
updatePrompt <- function(...) {
    dirs <- strsplit(getwd(),"/")[[1]]
    options(menu.graphics=FALSE, 
            prompt=paste("\001[01;32m\002", format(Sys.time(),"%H:%M"),
                         " R> ", sep=""))
    return(invisible(TRUE))
}

updatePrompt()
invisible(addTaskCallback(updatePrompt))

