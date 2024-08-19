clc;
close all;

Vpi=3.6;
time_period=1e-10;
bit_res=8;

% Define the number of layers in the ANN without input layer
layersCount=4;

% Number of neurons in each layer
neuronsLayer=[4, 10, 10, 3];

testCount=45; %define number of test data

%Generate Weight Files for each layer
weightSource='F:\Documents\IITP\4th Year\BTP\autoTest\layerWeights'; %Folder path for Layer-wise weight matrix files 
inputSource='F:\Documents\IITP\4th Year\BTP\autoTest\input_data.txt';

interconnect_exe = '"C:/Program Files/Lumerical/v231/bin/interconnect.exe"';
script_source = '"F:\Documents\IITP\4th Year\BTP\autoTest\automation_script.lsf"';


%Creating folder structure for the ANN
% Base directory where you want to create the folders
baseDir = "F:\Documents\IITP\4th Year\BTP\autoTest"; % Replace with your desired path

% Loop through each layer
for layer = 1:length(neuronsLayer)
    % Create the layer folder
    layerFolder = fullfile(baseDir, sprintf('layer%d', layer));
    if ~exist(layerFolder, 'dir')
        mkdir(layerFolder);
    end
    
    % Loop through each neuron in the current layer
    for neuron = 1:neuronsLayer(layer)
        % Create the neuron folder
        neuronFolder = fullfile(layerFolder, sprintf('neuron%d', neuron));
        if ~exist(neuronFolder, 'dir')
            mkdir(neuronFolder);
        end
        
        % Create subfolders 'xi', 'wli', 'wui' inside each neuron folder
        subfolders = {'xi', 'wLow', 'wUpper'};
        for i = 1:length(subfolders)
            subfolderPath = fullfile(neuronFolder, subfolders{i});
            if ~exist(subfolderPath, 'dir')
                mkdir(subfolderPath);
            end
        end
    end
end

disp('Folder structure created successfully.');



%Extracting the weight files
% Get a list of all files in the folder
fileList = dir(fullfile(weightSource, '*')); % Use '*' to match all files

% Filter out directories from the list
fileList = fileList(~[fileList.isdir]);

% Initialize an empty cell array to store the file paths
filePaths = cell(length(fileList), 1);

% Loop through each file and store its full path
for i = 1:length(fileList)
    filePaths{i} = fullfile(weightSource, fileList(i).name);
end
disp('Extracted weight matrix files successfully.');



for i=2:layersCount
    %Generate Weight Files
    prevLayerNeurons=neuronsLayer(i-1);

    for j=1:neuronsLayer(i)
        prac_iris_testjb(prevLayerNeurons, Vpi, time_period, bit_res, filePaths{i-1}, i, j, 1);

        %Combine Weight Files
        inputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\wLow\";
        outputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_li_combined.txt");

        inputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\wLow\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_ui_combined.txt");
    end
end

disp('Weight files generated successfully.');

inputSource="F:\Documents\IITP\4th Year\BTP\autoTest\testing_data.txt";
prac_iris_testjb(4, Vpi, time_period, bit_res, inputSource, 2, 1, 0);
inputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\xi\";
outputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");

destination = "F:\Documents\IITP\4th Year\BTP\autoTest\";
copyfile(outputFolderPath+"input_data.txt", destination);


for i=2:layersCount
    
    outputFilePath='F:\Documents\IITP\4th Year\BTP\autoTest\output_data.txt';
    for j=1:neuronsLayer(i)
        %setup weight input files
        weightLowSource="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\wLow\";
        copyFileOutput(weightLowSource, "F:\Documents\IITP\4th Year\BTP\autoTest\", "w_low.txt", i, 0);

        weightLowSource="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\wUpper\";
        copyFileOutput(weightLowSource, "F:\Documents\IITP\4th Year\BTP\autoTest\", "w_upper.txt", i, 0);
        

        %run Simulation
        system([interconnect_exe ' -run ' script_source]);

        %format Output
        removeLumericalSignatures(outputFilePath);

        destination = "F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
        copyfile(outputFilePath, destination);


        %Separate different data inputs
        layerOutPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\";
        separateMatrix=separateOutputs(outputFilePath, bit_res);
        saveOutputFile(separateMatrix, layerOutPath, i);

        disp(i, j);

    end
    
    %Replace input file with current output 
    destination="F:\Documents\IITP\4th Year\BTP\autoTest\";
    copyFileOutput(outputFilePath, destination, "upd_testing_data.txt", i, 0);

    inputSource="F:\Documents\IITP\4th Year\BTP\autoTest\upd_testing_data.txt";
    prac_iris_testjb(neuronsLayer(i), Vpi, time_period, bit_res, inputSource, 2, 1, 0);
    inputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\xi\";
    outputFolderPath="F:\Documents\IITP\4th Year\BTP\autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
    filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");
    
    destination = "F:\Documents\IITP\4th Year\BTP\autoTest\";
    copyfile(outputFolderPath+"input_data.txt", destination);

end

disp("Automation Complete");