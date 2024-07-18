
# Context tree drawing using tikz package

Observation: All functions in sub-repositories may use the functions  in 
<general_purpose_functions>. 

The functions in this repository are used to automatically write the code
necessary for drawing the tree in Latex Tikz package. Details of the  use
of each function are presented in  the  function   heading.  The  calling
tree bellow shows which functions are called from another in this reposi-
tory.

| Calling Tree |
tikz_tree
	permwithrep
	build_verticetree
		full_tree_with_vertices
	gen_imsufix
	write_tree