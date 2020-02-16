#command to change the working directory:
#copy below the path of the folder where you placed your files
setwd("~/Dropbox/didattica/magistraleDataScience/networks data and examples")


source("invtransform.R")
###n. of simulated steps###
nsteps<-20
###initial distribution###
p0<-c(1,0)

x<-matrix(0,nsteps,1)

###The Gothenburg weather###
states<-c("r","s")


#starting state
x[1]<-invtransform(p0,states)
#evolution
P<-matrix(c(0.75,0.25,0.25,0.75),nrow = 2,ncol=2)
for (j in c(2:nsteps)){
  if (x[j-1]=="r") 
    nrow<-1 
  else 
    nrow<-2
  x[j]<-invtransform(P[nrow,],states)
}
x
table(x)/nsteps
