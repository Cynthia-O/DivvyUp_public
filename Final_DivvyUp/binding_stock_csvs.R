install.packages('dplyr') #only if not yet installed
library(dplyr)
#this is slow, but it works 

files.list <- list.files(path = "/home/cynthiaorourke/Documents/Data/NYSENASDAQ/full_2018_stocks", pattern='*.csv')
df.list <- setNames(lapply(files.list, read_csv), files.list)
df <- bind_rows(df.list, .id = "id")
#still has .csv attached in id, but much better

df$id<-gsub('.csv','',df$id)
#rename 'id' Name?
rename(df, Name = id)
write.csv(df, file = '/home/cynthiaorourke/Documents/Data/Full2018Stocks.csv', row.names=FALSE)