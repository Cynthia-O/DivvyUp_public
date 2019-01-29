library(dplyr)
library(tidyr)
full_SP <- read.csv("~/Documents/Data/full_SP.csv")
med_monthly_only<-full_SP #start off with a copy

med_monthly_only<-med_monthly_only%>%select(-c(X,date,open,high,low,close,volume,daily_ROC,weekly_avg_ROC))%>%
  select(-c(monthly_avg_ROC,yearly_avg_ROC,yearly_average_ROC,yearly_median_ROC))

#drop everything except first business day of each month in 2017
med_monthly_only<-med_monthly_only%>%
  filter(date_as_date %in% c('2017-01-03', '2017-02-01','2017-03-01','2017-04-03','2017-05-01','2017-06-01','2017-07-03','2017-08-01','2017-09-01','2017-10-02','2017-11-01','2017-12-01'))
  
wide_med_monthly_SP<-med_monthly_only%>%spread(date_as_date,monthly_median_ROC) 

NaNcount<-sum(is.na(wide_med_monthly_SP))
print(NaNcount) #there's only 26 of them
#get rid of names because they're strings and kmeans will hate that
wide_med_monthly_SP<-wide_med_monthly_SP%>%select(-c(Name))
#finally, replace NaNs with zeros (NOT optimal, but there aren't too many so hopefully it won't screw this up
wide_med_monthly_SP[is.na(wide_med_monthly_SP)] <- 0

#finally, write to .csv
write.csv(wide_med_monthly_SP, file = '/home/cynthiaorourke/Documents/Data/wide_med_monthly_SP.csv', row.names=FALSE)

##to do daily:
full_SP <- read.csv("~/Documents/Data/full_SP.csv")
daily_ROC<-full_SP #start off with a copy

daily_ROC<-daily_ROC%>%select(-c(X,date,open,high,low,close,volume,monthly_median_ROC,weekly_avg_ROC))%>%
  select(-c(monthly_avg_ROC,yearly_avg_ROC,yearly_average_ROC,yearly_median_ROC))

daily_ROC$date_as_date<-as.Date(daily_ROC$date_as_date)

#narrow down to 2017
daily_2017_ROC<-daily_ROC%>%
  filter(date_as_date >= ('2016-12-31') & date_as_date <= ('2018-01-01'))

wide_daily_2017_ROC<-daily_2017_ROC%>%spread(date_as_date,daily_ROC) #holy crap, that is crazy

NaNcount<-sum(is.na(wide_daily_2017_ROC))
print(NaNcount) #there's 725 of them
#keep the names - you can drop them later in python, but they're necessary to validate clusters
#wide_daily_2017_ROC<-wide_daily_2017_ROC%>%select(-c(Name))
#finally, replace NaNs with zeros (NOT optimal, but there aren't too many so hopefully it won't screw this up
wide_daily_2017_ROC[is.na(wide_daily_2017_ROC)] <- 0

#finally, write to .csv
write.csv(wide_daily_2017_ROC, file = '/home/cynthiaorourke/Documents/Data/wide_daily_2017_SP.csv', row.names=FALSE)