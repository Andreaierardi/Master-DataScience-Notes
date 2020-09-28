#Homework - Sept 27, 2020 - Advanced Multivariate Statistics


#=============
#Part.a) 

library(distr6)
d = distr6::Uniform$new(lower = 0 , upper = 7)
#(i)
integrate(d$pdf, lower = -Inf , upper = Inf)

#(ii)
curve(d)
plot(d)

#(iii)
#The random variable is X

#(iv)
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
