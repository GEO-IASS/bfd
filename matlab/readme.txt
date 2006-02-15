

1) Functions included in the toolbox

This toolbox is divided in several parts or modules that allow it not only 
to train a BFD model but also to do auxiliary tasks. For example, the toolbox 
includes functions to project a dataset over the direction of discrimination 
obtained with BFD. This is useful if ROC curves or histograms want to be 
generated.
The files included in this toolbox are the following:

Core BFD, version 0.14
----------------------
bfd.m
bfdBound.m
bfdClassifyData.m
bfdClassifyToyData.m
bfdComputeAlpha.m
bfdComputeL.m
bfdCovarianceGradient.m
bfdKernelGradient.m
bfdKernelObjective.m
bfdMatVar.m
bfdOptimiseBFD.m
bfdPlot.m
bfdSaveData.m
bfdUpdateBeta.m
bfdUpdateSigma.m

Kernel and auxiliary functions 
------------------------------
computeKernel.m
loadData.m
setOptions.m
thetaConstrain.m
initTheta.m

ROC functions
-------------
generateROC.m
processROCdata.m

Functions to project data
-------------------------
selectParamsFromArray.m
selectParamsAndProject.m
delElements.m
projectData.m 

Functions to generate histograms
--------------------------------
bfdHist.m
generateHist.m

Demos
-----
demAUCbanana.m
demAUCbreastCancer.m
demAUCheart.m
demHistTwonorm.m
demHistWaveform.m

Text files
----------
scriptToCompareResults.txt
experimentResults.txt
readme.txt (this file!)

Other files included	
--------------------
classSpecsRBFARDLINARDBIASWHITE.m
classSpecsRBFBIASWHITE.m

Additional toolboxes or files that need to be installed to run the toolbox 
are:

Netlab 3.3 functions (additional)
---------------------------------
dist2.m
gradchek.m
linef.m
maxitmess.m
scg.m
normal.m  <-- nor part of Netlab, but written by Ian T. Nabney as well.

Neil Lawrence's utilities NDLUTIL0p1 or below (additional)
----------------------------------------------------------
logdet.m
pdinv.m

ls-SVMlab 1.5 functions (additional)
------------------------------------
roc.m


Note:All the functions are included in this toolbox, except those marked as 
     `additional', which need to be downloaded and installed separately.


2) Installation 

a.- Extract the zip files that contain the toolbox to some directory, for 
    example <your-matlab-path>/BFD/
 
b.- Then add to the matlab path this directory and the subdirectories included 
    in it; use the PATH command. This should look like this

	path('<your-matlab-path>/BFD/', path);
	path('<your-matlab-path>/ls-SVMlab', path);
	path('<your-matlab-path>/netlab', path);
	path('<your-matlab-path>/normalisationFunction/', path);
	path('<your-matlab-path>/NDLUTIL0p1', path);

c.- Download the `additional' toolboxes (ndlUtil, Netlab & ls-SVMlab) and include
    them in the matlab path.

d.- Download Gunnar Raetsch's datasets (see [5]) in case you want to train BFD 
    on some his data. Nonetheless, the results come included in this 
    distribution, so this step is not strictly necessary.


3) Datasets

We have included a copy of BUMPY, FULL-SPIRAL, OVERLAP and RELEVANCE. Check [1] 
to compare your results with those presented in the paper. Please note that the
FULL-SPIRAL data was used previously by Lang and Witbrock; see [3] and [4].


3) How to use it

Functionalities
---------------
The algorithm is described in detail in [4] and should be used as main reference
insofar to any theoretic aspect related to this implementation. This version of
the toolbox includes two main tasks that can be carried out

a.- Classification of datasets (data should have the same format as that of [5])
b.- Generation of ROC curves (this is to replicate the results presented in [1])

Later on we will try to include the functions that were used to generate the 
histograms presented in the paper.


Running classification experiments
----------------------------------
A typical run to classify a TOY DATA set would look like this from your matlab 
prompt

CLASSIFICATION WITH RBF KERNEL
>> dataset = 'full-spiral';
>> kernelType = {'rbf', 'bias', 'white'};
>> model = demToy(dataset, kernelType);

CLASSIFICATION WITH ARD-based KERNEL
>> dataset = 'overlap';
>> kernelType = {'rbfard', 'linard', 'bias', 'white'};
>> model = demToy(dataset, kernelType);

Note that a directory <your-matlab-path>/BFD/DATASET should be created at the end
of the experiment. This directory should contain a plot and the results of the 
experiments. A plot only will be generated for Toy datasets {Full-spiral, overlap, 
bumpy, relevance}.


Generating ROC curves
---------------------
The ROC and PROJECTDATA modules of the toolbox are designed to recreate the 
results presented in [1]. The data will be projected using the MEDIAN of the 
parameters obtained from training the first 5 training partitions of a given data
set, see [1],[6] and [7] for further reference. 
A typical run to obtain the ROC curves and related statistics looks like this

GENERATING ROC CURVES FOR BANANA DATASET
>> dataset = 'banana';
>> kernelType = {'rbf', 'bias', 'white'};
>> dataType = 'test';
>> selectParamsAndProject(dataset, kernelType, dataType, [], []);
>> generateROC(dataset, dataType, kernelType);
>> processROCdata(dataset, dataType, kernelType);


Recreating UCI experiments
--------------------------
As mentioned above, this distribution includes the results of training BFD on 
the first five partitions of each dataset so it is NOT necessary to train again 
everything. However, if it is required to do so, then the following steps should
be followed:

a.- Download Gunnar Raetsch's datasets from [1] and extract them so that they are
    stored in <your-matlab-path>/BFD/datasets/DATASET, where DATASET can be 
    'banana', 'thyroid', etc.
b.- Use the script classSpecsKERNELTYPE on the function CLASSIFYDATA. 
    Both of them were used to run the experiments reported in the paper [1]. Please 
    bear in mind that running experiments with the specifications of 
    classSpecsKERNELTYPE will take quite a long time as convergence criteria is 
    very small. In fact, the experiments were run using the Pascal Network cluster,
    which provides up to 26 processors with a fair amount of memory.


Note on KERNELS
------------------
The computation of different kernel matrices is based on some old code by Neil 
Lawrence. The idea behind this is to be able to fexibly compute kernels by adding
components one at a time and for this reason processing efficiency was somehow 
left behind. The components included in this toolbox are:

RBF - an rbf kernel
RBFARD - rbf kernel with ARD features
LIN - a linear kernel
LINARD - linear kernel with ARD features
BIAS - a matrix with all elements set to some scalar
WHITE - diagonal matrix \alpha*I

The kernels used for the experiments in [1] were 

a.- RBF based kernel - {'rbf', 'bias', 'white}
b.- ARD kernel - {'rbfard', 'linard', 'bias', 'white}


Note on the GAMMA structure inside MODSPECS
-------------------------------------------
This structure specifies a Gamma(a,b) distribution, which is the prior over the 
parameter \Beta in the BFD model. See [1] for more details.


#################################################################################
Appendix: 


a) References
Please note that all functions included in this toolbox make reference to some of 
the sources listed below

  [1] T.Peña-Centeno and N. D. Lawrence.  (2006) 
      "Optimising kernel parameters and regularisation coefficients 
      for non-linear discriminant analysis" in Journal of Machine 
      Learning Research. Accepted for publication.
  [2] T.Peña-Centeno and N. D. Lawrence. (2004) 
      "Optimising kernel parameters and regularisation coefficients 
      for non-linear discriminant analysis" 
      Technical Report no CS-04-13,
  [3] J. Lang and M. J. Witbrock. 
      "Learning to tell two spirals apart", in Proceedings of the 18th
      Connectionnist Models Summer Schools. Morgan-Kauffman, 1988.
  [4] Spiral data, available at 
      http://www-ra.informatik.uni-tuebingen.de/SNNS/SNNS-Mail/96/0464.html
  [5] URL http://users.rsise.anu.edu.au/~raetsch/data/index
  [6] G. Raetsch, T. Onoda and K.-R. Muller, 
      "Soft margins for AdaBoost", Machine Learning, vol. 43, no. 3, 
      pp 287-320, March 2001.
  [7] S. Mika, G. Rätsch, J. Weston, B. Schölkopf, and K.-R. Müller. 
      "Fisher discriminant analysis with kernels."
      In Y.-H. Hu, J. Larsen, E. Wilson, and S. Douglas, editors, 
      Neural Networks for Signal Processing IX, pages 41-48. IEEE, 1999. 

# EOF