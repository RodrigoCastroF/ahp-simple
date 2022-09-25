source("ahp.R")

criteria = matrix(c(1,1/5,1/2, 5,1,3, 2,1/3,1), 3, 3, byrow=TRUE)

costs = matrix(c(1,3, 1/3,1), 2, 2, byrow=TRUE)
location = matrix(c(1,2, 1/2,1), 2, 2, byrow=TRUE)
livability = matrix(c(1,1,4, 1,1,3, 1/4,1/3,1), 3, 3, byrow=TRUE)

costs_electricity = matrix(c(1,4, 1/4,1), 2, 2, byrow=TRUE)
costs_water = matrix(c(1,2, 1/2,1), 2, 2, byrow=TRUE)
location_friends = matrix(c(1,3, 1/3,1), 2, 2, byrow=TRUE)
location_studies = matrix(c(1,1/6, 6,1), 2, 2, byrow=TRUE)
livability_furniture = matrix(c(1,1, 1,1), 2, 2, byrow=TRUE)
livability_windows = matrix(c(1,1/4, 4,1), 2, 2, byrow=TRUE)
livability_toilet = matrix(c(1,1/2, 2,1), 2, 2, byrow=TRUE)


matrices = list(criteria,
                list(costs, location, livability),
                list(list(costs_electricity, costs_water),
                     list(location_friends, location_studies),
                     list(livability_furniture, livability_windows, livability_toilet)))

solution = solve_ahp(matrices)
solution
