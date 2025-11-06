function [LP] = loadLP1(LPPath)
    %==============================================
    %% Check if there is a LP file
    %==============================================
    splitedPath = strsplit(LPPath, '.');
    if length(splitedPath) == 1 || ~strcmp(splitedPath{end}, 'lp')
        LPPath = dir(fullfile(LPPath, '*.lp'));
        LP.Path = LPPath.folder;
        LPPath = fullfile(LPPath.folder, LPPath.name);
        
        if exist(LPPath, 'file') ~= 2
            msgbox(sprintf("%s\nDon't exist or is not a file...\n", LPPath), 'Invalid path', 'error', struct('WindowStyle', 'modal', 'Interpreter', 'none'));
            LP = [];
            return;
        end
    else
        LP.Path = fileparts(LPPath);
    end
    
    %==============================================
    %% Load and process the LP file
    %==============================================
    [File, ErrorMsg] = fopen(LPPath, 'r');
    if File < 0
        msgbox(ErrorMsg, 'Error I/O', 'error', struct('WindowStyle', 'modal', 'Interpreter', 'none'));
        LP = [];
        return;
    end
    
    % Updated textscan and file reading
    T = textscan(File, '%s %f %f %f', 'HeaderLines', 1);
    LP.FileNames = T{1};  % Changed indexing here
    LP.X = single(T{2});
    LP.Y = single(T{3});
    LP.Z = single(T{4});
    fclose(File);
end