function [Lut_table]=createWeightLUT(n, Vpi)

V2=linspace(0,Vpi,2^n);
%  V3=linspace(0,Vpi/2,2^n);
V3=Vpi-V2;
weight=zeros(1,2^n*2^n);
t=0;
for i=1:length(V2)
    for j=1:length(V3)
        t=t+1;
        weight(t)=cos(pi*V2(i)/(2*Vpi))^2-cos(pi*V3(j)/(2*Vpi))^2;
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

end