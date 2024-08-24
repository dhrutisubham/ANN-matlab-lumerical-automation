function [finalMatrix]=separateOutputs(source, sampleRate, featuresCount, data_size)


% Step 1: Load the data from the file
data = readmatrix(source);

% Step 2: Extract the second column
second_column = data(:, 2);

length(second_column);

if length(second_column) > data_size*sampleRate*featuresCount*2
    % Truncate if the matrix is larger than data_size
    second_column = second_column(1:data_size*sampleRate*featuresCount*2);
elseif length(second_column) < data_size*sampleRate*featuresCount*2
    % Pad with zeros if the matrix is smaller than data_size
    second_column = [second_column; zeros(data_size*sampleRate*featuresCount*2 - length(second_column), 1)];
end


length(second_column);


num_complete_sets = floor(length(second_column) / sampleRate);
second_column=second_column';
separateMatrix=[];
% Average
for i=1:num_complete_sets
    sum=0;
    for j=(i-1)*sampleRate+1:i*sampleRate
        sum=sum+second_column(j);
    end
    sum=sum/sampleRate;
    separateMatrix=[separateMatrix, sum];
end

num_complete_sets=num_complete_sets/featuresCount;
finalMatrix=[];
%Sum
for i=1:num_complete_sets
    sum=0;
    for j=(i-1)*featuresCount+1:i*featuresCount
        sum=sum+separateMatrix(j);
    end
    finalMatrix=[finalMatrix, sum];
end

finalMatrix=finalMatrix';
finalMatrix = finalMatrix(1:2:end, :);

% separateMatrix;


length(finalMatrix);

end