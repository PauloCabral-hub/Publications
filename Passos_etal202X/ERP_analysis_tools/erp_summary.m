% [gerp, ierp_easy_access, gerp_test_ref,...
%    gcerp, icerp_easy_access, gcerp_test_ref] = erp_summary(repo,...
%    bmkr,emkr,plen,align_method,tree_file_address, alpha)
%
% DESCRIPTION: The function calcutates the ERP based on data of <repo> from
% function <pack_data>. The function calculates the subjects ERPs by
% electrode, the respective grand_averages. The function also calculates
% this by contexts following <bdata> in repo.
%
% INPUT:
%
% repo = structure in the output of function <pack_data>.
% bmkr = string that indicates the left edge of the signal snippet. *[1]
% emkr = string that indicates the right edge of the signal snippet.*[1]
% plen = *[2]
% align_method = 'left' or 'right' indicates how the ERPs will be aligned.
% That is, left and right indicates alignment with bmkr and emkr,
% respectively.
% tree_file_address = address to the file containing the tree structure
% used in identify the contexts.
% alpha = significance level used in the test
% 
% OUTPUT:
%
% gerp = grand-averages ERPs by context. (electrodes - rows,
% samples - columns)
% ierp_easy_access = cell ERPs of each subject. Each cell field indicates a
% different electrode. Inside each cell (subjects -rows, samples - columns)
% gerp_test_ref = Indicates where the ERP is significantly different from
% zero using benjamini-hochberg multiple comparison correction. 
% (electrodes - rows, samples - columns)
% gcerp = Same as <gerp>, the third dimension indicates the contexts in
% lexographical order.
% icerp_easy_access = Same as <ierp_easy_access>,the third dimension 
% indicates the contexts in lexographical order.
% gcerp_test_ref =  Same as <gerp_test_ref>,the third dimension 
% indicates the contexts in lexographical order.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 11/04/2025
%
% [1] Only 'd3' and 'd4' were configured
% [2] Since the length can vary, this defines the interval based on the
% distribution of lengths. If 0.75, for example, it will consider that
% the interval to be 0.75 of the distribution of lengths and, for those
% with less or more, it will zero-padd the signal.    

function [gerp, ierp_easy_access, gerp_test_ref,...
    gcerp, icerp_easy_access, gcerp_test_ref] = erp_summary(repo,...
    bmkr,emkr,plen,align_method,tree_file_address, alpha)

     % PARAMETERS FOR TESTING THE FUNCTION
%     bmkr = 'd4';
%     emkr = 'd3';
%     plen = 0.75; % percentily cut [1]*
%     align_method = 'right';
%     tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';

    % Reading

    %   Number of subjects
    subjs_num = size(repo,1);
    %   Number of electrodes
    elec_num = size(repo{1,1},1);
    %   Number of trials
    ntrials = size(repo{1,2},1);
    %   Sample rate
    srate = repo{1,3}.srate;

    % forward option
    if isequal(bmkr,'d3')
       b_mref = 13;
       if isequal(emkr,'d4')
          e_mref = 14;
          shift = 0;
          from = 1;
          till = ntrials;
       end
    end

    % backward option
    if isequal(bmkr,'d4')
       b_mref = 14;
       if isequal(emkr,'d3')
          e_mref = 13;
          shift = 1;
          from = 1;
          till = ntrials-1;      
       end
    end

    if ~exist('shift')
       disp('Unexistant marker or unconfigured pair of markers.')
       return
    end


    basel_len = round(srate/5);

    cut_repo = cell( subjs_num, till , elec_num);
    base_repo = cut_repo;
    lablen_repo = zeros( till, subjs_num , 2); 

    % Cutting the signals

    for a = 1:subjs_num
       disp(['Cutting the signals ' num2str(a/subjs_num) ])
       eeg_data = repo{a,1};
       bdata = repo{a,2};
       [bdata, contexts] = label_contexts(tree_file_address, bdata); % INPUT: tree_file_address
       for b = 1:elec_num
           eeg_sig = eeg_data(b,:);
           sig_len = zeros( till, 1 );
           label_track = zeros( till, 1 );
           for c = 1:size(bdata,1)-1
               cut_repo{a,c,b} = eeg_sig( bdata(c,b_mref): bdata(c+shift,e_mref) );
               sig_len(c) = length(cut_repo{a,c,b});
               base_repo{a,c,b} = eeg_sig( bdata(c,b_mref) - basel_len:bdata(c,b_mref)); % baseline
               label_track(c) = bdata( c, size(bdata,2) );
           end
       end
       lablen_repo(:,a,1) = label_track;
       lablen_repo(:,a,2) = sig_len;
    end

    % Homogeneize, align and baseline in subject level
    
    cut_repo_layer = cell( size(cut_repo,1), size(cut_repo,2), size(cut_repo,3) );
    for a = 1:size(lablen_repo,2) % subject
        disp(['Homegeneizing, aligning and baselining ' num2str(a/size(lablen_repo,2)) ])
        final_len = round( quantile(lablen_repo(:,a,2),plen) );
        for c = 1:size(cut_repo,3) % electrodes
            for d = 1:size(cut_repo,2) % trials
                sig = cut_repo{a,d,c}-mean(base_repo{a,d,c});
                if length(sig) > final_len
                   lsig = ones(1,final_len);
                   sig = sig(1:final_len);
                elseif length(sig) < final_len && isequal(align_method,'left')
                   zpad = zeros(1, final_len - length(sig) );
                   lsig = [ones(1, length(sig)) zpad];
                   sig = [sig zpad];
                else
                   zpad = zeros(1, final_len - length(sig) );
                   lsig = [zpad ones(1, length(sig))];
                   sig = [zpad sig];
                end
                cut_repo{a,d,c} = sig;
                cut_repo_layer{a,d,c} = lsig;
            end    
        end
    end

    % Calculating the ERPs: subject level

    erp_repo = cell(elec_num,subjs_num);
    for a = 1:size(cut_repo,1) % subject
       disp(['Calculating the ERPs ' num2str(a/size(lablen_repo,2)) ])
       for b = 1:size(cut_repo,3) % electrode
          sig_len = length(cut_repo{a,1,1});
          mid_erp = zeros( size(cut_repo,2), sig_len );
          mid_erp_layer = zeros( size(cut_repo,2), sig_len ); 
          for c = 1:size(cut_repo,2) % trial
              mid_erp(c,:) = cut_repo{a,c,b};
              mid_erp_layer(c,:) = cut_repo_layer{a,c,b};
          end
          merp = zeros(1,sig_len);
          for d = 1:sig_len
              non_zero = find( mid_erp_layer(:,d) == 1);
              merp(1,d) = mean( mid_erp( non_zero, d ) ); %#ok<FNDSB>
          end
          erp_repo{b,a} = merp;
       end
    end


    % Calculating the ERPs by context: ADAPT

    cerp_repo = cell(elec_num,subjs_num, length(contexts) );
    for a = 1:size(cut_repo,1) % subjects
       disp(['Calculating the ERPs by context ' num2str(a/size(lablen_repo,2)) ])
       for b = 1:size(cut_repo,3) % electrodes
          sig_len = length(cut_repo{a,1,1});
          mid_erp = zeros( size(cut_repo,2), sig_len );
          mid_erp_layer = zeros( size(cut_repo,2), sig_len );
          mid_lab = zeros( size(cut_repo,2), 1 );
          for c = 1:size(cut_repo,2) 
              mid_erp(c,:) = cut_repo{a,c,b};
              mid_erp_layer(c,:) = cut_repo_layer{a,c,b};
              mid_lab(c,1) = lablen_repo(c,a,1);
          end
          for d = 1:length(contexts)
              erp_selection = mid_erp( mid_lab == d, :);
              layer_selection = mid_erp_layer( mid_lab == d, :);
              merp = zeros(1,sig_len);
              for e = 1:sig_len
                  non_zero = find( layer_selection(:,e) == 1);
                  merp(1,e) = mean( erp_selection( non_zero, e ) ); %#ok<FNDSB>
              end
              cerp_repo{b,a,d} = merp; 
          end
       end
    end

    % Calculating the length of the grand-average

    min_len = 10^10;
    for a = 1:size(erp_repo,2)
       cur_sig = erp_repo{1,a};
       if size(cur_sig,2) < min_len
          min_len = size(cur_sig,2); 
       end
    end

    % Homogeneizing ERPs: group level

    erp_cube = zeros(elec_num, min_len, subjs_num);
    for a = 1:size(erp_repo,2) % subjects
        for b = 1:size(erp_repo,1) % electrode
           sig = erp_repo{b,a};
           if isequal(align_method,'right')
              sig = sig(1, length(sig) - min_len +1 : length(sig) );
           else
              sig = sig(1,1:min_len);
           end
           erp_cube(b,:,a) = sig;
        end
    end

    % Homogeneizing ERPs by context: group level

    cerp_multi_cube = cell(length(contexts),1);
    for c = 1:length(contexts)
        cerp_cube = zeros(elec_num, min_len, subjs_num);
        for a = 1:size(cerp_repo,2)
            for b = 1:size(cerp_repo,1)
               sig = cerp_repo{b,a,c};
               if isequal(align_method,'right')
                  sig = sig(1, length(sig) - min_len +1 : length(sig) );
               else
                  sig = sig(1,1:min_len);
               end
               cerp_cube(b,:,a) = sig;
            end
        end
        cerp_multi_cube{c,1} = cerp_cube;
    end

    % Calculating the grand_averages 

    gerp = zeros(elec_num, min_len);
    ierp_easy_access = cell(elec_num, 1);
    gerp_test_ref = zeros(elec_num, min_len);
    for a = 1:size(erp_cube,1)
       mid_gerp = zeros(subjs_num,min_len);
       for b = 1:size(erp_cube,3)
          mid_gerp(b,:) = erp_cube(a,:,b);
       end
       ierp_easy_access{a,1} = mid_gerp;
       [results, ~] = erp_benjyuke(mid_gerp, alpha);
       gerp(a,:) = mean(mid_gerp,1);
       gerp_test_ref(a,:) = results;
    end

    % Calculating the grand_averages by context 

    gcerp = zeros(elec_num, min_len, length(contexts) );
    icerp_easy_access = cell(elec_num, 1, length(contexts));
    gcerp_test_ref = zeros(elec_num, min_len, length(contexts) );
    for c = 1:length(contexts)
       cerp_cube = cerp_multi_cube{c,1};
        for a = 1:size(cerp_cube,1)
           mid_gcerp = zeros(subjs_num,min_len);
           for b = 1:size(erp_cube,3)
              mid_gcerp(b,:) = cerp_cube(a,:,b);
           end
           icerp_easy_access{a,1,c} = mid_gcerp;
           [results, ~] = erp_benjyuke(mid_gcerp, 0.05);
           gcerp(a,:,c) = mean(mid_gerp,1);
           gcerp_test_ref(a,:,c) = results;
        end      
    end

end

% [1] Since the length can vary, this defines the interval based on the
% distribution of lengths. If 0.75, for example, it will consider that
% the interval to be 0.75 of the distribution of lengths and, for those
% with less or more, it will zero-padd the signal.