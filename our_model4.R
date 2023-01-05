library(readxl)
library(rethinking)

data <- read_excel("C:/Users/46766/Downloads/BayesianCommitAssignment/PSOWEdata2.xlsx", sheet = "combined", n_max = 3738)#746

d <- data.frame(data$wmc, data$dit, data$noc, data$cbo, data$rfc, 
                data$ca, data$ce, data$npm, data$lcom3, 
                data$loc, data$dam, data$moa,  data$mfa, 
                data$cam, data$ic, data$cbm, data$amc, 
                data$avg_cc, data$bug, data$projectcode)

d <- d[complete.cases(d),]
p <- as.factor(d$data.projectcode)
rfc <- d$data.rfc
npm <- d$data.npm
cbo <- d$data.cbo
lcom3 <- d$data.lcom3
bugs <- d$data.bug
dd <- data.frame(p, rfc, npm, cbo, lcom3, bugs)
dd <- dd[complete.cases(dd),]

summary(dd)
var(dd$bugs)



a <- rlnorm(1e4, 4, 10)
mean(a)

a <- rlnorm(1e4, 2, 1)
mean(a)

curve(dlnorm(x,2,1), from = -100, to=100, n=200)

set.seed(10)
N <- 100
a <- rlnorm( N , 2 , 1 )
b <- rlnorm( N , 2 , 1 )
c <- rlnorm( N , 2 , 1 )
d <- rlnorm( N , 2 , 1 )
e <- rlnorm( N , 2 , 1 )
plot( NULL , xlim=c(-2,2) , ylim=c(0,100) )
for ( i in 1:N ) curve( a + b[i]*x + c[i]*x + d[i]*x + e[i]*x , add=TRUE , col=grau() )


set.seed(10)
N <- 100
a <- rlnorm( N , 1 , 0.2 )
b <- rlnorm( N , 3 , 0.2 )
c <- rlnorm( N , 5 , 0.2 )
d <- rlnorm( N , 2 , 0.2 )
e <- rlnorm( N , 1 , 0.2 )
plot( NULL , xlim=c(-2,2) , ylim=c(0,100) )
for ( i in 1:N ) curve( a + b[i]*x + c[i]*x + d[i]*x + e[i]*x , add=TRUE , col=grau() )

a <- rlnorm(1e4, 4, 10)
mean(a)
curve(dnorm(x,0,1), from = -10, to=100, n=200)

#extract the priors from the model
prior<-extract.prior(m2)
dens(prior$a,main = 'Initial prior')

#------------------ulam-poison-----------------#

m6<- ulam(
  alist(bugs ~ dpois(mu),
        mu <- a[p]+ b*rfc,
        a[p] ~ dlnorm(1,0.2),
        b ~ dlnorm(3,0.2)
  ),data=dd, chains=4
)
precis(m6,depth=2)
#traceplot(m6)
#trankplot(m6)

m7<- ulam(
  alist(bugs ~ dpois(mu),
        mu <- a[p] + b*rfc + c*npm  + d*cbo + e*lcom3,
        a[p] ~ dlnorm(1,0.2),
        b ~ dlnorm(3,0.2),
        c ~ dlnorm(5,0.2),
        d ~ dlnorm(2,0.2),
        e ~ dlnorm(1,0.2)
        ),data=dd, chains=4, log_lik=TRUE
)
precis(m7,depth=2)
PSIS(m7)

traceplot(m7)

trankplot(m7)

# prior plot
prior<-extract.prior(m7)
xseq<-c(-2,2)
mu<- link(m7,post=prior,data=list(rfc=xseq, npm=xseq, cbo=xseq, lcom3=xseq))
plot(NULL, xlim=xseq,ylim=xseq)
for(i in 1:50) lines(xseq, mu[i,], col=col.alpha("blue",0.3))

# counter factual plot
xseq <- seq (from=min(dd$rfc)-0.15, to=max(dd$rfc)+0.15, length.out=50)
mu<-link(m7, data=list(rfc=xseq, npm=xseq, cbo=xseq, lcom3=xseq))
mu_mean <- apply(mu,2,mean)
mu_PI <- apply(mu,2,PI)
plot(bugs~rfc,data=dd)
lines(xseq, mu_mean, lwd=2)
shade(mu_PI,xseq)






























# #---------ULAM with dnorm-----------------#
# dat_slim <-list(datrfc=dd3$d.rfc, datloc=dd3$d.loc,datcbo=dd3$d.cbo,datlcom3=dd3$d.lcom3,datbug=dd3$d.bug)
# str(dat_slim)
# m6<- ulam(
#   alist(datbug ~ dnorm(mu, sigma),
#         mu <- a + b*datrfc  + c*datloc  + d*datcbo  + e*datlcom3,
#         a ~ dlnorm(0,0.1),
#         b ~ dlnorm(0,0.1),
#         c ~ dlnorm(0,0.1),
#         d ~ dlnorm(0,0.1),
#         e ~ dlnorm(0,0.1),
#         sigma ~ dexp(0.3)
#   ),data=dat_slim, chains=4
# )
# precis(m6)
# pairs(m6)
# traceplot(m6)
# 
# prior<-extract.prior(m6)
# xseq<-c(-2,2)
# mu<- link(m6,post=prior,data=list(datrfc=xseq,datloc=xseq,datcbo=xseq,datlcom3=xseq))
# plot(NULL, xlim=xseq,ylim=xseq)
# for(i in 1:50) lines(xseq, mu[i,], col=col.alpha("black",0.3))
# 
# 
# xseq <- seq (from=min(dat_slim$datrfc)-0.15, to=max(dat_slim$datrfc)+0.15, length.out=30)
# mu<-link(m6, data=list(datrfc=xseq,datloc=xseq,datcbo=xseq,datlcom3=xseq))
# mu_mean <- apply(mu,2,mean)
# mu_PI <- apply(mu,2,PI)
# plot(datbug~datrfc,data=dat_slim)
# lines(xseq, mu_mean, lwd=2)
# shade(mu_PI,xseq)



#----book example 12.2-----
data(Kline)
d <- Kline
d$P <- standardize( log(d$population) )
d$contact_id <- ifelse( d$contact=="high" , 2L , 1L )

dat2 <- list(
  T = d$total_tools,
  P = d$population,
  cid = d$contact_id )

m12.2 <- ulam(
  alist(
    T ~ dgampois( lambda , phi ),
    lambda <- exp(a[cid])*P^b[cid] / g,
    a[cid] ~ dnorm(1,1),
    b[cid] ~ dexp(1),
    g ~ dexp(1),
    phi ~ dexp(1)
  ), data=dat2 , chains=4 , log_lik=TRUE )

precis(m12.2)

