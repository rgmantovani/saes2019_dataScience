library(OpenML)
library(farff)

data.ids = c(61, 1557, 1499, 54, 1131)

cat("<<<<  Saving all datasets  >>>>\n")
for (id in data.ids) {
    data = getOMLDataSet(data.id = id)
    dataName = paste0("../../datasets/dataid_", id, "_", data$desc$name, ".arff")
    writeARFF(x = data$data, path = dataName, overwrite = TRUE)
}
cat("-----------------------------------------------------------\n\n")

cat("<<<<  Reading all datasets  >>>>\n")
# read all datasets
savedData = NULL
datasets  = list.files(path = "../../datasets", full.names = TRUE)
for (dataset in datasets) {
    savedData = readARFF(dataset)
    print(dim(savedData))
}
cat("-----------------------------------------------------------\n\n")
cat("<<<<  END  >>>>\n")
