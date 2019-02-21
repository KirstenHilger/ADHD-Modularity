# ADHD-Modularity
Analyses Code for Hilger &amp; Fiebach (2018): ADHD Symptoms are Associated with the Modular Structure of Intrinsic Brain Networks in a Representative Sample of Healthy Adults, doi: https://doi.org/10.1101/505891, https://www.biorxiv.org/content/10.1101/505891v1. 

The following text provides a detailed description of the analysis pipeline used in the paper “ADHD Symptoms are Associated with the Modular Structure of Intrinsic Brain Networks in a Representative Sample of Healthy Adults” coauthored by Kirsten Hilger and Christian Fiebach (doi: https://doi.org/10.1101/505891, https://www.biorxiv.org/content/10.1101/505891v1). 

It provides detailed instructions how to use the scripts in this folder and informs about all relevant hyperlinks to databases, preprocessing scripts and software used in our analyses as well as manually used code.

## 1.	Data
The data used for the present study was acquired by the Nathan S. Kline Institute for Psychiatric Research (NKI) and released as part of the 1000 functional connectomes project, which is an international neuroimaging data-sharing initiative (Nooner et al., 2012). 

Data can be downloaded from: http://www.nitrc.org/ir/app/template/XDATScreen_report_xnat_projectData.vm/search_element/xnat:projectData/search_field/xnat:projectData.ID/search_value/nki_rockland

For more detailed information see:
http://fcon_1000.projects.nitrc.org/indi/pro/nki.html

## 2. 	Preprocessing
Preprocessing scripts that have been released as part of the 1000 Functional Connectomes Project, Biswal et al., 2010: http://www.nitrc.org/projects/fcon_1000

Computer requirements to run the preprocessing scripts are:
•	Unix-compatible operating system
•	AFNI (http://afni.nimh.nih.gov/afni)
•	FSL (http://www.fmrib.ox.ac.uk/fsl)
•	AFNI and FSL commands require to be generally accessible at the command prompt (i.e., located in the path of the user; see documentation on AFNI and FSL websites)

All preprocessing scripts are bash scripts and can be called from a bash shell directly by using bash scriptname.sh or sh scriptname.sh. Here, we used the option to run the preprocessing scripts in an hierarchical manner by using a batch script on top (batch_process_Rockland_only.sh), which specifies the names of the data to be preprocessed, what to do in general, the brain template used for registration (templates/MNI152_T1_3mm_brain.nii.gz), and initializes the next level script (0_preprocess.sh), in which the preprocessing parameters are defined in more detail. This script (0_preprocess.sh) initializes the following scripts: 1_anatpreproc.sh, 2_funcpreproc.sh, 3_registration.sh, 4_segment.sh and 5_nuisance.sh, which comprise the code required to preprocess the data comprehensively. All these scripts have to be located in one folder. Furthermore, this hierarchical preprocessing requires two textfiles. In the first file (batch_list_Rockland_only.txt) six input parameters has to be written in one line separated by spaces: the main directory to the data, the full path to the subject list, the first timepoint to use (default = 0 as timepoint counting starts at 0), the last timepoint to use (default = number of timepoints -1), the number of timepoints in the resting-state scan, and finally the TR. The second textfile (here batch_list_Rockland_only.txt) includes the subject list. For both textfiles we created an example, which you can find in the preprocessing folder and use for your analyses. 

To be able to run also other preprocessing options provided by the scripts, it is useful to download also the following files: example_seed_list.txt and Fox_seed_list.txt as well as the folders seeds/, templates/, and tissuepriors/, which contain data required for more advanced preprocessing options as well as several standard brain templates that can be used for registration. You can find all these data in the respective preprocessing folder. 

## 3. 	First Level Graph Analysis
3.1. General Processing Steps
To compute subject specific graph metrics we used the open source python package “network-tools” (Ekman & Linssen, 2015), which can be downloaded from the following link:
http://dx.doi.org/10.5281/zenodo.14803
As the toolbox bases on the python programming language (https://www.python.org/), the respective commands can be implemented in any python script. The scripts used in our first level analyses are located in the folder: 02_FirstLevel_GraphAnalysis. 
Before computing the graph metrics, we downsampled the preprocessed images (named functional_scan_res2standard.nii automatically by the preprocessing pipeline) from 3x3x3 mm space into 6x6x6 mm space by using FSL and the following command, which can be called directly from the bash shell:
```
fslmaths functional_scan_res2standard.nii -subsamp2 functional_scan_res2standard_ss2.nii
```
The resulting file (functional_scan_res2standard_ss2.nii) served as basis for all subject specific computations of the graph metrics. 

3.2. Modularity
As outlined in the manuscript, community detection was performed on five different sparsity thresholds (i.e., 10%, 15%, 20%, 25%, 30%). This was done by running the script M_01_Script_Comm_Detect_Maps_uw_Enh_NKI_KH.py five times, i.e., one time for each threshold. Note, that the script needs to access a textfile (here: Rockland_Subjects_18_30.txt) that should be located in the script folder and defines all subject’s names. You can find our text file as an example in the 02_FirstLevel_GraphAnalysis folder. The resultant subject specific pi and zi maps were upsampled into 3 x 3 x 3 mm space and integrated across thresholds to one average nodal efficiency map for each subject by using flirt, fslmerge, flsmaths, and the following commands:

1. Upsampling (e.g. for threshold 20%):
```
flirt -in participation_coefficient_voxelwise6x6x6_Th0.20_uw -ref functional_scan_res2standard.nii -applyxfm -usesqform -out participation_coefficient_voxelwise6x6x6_Th0.20_uw_up3x3x3.nii
```

2. Combining images with fslmerge across thresholds:
```
fslmerge -t combined_by_fslmerge_PC_0.10-0.30.nii participation_coefficient_voxelwise6x6x6_Th0.10_uw_up3x3x3.nii participation_coefficient_voxelwise6x6x6_Th0.15_uw_up3x3x3.nii participation_coefficient_voxelwise6x6x6_Th0.20_uw_up3x3x3.nii participation_coefficient_voxelwise6x6x6_Th0.25_uw_up3x3x3.nii participation_coefficient_voxelwise6x6x6_Th0.30_uw_up3x3x3.nii
```

3. Calculating the average across thresholds with fslmaths:
```
fslmaths combined_by_fslmerge_PC_0.10-0.30 -Tmean combined_by_fslmerge_PC_0.10-0.30_average
```

The resultant subject specific maps (combined_by_fslmerge_PC_0.10-0.30_average.nii, combined_by_fslmerge_Z_0.10-0.30_average.nii) were renamed to participation_coefficient_thresholdaverage_by_fslmaths_0.10-0.30_after_up3x3x3.nii (within_module_DC_Zscore_thresholdaverage_by_fslmaths_0.10-0.30_after_up3x3x3.nii) and served as input for all group analyses, described below.

## 4. 	Second Level Group Analysis – Effects Between Graph Metrics and ADHD Symptoms
4.1. Participation coefficient/within-module degree and ADHD symptoms
To test for any ADHD-related effects in pi and zi by simultaneously controlling for age, sex and handedness, FSIQ and mean framewise displacement, we set up a regression model with SPM (http://www.fil.ion.ucl.ac.uk/spm/software/), which runs on the MATLAB platform (http://www.mathworks.com).

The computation of group effects relies on two scripts: The first script (i.e., sl_ADHD_contr_A_S_H_IQ_FD_PC_uw_10bis30_NKI_exFD_KH.m, sl_ADHD_contr_A_S_H_IQ_FD_Z_uw_10bis30_NKI_exFD_KH.m) contains all relevant input data (subject specific covariate values), as well as further specifications about the data structure and the desired output. The second script (i.e., sl_ADHD_contr_Age_Sex_Hand_IQ_FD_NKI_KH_job.m) defines the regression model itself. To run the respective model, both scripts have to be located in one folder and added to your MATLAB path. Computation starts by initializing the script sl_ADHD_contr_A_S_H_IQ_FD_PC_uw_10bis30_NKI_exFD_KH.m in the MATLAB command window, which automatically calls on sl_ADHD_contr_Age_Sex_Hand_IQ_FD_NKI_KH_job.m. Results of the group analysis can be inspected by loading the spmT_0001.img file in any fMRT-compatible viewer (e.g., xjviewer, fslview).

To correct the resultant p-values for multiple comparisons, we used a cluster-level thresholding procedure. An overall threshold of p < .05 (FWE-corrected) was achieved by combining a voxel-level threshold of p < .005 with a cluster-level threshold of k > 26 voxels. This critical cluster level threshold was calculated by using AlphaSim (Ward, 2000), the standard 3mm mask without cerebellum provided by the network toolbox used in our analyses, 10000 permutations, and the following code:
```
AlphaSim -mask MNI152_T1_3mm_brain_mask_no_white_no_brainstem_no_cerebellum_subsamp0.nii.gz -iter 10000 -pthr 0.005 -fwhm 6.0 -out /mnt/flab/kirsten/IQ_Connect/AlphaSim/output/alphasim_pthr_0.005_Rockland_SeedAnalyse.out
```
4.2. Global modularity values and ADHD symptoms
To investigate ADHD-related effects in global modularity Q, number of modules, average mode size and variability in module size, the subject specific values were correlated with ADHD index offline by using R (https://www.r-project.org/) and a critical alpha level of p < .05.

5. 	References
Biswal, B. B., Mennes, M., Zuo, X.-N., Gohel, S., Kelly, C., Smith, S. M., … Milham, M. P. (2010). Toward discovery science of human brain function. Proceedings of the National Academy of Sciences of the United States of America, 107(10), 4734–9. doi:10.1073/pnas.0911855107
Ekman, M., & Linssen, C. (2015) Network-tools: Large-scale Brain Network Analysis in Python. Available at: http://dx.doi.org/10.5281/zenodo.14803
Nooner, K. B., Colcombe, S. J., Tobe, R. H., Mennes, M., Benedict, M. M., Moreno, A. L., … Milham, M. P. (2012). The NKI-Rockland Sample: A Model for Accelerating the Pace of Discovery Science in Psychiatry. Frontiers in Neuroscience, 6(October), 152. doi:10.3389/fnins.2012.00152
Ward, B. D., 2000. Simultaneous inference for FMRI data. Retrieved from http://stuff.mit.edu/afs/sipb.mit.edu/project/seven/doc/ AFNI/AlphaSim.ps

## Citation:
Feel free to use the code for your analyses. Citating Hilger & Fiebach (2018) as well as this github repository (http://doi.org/10.5281/zenodo.2574588) is necessarily required.

Hilger, K., & Fiebach, C., J. (2018). ADHD Symptoms are Associated with the Modular Structure of Intrinsic Brain Networks in a Representative Sample of Healthy Adults. bioRxiv, 505891. doi: https://doi.org/10.1101/505891

