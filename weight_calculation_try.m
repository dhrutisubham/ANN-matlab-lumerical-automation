function[Voltage_vup_1,Voltage_vlow_1]=weight_calculation_try(target_wi, Lut_table)

% now need to find the function that will just pass the values and you
% will get the answer
%   inputMatrix=[-0.8,0.2;0.9,0.3;0.1,0.6];

Lut_table;
weight_1=target_wi;
[m,n]=size(weight_1);
k=length(weight_1);
%   display(weight_1)
%   weight=reshape(weight,1,9);
%    given_weight= reshape(weight,3,3);
%    display(given_weight);


All_weight=Lut_table(:,1)';
given_weight=reshape(weight_1,1,m*n);
rt=reshape(given_weight,m,n);
for p=1:length(given_weight)
    diff=abs(All_weight-given_weight(p));
    [minDifference, index] = min(diff);
    Achievable_weight=All_weight(index);
    indices = find(All_weight == Achievable_weight);
    Achievable_weights(p)=round(Lut_table(indices(1),1),3);
    Voltage_vup(p)=round(Lut_table(indices(1),2),3);
    Voltage_vlow(p)=round(Lut_table(indices(1),3),3);

end
Achievable_weights=reshape(Achievable_weights,m,n);
target_wi-Achievable_weights;


Voltage_vup_1=reshape(Voltage_vup,m,n);
Voltage_vlow_1=reshape(Voltage_vlow,m,n);

% 
% Vpi=3.6;
% calculatedWeights=cos((pi)*(Voltage_vup_1/(2*Vpi))).^2-cos((pi)*(Voltage_vlow_1/(2*Vpi))).^2;

%  plot( sort(weight));
 % display(Achievable_weights);
end