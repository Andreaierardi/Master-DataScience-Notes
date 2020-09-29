#Homework - Sept 27, 2020 - Advanced Multivariate Statistics


#=============
#Part.a) 

f = function(x)
{
  (x>=0 & x <= 7) * 1/7
   
}


#(i)
integrate(f, lower = -Inf , upper = Inf)

#(ii)
curve(f, from= -5, to= 12)

#(iii)
#The random variable is X

#(iv)
library(distr6)
d = distr6::Uniform$new(lower = 0 , upper = 7)
d$mgf(t = 1)



#=============
#Part.c) 


x1 = c(12,11,8,14,10)
x2 = c(10,8,5,11,7)
x3= c(8,11,11,13,6)

m = matrix(c(x1,x2,x3), ncol = 3)

vector_means = c(mean(x1), mean(x2), mean(x3))
vector_means
cov(m)
