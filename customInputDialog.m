function customInputDialog
    % Create a UIFigure for the dialog
    fig = uifigure('Position', [500, 500, 350, 250], 'Name', 'Input Dialog', 'NumberTitle', 'off');

    % Create a label and edit field for model structure
    uilabel(fig, 'Position', [20, 180, 300, 22], 'Text', 'Model Structure (comma-separated):');
    modelEdit = uieditfield(fig, 'text', 'Position', [20, 150, 300, 22], 'Value', '[4 10 10 3]');

    % Create a label and edit field for test data size
    uilabel(fig, 'Position', [20, 120, 300, 22], 'Text', 'Test Data Size (integer):');
    testEdit = uieditfield(fig, 'numeric', 'Position', [20, 90, 300, 22], 'Value', 45);

    % Create a label and edit field for accumulation percentage
    uilabel(fig, 'Position', [20, 60, 300, 22], 'Text', 'Accumulation Percentage (1-100):');
    accEdit = uieditfield(fig, 'numeric', 'Position', [20, 30, 300, 22], 'Limits', [1 100], 'Value', 50);

    % Create a submit button
    uibutton(fig, 'push', 'Position', [50, 10, 80, 22], 'Text', 'Submit', 'ButtonPushedFcn', @(btn,event) submitCallback(modelEdit, testEdit, accEdit, fig));

    % Create a cancel button
    uibutton(fig, 'push', 'Position', [220, 10, 80, 22], 'Text', 'Cancel', 'ButtonPushedFcn', @(btn,event) close(fig));
end
