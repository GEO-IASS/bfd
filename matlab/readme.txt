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
Neil at www.dcs.shef.ac.uk/~neil

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
tpena@dcs.shef.ac.uk


01-XII-04




