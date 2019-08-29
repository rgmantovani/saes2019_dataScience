library(OpenML)
library(mlr)

# Get a dataset
# more information https://www.openml.org/search?q=cancer&type=data
data_obj = getOMLDataSet(data.id=61)
dataset = data_obj$data

# classification
task = makeClassifTask(data = dataset, target = "class")

# Classification algorithm
classif.rf = makeLearner("classif.randomForest")

# measures
me = list(acc, bac)

# 10-cv 
rdesc = makeResampleDesc("CV", iters=10, stratify=TRUE)

# Calculate the performance
r = resample(learner=classif.rf, task=task, resampling=rdesc,
             measures=me, show.info = TRUE)
cat("--------------------------------------------------------------\n\n")

pred = getRRPredictions(r)
print(pred)
cat("--------------------------------------------------------------\n\n")

# 10-cv with 30 rep 
rdesc.rep = makeResampleDesc("RepCV", reps=30, stratify=TRUE)

# Calculate the performance
r = resample(learner=classif.rf, task=task, resampling=rdesc.rep,
             measures=me, show.info = TRUE)
cat("--------------------------------------------------------------\n\n")

pred.rep = getRRPredictions(r)
print(pred.rep)
cat("--------------------------------------------------------------\n\n")
