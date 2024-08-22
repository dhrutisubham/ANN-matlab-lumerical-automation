function saveOutputFile(firstColumn, destination, layerNumber, neuronNumber)

destinationFilePath = destination+"output_"+string(layerNumber)+".txt"; % Replace with your destination file path

% Initialize an empty matrix to store the combined data
combinedData = [];

% Read the matrix data from the current source file
matrixData=[];
if neuronNumber~=1
matrixData = readmatrix(destinationFilePath);

end
% Extract the first column
% firstColumn = matrixData(:, 1);

% Append the first column to the combined data matrix
combinedData = [matrixData, firstColumn];

% Write the combined data matrix to the destination file
writematrix(combinedData, destinationFilePath, 'Delimiter', '\t');
    
end