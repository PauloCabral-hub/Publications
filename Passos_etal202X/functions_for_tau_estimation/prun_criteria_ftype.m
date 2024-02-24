% ncut = prun_criteria_ftype(contexts, schain, sig_set, proj_num, sample_stretch)
%
% Returns a integer <ncut> which indicates if the contexts indicate   in 
% <contexts> should be prunned according to <schain> and <sig_set>. If  the 
% the test indicates that at least one of the contexts are different, no
% prunning is suggested.
% 
% INPUT:
%
% contexts   = cell with a vector representing a different context in each co-
%            lumn. These contexts present the same sufix and the only   diffe-
%            rence is the leftmost symbol.
% schain     = row vector containing a sequence in which the elements of  <le-
%            afs> are searched.
% sig_set    = row cell containing the associated signals (EXG) associated
%              whith each entry of <chain>
% proj_num   = number of projections to make for the pruning criteria.
% sample_stretch = length in samples of the functional to be used in the 
%              the projection test.
%
% OUTPUT:
% ncut    = is set to 1 if the contexts in contexts should not be prunned.

function [ncut, mosaic] = prun_criteria_ftype(contexts, schain, sig_set, proj_num, sample_stretch, mosaic)

% discarding empty contexts
holder = cell(1,1); aux = 1;
for a = 1:size(contexts,2)
  if ~isempty(contexts{1,a})
      holder{1,aux} = contexts{1,a}; aux = aux+1;
  end
end
contexts = holder;


[~, loc, count] = count_contexts(contexts, schain);

celldist = cell(max(count),length(contexts));
 
for a = 1:length(contexts)
   for b = 1:count(a,1)
      if (loc(a,b)+1) <= length(schain)
        celldist{b,a} = sig_set{ loc(a,b)+1,1 };
      end
   end
end

compare = combnk(1:size(contexts,2),2);

results = zeros(size(compare,1),1);
fresults =  zeros(size(compare,1),1);

for a = 1:size(compare,1)
A = celldist( :,compare(a,1) );
B = celldist( :,compare(a,2) );
    for b = 1:proj_num
        if rem(b,100) == 0
            fprintf('Processing...performing projection tests: %d %% \n', floor(100*b/proj_num) );
        end
        [proj_vals, proj_labels] = get_projections(A, B, sample_stretch);
        partial_result = kstest2(proj_vals(proj_labels == 1), proj_vals(proj_labels == 2));
        results(a,1) = results(a,1) + partial_result;
    end
    fprintf(['Accepted/Rejected Ratio = ' num2str( results(a,1)/proj_num) '\n']);
    if results(a,1) > ceil(0.0552*proj_num)
       fresults(a,1) = 1;
    end
end

if sum(fresults)/length(fresults) ~=0
    ncut = 1;
    fprintf('Result of proj. test...KEEP \n');
    for a = 1:length(contexts)
       for b = 1:count(a,1)
          if (loc(a,b)+1) <= length(schain)
            mosaic = [mosaic sig_set{ loc(a,b)+1,1 }'];
          end
       end    
    end
    
else
    ncut = 0;
    fprintf('Result of proj. test...PRUNNED \n');
end

end

