function copyFileOutput(source, destination, destinationFileName, layerNumber, neuronNumber)

% Construct the full destination file path
destinationFilePath = fullfile(destination, destinationFileName);

% Open the source file for reading
fileID = fopen(source, 'r');

% Check if the file opened successfully
if fileID == -1
    error('Failed to open source file: %s', source);
end

% Read the contents of the source file
fileContents = fread(fileID, '*char')';

% Close the source file
fclose(fileID);

% Open the destination file for writing (this will clear its contents if it exists)
fileID_dest = fopen(destinationFilePath, 'w');

% Check if the file opened successfully
if fileID_dest == -1
    error('Failed to open destination file: %s', destinationFilePath);
end

% Write the contents to the destination file
fwrite(fileID_dest, fileContents);

% Close the destination file
fclose(fileID_dest);

end