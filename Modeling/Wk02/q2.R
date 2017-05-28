
require(datasets)
features = iris[1:4]
target = iris[5]

colnames(features)

kmax = 5
models = list()
ss = c()

for (k in 1:kmax) {
  #store the model
  models[[k]] = kmeans(features, centers=k)
  #store the total within sum of squares
  ss = c(ss, models[[k]]$tot.withinss)
  target[paste("k.",k,sep="")] = models[[k]]$cluster
}

plot(x=1:kmax, y=ss, type="l", xlab="k (the number of clusters)", ylab="total within sum of squares")

#p = predict.kmeans(models[[2]], features)

tables = list()
for (k in 2:4) {
  tables[k] = table(target$Species, t(target[paste("k.",k,sep="")]))
}
