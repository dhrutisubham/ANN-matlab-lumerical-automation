function [updData]=activationFunction(data, bias, func)
data=data+bias;
updData=func(data);

end