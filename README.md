# StabSim_Grit

Similarity in functional connectome architecture predicts teenage grit (2023)


### Workflow ###

Overall, the analysis is consisted of two parts. If you need FC stability or similarity measures, you only have to run 1. Stabsim_Grit_FC.R! You can find more detailed explanations about the procedures in the manuscript.

**1. StabSim_Grit_FC.R**

!requirement: functional connectome matrices

(1) Bring in the data: bring the FC data and vectorize it

(2) Connectome stability: calculate within-subject FC stability (cross_movie stability as an example)

(3) Connectome similarity: calculate between-subject FC similarity (movieDM similarity as an example)

- calculate mean stability and mean similarity and bind up all the calculated FC measures. output (filename(1)) 

(4) Brain-Behavior: conduct multiple linear regression and get partial correlation



**2. StabSim_Grit_IS-RSA.ipynb**

!requirement: FC similarity measure calculated in 'StabSim_Grit_FC' and behavior scores

(1) Get ready: python dependencies, get FC similarity and behavior data

(2) IS-RSA: run IS-RSA with AnnaK framework and do permutation test

(3) Network lesion: run the same process only with within-network functional connectivities according to Shen_268 atlas and then bring it back to IS-RSA



-----------------------------------------------------------------------------------


Behavioral data and neuroimaging data utilized in this code can be accessed through: http://fcon_1000.projects.nitrc.org/indi/cmi_healthy_brain_network/.
