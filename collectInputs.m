function collectInputs
    % Default values
    defaultModelStructure = '[4 10 10 3]';
    defaultTestDataSize = '45';
    defaultAccumulation = '50';
    
    % Prompt for model structure (1D array as string)
    prompt1 = {'Enter model structure (comma-separated values):'};
    dlgtitle1 = 'Model Structure';
    definput1 = {defaultModelStructure};
    modelStructureStr = inputdlg(prompt1, dlgtitle1, [1 50], definput1);
    
    if isempty(modelStructureStr)
        return; % User canceled the dialog
    end
    
    % Convert model structure string to 1D array of numbers
    modelStructure = str2num(modelStructureStr{1}); %#ok<ST2NM>
    
    % Prompt for test data size (integer)
    prompt2 = {'Enter test data size:'};
    dlgtitle2 = 'Test Data Size';
    definput2 = {defaultTestDataSize};
    testDataSizeStr = inputdlg(prompt2, dlgtitle2, [1 50], definput2);
    
    if isempty(testDataSizeStr)
        return; % User canceled the dialog
    end
    
    % Convert test data size string to integer
    testDataSize = str2double(testDataSizeStr{1});
    
    % Check if test data size is a valid integer
    if isnan(testDataSize) || floor(testDataSize) ~= testDataSize
        errordlg('Test data size must be an integer.', 'Input Error');
        return;
    end
    
    % Prompt for accumulation percentage (range 1-100)
    prompt3 = {'Enter accumulation percentage (1-100):'};
    dlgtitle3 = 'Accumulation Percentage';
    definput3 = {defaultAccumulation};
    accumulationStr = inputdlg(prompt3, dlgtitle3, [1 50], definput3);
    
    if isempty(accumulationStr)
        return; % User canceled the dialog
    end
    
    % Convert accumulation percentage string to number
    accumulation = str2double(accumulationStr{1});
    
    % Check if accumulation percentage is in the valid range
    if isnan(accumulation) || accumulation < 1 || accumulation > 100
        errordlg('Accumulation percentage must be between 1 and 100.', 'Input Error');
        return;
    end
    
    % Display the collected inputs
    msg = sprintf('Model Structure: [%s]\nTest Data Size: %d\nAccumulation Percentage: %.2f%%', ...
        num2str(modelStructure), testDataSize, accumulation);
    msgbox(msg, 'Collected Inputs');
end
