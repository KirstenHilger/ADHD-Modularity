
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MATLAB CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This script was used to run the group analysis in spm to test for ADHD-related effects in 
%% within-module degree centrality by simultaneously controlling for effects of age, sex, handedness,
%% mean FD and FSIQ. 
%% The resultant effects were published: "ADHD Symptoms are Associated with the Modular Structure of 
%% Intrinsic Brain Networks in a Representative Sample of Healthy Adults", doi: https://doi.org/10.1101/505891, 
%% https://www.biorxiv.org/content/10.1101/505891v1
%%
%% coded by Kirsten Hilger	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Sex';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'WAIS_FULL';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'ADHD';
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(4).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(4).cname = 'Age';
matlabbatch{1}.spm.stats.factorial_design.cov(4).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(4).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(5).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(5).cname = 'Hand';
matlabbatch{1}.spm.stats.factorial_design.cov(5).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(5).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(6).c = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.cov(6).cname = 'FD';
matlabbatch{1}.spm.stats.factorial_design.cov(6).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(6).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec = {};
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec = {};
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0 0 0 1 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
