
# Context tree mode estimation from a set of trees

Observation: All functions in sub-repositories may use the functions  in 
<general_purpose_functions>. 

The functions in this repository are used to estimate a mode context tree. 
Details of the use of each function are presented in  the  function  head-
ing. The calling tree bellow shows which functions are called from another
in this repository.

| Calling Tree |
taumode_est
	mode_cutbranch
		removing_branch_how
		caseforcut
		brother_suffofacontext
		clean_nonest
	output_trees_set
	ctx_trees_count
	permwith_rep