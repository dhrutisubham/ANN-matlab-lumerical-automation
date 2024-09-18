clc;
close all;

data_size=45; %define the size of your data

data_bit=4; % IMPORTANT TO SET BEFORE RUNNING SIMULATION 

% Number of neurons in each layer
neuronsLayer=[4, 10, 10, 3, 3]; %last two are same for generating output

% Define the number of layers in the ANN without input layer
layersCount=length(neuronsLayer);

% Extract all the environment variables
loadEnvFile('./env/matlab/.env');


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
bit_res=8;

SAMPLE_RATE=1.28e+12; % CHECK LUMERICAL MODEL PROPERTIES
samplesPerPeriod=time_period*SAMPLE_RATE;


% DATA EXTRACTION SETTINGS
delayExtraction=time_period; % DETERMINED BY RUNNING SAMPLE DATA
extractPercent=0.5;
startSample=ceil(((1-extractPercent)/2)*samplesPerPeriod);
samplesCount=ceil(extractPercent*samplesPerPeriod);


% CREATE LUTs
wLut=createWeightLUT(data_bit, Vpi);
xLut=createXLUT(data_bit, Vpi);
% activationMap=generateMappingArray(data_bit);

workingDirectory=getenv('WORKING_DIRECTORY');
interconnect_exe = getenv('INTERCONNECT_EXE');

lumericalEnv="./env/lumerical/.env";

% Generate Weight Files for each layer
weightSource=workingDirectory+"\layerWeights"; % Folder path for Layer-wise weight matrix files 
inputSource=workingDirectory+"\input_data.txt";

script_source = "\automation_python.py";
trueResultSource=workingDirectory+"\trueOutputs";

trueLabels=extractResultMatrices(trueResultSource);

%% 

% Creating folder structure for the ANN
% Base directory where you want to create the folders
baseDir = workingDirectory; % Replace with your desired path

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
        inputFolderPath=workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\wLow\";
        outputFolderPath=workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_li_combined.txt");

        inputFolderPath=workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\wUpper\";
        filesCombiner(inputFolderPath, outputFolderPath, "w_ui_combined.txt");
    end
end

disp('Weight files generated successfully.');


%% 
% Generate Biases
% Specify the folder where bias files are located
folderPath = workingDirectory+"\layerBias";

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
inputSource=workingDirectory+"\testing_data.txt";
prac_iris_testjb(neuronsLayer(1), Vpi, time_period, data_bit, bit_res, inputSource, 2, 1, 0, data_size, wLut, xLut);
inputFolderPath=workingDirectory+"\layer"+string(2)+"\neuron"+string(1)+"\xi\";
outputFolderPath=workingDirectory+"\layer"+string(2)+"\neuron"+string(1)+"\";
filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");

destination = workingDirectory+"\";
copyfile(outputFolderPath+"input_data.txt", destination);


%% 

for i=2:layersCount-1
    
    outputFilePath=workingDirectory+"\output_data.txt";
    layerOutPath=workingDirectory+"\layer"+string(i)+'\';

    TIME_WINDOW=data_size*neuronsLayer(i-1)*2*time_period+time_period;
    writeEnvVar(lumericalEnv, 'TIME_WINDOW', TIME_WINDOW);
    for j=1:neuronsLayer(i)
        % setup weight input files
        weightLowSource=workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\w_li_combined.txt";
        copyFileOutput(weightLowSource, workingDirectory+"\", "w_low.txt", i, 0);

        weightUpperSource=workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\w_ui_combined.txt";
        copyFileOutput(weightUpperSource, workingDirectory+"\", "w_upper.txt", i, 0);


        %run Simulation
        system(char(string("py "+""""+workingDirectory+script_source+"""")));

        %format Output
        removeLumericalSignatures(outputFilePath);

        destination = workingDirectory+"\layer"+string(i)+"\neuron"+string(j)+"\";
        copyfile(outputFilePath, destination);


        %Separate different data inputs
        separateMatrix=separateOutputs(outputFilePath, samplesPerPeriod, neuronsLayer(i-1), data_size, startSample, samplesCount, samplesPerPeriod);
        
        % separateMatrix=[1 1 1 1]';

        %convert current output to actual data result
        % separateMatrix=separateMatrix/(prop_constant*neuronsLayer(i-1));
        separateMatrix=1000*separateMatrix; %REPLACE 2000 BY ACTUAL NORMALISATION FACTOR

        %apply activation function
        updData=activationFunction(separateMatrix, biasCellArray{i-1}(j), sigmoid);
        updData=quantizeInputs(data_bit, updData); %Bit Quantised Activation Output
       
        %save separated matrix
        saveOutputFile(updData, layerOutPath, i, j);

        disp([i, j]);

    end
    
    %Replace input file with current output 
    destination=workingDirectory+"\";
    copyFileOutput(layerOutPath+"output_"+string(i)+".txt", destination, "upd_testing_data.txt", i, 0);

    disp(i);
    currentOutputLabels=readmatrix(layerOutPath+"output_"+string(i)+".txt");
    
    determineAccuracy(readmatrix(workingDirectory+"\trueOutputs\Y_test.csv"), currentOutputLabels);
    inputSource=workingDirectory+"\upd_testing_data.txt";
    prac_iris_testjb(neuronsLayer(i), Vpi, time_period, data_bit, bit_res, inputSource, i+1, 1, 0, data_size, wLut, xLut);
    inputFolderPath=workingDirectory+"\layer"+string(i+1)+"\neuron"+string(1)+"\xi\";

    outputFolderPath=workingDirectory+"\layer"+string(i+1)+"\neuron"+string(1)+"\";
    filesCombiner(inputFolderPath, outputFolderPath, "input_data.txt");
    
    destination = workingDirectory+"\";
    copyfile(outputFolderPath+"input_data.txt", destination);

end

disp("Automation Complete");