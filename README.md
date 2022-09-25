# AHP Simple

## Overview

This is a simple program to run the **analytic hierarchy process (AHP)** in R,
more limited and easier to use than the package `frankiecho/ahpsurvey`.
The AHP is used to select the best option among several alternatives
based on a list of criteria and subcriteria. 

The user needs to give a **pairwise comparison matrix** 
for the criteria, for the subcriteria of each criterion, and
for the alternatives under each subcriterion.
By doing so, the user indicates which criteria and subcriteria
they value more highly, and
which alternatives are better under each of those subcriterion.

For every pairwise comparison matrix given by the user, this program
calculates the scores or weights of every compared item
using the **dominant eigenvalue method**.
These weights are then used to compute
the overall score of the alternatives.

## Usage

To use this program, simply put the `ahp.R` file
in your working directory, and then load the functions
in the script you need them with this line of code:

```r
source("ahp.R")
```

This program contains these two functions:

- `evaluate`: given a pairwise comparion matrix,
this function calculates the corresponding
weights and consistency ratio,
using the dominant eigenvalue method.
- `solve_ahp`: given a list of pairwise comparion matrices
with the structure shown bellow,
this program calculates all the weights, consistency ratios
and overall scores of the problem.

The list of matrices given to `solve_ahp`
should have the following structure.
Let $S$ be the pairwise comparison matrix of the criteria,
$S_{i}$ of the subcriteria for criterion $i$,
and $S_{ij}$ of the alternatives
under subcriterion $j$ of criterion $i$.
Additionally, let $N$ be the number of criteria,
and $n_{i}$ the number of subcriteria for criterion $i$.
The structure of the list given to `solve_ahp` should be:

$$
\displaylines{list(S,\\
     list(S_{1}, ..., S_{N}),\\
     list(list(S_{11}, ..., S_{1n_{1}}),\\
          ...,\\
          list(S_{N1}, ..., S_{Nn_{N}})))}
$$
