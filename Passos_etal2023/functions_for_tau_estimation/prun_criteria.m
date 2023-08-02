% ncut = prun_criteria(leafs,schain, rtchain)
%
% Returns a integer <ncut> which indicates if the contexts indicate   in 
% <leafs> should be prunned according to <schain> and <rtchain>. If  the 
% the test indicates that at least one of the contexts are different, no
% prunning is suggested.
% 
% INPUT:
%
% leafs   = cell with a vector representing a different context in each co-
%           lumn. These contexts present the same sufix.
% schain  = row vector containing a sequence in which the elements of <le-
%           afs> are searched.
% rtchain = row vector containing a sequence of real numbers conditioned 
%           to <schain>
%
% OUTPUT:
% ncut    = is set to 1 if the contexts in leafs should not be prunned.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 02/08/2023


function ncut = prun_criteria(leafs,schain, rtchain)

% discarding empty leafs
holder = cell(1,1); aux = 1;
for a = 1:size(leafs,2)
  if ~isempty(leafs{1,a})
      holder{1,aux} = leafs{1,a}; aux = aux+1;
  end
end
leafs = holder;


[~, loc, count] = count_contexts(leafs, schain);

celldist = cell(1,length(leafs));

for a = 1:length(leafs)
   for b = 1:count(a,1)
      if (loc(a,b)+1) <= length(rtchain)
      celldist{1,a} = [celldist{1,a}; rtchain(1,(loc(a,b)+1))];
      end
   end
end

compare = combnk(1:size(leafs,2),2);

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

