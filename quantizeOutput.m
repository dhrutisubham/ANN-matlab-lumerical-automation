
% Function to quantize an array of numbers
function quantizedOutput = quantizeOutput(numberArray, mappingArray)
    quantizedOutput = zeros(size(numberArray)); % Initialize the output array
    for i = 1:length(numberArray)
        [~, idx] = min(abs(mappingArray - numberArray(i))); % Find closest quantization level
        quantizedOutput(i) = mappingArray(idx); % Assign quantized value
    end
end
