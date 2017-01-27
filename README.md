---
Title: "Yahoo Financial Data Extraction"
Author: "Fung YIP"
date: "14 Jan 2017"
Analytics:
  Webscraping: Sitemap Creation
---

## YahooFinanceData - Creating a custom yahoo finance data based on Symbols

This handy R script is created to extract Financial data from Yahoo Finance available on 
<http://ichart.finance.yahoo.com/table.csv?> for rapid machine learning.


### Data Collection

Yahoo Finance provides a URL-based API for financial stock data extraction, in which you can dynamically build a URL with parameters to specify the stock and the date ranges.

```r
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

stock <- read.csv(paste0("http://ichart.finance.yahoo.com/table.csv?s=",tickers,"&d=",toString(as.double(today_month)-1),"&e=",today_day,"&f=",today_year,"&g=d","&a=",toString(as.double(start_month)-1),"&b=",start_day,"&c=",start_year,"&ignore=.csv", collapse = ", "))
write.csv(stock, file=paste("./DataOut/", tickers,".csv", sep=""))
```
