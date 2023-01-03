# BayesianAnalysis

Internal attributes of software include complexity, coupling, cohesion, size, level of inheritance and level of abstraction in the source code.

In this project, we use bayesian data analysis to analyse the relationship between software bugs in the software and internal attributes of software.

In this regard, we consider the above mentioned six internal attributes in order to develop a bayesian model that explains their relationship with software bugs.

Internal attributes of software are often measured using object oriented source code metrics proposed by Chidamber and Kemerer, Mccabe etc. A brief background on these source code metrics can be found here. We utilise the dataset made available here which reports 20 source code metrics for several open source systems.

In order to avoid issues of multicollinearity in our model, we only select one static source code metric for each individual internal attribute considered.
