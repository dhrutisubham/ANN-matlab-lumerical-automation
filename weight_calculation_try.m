function[Voltage_vup_1,Voltage_vlow_1]=weight_calculation_try(n,Vpi,target_wi)
%  n=3;
Vpi=3.6;
V2=linspace(0,Vpi/2,2^n);
%  V3=linspace(0,Vpi/2,2^n);
V3=Vpi/2-V2;
weight=zeros(1,2^n*2^n);
t=0;
for i=1:length(V2)
    for j=1:length(V3)
        t=t+1;
        weight(t)=cos(pi*V2(i)/Vpi)^2-cos(pi*V3(j)/Vpi)^2;
        Weight_Vup(t)=V2(i);
        Weight_Vlow(t)=V3(j);
    end
end
% plot(sort(weight));

% you can create a look up table
Lut_table=zeros(2^(2*n),3);
for t=1:2^(2*n)
    Lut_table(t,1)=weight(t);
    Lut_table(t,2)=Weight_Vup(t);
    Lut_table(t,3)=Weight_Vlow(t);
end


% now need to find the function that will just pass the values and you
% will get the answer
%   inputMatrix=[-0.8,0.2;0.9,0.3;0.1,0.6];
inputMatrix=target_wi;

weight_1=inputMatrix;
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


Voltage_vup_1=reshape(Voltage_vup,m,n);
Voltage_vlow_1=reshape(Voltage_vlow,m,n);

%  plot( sort(weight));
%  display(Achievable_weights);
end