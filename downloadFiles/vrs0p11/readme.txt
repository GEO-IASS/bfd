ReadMe file for the BFD toolbox version 0.11 Monday, December 6, 2004 at 19:15:29
Written by Tonatiuh Pena Centeno.

License Info
------------

This software is free for academic use. Please contact Neil Lawrence if you are interested in using the software for commercial purposes.

This software must not be distributed or modified without prior permission of the author.


This file provides an explanation on how to install 
and run the demos in the BFD toolbox provided.

a) Files and scripts
The toolbox is comprised of (at least) the 
following

Functions
bfdBound                 bfdMakePredictions    bfdUpdateBeta
bfdComputeAlpha          bfdMidProduct         bfdUpdateSigma
bfdComputeCCProbs        bfdOptimiseBFD		  
bfdComputeError          bfdOptimiseKernel     
bfdComputeL              bfdParamInit          
bfdCovarianceGradient    bfdPlot               
bfdKernelGradient        bfdProjectData        
bfdKernelObjective       bfdSaveData           
bfdLoadData              bfdSelectWidth        
bfd							 bfdTrainModel

Scripts
classdemo
toydemo

b) Requirements
Other toolboxes & functions
The toolbox works with some the functions provided by Neil D.
Lawrence's toolbox for 'Machine Learning'. The functions that 
are required are:
				 kern
				 ndlutil
				 general		 
				 matlab
For more information on how to get his toolbox, please contact
Neil at www.dcs.sheffield.ac.uk/~neil

Operating system
There shouldn't be any problems regarding OS, but make sure that
the functions 'bfdSaveData' and 'bfdLoadData' point to the right
directories.

## Note
Please make sure that you have the function 'setoptions' (provided
as well) in the same directory where the rest of the functions are.
This function converts an 'optimset' structure into the older
vector format 'options'. 

Matlab
There shouldn't be any problems here. However, if there are any
problems, just check 'bfdLoadData' and 'bfdSaveData' (if my 
memory doesn't fail) as some of these files check which version
is being used.

c) Installation
Just put all the files inside a directory, say BFD, and include 
a directory 'datasets' to store all the UCI and toy data sets.
Each dataset should be stored in a directory with its own name,
see the figure below:

	    /BFD
		  |
		  classdemo.m
		  bfd.m
		  ...
		  datasets/ --		
						  |
						  bumpy/
						  toyARD/
						  thyroid/

d) Saving results
If you want to save results from your classifications, you just
have to uncomment the lines at the bottom of classdemo and 
toydemo, to save the final results: classification error and
learnt parameters. You will have to create a directory
called 'results' underneath BFD, just as with 'datasets'.

If you want to save partial results, then it will be necessary
to uncomment the lines at the bottom of bfdTrainModel. It will
also be necessary to create the following directory

/BFD/partialResults/datasetName/

where dataSetName is the name of the data set being trained.

The files stored inside dataSetName will be .mat and will be
named with the following convention:

kernelType_date&hour_datasetName.m

e) Enquiries, complaints or suggestions can be directed to
Tonatiuh Pena Centeno
tpena@dcs.sheffield.ac.uk


01-XII-04





File Listing
------------

bfd.m: Creates a model with parameters and required specifications
bfdBound.m: Computes bound on marginal log-likelihood
bfdComputeAlpha.m: Computes the 'eigenvectors' of the model
bfdComputeCCProbs.m: Computes Class Conditional Probs for BFD
bfdComputeError.m: Computes prediction error on test data
bfdComputeL.m: Computes matrix that clusters targets
bfdCovarianceGradient.m: Gradient of marginal log-likelihood wrt K
bfdKernelGradient.m: Gradient of KL divergence wrt kernel parameters.
bfdKernelObjective.m: KL divergence between prior and posterior kernels 
bfdLoadData.m: Loads NINST files belonging to data set NAME
bfdMakePredictions.m: Assigns labels to test data 
bfdMidProduct.m: Auxiliary function to compute variance of a test point
bfdOptimiseBFD.m: Optimises a BFD model
bfdOptimiseKernel.m: Applies OPTIMETHOD to optimise parameters of a MODEL
bfdParamInit.m: Initialises kernel parameters
bfdPlot.m: Plot the discriminant defined by the MODEL
bfdProjectData.m: Projects training and test data over discriminant
bfdSaveData.m: Saves results of (training a/classifying with a) BFD model
bfdSelectWidth.m: Selects arameters in terms of the marginal like
bfdTestToy.m: Plots 
bfdTrainModel.m: Trains several BFD models according to partitions/trialWidths  
bfdUpdateBeta.m: Update precision beta
bfdUpdateSigma.m: Update the posterior for BFD
classdemo.m: Script to classify a given data set (e.g. from UCI)
dembfd.m: Demo for classifying a given Toy data set
setOptions.m: Converts an optimset structure to a vector foptions
toydemo.m: Script to classify Toy data and to plot the results
