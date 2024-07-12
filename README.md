## Codes and how they were used for analysis in "Adhesion Strength of Tumor Cells Predicts Metastatic Disease in vivo" manuscript


# Matlab files to use for in vitro cell line data or cells retrieved from mouse samples

To test the Weibull distribution to model MDA-MB231 and MCF10A adhesion profiles (Figure 5 of manuscript), in a monoculture and co-culture, we simulated mixtures with varying adhesion strength to test the accuracy of the method’s predictions of T50 and cancer cell fraction in a virtual mixture, and used the script "PlotCoCulture_rev2.m". The error of the predictions of T50 and cancer fraction were calculated using the script "ShearPredictions_rev2.m".
   
The main script to generate adhesion curves for individual microscope slides/technical replicates is                         "ShearAnalysis_rev14_InVitroCellLines_MouseData.m". To run script "fancyPlot.m", "readnd2.m", and "ComsolShears.mat" are needed in file directory as they are called in "ShearAnalysis_rev14_InVitroCellLines_MouseData.m". User will edit line 15 to input directory where nd2 files are stored. Additionally, line 17 may be edited if maximum shear stress within dPPFC is changed. Depending upon the number of cell lines used in dPPFC experiment, user will edit line 18 and input 1 if experiment was a monoculture or 2 if experiment was a co-culture. User will edit lines 24 and 25 to input names of pre and post shear nd2 files. Now code can be run to achieve adhesion curves for each slide/replicate.

To generate a folder where all slides/replicates are organized, post analysis, user can use "OrganizeCellLineData.m" script. User will edit line 3 of code to input directory where Data folder will be generated with all slides/replicates.

To determine which slides/replicates have an R^2 above a specific threshold, use "PlotAdhesion.m". To run script "fancyPlot.m", "natsort.m", and "natsortfiles.m" are needed in file directory. User will edit line 11 in "PlotAdhesion.m" script and input the file path to their replicates/slides. User can edit line 14 to adjust threshold of R^2 desired to be evaluated. Now code can be run to observe slides/replicates with R^2 value at or above identified threshold. Index of slides will be printed in command window.

To generate curves where migration data (cell speed and displacement) is plotted against adhesion strength user can use "AdhesionVsSpeed.m". To run script "natsort.m", "natsortfiles.m", "PlotSpeed.m", "ComsolShears.mat" and "MigrationData.mat" are needed in file directory. User will edit lines 12-24 with file paths where replicates for     different cell line are located to analyze with script. User will edit line 37 to the maximum shear stress used in dPPFC experiment. Now code can be run to achieve migration versus adhesion data for different cell lines.  

To generate a logistic regression model and run an ROC analysis the script "ROCAnalysis_rev2.2" was used.

# Matlab files used for human patient sample data

The main script to generate adhesion curves for individual microscope slides/technical replicates is "ShearAnalysis_rev14_HumanPatientData.m". This script is similar to "ShearAnalysis_rev14_InVitroCellLines_MouseData.m" however it contains additional steps that help to automate the thresholding process of each microscope slide. Human patinet samples are more heterogeneous than in vitro cell lines, therefore it is necessary to optimize thresholding for each replicate as opposed to using a standard thresholing parameter for each replicate with cell lines. To run script "fancyPlot.m", "readnd2.m", and "ComsolShears.mat" are needed in file directory as they are called in "ShearAnalysis_rev14_HumanPatientData.m". User will edit line 15 to input directory where nd2 files are stored. Additionally, line 17 may be edited if maximum shear stress within dPPFC is changed. User will edit lines 24 and 25 to input names of pre and post shear nd2 files. Now code can be run to achieve adhesion curves for each slide/replicate.

To generate a folder where all slides/replicates are organized, post analysis, user can use "OrganizeCellLineData.m" script. User will edit line 3 of code to input directory where Data folder will be generated with all slides/replicates.

To determine which slides/replicates have an R^2 above a specific threshold, use "PlotAdhesion.m". To run script "fancyPlot.m", "natsort.m", and "natsortfiles.m" are needed in file directory. User will edit line 11 in "PlotAdhesion.m" script and input the file path to their replicates/slides. User can edit line 14 to adjust threshold of R^2 desired to be evaluated. Now code can be run to observe slides/replicates with R^2 value at or above identified threshold. Index of slides will be printed in command window.

To generate averaged adhesion curve use "getAverageAdhesionCurve.m". To run script "ComsolShears.mat" is needed. User will edit line 8 to identify directory where all slides/replicates are stored. User will edit line 13 to indicate replicates to include in average adhesion curve. Now code can be run to achieve average adhesion curve.

