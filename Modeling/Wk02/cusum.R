temps = read.csv('temps.txt', header = T, sep = '\t')
t.1996 = temps$X1996
mu.1996 = mean(t.1996)
sd.1996 = sd(t.1996)
C = 0
T = mu.1996 - 2*sd.1996

my.cusum = function(data, C) {
  st = 0
  ss = c()
  data.mu = mean(data)
  data.sd = sd(data)
  
  T = -2*data.sd
  print(T)
  t = 1
  
  for(i in length(data)){
    st = min(0, st + (data[i] - data.mu - C))

    if (st <= T){
      t = i
      print(st)
      print(t)
      break
    }
    ss = c(ss,st)
  }
  t
}

#zz = my.cusum(t.1996, C)
#plot(1:length(t.1996), zz)
#abline(T, 0)

