  #################
    # R Packages
  #################
  
# Load magrittr package
library(magrittr)

# Chaining example
chainedResult <- filter(flights, flights$origin == "JFK") %>% 
  group_by(flights$dest) %>% 
  summarize(count = n(flights$dest))	

collect(chainedResult)

  #########################
    # Local computations
  #########################

# Make local
joinedDF
localDf <- collect(joinedDF)

# Local calculation
localDf$extraColumn <- (localDf$value1 %% localDf$value2) * localDf$value3

# Re-create DataFrame
joinedDF <- createDataFrame(sqlContext, localDf)
joinedDF

  ##############################
    # Within SparkR functions
  ##############################

# Create your R function
ownMean <- function(c1,c2) (c1+c2)/2

# Push iris data set to SparkR
data(iris)
irisDF <- createDataFrame(sqlContext, iris)

# Use your own function
newDF <- withColumn(irisDF, "newCol", ownMean(irisDF$Sepal_Length,irisDF$Petal_Length))

# Inspect the result
collect(newDF)
