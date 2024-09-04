% function [finalMatrix]=separateOutputs(source, sampleRate, featuresCount, data_size)
% 
% 
% % Step 1: Load the data from the file
% data = readmatrix(source);
% 
% % Step 2: Extract the second column
% second_column = data(:, 2);
% 
% length(second_column);
% 
% if length(second_column) > data_size*sampleRate*featuresCount*2
%     % Truncate if the matrix is larger than data_size
%     second_column = second_column(1:data_size*sampleRate*featuresCount*2);
% elseif length(second_column) < data_size*sampleRate*featuresCount*2
%     % Pad with zeros if the matrix is smaller than data_size
%     second_column = [second_column; zeros(data_size*sampleRate*featuresCount*2 - length(second_column), 1)];
% end
% 
% 
% length(second_column);
% 
% 
% num_complete_sets = floor(length(second_column) / sampleRate);
% second_column=second_column';
% separateMatrix=[];
% % Average
% for i=1:num_complete_sets
%     sum=0;
%     for j=(i-1)*sampleRate+1:i*sampleRate
%         sum=sum+second_column(j);
%     end
%     sum=sum/sampleRate;
%     separateMatrix=[separateMatrix, sum];
% end
% separateMatrix';
% num_complete_sets=num_complete_sets/featuresCount;
% finalMatrix=[];
% %Sum
% for i=1:num_complete_sets
%     sum=0;
%     for j=(i-1)*featuresCount+1:i*featuresCount
%         sum=sum+separateMatrix(j);
%     end
%     finalMatrix=[finalMatrix, sum];
% end
% 
% finalMatrix=finalMatrix';
% finalMatrix = finalMatrix(1:2:end, :);
% 
% % separateMatrix;
% 
% 
% length(finalMatrix);
% 
% end


function [finalMatrix] = separateOutputs(source, sampleRate, featuresCount, data_size, l, samplesCount, delaySamples)

    % Step 1: Load the data from the file
    data = readmatrix(source);

    % Step 2: Extract the second column
    second_column = data(delaySamples:end, 2);
    length(second_column);

    % Adjust the length of the second column if necessary
    if length(second_column) > data_size * sampleRate * featuresCount * 2
        second_column = second_column(1:data_size * sampleRate * featuresCount * 2);
    elseif length(second_column) < data_size * sampleRate * featuresCount * 2
        second_column = [second_column; zeros(data_size * sampleRate * featuresCount * 2 - length(second_column), 1)];
    end

    % Transpose the second column to a row vector
    second_column = second_column';
    length(second_column);

    % Initialize variables
    num_complete_sets = floor(length(second_column) / sampleRate);
    separateMatrix = [];

    % Calculate averages for the segments
    for i = 1:num_complete_sets
        segment_start = (i - 1) * sampleRate + l;
        segment_end = segment_start + samplesCount - 1;

        % Ensure indices are within bounds
        if segment_end <= length(second_column)
            segment = second_column(segment_start:segment_end);
            avg_value = mean(segment);
            separateMatrix = [separateMatrix, avg_value];
        else
            break;
        end
    end

    separateMatrix';

    % Further processing
    num_complete_sets = num_complete_sets / featuresCount;
    finalMatrix = [];

    % Sum across features count
    for i = 1:num_complete_sets
        sum_value = 0;
        for j = (i - 1) * featuresCount + 1:i * featuresCount
            sum_value = sum_value + separateMatrix(j);
        end
        finalMatrix = [finalMatrix, sum_value];
    end

    finalMatrix = finalMatrix';
    finalMatrix = finalMatrix(1:2:end, :);
    finalMatrix*1000;

end
