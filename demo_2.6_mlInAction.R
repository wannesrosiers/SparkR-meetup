# Load the package
library(InfoFarmSparkML)

  ###################
    # NAIVES BAYES
  ###################

# Create sets
data(iris)
iris$response <- ifelse(iris$Species == "setosa", TRUE, FALSE)
iris$Species  <- NULL

nb_train <- createDataFrame(sqlContext, rbind(iris[1:40,],iris[51:90,],iris[101:140,]))
nb_calib <- createDataFrame(sqlContext, rbind(iris[41:45,],iris[91:95,],iris[141:145,]))
nb_test  <- createDataFrame(sqlContext, rbind(iris[46:50,],iris[96:100,],iris[146:150,]))

# create model
config <- c()
config$numberOfPartitions <- 2
nb <- NaiveBayes(nb_train, columns(nb_train)[-5])
lapply(nb[["model"]], function(mod){
  cache(mod)
  count(mod)
})

# Inspect the model
collect(nb[["model"]]$Petal_Width)

# get threshold
nb_calibPred <- predict_NaiveBayes(nb_calib, nb[["scales"]], nb[["model"]])
nb_thresh    <- getThreshold(nb_calibPred, "response", "rate", 100)

# get measures on test set
nb_testPred            <- getColumns(predict_NaiveBayes(nb_test, nb[["scales"]], nb[["model"]]), c("response", "rate"))
nb_testPred$prediction <- nb_testPred$rate > nb_thresh[["threshold"]]
nb_confusionList       <- getConfusionList(nb_testPred, "response", "prediction")
am                     <- accuracyMeasures(nb_confusionList,NULL,"NaiveBayes")

  #############
    # KMEANS
  #############

# Create sets
data(iris)
trainingSet    <- createDataFrame(sqlContext, rbind(iris[1:40,],iris[51:90,],iris[101:140,]))
calibrationSet <- createDataFrame(sqlContext, rbind(iris[41:45,],iris[91:95,],iris[141:145,]))
testSet        <- createDataFrame(sqlContext, rbind(iris[46:50,],iris[96:100,],iris[146:150,]))

# Create the model
k <- 3
km_data   <- unionAll(trainingSet, calibrationSet)
km        <- kmeans(km_data, names(km_data)[-5], names(km_data)[5], k,  eps=0.01, logging=TRUE)

# Use as classifier 
km_pred <- collect(predict_kmeans(testSet, km[["scales"]], km[["means"]], names(km_data)[5]))
base::table(km_pred$Species,as.factor(km_pred$cluster))

  ########################
    # Association rules
  ########################

# Read the data
networkData <- read.df(sqlContext, paste(getwd(),"data/network.csv", sep="/"), "com.databricks.spark.csv", header="true")
networkData <- removeColumns(networkData, c(""))

# Create the model
model <- recommenderModel(networkData, "user", "followed_user", 15, FALSE)
cache(model)
print(paste("Found", count(model), "rules"))

# Create a reommendation
user   <- 730105568
result <- getRecommendations(networkData, model, user, "user", "followed_user", "confidence", logging=FALSE)
View(collect(result))
