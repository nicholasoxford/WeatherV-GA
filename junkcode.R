##Set Date for countrykey, define plus.1 as a variable and load fips_code
date <- "2019-01-01"
plus.1 <- 1
data(fips_codes)
##remove columns from fips_code that do not relate to georiga.
fips_codes <- fips_codes[-(548:3237), ]
fips_codes <- fips_codes[-(1:388), ]
sampledf <- daily_fips(fips = 13001, date_min = date, 
                       date_max = date, var = "tmax")
##using this to create a dataframe that I can add to later
##Delete varibales I don't need 
sampledf$daily_data$fips <- 13001
new.df <- rbind(sampledf$daily_data)
#makenew df that I will add to later
gafips <- 13000
countyfips <- 15
##Going to have this while loop eventually run through all GA FIPS codes. 
##I was thinking a for loop could be better
while ( countyfips <= 30 ){
  fipsnum= gafips + countyfips
  countytest <- as.character(countyfips)
  countytest1 <- paste("0", countytest, sep="")
  ##running an if statement to check if the fips code is one used in georiga.
  ##if true it grabs the data and does the same manipulation as above
  if(countytest1 %in% fips_codes$county_code == TRUE){
    tempdata <- daily_fips(fips = fipsnum, date_min = date, 
                           date_max = "2019-02-01", var = "tmax")
    tempdata$daily_data$fips <- fipsnum
    new.df <- rbind( tempdata$daily_data,new.df)
    rm(tempdata)
    ##I thought removing the tempdata would solve my column id issue
  } else { print (paste("Nothing found for", fipsnum, sep=" "))
    
  }
  countyfips <- plus.1 + countyfips
}

