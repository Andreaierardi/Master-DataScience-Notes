library(stats)
invtransform<-function(p,s){
  #generate a random number in the states s, 
  #with discrete distribution p with the method of
  #the inverse transform
  
  #s=vector of states
  #p=probability of each state. Vector of the same length as s
  n<-length(p)
  cs<-cumsum(p)
  u<-runif(1,min = 0,max = 1)
  d<-cs-u 
  i<-min(which(d>0))
  s[i]
}