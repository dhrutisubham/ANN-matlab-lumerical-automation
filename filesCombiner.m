function filesCombiner(inputFolderPath, outputFolderPath, fileName)


% Define the folder where the text files are located and where the combined file will be saved
% inputFolderPath = 'F:\Documents\IITP\4th Year\BTP\Matlab\output_text\xi'; % Path where files are located
% outputFolderPath = 'F:\Documents\IITP\4th Year\BTP\Matlab\'; % Path where the combined file will be saved

% Get a list of all text files in the input folder
fileList = dir(fullfile(inputFolderPath, '*.txt')); % Adjust if your files have a different extension

% Initialize a cell array to store combined data
combinedData = {};

% Loop through each file and read its contents
for i = 1:length(fileList)
    % Construct the full file path
    filePath = fullfile(inputFolderPath, fileList(i).name);
    
    % Open the file
    fileID = fopen(filePath, 'r');
    
    % Check if the file opened successfully
    if fileID == -1
        warning('Failed to open file: %s', filePath);
        continue;
    end
    
    % Read the contents of the file
    fileData = fread(fileID, '*char')';
    
    % Close the file
    fclose(fileID);
    
    % Append the file data to the combined data
    combinedData{end+1} = fileData;
end

% Combine all the data into one string
combinedText = strjoin(combinedData, '\n'); % Use '\n' to separate the content of different files

% Define the path for the combined output file
outputFilePath = fullfile(outputFolderPath, fileName);

% Open the output file for writing
fileID = fopen(outputFilePath, 'w');

% Check if the output file opened successfully
if fileID == -1
    error('Failed to create file: %s', outputFilePath);
end

% Write the combined data to the output file
fprintf(fileID, '%s', combinedText);

% Close the output file
fclose(fileID);


end
