% Function to generate the mapping array
function mappingArray = generateMappingArray(k)
    L = 2^k; % Number of quantization levels
    delta = 1 / L; % Width of each interval
    mappingArray = (0:L-1) * delta; % Quantization levels

    disp("Activation mapping array generated.");
end


