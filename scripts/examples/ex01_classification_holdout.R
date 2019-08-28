library(OpenML)
library(mlr)

# List OpenML data sets.
cat("OpenML datasets: ...\n")
list_datasets = listOMLDataSets()
print(head(list_datasets))
cat("------------------------------------------------------------------\n\n")

# Get a dataset
# more information https://www.openml.org/search?q=cancer&type=data
data_obj = getOMLDataSet(data.id = 61)
dataset = data_obj$data

# dataset exploration
cat("Dataset Exploration: ...\n")
dimension = dim(dataset)
cat("lin=",dimension[1]," col=", dimension[2], "\n")
summary(dataset)
barplot(table(dataset$class))
cat("------------------------------------------------------------------\n\n")

# classification
task = makeClassifTask(data = dataset, target = "class")
cat("Classification Task: ...\n")
print(task)
cat("------------------------------------------------------------------\n\n")

# Classification algorithm
classif.rf = makeLearner("classif.randomForest")

# Resampling validatio strategies
# rdesc = makeResampleDesc("Holdout", split = 2/3)
rdesc = makeResampleDesc("CV", iter = 5)
# rdesc = makeResampleDesc("RepCV", folds = 5, reps = 10)

# measure
me = list(acc, bac)

# Calculate the performance
r = resample(learner = classif.rf, task = task, resampling = rdesc,
  measures = me, show.info = TRUE)
cat("------------------------------------------------------------------\n\n")

pred = getRRPredictions(r)
print(pred)
cat("------------------------------------------------------------------\n\n")
