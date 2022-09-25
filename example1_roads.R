source("ahp.R")

# If there are no subcriteria, 
# you need to treat the criteria as subcriteria under a single criterion

criteria = matrix(c(1), 1, 1, byrow=TRUE)

subcriteria = matrix(c(1,2,5, 1/2,1,3, 1/5,1/3,1), 3, 3, byrow=TRUE)

cost = matrix(c(1,6,3, 1/6,1,1/2, 1/3,2,1), 3, 3, byrow=TRUE)
impact = matrix(c(1,1/9,1/5, 9,1,2, 5,1/2,1), 3, 3, byrow=TRUE)
time = matrix(c(1,1/2,1/4, 2,1,1/2, 4,2,1), 3, 3, byrow=TRUE)


matrices = list(criteria,
                list(subcriteria),
                list(list(cost, impact, time)))

solution = solve_ahp(matrices)
solution
