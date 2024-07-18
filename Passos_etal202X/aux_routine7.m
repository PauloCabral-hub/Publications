% Description: Script to join the summary_repo processed in blocks 


subjects = [51 52 54 55 56];
path_to_files = "/home/paulo/Documents/Publications/Passos_etal202X/data_files/";
fname_prefix = "subj";
fname_sufix = "_EEGtrees_block_and_global";

for s = 1:length(subjects)
    subj = subjects(s);
    if subj < 10
        aux = ["0" num2str(subj)];
    else
        aux = num2str(subj);
    end
    for b = 1:3
        load( strcat( path_to_files, fname_prefix, aux, fname_sufix, "_B", num2str(b), ".mat"), "summary_repo" );
        cur_summary = summary_repo;
        try
            final_summary = [final_summary; cur_summary];
        catch
            final_summary = cur_summary;
        end  
    end
    summary_repo = final_summary;
    save( strcat( path_to_files, fname_prefix, aux, fname_sufix, ".mat"), "summary_repo" )
    clear final_summary
end