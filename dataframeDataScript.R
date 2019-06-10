
date <- "2019-01-01"
plus.1 <- 1
data(fips_codes)
print(talk)
fips_codes <- fips_codes[-(548:3237), ]
fips_codes <- fips_codes[-(1:388), ]
sampledf <- daily_fips(fips = "13003", date_min = "2019-01-01", 
                       date_max = "2019-01-01", var = "tmax")
sampledf$station_map <- NULL
sampledf$station_metadata <- NULL
sampledf$daily_data$tmax_reporting <- NULL
sampledf$daily_data$fips <- 13001
new.df <- rbind(sampledf$daily_data)
rm(sampledf)

gafips <- 13000
countyfips <- 15

while ( countyfips <= 337 ){
  fipsnum= gafips + countyfips
  countytest <- as.character(countyfips)
  countytest1 <- paste("0", countytest, sep="")
  if(countytest1 %in% fips_codes$county_code == TRUE){
    tempdata <- daily_fips(fips = "13019", date_min = "2019-01-01", 
                           date_max = "2019-01-01", var = "tmax")
    andrew_precip <- daily_fips(fips = "12086", date_min = "1992-08-01", 
                                date_max = "1992-08-31", var = "prcp")
    tempdata$station_map <- NULL
    tempdata$station_metadata <- NULL
    tempdata$daily_data$tmax_reporting <- NULL
    tempdata$daily_data$fips <- fipsnum
    new.df <- rbind( tempdata$daily_data,new.df)
    rm(tempdata)
  } else { print (paste("Nothing found for", fipsnum, sep=" "))
    
  }
  countyfips <- plus.1 + countyfips
}

