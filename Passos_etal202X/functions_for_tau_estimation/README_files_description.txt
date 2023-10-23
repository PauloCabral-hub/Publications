
# Context tree estimation from a sequence of symbols and  an  associated 
sequence of real values

Observation: All functions in sub-repositories may use the functions  in 
<general_purpose_functions>. 

The functions in this repository are used to estimate a context tree. De-
tails of the use of each function are presented in the function  heading.
The calling tree bellow shows which functions are called from another  in
this repository.

| Calling Tree |
tauest_real
	permwith_rep
	cut_branch
		count_contexts
		prun_criteria
			count_contexts
            get_projections
                brownianbridge
		brother_suffofacontexts
		clean_zeorcounts
		removing_branch_how
			insert_s