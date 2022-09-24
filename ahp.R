evaluate = function(mat) {
  
  # Input - pairwise comparison matrix
  # Output - weights and consistency ratio
  
  eig = eigen(mat)
  max_eigval = - Inf
  
  for (index in seq_along(eig$values)) {
    eigval = eig$values[index]
    if (Im(eigval)==0) {
      eigval = Re(eigval)
      if (eigval > max_eigval) {
        max_eigval = eigval
        eigvec = Re(eig$vectors[,index])
        # We normalize the eigenvector
        weights = eigvec/sum(eigvec)
      }
    }
    
    rank = nrow(mat)
    consistency = (max_eigval-rank)/(rank-1)
    
  }

  # named list - from https://stackoverflow.com/questions/1826519/how-to-assign-from-a-function-which-returns-more-than-one-value
  return(list(weights=weights, consistency=consistency))
  
}

solve_ahp = function(matrices) {
  
  # Input - list of pairwise comparison matrices, with the following structure:
  #
  #  list(matrix of criteria,
  #       list(matrix of subcriteria for the criterion 1, ..., matrix of subcriteria for the criterion N),
  #       list(list(matrix of alternatives under the subcriterion 1 of the criterion 1, ..., matrix of alternatives under the subcriterion N1 of the criterion 1),
  #            ...,
  #            list(matrix of alternatives under the subcriterion 1 of the criterion N, ..., matrix of alternatives under the subcriterion NN of the criterion N)))
  #
  # Output - named list with:
  # 
  #  the weights of each criterion, subcriterion and alternative (under each subcriterion);
  #  the consistency ratios of each matrix; 
  #  and the values of the alternatives
  #
  
  weights_criteria = list()
  weights_subcriteria = list()
  weights_alternatives = list()
  
  consistency_criteria = list()
  consistencies_subcriteria = list()
  consistencies_alternatives = list()
  
  values = list()
  
  # Weights of the criteria
  
  matrix_criteria = matrices[[1]]
  # [[]] is used instead of [] to access the element itself: https://www.learnbyexample.org/r-list/
  evaluation = evaluate(matrix_criteria)
  weights_criteria = evaluation$weights
  consistency_criteria = evaluation$consistency
  
  # Weights of the subcriteria, for each criterion
  
  for (index_criterion in seq_along(matrices[[2]])) {
    matrix_subcriteria = matrices[[2]][[index_criterion]]
    evaluation_subcriteria = evaluate(matrix_subcriteria)
    weights_subcriteria[[index_criterion]] = evaluation_subcriteria$weights
    consistencies_subcriteria[[index_criterion]] = evaluation_subcriteria$consistency
  }
  
  # Weights of the alternatives, for each criterion and subcriterion
  
  for (index_criterion in seq_along(matrices[[3]])) {
    for (index_subcriterion in seq_along(matrices[[3]][[index_criterion]])) {
      matrix_alternatives = matrices[[3]][[index_criterion]][[index_subcriterion]]
      evaluation_subcriteria = evaluate(matrix_alternatives)
      if (index_subcriterion == 1) {
        weights_alternatives[[index_criterion]] = list(evaluation_subcriteria$weights)
        # simply assigning a value to weights_alternatives[[X]][[1]] doesn't work
        consistencies_alternatives[[index_criterion]] = list(evaluation_subcriteria$consistency)
      } else {
        weights_alternatives[[index_criterion]][[index_subcriterion]] = evaluation_subcriteria$weights
        consistencies_alternatives[[index_criterion]][[index_subcriterion]] = evaluation_subcriteria$consistency
      }
    }
  }
  
  # Values of the alternatives
  
  for (index_alternative in seq_along(weights_alternatives[[1]][[1]])) {
    value = 0
    for (index_criterion in seq_along(weights_criteria)) {
      value_in_criterion = 0
      for (index_subcriterion in seq_along(weights_subcriteria[[index_criterion]])) {
        value_in_criterion = value_in_criterion +
          weights_subcriteria[[index_criterion]][[index_subcriterion]] *
          weights_alternatives[[index_criterion]][[index_subcriterion]][[index_alternative]]
        # en R, puedes tener sentencias de varias líneas dejando la 1ra incompleta:
        # https://stackoverflow.com/questions/6329962/split-code-over-multiple-lines-in-an-r-script
      }
      value = value +
        value_in_criterion * weights_criteria[[index_criterion]]
    }
    values[[index_alternative]] = value
  }
  
  return(list(values=values,
              weights=list(criteria=weights_criteria,
                           subcriteria=weights_subcriteria,
                           alternatives=weights_alternatives),
              consistencies=list(criteria=consistency_criteria,
                                 subcriteria=consistencies_subcriteria,
                                 alternatives=consistencies_alternatives)))
  
}

metacriterios = matrix(c(1,1/5,1/2, 5,1,3, 2,1/3,1), 3, 3, byrow=TRUE)

coste = matrix(c(1,3, 1/3,1), 2, 2, byrow=TRUE)
ubicacion = matrix(c(1,2, 1/2,1), 2, 2, byrow=TRUE)
habitabilidad = matrix(c(1,1,4, 1,1,3, 1/4,1/3,1), 3, 3, byrow=TRUE)

costes_luz = matrix(c(1,4, 1/4,1), 2, 2, byrow=TRUE)
costes_agua = matrix(c(1,2, 1/2,1), 2, 2, byrow=TRUE)
cercania_amigos = matrix(c(1,3, 1/3,1), 2, 2, byrow=TRUE)
cercania_estudios = matrix(c(1,1/6, 6,1), 2, 2, byrow=TRUE)
muebles = matrix(c(1,1, 1,1), 2, 2, byrow=TRUE)
ventanas = matrix(c(1,1/4, 4,1), 2, 2, byrow=TRUE)
bano = matrix(c(1,1/2, 2,1), 2, 2, byrow=TRUE)


matrices = list(metacriterios,
                list(coste, ubicacion, habitabilidad),
                list(list(costes_luz, costes_agua),
                     list(cercania_amigos, cercania_estudios),
                     list(muebles, ventanas, bano)))

resolucion = solve_ahp(matrices)
resolucion
