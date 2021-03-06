function DesignProcessing(design_name,number_of_runs,IS_PARALLEL)

fprintf('### Running the designs with a library size of %d...\n',number_of_runs);

file_list = dir(sprintf('DesignFiles/%s/*.txt',design_name));
design_file_list = {};

for c1 = 1:size(file_list)
    name = sprintf('%s/%s',design_name,file_list(c1).name);
    design_file_list{end+1} = name;
    
end

save_dir = sprintf('DesignFiles/%s',design_name);
sim_info_set = {};

for c1 = 1:numel(design_file_list)
    
    script_name = design_file_list{c1}(1:end-4);
    sub_save_dir = script_name;
    index = findstr('/',sub_save_dir);

    if ~isempty(index)
        sub_save_dir = sub_save_dir(index(1)+1:end);
    end
    
    [~,~,~] = mkdir([save_dir,'/',sub_save_dir]);

    for c2 = 1:number_of_runs
        sim_info_set(end+1,:) = {script_name,sub_save_dir,c2};
    end

    if IS_PARALLEL
        parfor c2 = 1:size(sim_info_set,1)
                design_folder = sim_info_set{c2,1};
                new_folder = sprintf('%s/%s',save_dir,sim_info_set{c2,2});
                file_name = ['DesignFiles/',sim_info_set{c2,1},'.txt'];
                new_file_name = [sprintf('%s/%s_%d',new_folder,sim_info_set{c2,2},c2),'.np'];    
                copyfile(file_name,new_file_name);

                system (sprintf('multitubedesign %s',new_file_name));
                %fprintf('**Design %s %d/%d is finished ...\n',sim_info_set{c2,2},c2,number_of_runs);
        end
    else
        for c2 = 1:size(sim_info_set,1)
                design_folder = sim_info_set{c2,1};
                new_folder = sprintf('%s/%s',save_dir,sim_info_set{c2,2});
                file_name = ['DesignFiles/',sim_info_set{c2,1},'.txt'];
                new_file_name = [sprintf('%s/%s_%d',new_folder,sim_info_set{c2,2},c2),'.np'];    
                copyfile(file_name,new_file_name);

                system (sprintf('multitubedesign %s',new_file_name));
                %fprintf('**Design %s %d/%d is finished ...\n',sim_info_set{c2,2},c2,number_of_runs);
        end
    end   
    sim_info_set = {};
end

