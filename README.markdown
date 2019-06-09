# WeatherVisualizerGA: Daily Average Temps By County - Georgia 

>Simple tool to visualize The hottest and coldest places in Georgia. 

<hr>

## Overview

I am creating this tool to apply knowledge around API request, Data Tranformation, R, Javascript, and Vue. I am pulling this data from [NOAA's](https://www.noaa.gov/) National Centers for Environmental Information's (NCDC) database. While on their [website](https://www.ncdc.noaa.gov/cdo-web/), there are many ways to access data, I found accesing via API is the most feasible. This is a result of their  downlaodable CSV's "capacity of 1,000 Station Years" and convuated data sets. Furthermore, I wanted to display by county and there were was no sort by FIPPS code. Every county in the United States has a FIPS code, and the first two numbers represent the state which the county is found. 

I am wrapping this tool using [VUE.JS](https://vuejs.org/). I am trying to further my knowledge in using VUE.JS, after spending my first week interning at **Peloton** and learning about it. While at Georgia State I learned the fundamentals of R in a Data Systems class. 

The Data Vsualtion will be done using [plotly.js](https://plot.ly/javascript/). I found this tool to be most inline with my goal, if there are any other better tools you are aware of, please leave a comment. I also grabbed an outline of the counties in Georiga in javascript from [Simplemaps](https://simplemaps.com/county-ga). 

#Install and Setting Up R + R Studio

**1) Install R.**
- Go to this [webpage](https://cran.r-project.org/bin/macosx/), and download the latest release of R. 
- Run the executable.

**2) Install RStudio**
- For mac go to this [webpage](https://www.rstudio.com/products/rstudio/download/), and download the free version. You must install RStudio after installing R. 

**3) Install Countryweather** 
- Install the package "Countyweather" (without quotes). You can learn how to install packages [here](http://web.cs.ucla.edu/~gulzar/rstudio/). 
- Make sure to go back to the packages eplorer and ensure they are all checked. 
```dplyr (>= 0.4.3), ggmap (>= 2.6.1), ggplot2 (>= 2.1.0),
geosphere (>= 1.5.1), lubridate (>= 1.5.6), purrr (>= 0.2.1),
raster (>= 2.5.8), rnoaa (>= 0.6.5), sp (>= 1.2.3), stringi (>=
1.1.1), tibble(>= 1.2), tidyr (>= 0.3.1), tigris (>= 0.3.3)
```
## Generate API Token

First thing you will need to do after setting up R is generate an API Token from NCDC's [webportal](https://www.ncdc.noaa.gov/cdo-web/token). This is free and is done so you can make API request to their databse. After putting in your email they will almost immediately email you back with your token. Keep this saved because we will be using it in a few steps. Next you will have to set the api key as a global variable so you don't have define it every time you start up r. 

**Setting API Token as global variable**
- First check if there is an .Renviron file in terminal.
>any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))

- If there is a .Renviron file it will return the value of **TRUE**, if there isn't, this command will return the value of **FALSE**
- If the value is TRUE, find that file in your home folder and open in a text editor. If FALSE, create a new text file in RStudio and save it as .Renviron
- This is case-sensitive. In the text editor, or RStudio add this
>noaakey=your_emailed_key

- Add your token where it says your_email_key.
- **Make sure to include an empty line following noaakey=your_emailed_key.**
- Save and restart RStudio. 

## Generate and Define Google API Token

For the package ggmap and others you need to generate a Google API key and defining it as a global variable. 

**Generate Google Api Key**
- Go to the [Google Maps Platform](https://cloud.google.com/maps-platform/), and click get started. After signing into a google account click through the prompts, choose maps api, and add your credit card. This service is completely free, but it requires a credit card. After that save the api key it generates for you.  
- Next in your console copy, paste, and run register_google(key = "YOUR KEY", write = TRUE)
- Keep quotes

## Run test

Next we are going to see if all the packages are working. We are going to do this by running a *daily_fips* test. *daily_fips* is a function that pulls daily weather data from any NOAA station. For our example we are going to pull the daily max temp in Fulton County, on the first week of February 2019. Because these dates coincide when the Superbowl was hosted in Atlanta I am going to name this variable superbowlAtlanta. Furthermore, other information we need is the FIPS code for Fulton County, 13121.

To run this code create a new R file and add this code. 
``` 
atlantaSuperbowl <- daily_fips(fips = "13121", date_min = "2019-02-01", 
date_max = "2019-02-07", var = "tmax")
```
Run this command in the console. It should create an enviroment variable named superbowlAtlanta.

To check if everything downloaded properly run in your console:
> atlantaSuperbowl[["daily_data"]][["tmax"]]

It should return
>[1] 16.40 18.90 18.30 19.15 23.30 21.95 26.95

***Congrats! You are now succesfully downloading NOAA data based on county!***

## Plotting Data Test

After succesfully pulling data lets run another function to plot it.

``` library(ggplot2)
ggplot(atlantaSuperbowl$daily_data, aes(x = date, y = tmax, color = tmax_reporting)) + 
  geom_line() + geom_point() + theme_minimal() + 
  xlab("Date in 2019") + ylab("Daily Max Temp (c)") + 
  scale_color_continuous(name = "# stations\nreporting")
```

You should see an output in RStudio.

***Ploting Data on a Map***

atlantaSuper bowl consist of three elements: "daily_data", "station _metadata", and "station_map". In the final element, "station_map", has information where the weather stations inside a county are located. If you run

> atlantaSuperbowl$station_map

You will see a map of Fulton with markers where the weather stations are. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Taking a big step forward.

Next, after hours of learning how much I don't know in R, I finally have code that is able to pull data, in order, and add it to a data frame. Here is the code I created.

``` 
##Set Date for countrykey, define plus.1 as a variable and load fips_code
date = "2019-01-01"
plus.1 <- 1
data(fips_codes)
##remove columns from fips_code that do not relate to georiga.
fips_codes <- fips_codes[-(548:3237), ]
fips_codes <- fips_codes[-(1:388), ]
sampledf <- daily_fips(fips = 13001, date_min = date, 
                      date_max = date, var = "tmax")
##using this to create a dataframe that I can add to later
##Delete varibales I don't need 
sampledf$station_map <- NULL
sampledf$station_metadata <- NULL
sampledf$daily_data$tmax_reporting <- NULL
sampledf$daily_data$fips <- 13001
new.df <- rbind(sampledf$daily_data)
##makenew df that I will add to later
gafips <- 13000
countyfips <- 10
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
date_max = date, var = "tmax")
tempdata$station_map <- NULL
tempdata$station_metadata <- NULL
tempdata$daily_data$tmax_reporting <- NULL
tempdata$daily_data$fips <- fipsnum
new.df <- rbind( tempdata$daily_data,new.df)
rm(tempdata)
##I thought removing the tempdata would solve my column id issue
} else { print (paste("Nothing found for", fipsnum, sep=" "))

}
countyfips <- plus.1 + countyfips
}
```
While I am sure there are better ways of getting this working. 

## License
[MIT](https://choosealicense.com/licenses/mit/)