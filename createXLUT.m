function [Lut_table]=createXLUT(n, Vpi)


%  n=6;
%  Vpi=3.6;
%  target_xi=[0,0];

V=linspace(0,Vpi,2^n);


xi=zeros(1,2^n);

for i=1:1:length(V)
    %       display(V(i));
    xi(i)=cos((pi)*(V(i)/(2*Vpi))).^2;
    %   display(xi(i));
    Xi_voltage(i)=V(i);
end

% you can create a look up table
Lut_table=zeros(2^n,2);
for t=1:1:(2^n)
    Lut_table(t,1)=xi(t);
    Lut_table(t,2)=Xi_voltage(t);
end

end