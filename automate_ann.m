clc;
close all;

data_size=45; %define the size of your data


% Define activation functions

relu = @(x) max(0, min(x, 1));
sigmoid = @(x) 1 ./ (1 + exp(-x));


% Lumerical Model Properties
Potp=0.001;
responsivity=1;
capacitance=1;
prop_constant=(Potp*responsivity)/capacitance;


Vpi=3.6;
time_period=1e-10;
bit_res=10;
data_bit=4;

wLut=createWeightLUT(data_bit, Vpi);
xLut=createXLUT(data_bit, Vpi);

% Define the number of layers in the ANN without input layer
layersCount=5;

% Number of neurons in each layer
neuronsLayer=[4, 10, 10, 3, 3]; %last two are same for generating output

testCount=45; %define number of test data

%Generate Weight Files for each layer
weightSource='F:\Documents\IITP\4th_Year\BTP\autoTest\layerWeights'; %Folder path for Layer-wise weight matrix files 
inputSource='F:\Documents\IITP\4th_Year\BTP\autoTest\input_data.txt';


workingDirectory="F:\Documents\IITP\4th_Year\BTP\";
interconnect_exe = '"C:/Program Files/Lumerical/v231/bin/interconnect.exe"';
script_source = 'autoTest\automation_script.lsf"';

trueResultSource="F:\Documents\IITP\4th_Year\BTP\autoTest\trueOutputs";

trueLabels=extractResultMatrices(trueResultSource);

%% 

% Creating folder structure for the ANN
% Base directory where you want to create the folders
baseDir = workingDirectory+"autoTest"; % Replace with your desired path

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


%% 

for i=2:layersCount-1
    %Generate Weight Files
    prevLayerNeurons=neuronsLayer(i-1);

    for j=1:neuronsLayer(i)
        prac_iris_testjb(prevLayerNeurons, Vpi, time_period, data_bit, bit_res, filePaths{i-1}, i, j, 1, data_size, wLut, xLut);

        %Combine Weight Files
        inputFolderPath=workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\wLow\";
        outputFolderPath=workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_li_combined.txt");

        inputFolderPath=workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\wUpper\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_ui_combined.txt");
    end
end

disp('Weight files generated successfully.');


%% 
% Generate Biases
% Specify the folder where bias files are located
folderPath = workingDirectory+"autoTest\layerBias";

% Get a list of all bias files in the folder
biasFiles = dir(fullfile(folderPath, '*.csv'));

% Initialize a cell array to hold biases for each layer
biasCellArray = cell(1, length(biasFiles));

% Load biases from each file
for i = 1:length(biasFiles)
    % Construct the full file path
    filePath = fullfile(folderPath, biasFiles(i).name);
    
    % Load the biases from the file
    biases = load(filePath);
    
    % Store the biases in the cell array
    biasCellArray{i} = biases;
end
disp('Bias files generated successfully.');

%% 
% Input Layer Matrix
inputSource=workingDirectory+"autoTest\testing_data.txt";
prac_iris_testjb(neuronsLayer(1), Vpi, time_period, data_bit, bit_res, inputSource, 2, 1, 0, data_size, wLut, xLut);
inputFolderPath=workingDirectory+"autoTest\layer"+string(2)+"\neuron"+string(1)+"\xi\";
outputFolderPath=workingDirectory+"autoTest\layer"+string(2)+"\neuron"+string(1)+"\";
filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");

destination = workingDirectory+"autoTest\";
copyfile(outputFolderPath+"input_data.txt", destination);


%% 

for i=2:layersCount-1
    
    outputFilePath=workingDirectory+"autoTest\output_data.txt";
    layerOutPath=workingDirectory+"autoTest\layer"+string(i)+'\';
    for j=1:neuronsLayer(i)
        % setup weight input files
        weightLowSource=workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\w_li_combined.txt";
        copyFileOutput(weightLowSource, workingDirectory+"autoTest\", "w_low.txt", i, 0);

        weightLowSource=workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\w_ui_combined.txt";
        copyFileOutput(weightLowSource, workingDirectory+"autoTest\", "w_upper.txt", i, 0);


        %run Simulation
        workingDirectory='"F:\Documents\IITP\4th_Year\BTP\';
        system([interconnect_exe ' -run ' workingDirectory script_source]);
        workingDirectory="F:\Documents\IITP\4th_Year\BTP\";

        %format Output
        removeLumericalSignatures(outputFilePath);

        destination = workingDirectory+"autoTest\layer"+string(i)+"\neuron"+string(j)+"\";
        copyfile(outputFilePath, destination);


        %Separate different data inputs
        separateMatrix=separateOutputs(outputFilePath, bit_res, neuronsLayer(i-1), data_size);
        
        % separateMatrix=[1 1 1 1]';

        %convert current output to actual data result
        separateMatrix=separateMatrix/(prop_constant*neuronsLayer(i-1));

        %apply activation function
        updData=activationFunction(separateMatrix, biasCellArray{i-1}(j), sigmoid);
        % updData=(quantizeInputs(data_bit, updData));
        

        %save separated matrix
        saveOutputFile(updData, layerOutPath, i, j);

        disp([i, j]);

    end
    
    %Replace input file with current output 
    destination=workingDirectory+"autoTest\";
    copyFileOutput(layerOutPath+"output_"+string(i)+".txt", destination, "upd_testing_data.txt", i, 0);

    disp(i);
    currentOutputLabels=readmatrix(layerOutPath+"output_"+string(i)+".txt");
    
    determineAccuracy(cell2mat(trueLabels(i-1)), currentOutputLabels);

    inputSource=workingDirectory+"autoTest\upd_testing_data.txt";
    prac_iris_testjb(neuronsLayer(i), Vpi, time_period, data_bit, bit_res, inputSource, i+1, 1, 0, data_size, wLut, xLut);
    inputFolderPath=workingDirectory+"autoTest\layer"+string(i+1)+"\neuron"+string(1)+"\xi\";

    outputFolderPath=workingDirectory+"autoTest\layer"+string(i+1)+"\neuron"+string(1)+"\";
    filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");
    
    destination = workingDirectory+"autoTest\";
    copyfile(outputFolderPath+"input_data.txt", destination);

end

disp("Automation Complete");