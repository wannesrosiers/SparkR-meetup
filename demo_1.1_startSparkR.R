  ########################
    # Defining all paths
  ########################
  
# Set SPARK_HOME
Sys.setenv(SPARK_HOME="/Users/wannes/scala/spark-1.4.0")

# Load Spark-csv packages
Sys.setenv('SPARKR_SUBMIT_ARGS'=
             '"--packages" "com.databricks:spark-csv_2.10:1.0.3" "sparkr-shell"')

# Add SparkR libpath to libpaths
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))

# Actually load SparkR
library(SparkR)

  ########################
    # Initialize SparkR
  ########################

# Initialize a sparkContext, SparkHome already set
sc <- sparkR.init("local[2]",sparkEnvir=list(spark.executor.memory="3g"))

# Initialize an sqlContext
sqlContext <- sparkRSQL.init(sc)

# Load a dataset (23,5MB)
flights <- read.df(sqlContext, 
                   paste(getwd(),"data/flightData.csv",sep="/"), 
                   "com.databricks.spark.csv", 
                   header="true")

# Inspect the data
flights
head(flights)
count(flights)
