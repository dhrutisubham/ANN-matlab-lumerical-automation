function writeEnvVar(envFilePath, varName, varValue)
       % Open the file in write mode, which will clear the existing content
    fid = fopen(envFilePath, 'w');
    
    % Write the new variable in the format: VAR_NAME=VALUE
    fprintf(fid, '%s=%s\n', varName, varValue);
    
    % Close the file
    fclose(fid);
    
end
