########################################
### created and edited by Sujin Park ### 
########################################

############################
### 1. Bring in the data ###
############################

### subjects with multiple fMRI conditions ###
sub <- list('#sub-id')

  # movieDM (as an example, repeat this procedure for every fMRI condition)

setwd("#directory path")

files <- list() # bring in FC matrices
for (i in sub){
  files[[i]] <- paste0(i,"_FC_000.csv") # put file name
}
data <- lapply(files, function(x) {read.csv(x, header=F, sep=',')})

matdata <- list() # dataframe 2 matrix
for (i in 1:length(data)){
  frame <- data[[i]]
  mat <- as.matrix(frame)
  matdata[[i]] <- mat
  rm(mat)
}
dim(matdata[[1]]) # n x n 

library(mvmeta) 
listfin_movieDM <- list() # vectorize the matrix
for (i in 1:length(data)){
  vall <- matdata[[i]]
  vall <- vechMat(vall, diag=FALSE) # matrix 2 vector (lower triangular elements) 
  listfin_movieDM[[i]] <- vall
  rm(vall)
}

str(listfin_movieDM) 
  # listfin_movieDM: list of vectorized connectomes for all sub
  # edges: (268*268-268)/2=35778
rm(data, files, matdata, frame)


###############################
### 2. Connectome stability ###
###############################

corlist <- list() 

  # within-subject cross-movie stability (as an example, repeat this procedure for every pair of fMRI conditions)
corlist1 <- list() # edge-wise correlation between a sub's FC matrices during two conditions 
for (j in 1:length(sub)){
  corval <- cor(listfin_movieDM[[j]], listfin_movieTP[[j]])
  corlist1[[j]] <- corval
}
str(corlist1) 

cor(listfin_movieDM[[7]], listfin_movieTP[[7]]) # double-check (should be identical with below)
corlist1[[7]] 

corlist[[1]] <- corlist1 # list up the output in the 1st element of corlist
str(corlist) 

  # corlist[[1]] is cross-movie FC stability


################################
### 3. Connectome similarity ###
################################

  # between-subject movieDM similarity (as an example, repeat this procedure for every fMRI condition)

sim <- list()
meancorr1 <- list()

for (i in 1:length(sub)){
  k = 1
  for (n in 1:length(sub)){
    if (i != n){
      if (k == 1){
        corr <- cor(listfin_movieDM[[i]], listfin_movieDM[[n]])
        sim[[i]] <- corr
        k = k+1
      }
      else{
        corr <- cor(listfin_movieDM[[i]], listfin_movieDM[[n]])
        sim[[i]] <- append(sim[[i]], corr)
      }
    }
    sim <- na.omit(sim)
  }
  print(sim)
  meancorr1[[i]] <- mean(sim[[i]]) 
}

cor(listfin_movieDM[[64]], listfin_movieDM[[61]]) # double-check with sim

  # meancorr1 is movieDM FC similarity 


### mean stability and similarity ###
conn <- do.call(rbind, Map(data.frame, sub=sub, cross_movie=corlist[[1]], movieDM=meancorr1)) # bind up FC measures
str(conn)

mean_stab <- list()
mean_sim <- list()

for (i in 1:length(sub)){
  mean_stab[[i]] <- mean(unlist(conn[i,n:m])) # put column index of stability measures in n and m 
  mean_sim[[i]] <- mean(unlist(conn[i,k:l])) # put column index of similarity measures in k and l
}

str(mean_stab)
str(mean_sim)

conn <- do.call(rbind, Map(data.frame, sub=sub, cross_movie=corlist[[1]], movieDM=meancorr1, mean_stability=mean_stab, mean_similarity=mean_sim)) # bind up mean measures
str(conn)

write.table(conn, file="#path/#filename(1).csv", row.names=F, col.names=T, sep=',', quote=F)


################################
###### (Input for IS-RSA) ######
################################

  # list up subjects in order (from low to high - or high to low - in behavior phenotype)
sub <- list('#sub-id')

  # movieTP (same as connectome similarity calculation above)
  # the list of FC matrices should be organized in the sub list right above

files <- list() 
for (i in sub){
  files[[i]] <- paste0(i,"_FC_000.csv")
}
data <- lapply(files, function(x) {read.csv(x, header=F, sep=',')})

matdata <- list() # dataframe 2 matrix
for (i in 1:length(data)){
  frame <- data[[i]]
  mat <- as.matrix(frame)
  matdata[[i]] <- mat
  rm(mat)
}
dim(matdata[[1]])

listfin_movieTP <- list()
for (i in 1:length(data)){
  vall <- matdata[[i]]
  vall <- vechMat(vall, diag=FALSE)
  listfin_movieTP[[i]] <- vall
  rm(vall)
}
str(listfin_movieTP)
rm(data, files, matdata, frame)


sim <- list()
meancorr2 <- list()

for (i in 1:length(sub)){
  k = 1
  for (n in 1:length(sub)){
    if (k == 1){
      corr <- cor(listfin_movieTP[[i]], listfin_movieTP[[n]])
      sim[[i]] <- corr
      k = k+1
    }
    else{
      corr <- cor(listfin_movieTP[[i]], listfin_movieTP[[n]])
      sim[[i]] <- append(sim[[i]], corr)
    }
  }
  sim <- na.omit(sim)
  print(sim)
  meancorr2[[i]] <- mean(sim[[i]])
}

write.table(sim, file="#path/#filename(2).csv", row.names=F, col.names=F, sep=',', quote=F)



###########################
### 4. Brain & Behavior ###
###########################

setwd("#directory path")
meta <- read.csv('#file name.csv', header=TRUE) # bring in file with filename(1) + added variables (e.g., age, sex, meanFD, behavior variable)  

  # calculate meanFD covariates
meta$avg_meanFD <- rowMeans(meta[,c(n:m)]) # put column index of meanFDs for corresponding conditions (e.g., for cross_movie stability, meanFDs of movieDM and movieTP should be averaged)

  # multiple linear regression (cross_movie and grit as an example)
  # check assumptions for regression, first
library(stargazer)

m1 <- lm(meta$cross_movie~meta$GRIT_total) # put whatever FC measure and behavior variable you want to look at 
summary(m1)

m2 <- lm(meta$cross_movie~meta$GRIT_total+meta$age+meta$sex+meta$site+meta$movie_avg_meanFD) # with covariates
summary(m2)

stargazer(m1, m2, type='text', keep.stat = c('n','rsq','adj.rsq'), title='Regression Results', align=TRUE)

  # partial correlation
library(ppcor)
pcor.test(meta$cross_movie, meta$GRIT_total, meta[,c('movie_avg_meanFD','age','sex','site')])

