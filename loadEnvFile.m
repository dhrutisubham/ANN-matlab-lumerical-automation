function loadEnvFile(envFilePath)
    % Check if the file exists
    if exist(envFilePath, 'file') ~= 2
        error('File not found: %s', envFilePath);
    end
    
    % Open the file for reading
    fid = fopen(envFilePath, 'r');
    
    % Read the file line by line
    while ~feof(fid)
        line = fgetl(fid);  % Read a line
        if isempty(line) || line(1) == '#'
            % Skip empty lines or comments
            continue;
        end
        
        % Split line at the '=' character
        kv = strsplit(line, '=');
        if numel(kv) == 2
            key = strtrim(kv{1});
            value = strtrim(kv{2});
            
            % Set environment variable in MATLAB
            setenv(key, value);
        end
    end
    
    % Close the file
    fclose(fid);
end
