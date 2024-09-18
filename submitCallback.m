
function submitCallback(modelEdit, testEdit, accEdit, fig)
    % Get values from edit fields
    modelStr = modelEdit.Value;
    testSize = testEdit.Value;
    accumulation = accEdit.Value;

    % Convert model structure string to 1D array of numbers
    modelStructure = str2num(modelStr); %#ok<ST2NM>

    % Check if test data size is a valid integer
    if isnan(testSize) || floor(testSize) ~= testSize
        uialert(fig, 'Test data size must be an integer.', 'Input Error');
        return;
    end

    % Check if accumulation percentage is in the valid range
    if accumulation < 1 || accumulation > 100
        uialert(fig, 'Accumulation percentage must be between 1 and 100.', 'Input Error');
        return;
    end

    % Display the collected inputs
    msg = sprintf('Model Structure: [%s]\nTest Data Size: %d\nAccumulation Percentage: %.2f%%', ...
        num2str(modelStructure), testSize, accumulation);
    uialert(fig, msg, 'Collected Inputs');
    % close(fig);
end
