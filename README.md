# Mobile_Application_Market_Visualization
Global mobile application market overview with visualization using ggplot in R


The mobile application market seems to be a very potentially lucrative one. You asked us to develop a plan to enter mobile application market. To do this, we must help you to understand the market with insights derived by investigating the data available on the market.
  
  
Identifying what makes a “successful” mobile application is problematic. We have a limited set of attributes from which to derive insights. As of now, you haven’t constrained us with limitations as to any characteristic of the app you want to develop.
  
  
After careful analysis of the data, we recommend that you focus on developing a single free app, targeted to the Google Play Store for smartphone users in the US, that is low in system resource requirements.


The majority of developers have one app in the market. We believe that launching one app will make the allocation of your resources more efficient and require less effort on the development and maintenance of the app.
  
 
Free apps make up 40.8% of the overall app market across all regions, device types, and operating systems, whereas  grossing apps (those categorized as continuing to generate revenue) and paid apps (those that have a one time purchase fee) are 29.9% and 29.3% respectively. However, the average rating count for free apps is 2.7 times higher than grossing apps and almost 14 times higher than that of paid apps. This suggests that there is greater customer interaction with free apps which can provide better feedback and more word of mouth recommendations.


We have identified the Google Play Store as a better opportunity for entry over the Apple App Store. There is massive saturation of the App Store Market as compared to Google Play. We found that 87% of all apps are hosted on the App Store while 13% are on Google Play. But even given that wide disparity of availability, Google Play Store apps have, on average, 24.5 times more ratings than the average rating count of an App Store app. We also conclude that apps available on Android devices have lower average development and maintenance costs. On average, App Store smartphone apps are 99 MB in size, while Google Play Store smartphone apps are 48MB. We believe this lower overall file size indicates a less complex development process.


We have identified the United States as a better choice over China based on the average count of app ratings per app. We believe that a higher count of ratings is indicative of better customer interaction with the product. A higher number of ratings also aids adoption as people are more likely to try something they know is popular. Overall, there are more apps in the Chinese Market (57.8%) than in the US (42.2%), but the average rating count per app is 2.7 times higher in the US.


## Assumptions and Limitations:
#### Assumptions:
- We have assumed that file size equates to development complexity
- We have assumed that the count of rating is an indicator for customer engagement
- We have assumed Rating Count as the measurement of success
- We have ignored/removed data related to Amazon as it is not comprehensive enough because of very less data points (<1% of total data) and could even possibly skew the results
- We have filtered data for the final crawl date (Jan 15, 2013) to proceed with the analysis. Since we are not comparing the performance of the same apps over a period of time and just rather understanding how the overall app market is performing


#### Limitations:
- In the data cleaning process, we substitute all anomalies which equals 50 in average rating column with 5 as the rating system was assumed to scale from 0 to 5. This approach can be proved imprudent as the probability for all users rating at 5 is extremely low. Using the mean value by category level to replace error data would be more appropriate.
- Our recommendations are provided by analyzing intuitive correlation or comparative relationships between variables. Statistical modeling is definitely required to verify if there are causality between independent variables to dependent variable to improve the persuasion of our recommendation.
- Even if we have performed statistical analysis on the causality, our recommendations can still be impaired by the potential correlations between independent variables. Further examination on the correlation within columns and field research could help to validate our recommendations.


#### Risks:
• Android apps have to cater to a wider variety of devices as compared to iOS which could lead to higher development costs and more development barriers to make the APP more compatible.
• Free apps are observed to have shorter average age than grossing or paid apps which may suggest that free apps have shorter updating cycle, incurring greater development costs.
• The difference in approval criteria in terms of cost and inspection rules between Android and iOS should also be taken into consideration. 
• According to our analysis, games and social media apps take up the majority of market share, make it competitive to enter for novice developers. More data related to various category characteristic, such as user profile, financial performance, development learning curve and update cycle,  needs to be examined to generate convincing category recommandations.



