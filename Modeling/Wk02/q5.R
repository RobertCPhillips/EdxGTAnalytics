temps = read.csv('temps.txt', header = T, sep = '\t')
years = as.numeric(substring(colnames(temps[-1]), 2))

my.cusum1 = function(data, C, T) {
  st = 0
  sts = c()
  mu.data = mean(data)
  st.day = 0
  
  for(i in 1:length(data)){
    st = max(0, st + (mu.data - data[i] - C))
    sts = c(sts,st)
    if (st.day == 0 && st >= T){
      st.day = i
    }
  }
  list(sts, st.day)
}

t.1996 = temps$X1996
days = as.Date(paste("1996", temps$DAY, sep="-"), "%Y-%d-%b")

#choose a threshold of 2 times the std. dev.
T = 2*sd(t.1996)
C = 0

zz = my.cusum1(t.1996, C, T)
plot(days, -zz[[1]], xlab="days", ylab="St")
abline(-T, 0)
day = days[zz[[2]]]
abline(v=day)

C = 4

zz = my.cusum1(t.1996, C, T)
plot(1:length(t.1996), -zz[[1]], xlab="days", ylab="St")
abline(-T, 0)
abline(v=zz[[2]])

my.cusum2 = function(data, C, T) {
  st = 0
  mu.data = mean(data)
  st.day = 0
  
  for(i in 1:length(data)){
    st = max(0, st + (mu.data - data[i] - C))
    if (st.day == 0 && st >= T){
      st.day = i
    }
  }
  st.day
}

detections = data.frame(row.names=colnames(temps)[-1])
cnames = c()

for (C in seq(0, 4, by=.5)){
  for (k in seq(1.5, 2.5, by=.1)){
    days = apply(temps[-1], 2, function(x){T = k*sd(x); my.cusum2(x, C, T)})
    cnames = c(cnames, paste("C.",C,".k.",k, sep=''))
    detections = cbind(detections, days)
  }
}
colnames(detections) = cnames

#which column has minimum std. dev.
detections.min = unname(which.min(apply(detections, 2, sd)))

#what are the parameter value and selected days
params = cnames[detections.min]
days = detections[,detections.min]


#warmer?
my.cusum3 = function(data, C, T) {
  st = 0
  sts = c()
  mu.data = mean(data)
  year = 0
  
  for(i in 1:length(data)){
    st = max(0, st + (data[i] - mu.data - C))
    sts = c(sts,st)
    if (year == 0 && st >= T){
      year = years[i]
    }
  }
  list(sts, year)
}

temps.avg = unname(colMeans(temps[-1]))

T = 2*sd(temps.avg)
C = 0

zz = my.cusum3(temps.avg, C, T)
plot(years, zz[[1]], xlab="years", ylab="St")
abline(T, 0)
abline(v=zz[[2]])

C = 1

zz = my.cusum3(temps.avg, C, T)
plot(years, zz[[1]], xlab="years", ylab="St")
abline(T, 0)
abline(v=zz[[2]])


