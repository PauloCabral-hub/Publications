% ncut = prun_criteria(contexts, schain, rtchain)
%
% Returns a integer <ncut> which indicates if the contexts indicate   in 
% <contexts> should be prunned according to <schain> and <rtchain>. If  the 
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
% rtchain    = row vector containing a sequence of real numbers conditioned to
%            <schain>
%
% OUTPUT:
% ncut    = is set to 1 if the contexts in contexts should not be prunned.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 02/08/2023


function ncut = prun_criteria(contexts,schain, rtchain)

% discarding empty contexts
holder = cell(1,1); aux = 1;
for a = 1:size(contexts,2)
  if ~isempty(contexts{1,a})
      holder{1,aux} = contexts{1,a}; aux = aux+1;
  end
end
contexts = holder;


[~, loc, count] = count_contexts(contexts, schain);

celldist = cell(1,length(contexts));

for a = 1:length(contexts)
   for b = 1:count(a,1)
      if (loc(a,b)+1) <= length(rtchain)
      celldist{1,a} = [celldist{1,a}; rtchain(1,(loc(a,b)+1))];
      end
   end
end

compare = combnk(1:size(contexts,2),2);

results = zeros(size(compare,1),1);


for a = 1:size(compare,1)
x = celldist{1,compare(a,1)};
y = celldist{1,compare(a,2)};
results(a,1) = kstest2(x,y);
end

if sum(results,1)/length(results) ~=0
ncut = 1;
else
ncut = 0;
end

end

