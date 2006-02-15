%
% VERSION 1.11 IN CVS


The last release of this version of the BFD toolbox is 1.13, which in MATLAB 
code is the same as 1.11 and 1.12 but with some differences in the TEX files.

TPC - 14-Feb-04

-----------------------------------------------------------------------------
This realease should correspond to submissions 1 and 2 of the JMLR paper. 
The following equivalences apply:

My parlance:	   JMLR:	  My parlance:			CVS:   TAG
Submission 1  ---- 04-473(1)	  original			1.11  rel-1-11
Submission 2  ---- 04-473(2) ---- Revision 1			1.13  rel-1-11
                                  Revision 2 (never submitt'd)	
Submission 3  ---- 04-473(3) ---- Revision 3			1.14  rel-1-12

Go to the TEX directory to obtain the copy of Submission 

The next release of the toolbox will be rel-1-12 and will be available at 

		www.dcs.shef.ac.uk/~neil

and corresponds to submission 3 of the JMLR paper, which was the accepted 
submission by the way. rel-1-12 will also be associated to the  FINAL 
version of the JMLR paper: that is the paper that was printed in the journal,
finally.

RUNNING THE CODE:
a) Please note that in order to obtaing the TOY results reported in 
submissions 1 and 2 it is necessary to run TOYDEMO. 
b) To 'recreate' the results of Table 2 (UCI data) is is necessary to 
run CLASSDEMO.
c) RUNBFD is also a 'demo' that implements by itself the EM routine, so it
doeesn't make use of BfDOPTIMISEBFD.

OTHER FILES WITH INFORMATION
a) paramTying.txt contains some information about tying hyperparameters for
composed kernels. This usually happens with kernels that have RBF-ARD and 
LIN-ARD parts. Note that BFD already has a function to carry out this task
'automatically'.
c) There usually are a couple of files:
  
   classification_DATASET_optimOptions.txt
   classification_DATASET_results.txt

inside the directories Banana, heart and titanic, each of them containing
information about the parameters used to train the models and the 
classification results obtained on the test sets.

d) The directory PARTIALRESULTS/ also contains some .TXT files with info. 
See for instance THYROID and BUMPY directories.

The following are the toolboxes and the directories that need to be included 
to be able to run the code

TOOLBOXES TO RUN THE CODE
The following toolboxes and path directories need to be included in matlab
to be able to run the code

path('/home/tpena/netlab', path)
path('/home/tpena/mlprojects/matlab/general', path)
importTool('kern')
importTool('ndlutil')
importTool('optimi')
importTool('noise')
importTool('prior')
# General utilities
path('/home/tpena/mlprojects/tpenaUtil', path)


FILES AND DIRECTORIES
This revision includes the following files and directories

banana/                  bfdKernelObjective.m  bfdPlot.m                  
bfdUpdateBeta.m		 partialResults/       titanic/
bfdBound.m               bfdLoadData.m         bfdProjectData.m           
bfdUpdateSigma.m	 readme.txt            toydemo.m
bfdComputeAlpha.m        bfd.m                 bfdSaveData.m              
classdemo.m		 runbfd.m              toyResults/
bfdComputeCCProbs.m      bfdMakePredictions.m  bfdSelectWidthFromFiles.m       
runClassBkgrndThyroid.m
bfdComputeError.m        bfdMidProduct.m       bfdSelectWidth.m           
datasets/		 runClassThyroid.m
bfdComputeL.m            bfdOptimiseBFD.m      bfdTestRecords.m           
dembfd.m		 setOptions.m
bfdCovarianceGradient.m  bfdOptimiseKernel.m   bfdTestToy.m               
heart/			 testPartialParamRecords.m
bfdKernelGradient.m      bfdParamInit.m        bfdTrainModel.m            
paramTying.txt		 testToyParams.m

a) Each of the directories BANANA, HEART and THYROID contains 15 matlab files. 
These files contain the parameters of the kernel and of Beta after having
trained a BFD model. They are stored in a vector in the following way:

	[kernParams, beta]

There should also be 2 .TXT files inside each directory with the 
classification results and information about the parameters used for the 
optimisation routine.

b) The directory PARTIALRESULTS should contain the following directories:

       bumpy/  full-spiral/  half-spiral/  overlap/  thyroid/  toyARD/

each of them contains one .TXT file and 3 matlab files. The matlab files
store the paramters of having trained BFD model on a toy dataset. The .TXT
file shows the model selection process.


Update: 13-Feb-06


------------------------------------------------------------------------------
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




