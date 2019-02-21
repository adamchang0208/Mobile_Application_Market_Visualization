# load the packages:
library(tidyr)
library(dplyr)
library(ggplot2)
library(stringr)

#Load the raw dataset:

getwd()
setwd("D:/MSBA6410 EDA/HW1/HW 1/HW 1")
apps <- read.csv("mobileApps.csv", header = TRUE)


#Data Cleaning Process:
#1. For average_rating column: Replace the 50 with 5.0
apps$average_rating[apps$average_rating == 50] <- 5.0


#2. Column "crawl_date": Format the crawl_date into date format:
apps$crawl_date <- as.Date(apps$crawl_date,format = "%m/%d/%y")


#3. Column "release_date": Format the release_date into date format:
apps$release_date <- as.Date(apps$release_date,format = "%m/%d/%y")


#4. Column "app_age_current_version": For all the "NA" in this "app age" column, replace them with the results of "crawl_date - release_date"
apps$app_age_current_version[is.na(apps$app_age_current_version)] <- as.numeric(apps$crawl_date[is.na(apps$app_age_current_version)] - apps$release_date[is.na(apps$app_age_current_version)])


#5. Column "category": Remove all the special characters (" åÊ") from the "category" column
apps$category <- str_replace(apps$category,"åÊ","")
apps$category <- str_trim(apps$category)


#6. Duplicates: Remove all the duplicated rows based on the level of Crawl_date, device, rank, category, appstore, region, developer, apptype
apps <- apps[!duplicated(apps[,c("crawl_date","device","rank","category","app_store","region","developer","app_type")]),]


#7. Column "Region": There are only 374 rows (out of 25129) with a "NA" region, accounting for only 1.5% of total data, therefore, for the data consistency, we removed all the rows with 'NA'
apps <- filter(apps, region != 'NA')


#8. Column "Average rating" & "Rating Count": Replace 0 with average values related to the developer
apps <- apps %>% 
  group_by(developer) %>% 
  mutate(rating_count= ifelse(rating_count == 0, mean(rating_count, na.rm=TRUE), rating_count))

apps <- apps %>% 
  group_by(developer) %>% 
  mutate(average_rating= ifelse(average_rating == 0, mean(average_rating, na.rm=TRUE), average_rating))


# However, after replacement with the developer average, there are "0" because some developers might be new to the market therefore they don't have any rating_count and average_tating other than 0. Therefore, we decided to remove these rows (148 rows) with 0 ratings.
apps <- filter(apps, average_rating != 0 & rating_count != 0)


#9. Column "price": Remove the rows with price outliers (prices greater than 100)
apps <- filter(apps, price <= 100)


#Write the cleaned data into a CSV file -- "HW1_Cleaned.csv"
apps_clean <- apps
write.csv(apps_clean, file = "HW1_Cleaned.csv",row.names=F)





# Analysis 
head(apps_clean)
#For standardization and in order to avoid the noise brought by the duplicates, we only kept the data on the "crawl date" "2013-01-15".
apps_clean <- filter(apps_clean, crawl_date == "2013-01-15")


#Part I: Region

# Frequency by Region (China Vs. US)

ggplot(apps_clean, aes(x = region,y = (..count..)/sum(..count..)*100,fill = region)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'Region', y = '% by frequency', fill = 'Region') +
  ggtitle("Percentage by Region") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) 


# Average Rating Count by Region (China Vs. US)

ggplot(apps_clean, aes(x=region, y=rating_count, fill = region)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'Region', y = 'Average Rating Count', fill = 'Region') +
  ggtitle("Average Rating Count by Region") +
  theme(plot.title = element_text(hjust = 0.5)) 



#13) # Average App Age by Region (China Vs. US
ggplot(apps_clean, aes(x=region, y=app_age_current_version, fill = region)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'Region', y = 'Average App Age (Days)', fill = 'Region') +
  ggtitle("Average App Age by Region") +
  theme(plot.title = element_text(hjust = 0.5)) 


#Part II: Platform (App Store)

# Percentage by App Store (Apple Vs. Google Play)

ggplot(apps_clean, aes(x = app_store,y = (..count..)/sum(..count..)*100,fill = app_store)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'App Store', y = '% by frequency', fill = 'App Store') +
  ggtitle("Percentage by App Store") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) 



# Average Rating Count by App Store

ggplot(apps_clean, aes(x=app_store, y=rating_count, fill = app_store)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'App Store', y = 'Average Rating Count', fill = 'App Store') +
  ggtitle("Average Rating Count by App Store") +
  theme(plot.title = element_text(hjust = 0.5)) 



# Average App Size by App Store

ggplot(apps_clean, aes(x=app_store, y=filesize..MB., fill = app_store)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'App Store', y = 'Average App Size (MB)', fill = 'App Store') +
  ggtitle("Average App Size by App Store") +
  theme(plot.title = element_text(hjust = 0.5)) 


#Part III: Device

# Percentage by Device

ggplot(apps_clean, aes(x = device,y = (..count..)/sum(..count..)*100,fill = device)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'Device', y = '% by frequency', fill = 'Device') +
  ggtitle("Percentage by Device") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) 


# Average Rating Count by Device

ggplot(apps_clean, aes(x=device, y=rating_count, fill = device)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'Device', y = 'Average Rating Count', fill = 'Device') +
  ggtitle("Average Rating Count by Device") +
  theme(plot.title = element_text(hjust = 0.5)) 




# Average App Size by Device

ggplot(apps_clean, aes(x=device, y=filesize..MB., fill = device)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'Device', y = 'Average App Size (MB)', fill = 'Device') +
  ggtitle("Average App Size by Device") +
  theme(plot.title = element_text(hjust = 0.5)) 


#Part IV: No. of Apps

# Average Number of Apps by Each Developer

apps_by_developer <- apps_clean %>% 
  group_by(developer) %>% 
  summarise(avg_count = n())  

apps_by_developer$avg_count[apps_by_developer$avg_count > 10] <- 'More than 10'

apps_by_developer$avg_count <- ifelse(apps_by_developer$avg_count <= 5,apps_by_developer$avg_count, 
                                      ifelse(apps_by_developer$avg_count <= 10,"5-10","More than 10"))

ggplot(apps_by_developer, aes(x = avg_count,y = (..count..)/sum(..count..)*100,fill = avg_count)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'Number of Apps', y = '% by frequency', fill = 'Number of apps') +
  ggtitle("Average Number of Apps by Each Developer") +  
  scale_y_continuous(limits = c(0,80),breaks =seq(0,80,20)) +
  theme(plot.title = element_text(hjust = 0.5)) 



#Part V: App Type (Free Vs. Grossing Vs. Paid)

# App Type vs Freq(%) 

ggplot(apps_clean, aes(x = app_type,y = (..count..)/sum(..count..)*100,fill = app_type)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'App Type', y = '% by frequency', fill = 'App Type') +
  ggtitle("Percentage by App Type") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) 




#Average Rating Count by App Type

ggplot(apps_clean, aes(x=app_type, y=rating_count, fill = app_type)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'App Type', y = 'Average Rating Count', fill = 'App Type') +
  ggtitle("Average Rating Count by App Type") +
  theme(plot.title = element_text(hjust = 0.5)) 
  



#Average File Size by App Type

ggplot(apps_clean, aes(x=app_type, y=filesize..MB., fill = app_type)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'App Type', y = 'Average File Size (MB)', fill = 'App Type') +
  ggtitle("Average File Size by App Type") +
  theme(plot.title = element_text(hjust = 0.5)) 


#Average App Age by App Type 

ggplot(apps_clean, aes(x=app_type, y=app_age_current_version, fill = app_type)) + 
  stat_summary(fun.y="mean", geom="bar") +
  stat_summary(aes(label=round(..y..,0)), fun.y=mean, geom="text", size=3,
               vjust = -0.5) +
  labs(x = 'App Type', y = 'Average App Age (Days)', fill = 'App Type') +
  ggtitle("Average App Age by App Type") +
  theme(plot.title = element_text(hjust = 0.5)) 


#Part VI: Price

#Price Range of Paid Apps

apps_clean$price_range <- ifelse(apps_clean$price < 1,"< $1", 
                                 ifelse(apps_clean$price < 3,"$1-3",
                                        ifelse(apps_clean$price < 5,"$3-5",
                                               ifelse(apps_clean$price < 10,"$5-10",
                                                      ifelse(apps_clean$price < 20,"$10-20",
                                                             "> $20")))))


install.packages("forcats")
library(forcats)

ggplot(filter(apps_clean,app_type =='paid'), aes(x = fct_infreq(price_range),y = (..count..)/sum(..count..)*100,fill = price_range)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'Price Range (in $)', y = '% by frequency', fill = 'Price Range') +
  ggtitle("Price Range of Paid Apps") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position='none')




#Price Range of Paid Apps in China & US

ggplot(filter(apps_clean,app_type =='paid'), aes(x = fct_infreq(price_range),y = (..count..)/sum(..count..)*100,fill = region)) +
  geom_bar(aes(y = prop.table(..count..)*100),position=position_dodge()) +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),2) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 3) +
  labs(x = 'Price Range (in $)', y = '% by frequency', fill = 'Region') +
  ggtitle("Price Range of Paid Apps in China and US") +  
  scale_y_continuous(limits = c(0,40),breaks =seq(0,40,10)) +
  theme(plot.title = element_text(hjust = 0.5)) 


#Price Range of Paid Apps on Smart Phone and Tablet

ggplot(filter(apps_clean,app_type =='paid'), aes(x = fct_infreq(price_range),y = (..count..)/sum(..count..)*100,fill = device)) +
  geom_bar(aes(y = prop.table(..count..)*100),position=position_dodge()) +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),2) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 3) +
  labs(x = 'Price Range (in $)', y = '% by frequency', fill = 'Device') +
  ggtitle("Price Range of Paid Apps 
          on Smart Phone and Tablet") +  
  scale_y_continuous(limits = c(0,40),breaks =seq(0,40,10)) +
  theme(plot.title = element_text(hjust = 0.5)) 


#Price Range of Grossing Apps
ggplot(filter(apps_clean,app_type =='grossing'), aes(x = fct_infreq(price_range),y = (..count..)/sum(..count..)*100,fill = price_range)) +
  geom_bar(aes(y = prop.table(..count..)*100),position = "dodge") +
  geom_text(aes(y = prop.table(..count..) * 100 + 0.5, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', vjust = -0.5,
            position = position_dodge(1), 
            size = 4) +
  labs(x = 'Price Range (in $)', y = '% by frequency', fill = 'Price Range') +
  ggtitle("Price Range of Grossing Apps") +  
  scale_y_continuous(limits = c(0,100),breaks =seq(0,100,20)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position='none')


