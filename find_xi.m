function [xi_achieve,Voltage_xi]=find_xi(target_xi, Lut_table)

input_1=target_xi;
[m,n]=size(input_1);
%      % Find the row indices where the value is 3.6 in the second column
% row_indices1 = find(Lut_table(:, 2) == Vpi);
%
% % Replace the value with 1.8
% Lut_table(row_indices1, 2) = Vpi/2;


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

end
