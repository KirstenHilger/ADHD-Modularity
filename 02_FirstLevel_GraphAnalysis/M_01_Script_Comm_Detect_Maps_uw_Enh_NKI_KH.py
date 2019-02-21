#!/usr/bin/python
# -*- coding: utf-8 -*-

## ----------------------------------------------------------------------------------------------------------##
##
## This script was coded by Kirsten Hilger for community detection for the paper:
## "ADHD Symptoms are Associated with the Modular Structure of Intrinsic Brain Networks in a Representative 
## Sample of Healthy Adults", doi: https://doi.org/10.1101/505891, 
## https://www.biorxiv.org/content/10.1101/505891v1
##
## ----------------------------------------------------------------------------------------------------------##


"""
python /mnt/flab/kirsten/IQ_Connect/scripts/analysis/M_01_Script_Comm_Detect_Maps_uw_Enh_NKI_KH.py
"""

import numpy as np
import os.path
from nt import *

from time import time
import cPickle
#import h5py
import nibabel as nib
import igraph


# ------------------------------------------------------------------ #
PROJECT = '01_Enh_NKI'
# ------------------------------------------------------------------ #
# SUBJECTS

# textfile with the names of all subjects:
file='/data/hippocampus/01_Enh_NKI/04_Subject_lists/Enh_NKI_Subjects_17-60_N309.txt'

# data structure:
DATA_DIR='/data/hippocampus'
project_dir='/data/hippocampus/%s' %(PROJECT)
sub_path='/data/hippocampus/01_Enh_NKI/01_Data_NKI_fMRT'# %(PROJECT)
SUBJ_DIR='/data/hippocampus/01_Enh_NKI/01_Data_NKI_fMRT/001_EnhNKI_17-60_N312'# %(PROJECT)
SUBJECTS = np.loadtxt(os.path.join(sub_path, file), dtype='string')
SUBJECTS= np.atleast_1d(SUBJECTS)
n_subjects = SUBJECTS.size


# ------------------------------------------------------------------ #
TR=2.5
# ------------------------------------------------------------------ #

# threshold for the adj matrix, here you can vary between 0.1, 0.15...0.3..
thr=0.15

# load this only once; it's the same for all subjects
MASK = "/data/hippocampus/01_Enh_NKI/MNI152_T1_3mm_brain_mask_no_white_no_brainstem_no_cerebellum_subsamp2.nii.gz" # mask is provided in the network toolbox (Ekman & Linsen, 2015)
M = connectivity_mask(MASK)

for s in range(SUBJECTS.size):     # loops over all subjects specified in text file
    subj_id = SUBJECTS[s]
    t0=time()       
    BOLD_PATH = '%s/%s/01_Data_NKI_fMRT/001_EnhNKI_17-60_N312/%s/func' %(DATA_DIR, PROJECT, subj_id)  

  
    # ------------------------------------------------------------------------ # 
    
    print '>>> loading data', subj_id
    FUNC = '%s/functional_scan_res2standard_ss2.nii.gz' %(BOLD_PATH)    # input data, my functional scan
    ts = load_mri(FUNC, MASK)      # time series data
    
    print ts.shape
    # ------------------------------------------------------------------------ # 
    # GT analysis
    # ------------------------------------------------------------------------ # 
    A = adj_static(ts)   # calculates adjacency matrix
    A[A<0] = 0.          # sets all negative edges to zero
    
    A = thresholding_M(A, M. todense()) # exclude direct neighbors see Power et al. (2012)
    A = thresholding_prop(A, thr) # thresholding
    A = make_unweighted(A) # binarizing 
    
    print number_edges(A)
    print number_nodes(A)
    
    n2c, info = louvain(A, weighted=False) # provides the partition information 
    Q = info            # global modularity
    
    stats = partition_stats(n2c)   # hier sollen die drei Kennwerte (Anzhal der Module, Nodes per Modul, SD) gespeichert werden
    
    z = within_module_degree_z_score(A, partition=n2c) # calculate map for z based on the modular partition
    p = participation_coefficient(A, partition=n2c)   # calculate map for p based on the modular partition
    
    stats, labels = zp_parameter_space_stats(z, p, perc=True, zbreak=1)  # nodes types in accordance to Guimera & Amaral (2005)
    
    fname1 = '%s/participation_coefficient_voxelwise6x6x6_Th0.15_uw.nii.gz'%(BOLD_PATH) # saves p map
    save_mri(p, MASK, fname1)
    fname2 = '%s/within_module_DC_Zscore_voxelwise6x6x6_Th0.15_uw.nii.gz'%(BOLD_PATH) # saves z map
    save_mri(z, MASK, fname2)
    fname3 = '%s/labels_voxelwise6x6x6_Th0.15_uw.nii.gz'%(BOLD_PATH) # saves labels for node types
    labels_array = np.asarray(labels)
    save_mri(labels_array, MASK, fname3)
    fname4 = '%s/n2c_modulpartition_voxelwise6x6x6_Th0.15_uw.nii.gz'%(BOLD_PATH) # saves partition
    save_mri(n2c+1, MASK, fname4)
    
    # - #
    print ' SUBJ:', s+1, SUBJECTS.size, ' calc time:', np.round((time()-t0)/60.,4), 'min'  # prints some valuable infos to see the progress :-)
            
      



