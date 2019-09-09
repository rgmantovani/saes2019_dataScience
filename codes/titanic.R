# pacotes necessarios: OPenML e mlr
# dataset titanic - info
# http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic3info.txt
data = OpenML::getOMLDataSet(data.id = 40945)
dataset = data$data

# removendo a coluna do nome do passageiro (id) - coluna desnecessaria
dataset = dataset[,-3]

# removendo alguns dos atributos do tipo caracter
dataset$cabin  = NULL
dataset$home.dest = NULL
dataset$ticket = NULL

# converter character para factor
dataset$boat = as.factor(dataset$boat)

# realizando data imputation
# se for coluna numerica - completa com a mediana
# se for coluna categorica - cria uma nova class
obj = mlr::impute(obj = dataset, target = "survived", 
      classes = list(
        numeric = mlr::imputeMedian(),
        factor  = mlr::imputeConstant(const = "New")
))
depois = obj$data

# cria tarefa de classificacao e especifica a coluna preditiva
task = mlr::makeClassifTask(data = depois, target = "survived")

# cria o algoritmo, no caso uma arvore de decisao
algo = mlr::makeLearner(cl = "classif.rpart", predict.type = "prob")

# define o procedimento de validacao e avaliacao: 10x 10-CV
rdesc = mlr::makeResampleDesc(method = "RepCV", folds = 10, rep = 10, stratify = TRUE)

# medida de desempenho eh a acuracia simples
measures = list(mlr::acc)

# rodando o experimento
result = mlr::benchmark(algo, task, resampling = rdesc, measures = measures, show.info = TRUE)

# vendo os resultados
result


# induzir o modelo com a base toda
model = mlr::train(learner = algo, task = task)

tree.model = mlr::getLearnerModel(model = model)

# mostrar a arvore de saida com as regras
library(partykit)
plot(as.simpleparty(as.party(tree.model)))

# boat: atributo mais importante
#boat=New 823  23 0 (0.97205346 0.02794654) *

# Se o passageiro nao foi para nenhum bote (New), ou foi para os botes 823 e 23 -> morreu
# Senao: sobreviveu

