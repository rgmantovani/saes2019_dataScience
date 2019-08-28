library(OpenML)
library(mlr)
library(ggplot2)
library(PMCMR)

# Get a dataset
# more information https://www.openml.org/search?q=cancer&type=data
data_obj = getOMLDataSet(data.id=61)
dataset = data_obj$data

# classification
task = makeClassifTask(data = dataset, target = "class")

# Create a list of learners
lrns = list(
  makeLearner("classif.lda", id = "lda"),
  makeLearner("classif.svm", id = "svm"),
  makeLearner("classif.rpart", id = "rpart"),
  makeLearner("classif.randomForest", id = "randomForest")
)

### 10-fold cross validation
rdesc = makeResampleDesc("CV", iters = 10, stratify=TRUE)
me = list(acc, bac)
bmr = benchmark(lrns, task, rdesc, me, show.info = TRUE)
print(bmr)
cat("--------------------------------------------------------\n\n")

rank_box = plotBMRBoxplots(bmr, measure = bac, style = "violin",
                           # pretty.names = FALSE, 
                           order.lrn = getBMRLearnerIds(bmr)) +
                           aes(color = learner.id) +
                           theme(strip.text.x = element_text(size = 8))
print(rank_box)
readline(prompt="Press enter: ")


######################################
# for multiple datasets

# Get a datasets
# more information https://www.openml.org/search?q=cancer&type=data
data1 = getOMLDataSet(data.id=61)$data
data2 = getOMLDataSet(data.id=1557)$data
data3 = getOMLDataSet(data.id=1499)$data
data4 = getOMLDataSet(data.id=54)$data

# classification
task1 = makeClassifTask(data = data1, target = "class")
task2 = makeClassifTask(data = data2, target = "Class")
task3 = makeClassifTask(data = data3, target = "Class")
task4 = makeClassifTask(data = data4, target = "Class")
tasks = list(task1, task2, task3, task4)

# Create a list of learners
lrns = list(
  makeLearner("classif.lda", id = "lda"),
  makeLearner("classif.svm", id = "svm"),
  makeLearner("classif.rpart", id = "rpart"),
  makeLearner("classif.randomForest", id = "randomForest")
)

### 10-fold cross validation
rdesc = makeResampleDesc("CV", iters = 10, stratify=TRUE)
me = list(acc, bac)
bmr = benchmark(lrns, tasks, rdesc, me, show.info = TRUE)
print(bmr)
cat("--------------------------------------------------------\n\n")

rank_box = plotBMRBoxplots(bmr, measure = bac, style = "violin",
                           pretty.names = FALSE, 
                           order.lrn = getBMRLearnerIds(bmr)) +
                           aes(color = learner.id) +
                           theme(strip.text.x = element_text(size = 8))
print(rank_box)
readline(prompt="Press enter: ")

### Nemenyi test
g = generateCritDifferencesData(bmr, p.value = 0.1, test = "nemenyi")
cd = plotCritDifferences(g) +
    coord_cartesian(xlim = c(-1,5), ylim = c(0,2)) +
    scale_colour_manual(values = c("lda" = "#F8766D",
                                   "svm" = "#00BA38",
                                   "rpart" = "#619CFF",
                                   "randomForest" = "#8B008B"))
print(cd)
readline(prompt="Press enter: ")
