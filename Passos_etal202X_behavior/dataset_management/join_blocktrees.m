% [] = join_blocktrees(block_trees_dir, output_dir)
%
% DESCRIPTION: This function gets block tree structures of each volunteer 
% in the folder <block_trees_dir>, merge them volunteer-wise and saves it
% in the folder <output_dir>
%
% INPUT:
%
% block_trees_dir = folder containing the block tree structures. Files must
% follow the pattern ex.: vol01_EEGtrees_blockB1
% 
%
% OUTPUT:
%
% output_dir = folder where the merged files are saved.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 29/01/2025


function  [] = join_blocktrees(block_trees_dir, output_dir)

    % Getting the name of all files

    all_files = dir(block_trees_dir);

    % Getting the files of a given subject all together

    cont = 1;
    while cont == 1
        cont = 0;
        pos = [];
        for f = 1:length(all_files)
           if ( length(all_files(f).name) >=3 ) && ( strcmp(all_files(f).name(1:3),'vol') )
              cont = 1; 
              pos = [pos f];
              for p = f+1:length(all_files)
                  if strcmp(all_files(f).name(1:5),all_files(p).name(1:5))
                     pos = [pos p];
                  end
              end
              break
           end
        end
        if cont == 0
           break 
        end 

        % Sorting according to position
        pos_f = [];
        for p = 1:length(pos)
           pos_f = [pos_f str2num( all_files( pos(p) ).name(end-4) ) ]; 
        end
        [~,I] = sort(pos_f);
        pos = pos(1,I);

        % Opening the files
        for l = 1:length(pos)
           load( [ all_files( pos(l) ).folder '\' all_files( pos(l) ).name ], 'summary_repo');
           elem = 1;
           % Cleaning the files
           while elem < length(summary_repo)
              if isempty(summary_repo(elem).subj_num)
                 summary_repo(elem) = [];
              else
                 elem = elem + 1;
              end
           end
           if l == 1
              final_repo = summary_repo; 
           else
              final_repo = [final_repo; summary_repo];
           end
        end

        summary_repo = final_repo;
        save([output_dir '\trees_vol' ...
            all_files(pos(1)).name(4:5) '.mat'], 'summary_repo') 

        % Eliminating the rows of processed files
        all_files(pos) = [];

        % Cleaning variables
        clearvars summary_repo final_repo    
    end

end