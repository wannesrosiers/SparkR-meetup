  ###############
    # Grouping
  ###############

# Create a DataFrame via R
df <- data.frame(id = c(1,2,3,4,5,6),
                 value1 = c(3,6,1,5,4,2),
                 value2 = c(1,3,6,2,4,5),
                 group1 = c(1,1,1,2,2,2),
                 group2 = c(1,1,2,2,3,3))

DF <- createDataFrame(sqlContext, df)

# GroupBy
singleGrouped <- groupBy(DF, "group1")
doubleGrouped <- groupBy(DF, "group1", "group2")

# Aggregtation
singleAggregated <- avg(singleGrouped)
doubleAggregated <- agg(doubleGrouped, value1 = "avg", value2 = "max")

# Actual calculation
collect(singleAggregated)
collect(doubleAggregated)

  #####################
    # Transformation
  #####################

# Create second DataFrame
DF2 <- createDataFrame(sqlContext, data.frame(group1 = c(1,2),
                                              value3 = c(4,6)))

# Perform transformation
filteredDF <- filter(DF,"value1 > 3")
joinedDF   <- join(DF, DF2, DF$group1 == DF2$group1)
selectedDF <- select(DF, list(DF$id, DF$value1 + 1))

# Actual calculation
take(filteredDF, 2)

cache(joinedDF)
system.time({collect(limit(joinedDF,2))})
system.time({collect(limit(joinedDF,2))})

head(selectedDF,4)

  ##########
    # SQL
  ##########

# Create new DataFrame
DF3 <- createDataFrame(sqlContext, data.frame(value1 = c(3,6,1,5,4,2),
                                              value2 = c(1,3,6,2,4,5),
                                              id1    = c(1,1,1,2,2,2),
                                              id2    = c(1,1,2,2,3,3)))

# Register as an SQL table
registerTempTable(DF3, "exampleTable")
tableNames(sqlContext)

# Perform queries
totalTable <- sql(sqlContext, "SELECT * FROM exampleTable")
subTable   <- sql(sqlContext, 
                  "SELECT id1, avg(value2) as value2
                  FROM exampleTable
                  WHERE value1 > 2
                  GROUP BY id1")

# Actual calculations
collect(totalTable)
collect(subTable)

  ############################
    # Descriptive analytics
  ############################

collect(describe(DF, "value1", "value2"))
collect(summarize(singleGrouped, highest = max(DF$value2)))
