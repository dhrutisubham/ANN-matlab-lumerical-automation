function determineAccuracy(predictions, y)

% % Step 1: Determine the predicted and true labels
% [~, predictions] = max(predictions, [], 2);
% [~, y] = max(y, [], 2);
% 
% predictions;
% y;
% 
% % Step 2: Compute accuracy
% correct_predictions = (predictions == y);
% sum(correct_predictions);
% accuracy = sum(correct_predictions) / length(y);
% 
% % Display accuracy
% fprintf('Accuracy: %.2f%%\n', accuracy * 100);

% Initialize the total difference
    total_difference = 0;

    % Iterate over each sample
    for i = 1:size(y, 1)
        % Find the index of the maximum value in the true label (y)
        [~, max_index_y] = max(y(i, :));

        % Find the difference between the prediction and the true label at this index
        difference = abs(predictions(i, max_index_y));

        % Accumulate the difference
        total_difference = total_difference + difference;
    end

    % Compute the average difference
    accuracy = total_difference / size(y, 1);

    fprintf('Accuracy: %.2f%%\n', accuracy * 100);
    
    % Alternatively, you can return a "score" which is 1 minus the average difference
    % score = 1 - avg_difference;


end