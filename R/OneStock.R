# install.packages("tidyverse")
library(tidyverse)

#set start date for historical look
start_year = "1990"
start_month = "1"
start_day = "1"

#get present date
today = Sys.Date()
today_year = format(today, "%Y") # with month as a word
today_month = format(today, "%m") #months are one less for yahoo
today_day = format(today, "%d")

#Yahoo Finance Symbol
tickers = c("^HSI")

stock <- read_csv(paste0("http://ichart.finance.yahoo.com/table.csv?s=",tickers,"&d=",toString(as.double(today_month)-1),"&e=",today_day,"&f=",today_year,"&g=d","&a=",toString(as.double(start_month)-1),"&b=",start_day,"&c=",start_year,"&ignore=.csv", collapse = ", "))
write_csv(stock, paste("./DataOut/", tickers,".csv", sep=""))


# #sort Date
# stock_date <- stock[rev(order(as.Date(stock$Date, format="%d/%m/%Y"))),]
# 
# #install.packages("dse")
# library(dse)
# freq=365.25
# stock_price<-ts(stock_date$Adj.Close,start=c(1990,1,1),frequency=freq)
# 
# 
# #Pretty Chart
# library(ggplot2)
# library(forecast)
# stock_price2<-autoplot(stock_price, s.window="periodic", robust=TRUE)
# #autoplot(stl(lflat_net_price, s.window="periodic", robust=TRUE))
# ggsave(filename="./Figure/stock_price2.png",plot=stock_price2)
# 
# 


