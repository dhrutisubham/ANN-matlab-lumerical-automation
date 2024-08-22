function matrices=extractResultMatrices(folderPath)

% Get a list of all .csv files in the folder
csvFiles = dir(fullfile(folderPath, '*.csv'));

% Initialize a cell array to hold the matrices
matrices = cell(1, length(csvFiles));

% Loop over each file and import the matrix
for i = 1:length(csvFiles)
    % Construct the full file path
    filePath = fullfile(folderPath, csvFiles(i).name);
    
    % Read the matrix from the .csv file
    matrices{i} = readmatrix(filePath); % or use csvread(filePath) for older MATLAB versions
end
disp("Extracted true labels for each layer.");
end