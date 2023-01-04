# BayesianAnalysis
## Background
Internal attributes of software include complexity, coupling, cohesion, size, level of inheritance and level of abstraction in the source code. In this project, we use bayesian data analysis to analyse the relationship between software bugs in the software and internal attributes of software. In this regard, we consider the above mentioned six internal attributes in order to develop a bayesian model that explains their relationship with software bugs.

Internal attributes of software are often measured using object oriented source code metrics proposed by Chidamber and Kemerer, Mccabe etc. Goel et al.[1] give an overview on these source code metrics. We utilise the dataset made available [here](https://figshare.com/articles/dataset/Software_Defect_Prediction_Dataset/13536506) which reports 20 source code metrics along with the number of bugs found for several open source systems.

## Designing the directed acyclic graph
The directed acyclic graph, DAG, is depicted in the following figure. According to the static source code measurement theory, internal attributes do not influence each other. This may be better illustrated with an example. A piece of code which may be highly complex but has low coupling with other pieces of code. Also, small lenght of source code can also be complex depending on the kind of functionality implemented while very long length of source code may contain less complexity. The bugs introduced due to carelessness or lack of knowledge of the developer are not considered and is an unobserved variable in our analysis.     

<p align="center">
  <img src="Images/DAGv1.png" width=40% height=40% title="DAG: internal attributes software bugs">
</p>

## Selecting source code metrics
In order to avoid issues of multicollinearity in our model, we only select one static source code metric to represent individual internal attribute considered. The following set of source code metrics have been extracted in the dataset considered. 

| Internal attribute | Extracted metrics             |
|--------------------|-------------------------------|
| Complexity         | WMC, RFC, AMC, MAX-CC, AVG-CC | 
| Coupling           | CBO, CA, CE, IC               |
| Cohesion           | LCOM, LCOM3, CAM, CBM         |
| Size               | NPM, LOC,                     |
| Abstraction        | DAM, MOA, MFA                 |
| Inheritance        | DIT, NOC                      |

Later, we also discuss our choice of selecting a source code metric that corresponds to the internal attributes of interest. The different models created select a single source code metric for each internal attribute.

## Selecting priors
Since the source code metrics can only take positive values for a given software module, we chose log-normal as the distribution for the priors of the source code metrics. We also assumed a linear relationship between the source code metrics and number of bugs. The different combinations of source code metrics that were used to describe the models are provided in the table below. 

| Model Name | Source code metrics used       | Approximation method    | 
|------------|--------------------------------|-------------------------|
| m1draft    | WMC, LOC, LCOM3, CBO, DIT, DAM | Quadratic approximation |
| m1         | WMC, LOC, LCOM3, CBO, DIT, DAM | Quadratic approximation |
| m2         | AMC, NPM, CAM, CA, MOA, NOC    | Quadratic approximation |
| m3         | RFC, LOC, CBO, LCOM3           | Quadratic approximation |
| m5         | WMC, CE, LCOM3, LOC            | Quadratic approximation |
| m6         | RFC, LOC, CBO, LCOM3           | Hamiltonian Monte Carlo |
| m7         | RFC, LOC, CBO, LCOM3           | Hamiltonian Monte Carlo |

After extracting data from the stored file, we remove any rows with incomplete data and then we standardised all the source code metrics. Next, we set out to find reasonable priors for our first model. In **m1draft**, we chose broad priors and then plot the priors to observe their behaviour. The priors for **m1draft** are show below. (The attached R code can be used to reproduce all the figures shown.)   


Next, we incrementatlly reduced the standard deviation that leads to **m1** model. Extracting and plotting the priors from **m1** gives the following output, which is in a much narrower range and can be used for the approximation. The same priors were then selected for the all the models.





## References
[1] B. M. Goel and P. K. Bhatia, ‘An Overview of Various Object Oriented Metrics’, International Journal of Information Technology, vol. 2, no. 1, p. 11.
