function [separateMatrix]=separateOutputs(source, bit_res, featuresCount, data_size)

num_repetitions=2^bit_res;

% Step 1: Load the data from the file
data = readmatrix(source);

% Step 2: Extract the second column
second_column = data(2:end, 2);

num_complete_sets = floor(length(second_column) / num_repetitions);

% Average
separateMatrix = arrayfun(@(i) mean(second_column((i-1)*num_repetitions + (1:num_repetitions))), 1:num_complete_sets)';

%Sum
separateMatrix = arrayfun(@(i) sum(second_column((i-1)*featuresCount + (1:featuresCount))), 1:num_complete_sets)';

separateMatrix = separateMatrix(1:2:end, :);

if length(separateMatrix) > data_size
    % Truncate if the matrix is larger than data_size
    separateMatrix = separateMatrix(1:data_size);
elseif length(separateMatrix) < data_size
    % Pad with zeros if the matrix is smaller than data_size
    separateMatrix = [separateMatrix; zeros(data_size - length(separateMatrix), 1)];
end

end