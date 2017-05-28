filename = 'credit_card_data-headers.txt'
data = read.csv(filename, header=T, sep='\t')
summary(data)

#q2.1
require(kernlab)
?ksvm

fit.c1 = ksvm(R1~., data = data, scaled = T, C = 1)
fit.c1.1 = ksvm(R1~., data = data, scaled = T, C = 1.1)
fit.c.9 = ksvm(R1~., data = data, scaled = T, C = .9)

C = 100
N = 5
inc = .2
results = data.frame(C=rep(0,N), err=rep(0,N))
for (i in 1:N) {
  C = C * (1 + inc)^i
  fit = ksvm(R1~., data = data, scaled = T, kernal='vanilladot', type='C-svc', C=C)
  fit.err = error(fit)
  results[i,] = list(C, fit.err)
}

a	<- colSums(data[fit@SVindex,1:10] * fit@coef[[1]])
a
a0	<- sum(a*data[1,1:10]) - fit@b
a0


#-----------------------------
#question 2.2

require(kknn)
?kknn

m <- dim(data)[1]
train <- sample(1:m, size = round(m*.9), replace = FALSE, 
              prob = rep(1/m, m)) 
data.train <- data[train,]
data.test <- data[-train,]

fit.def <- kknn(R1~., data.train, data.test, scale=T, k=5)
summary(fit.def)

table(data.test$R1, fitted(fit.def) >= .5)


ks = c(1,3,7,9,5)
results = data.frame(k=ks, err=c(0,0,0,0,0))

for (k in c(1,3,5,7,9)) {
  fit <- kknn(R1~., data.train, data.test, scale=T, k=k)
  
  fit.conf = table(data.test$R1, fitted(fit) >= .5)
  fit.err = (fit.conf[1,2] + fit.conf[2,1])/sum(fit.conf)
  results[results$k==k,]$err = fit.err
}
results
