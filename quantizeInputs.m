% function [X_quantized]=quantizeInputs(k_bit, X)
% 
% % Find the range of the matrix
% X_min = min(X(:));
% X_max = max(X(:));
% % 
% % % Normalize the matrix to the range [0, 1]
% % X_normalized = (X - X_min) / (X_max - X_min);
% 
% % Quantize the matrix to k_bit precision
% X_quantized = round(X * (2^k_bit - 1)) / (2^k_bit - 1);
% 
% % Optionally, scale back to the original range if needed
% % X_quantized_original_range = X_quantized * (X_max - X_min) + X_min;
% 
% % Display the quantized matrix
% % disp('Original Matrix:');
% % disp(X);
% % 
% % disp('Quantized Matrix:');
% % disp(X_quantized);
% 
% % disp('Quantized Matrix in Original Range:');
% % disp(X_quantized_original_range);
% 
% 
% end

function q = quantizeInputs(k_bit, w)
   % Import the Python library
quantizers = py.importlib.import_module('larq.quantizers');
q = quantizers.DoReFa(k_bit, 'activations').call(py.numpy.array(w));
q=double(q);
q=q';

end