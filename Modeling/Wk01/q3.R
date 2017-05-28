filename = 'credit_card_data-headers.txt'
data = read.csv(filename, header=T, sep='\t')
summary(data)

folds = 5
folds.id = sample(1:folds, nrow(data), replace=T)

ks = c(1,3,5,7,9)
ks.n = length(ks)
results = data.frame(k=ks, f1=rep(0,ks.n), f2=rep(0,ks.n), f3=rep(0,ks.n),
                     f4=rep(0,ks.n), f5=rep(0,ks.n))

require(kknn)

for (i in 1:folds) {
  train = data[i != folds.id, ]
  test = data[i == folds.id, ]

  for (k in ks){
    fit <- kknn(R1~., train, test, scale=T, k=k)
    
    fit.conf = table(test$R1, fitted(fit) >= .5)
    fit.err = (fit.conf[1,2] + fit.conf[2,1])/sum(fit.conf)
    results[results$k==k,i+1] = fit.err
  }
  results$mean.err = rowMeans(results[,-1])
  results
}

---------------------

set.seed(1)
set.id = sample(1:3, nrow(data), replace=T, prob=c(.6,.2,.2))

train = data[set.id == 1, ]
valid = data[set.id == 2, ]
test = data[set.id == 3, ]

ks = c(1,3,5,7,9)
results = data.frame(k=ks, err=c(0,0,0,0,0))

for (k in ks){
  fit <- kknn(R1~., train, valid, scale=T, k=k)
  
  fit.conf = table(valid$R1, fitted(fit) >= .5)
  fit.err = (fit.conf[1,2] + fit.conf[2,1])/sum(fit.conf)
  results[results$k==k, "err"] = fit.err
}
results