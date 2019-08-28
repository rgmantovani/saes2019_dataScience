library(OpenML)
library(farff)

data.ids = c(61, 1557, 1499, 54, 1131)

cat("<<<<  Saving all datasets  >>>>\n")
for (id in data.ids) {
    data = getOMLDataSet(data.id=id)$data
    # export arff format file
    data_name = paste("datasets/dataid_", id, ".arff", sep="")
    writeARFF(data, path=data_name)
}
cat("-----------------------------------------------------------\n\n")

cat("<<<<  Reading all datasets  >>>>\n")
# read all datasets
data = NULL
for (id in data.ids) {
    # import arff format file
    data_name = paste("datasets/dataid_", id, ".arff", sep="")
    data = readARFF(data_name)
    print(dim(data))
}
cat("-----------------------------------------------------------\n\n")
cat("<<<<  END  >>>>\n")
