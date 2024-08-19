 function [xi_achieve,Voltage_xi]=find_xi(n,Vpi,target_xi)

%  n=6;
%  Vpi=3.6;
%  target_xi=[0,0];
V=linspace(0,Vpi,2^n);


 xi=zeros(1,2^n);

  for i=1:1:length(V)
%       display(V(i));
  xi(i)=cos((pi)*(V(i)/Vpi)).^2;
%   display(xi(i));
  Xi_voltage(i)=V(i);
 end
  
  % you can create a look up table 
  Lut_table=zeros(2^n,2);
  for t=1:1:(2^n)
      Lut_table(t,1)=xi(t);
      Lut_table(t,2)=Xi_voltage(t);
  end
 
input_1=target_xi;
  [m,n]=size(input_1);
     % Find the row indices where the value is 3.6 in the second column
row_indices1 = find(Lut_table(:, 2) == 3.6);

% Replace the value with 1.8
Lut_table(row_indices1, 2) = 1.8;


   All_xi=Lut_table(:,1)';
   given_xi=reshape(input_1,1,m*n);
   for p=1:length(given_xi)
   diff=abs(All_xi-given_xi(p));
   [minDifference, index] = min(diff);
    Achievable_xi=All_xi(index);
   indices = find(All_xi == Achievable_xi);
   xi_achieve(p)=round(Lut_table(indices(1),1),3);
    Voltage_xi(p)=round(Lut_table(indices(1),2),3);
  
   end
   xi_achieve=reshape(xi_achieve,m,n);
   Voltage_xi=reshape( Voltage_xi,m,n);
%    display(xi_achieve);
%    display(Voltage_xi);
%    
%   
   



end
