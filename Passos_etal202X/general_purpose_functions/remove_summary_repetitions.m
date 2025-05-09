% summary_repo = remove_summary_repetitions(summary_repo)
%
% DESCRIPTION: This function processes the <summary_repo> structure to 
% identify and remove duplicate entries based on unique 'chan', 'subj_num'
%'from' fields. It ensures that only the first occurrence of each unique 
% combination of 'chan' and 'from' is retained, removing any subsequent 
% duplicates.
%
% INPUT:
%
% summary_repo  - Structure containing the data to process
%
% OUTPUT:
%
% summary_repo  - Processed structure with duplicates removed.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function summary_repo = remove_summary_repetitions(summary_repo)

    % Getting Unique Channels
    del_list = [];
    chan_list = {};
    
    disp('Checking all channels')
    for a = 1:length(summary_repo)
        if isempty(chan_list) && ( ~isempty( summary_repo(a).chan ) ) 
           chan_list = [chan_list ; summary_repo(a).chan];
        else
            include = 1;
            for b = 1:length(chan_list)
               if isequal(summary_repo(a).chan, chan_list{b})
                  include = 0;
               end
            end
            if include == 1
               chan_list = [chan_list ; summary_repo(a).chan];
            end
        end
    end

    % Getting Unique 'From' Fields

    del_list = [];
    from_list = [];
    
    disp('Checking all trial initiations')
    for a = 1:length(summary_repo)
        if isempty(from_list)
           from_list = [from_list ; summary_repo(a).from];
        else
            should_idel = 0;
            for b = 1:length(from_list)
               if isequal(summary_repo(a).from, from_list(b))
                  should_idel = 1;
               end
            end
            if should_idel == 0
               from_list = [from_list ; summary_repo(a).from];
            end
        end
    end

    % Getting Unique 'subj_num' Fields
    
    del_list = [];
    num_list = [];
    
    disp('Checking all subjects')
    for a = 1:length(summary_repo)
        if isempty(num_list)
           num_list = [num_list ; summary_repo(a).subj_num];
        else
            should_idel = 0;
            for b = 1:length(num_list)
               if isequal(summary_repo(a).subj_num, num_list(b))
                  should_idel = 1;
               end
            end
            if should_idel == 0
               num_list = [num_list ; summary_repo(a).subj_num];
            end
        end
    end
    
    

    % Removing Repetitions
    
    del_list = [];
    for a = 1:length(chan_list)
       disp([ 'Removing duplicates ... ' num2str(a/length(chan_list)) ])
       cur_chan = chan_list{a};
       for b = 1:length(from_list)
          cur_from = from_list(b);
          for c = 1:length(num_list)
                cur_num = num_list(c);
                first = 0;
                for d = 1:length(summary_repo)
                    if isequal(summary_repo(d).chan, cur_chan)...
                            && isequal(summary_repo(d).from, cur_from)...
                                && isequal(summary_repo(d).subj_num, cur_num)
                       if first == 1
                          del_list = [del_list d];
                       else
                          first = 1;
                       end
                    end                                        
                end
          end
       end
    end

    % Remove duplicates from summary_repo
    summary_repo(del_list) = [];
end
