% tree_seq = gen_tree_sequence(ctxs, PM, seq_len)
%
% Description: Generates a sample sequence following the context tree
% provided.
%
% INPUT:
% ctxs = cell containing the contexts of the probabilistic context tree
% PM = probability matrix of the probabilistic context tree
%
% OUTPUT:
% tree_seq = sample sequence generated from the probabistic context tree*
%
% Attention: the sequence is not generated following the univariate
% measure.
%
% Author: Paulo Roberto Cabral Passos     Last modified = 29/02/2024

function tree_seq = gen_tree_sequence(ctxs, PM, seq_len)

% Determining the alphabet (FUTURE FUNCTION)

alphabet = [];
for a = 1:length(ctxs)
    alphabet = [alphabet ctxs{a}]; %#ok<AGROW>
end
alphabet = sort(unique(alphabet));

% Determining which will be the first context

tree_seq = zeros(1,seq_len);
prime = randi([1 length(ctxs)],1);
tree_seq(1,1:length(ctxs{1,prime})) = ctxs{1,prime};
start = length(ctxs{1,prime})+1;

% Constructing the cumulative probability matrix

CM = zeros(size(PM,1),size(PM,2));
for a = 1:size(PM,1)
   aux = 0;
   for b = 1:size(PM,2)
   CM(a,b) = PM(a,b)+aux;
   aux = CM(a,b);
   end
end

% Generating the sequence

for a = start:seq_len
    for b = 1:length(ctxs)
       ctx = ctxs{1,b};
       st = (a-1)-length(ctx)+1; ed = a-1;
       if (st)>0
            qmark = sum(tree_seq(1,st:ed) == ctx,2)/length(ctx); 
            if qmark == 1
            draw = rand(1,1);
                for c = 0: (length(alphabet)-1)
                    if draw < CM(b,length(alphabet)-c)
                       next = length(alphabet)-c;
                    else
                        break;
                    end
                end
                tree_seq(1,a) = alphabet(1,next);
            end
       end
    end
end



end




