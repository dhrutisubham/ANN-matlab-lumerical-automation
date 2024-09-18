function data=Waveform1(input_vector, time_period, num_repetitions,iteration, delay, isVoltage, isWeight, layerNumber, neuronNumber)

workingDirectory=getenv('WORKING_DIRECTORY');
input_vector = input_vector';

% Add value 3.6 to the input vector
% if flag==0
%     input_vector = [input_vector,0];
% else
%     input_vector=[input_vector, 1.8];
% end

% Define the total time span
total_time = length(input_vector) * time_period;

% Initialize an empty array to store the repeated values
repeated_vector = [];

% Initialize an empty array to store the time values
time_vector = [];

% Repeat each value by num_repetitions times within specific time periods
for i = 1:length(input_vector)
    % Generate the time vector for the current time period
    time_values = linspace((i-1)*time_period, i*time_period, num_repetitions);

    % Append the time values to the time vector
    time_vector = [time_vector, time_values];

    % Repeat the current value by num_repetitions times within the current time period
    repeated_values = repmat(input_vector(i), 1, num_repetitions);

    % Append the repeated values to the final repeated vector
    repeated_vector = [repeated_vector, repeated_values];
end


% if flag==0
%     repeated_vpi = repmat(input_vector(1, 1), 1, num_repetitions);
% else
%     repeated_vpi = repmat(1.8, 1, num_repetitions);
% end


% Repeat the repeated_vector for the specified number of repetitions
% instead of three used the next layer hidden size
% repeated_vector = repmat(repeated_vector, 1, Hidden_size);
% repeated_vector=[repeated_vpi,repeated_vector];

% Generate the time vector for the repeated sequence
% time_vector = linspace(0, total_time * num_repetitions, length(repeated_vector));

% Generate the time vector for the repeated sequence
% time_vector = linspace(0, total_time * Hidden_size+100e-12, length(repeated_vector));
% time_vector = time_vector + time_period*num_repetitions; % Adjust the time vector to include the additional repetition of 1.8

% Plot the repeated_vector against time_vector
time_vector=time_vector+delay;

% if isVoltage==2
%     plot(time_vector, repeated_vector, 'b.-');
% 
%     xlabel('Time (seconds)');
%     ylabel('Repeated Vector');
%     title('Repeated Vector over Time');
%     grid on;
%     hold on;
% 
% end

% Specify the folder path where you want to save the files
if isVoltage==1
    folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\xi\';
elseif isVoltage==2
    folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\wLow\';
elseif isVoltage==3
    folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\wUpper\';
end

% Save the repeated vector and corresponding time values to a text file
data =[time_vector', repeated_vector'];
if isVoltage==0
    if isWeight==0
        folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\xi\';
        file_name = sprintf('%sdata_%d_%d_%d.txt',folder_path, layerNumber, neuronNumber, iteration);
        dlmwrite(file_name, data, 'delimiter', '\t', 'precision', 10);
    else
        folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\wLow\';
        file_name = sprintf('%sdata_%d_%d_%d.txt',folder_path, layerNumber, neuronNumber, iteration);
        dlmwrite(file_name, data, 'delimiter', '\t', 'precision', 10);

        folder_path = workingDirectory+"\layer"+string(layerNumber)+'\neuron'+string(neuronNumber)+'\wUpper\';
        file_name = sprintf('%sdata_%d_%d_%d.txt',folder_path, layerNumber, neuronNumber, iteration);
        dlmwrite(file_name, data, 'delimiter', '\t', 'precision', 10);
    end
else
    file_name = sprintf('%sdata_%d_%d_%d.txt',folder_path, layerNumber, neuronNumber, iteration);
    dlmwrite(file_name, data, 'delimiter', '\t', 'precision', 10);
end


end
