function determineAccuracy(result_matrix, test_output_matrix)

% Step 1: Determine the predicted and true labels
[~, predicted_labels] = max(result_matrix, [], 2);
[~, true_labels] = max(test_output_matrix, [], 2);

% Step 2: Compute accuracy
correct_predictions = (predicted_labels == true_labels);
accuracy = sum(correct_predictions) / length(true_labels);

% Display accuracy
fprintf('Accuracy: %.2f%%\n', accuracy * 100);


end