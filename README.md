## Codes and how they were used for analysis in "Adhesion Strength of Tumor Cells Predicts Metastatic Disease in vivo" manuscript

## Matlab files to use for in vitro cell line data or cells retrieved from mouse samples




## Matlab files used for human patient sample data

# The main script to generate adhesion curves for individual microscope slides/technical replicates is "ShearAnalysis_rev14_HumanPatientData.m". To run script "fancyplot.m", "readnd2.m", and "ComsolShears.m" are needed in file directory as they are called in "ShearAnalysis_rev14_HumanPatientData.m". User will edit line 15 to input directory where nd2 files are stored. Additionally, line 17 may be edited if maximum shear stress within dPPFC is changed. User will edit lines 24 and 25 to input names of pre and post shear nd2 files. Now code can be run to achieve adhesion curves for each slide/replicate.

# To generate a folder where all slides/replicates are organized, post analysis, user can use "OrganizeCellLineData.m" script. User will edit line 3 of code to input directory where Data folder will be generated with all slides/replicates.

# To determine which slides/replicates have an R^2 above a specific threshold, use "PlotAdhesion.m". 

