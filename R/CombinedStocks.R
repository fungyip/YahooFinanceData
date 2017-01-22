## credited by http://www.worldominance.com/2014/12/19/take-over-the-world-with-the-stock-market-random-forest-models-using-r/
# install.packages("tidyverse")
library(tidyverse)

time_screen = 364

#get present date
today = Sys.Date()
today_year = format(today, "%Y") # with month as a word
today_month = format(today, "%m") #months are one less for yahoo
today_day = format(today, "%d")

#set start date for historical look
start_year = "2010"
start_month = "1"
start_day = "1"

##Stock Selection

#恒生指數
symbols = c(
  "0001.HK", #長和
  "0002.HK", #中電控股
  "0003.HK", #香港中華煤氣
  "0004.HK", #九龍倉集團
  "0005.HK", #匯豐控股
  "0006.HK",#電能實業
  "0011.HK",#恆生銀行
  "0012.HK",#恆基地產
  "0016.HK",#新鴻基地產
  "0017.HK",#新世界發展
  "0019.HK",#太古股份公司Ａ
  "0023.HK",#東亞銀行
  "0027.HK",#銀河娛樂
  "0066.HK",#港鐵公司
  "0083.HK",#信和置業
  "0101.HK",#恆隆地產
  "0135.HK",#崑崙能源
  "0144.HK",#招商局港口
  "0151.HK",#中國旺旺
  "0267.HK",#中信股份
  "0293.HK",#國泰航空
  "0322.HK",#康師傅控股
  "0386.HK",#中國石油化工股份
  "0388.HK",#香港交易所
  "0494.HK",#利豐
  "0688.HK",#中國海外發展
  "0700.HK",#騰訊控股
  "0762.HK",#中國聯通
  "0823.HK",#領展房產基金
  "0836.HK",#華潤電力
  "0857.HK",#中國石油股份
  "0883.HK",#中國海洋石油
  "0939.HK",#建設銀行
  "0941.HK",#中國移動
  "0992.HK",#聯想集團
  "1038.HK",#長江基建集團
  "1044.HK",#恆安國際
  "1088.HK",#中國神華
  "1109.HK",#華潤置地
  "1113.HK",#長實地產
  "1299.HK",#友邦保險
  "1398.HK",#工商銀行
  "1880.HK",#百麗國際
  "1928.HK",#金沙中國有限公司
  "3328.HK",#交通銀行
  "3988.HK")#中國銀行

##Stock Data Extraction
count = 0
for(symbol in symbols)
{
  # import data for historical stocks  
  retrieved_csv <- read.csv(paste0("http://ichart.finance.yahoo.com/table.csv?s=",symbol,"&d=",toString(as.double(today_month)-1),"&e=",today_day,"&f=",today_year,"&g=d","&a=",toString(as.double(start_month)-1),"&b=",start_day,"&c=",start_year,"&ignore=.csv", collapse = ", "), sep=",", header=1 )
  
  write_csv(retrieved_csv, paste("./DataOut/HangSeng/", symbol,".csv", sep=""))
  
  #only use stocks whose data are larger than pre-set time_screen 
  if (nrow(retrieved_csv) > time_screen)
  {
    
    if(count==0){
      symbols2 <- c(symbol)
    } else {
      symbols2 <- c(symbols2,symbol)
    }
    
    # Change Date format
    retrieved_csv$Date = as.POSIXct(retrieved_csv$Date, format="%Y-%m-%d")
    
    
    #calculate the day change (%)
    retrieved_csv$CloseChange <- (retrieved_csv$Close-retrieved_csv$Open)/(retrieved_csv$Open)*100
    #filecsv$CloseChange <- (filecsv[,paste("Close_",symbol,sep="")]-filecsv[,paste("Open_",symbol,sep="")])/(filecsv[,paste("Open_",symbol,sep="")])*100
    retrieved_csv$CloseChange <- round(retrieved_csv$CloseChange, 1)
    
    
    # Optionally only keep those columns used for prediction
    retrieved_csv_colnames <- colnames(retrieved_csv)
    retrieved_csv_colnames = retrieved_csv_colnames[! retrieved_csv_colnames %in% "Open"]
    retrieved_csv_colnames = retrieved_csv_colnames[! retrieved_csv_colnames %in% "Close"]
    retrieved_csv_colnames = retrieved_csv_colnames[! retrieved_csv_colnames %in% "High"]
    retrieved_csv_colnames = retrieved_csv_colnames[! retrieved_csv_colnames %in% "Low"]
    retrieved_csv_colnames = retrieved_csv_colnames[! retrieved_csv_colnames %in% "Adj.Close"]
    
    retrieved_csv <- retrieved_csv[,retrieved_csv_colnames]
    
    #amend the column names - add symbol name suffix
    colnames(retrieved_csv) <- paste(colnames(retrieved_csv), symbol, sep = "_")
    #merge into one big table
    if (count==0){
      bigtable <- retrieved_csv
      colnames(bigtable)[1] <- "Date" #rename this to help standardize
    }else{
      #merge is based on the FIRST column which is posixct DATE
      bigtable <-merge(bigtable,retrieved_csv,by.x = paste(colnames(bigtable)[1]), by.y = paste(colnames(retrieved_csv)[1]), all=TRUE)
      
    }
    
    count = count + 1
  }
}
write_csv(bigtable, "./DataOut/HangSeng/CombinedStocks.csv")

