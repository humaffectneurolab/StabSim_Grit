# StabSim_Grit

Similarity in functional connectome architecture predicts teenage grit (2023)

### Workflow ###
**1. StabSim_Grit_FC.R**

require: functional connectome matrices

(1) Bring in the data: you will bring the FC data and vectorize it

(2) Connectome stability: calculate within-subject FC stability (cross_movie stability as an example)

(3) Connectome similarity: calculate between-subject FC similarity (movieDM similarity as an example)

- calculate mean stability and mean similarity and bind up all the calculated FC measures. output (filename(1)) 

(4) Brain-Behavior: conduct multiple linear regression and get partial correlation


2. 

Behavioral data and neuroimaging data utilized in this code can be accessed through: http://fcon_1000.projects.nitrc.org/indi/cmi_healthy_brain_network/.
