# CIFL
Compressed imaging with focused light

Folders in Code:

Q1-recon
	This folder contains all the scripts and functions specific to the analysis 
	of noiseless and noisy image reconstruction
	in the context of compressed sensing with focus illumination

Q1-deconNC
	This folder contains all the scripts and functions specific to the analysis 
	in the context of compressed sensing with focus illumination
	without data compression.

Q2-noise
	This folder contains all the scripts and functions specific to the analysis 
	of array illumination and metrics to quantify illumination suitability
	in the context of compressed sensing with focus/speckle illumination.

Q3-3Dimaging
	This folder contains all the scripts and functions specific to the analysis 
	of optical sectioning for 3D imaging
	in the context of compressed sensing with focus illumination.

Q4-Bending
	This folder contains all the scripts and functions specific to the analysis 
	of multimode optical fibre bending 
	in the context of compressed sensing with focus/speckle illumination.

Q5-Aberrations
	This folder contains all the scripts and functions specific to the analysis 
	of optical aberrations 
	in the context of compressed sensing with focus/speckle illumination.

Q5-Aberrations
	This folder contains the scripts specific to the analysis 
	of extended source object
	in the context of compressed sensing with focus/speckle illumination.

RLTV_mod
	This folder contains the code for L.R. deconvolution with a spatially variant PSF
	Referencing the following work:
	https://www.osapublishing.org/boe/fulltext.cfm?uri=boe-11-8-4759&id=433935
	Original code can be dowloaded here:
	https://github.com/dop-oxford/svDeconRL

OriginalPackages
	This folder is empty. The l1-magic code should be downloaded here:
	https://statweb.stanford.edu/~candes/software/l1magic/#code
	And added to this folder. 

MMFsim
	This folder contains an edited version of the code for modeling light propagation
	through multimode optical fibre. The original code can be downloaded here:
	https://www.mathworks.com/matlabcentral/fileexchange/75327-mmf-simulation/?s_tid=LandingPageTabfx
	Only the edited files are included. The original code will have to be downloaded together with the	required FMINSEARCHBND code.

Functions and Scripts and Data:

basis_pursuit_mod.m
	This function is a modified version of the basis pursuit algorithm. 
	The original version can be found here:
	https://web.stanford.edu/~boyd/papers/admm/basis_pursuit/basis_pursuit.html

normalisation_illumination.m
	This script calculated the integrated intensity under the different illumination tested.

normIllum.mat
	This script  contains he integrated intensity under the different illumination tested.
	These are used to normalize the data such that the samples are illuminated
	with the same total number of incident photons.	 This has to be generated with 
	normalisation_illumination.m before running other scripts.


TIFmanip
	Some common function to handle images. This is not original code.
	Please refer to file headers for copyright information.
