% By Raphael Turcotte (2021)
% rturcotte861@gmail.com

clear

Results = 'Results_Q4_illumination_correlation_foci.txt';
ID = fopen(Results,'a+');

%Parameters for straight fibre
load("Q1_PSF.mat");
output_img_H_str = output_img_H;
output_img_H_str = sub_ill(N, 49^2, output_img_H_str);
output_img_H_str = reshape(output_img_H_str, [N^2*49^2, 1]);

for k = 0:4

    %Parameters for bent fibre
    openname = strcat('Q4_Foci_2500_', num2str(k), '.mat');
    load(openname);
    output_img_H_bent = sub_ill(N, 49^2, output_img_H_bent);
    output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);

    CC = corrcoef(output_img_H_bent, output_img_H_str);

    ff = '2500';
    fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));

end

for k = 2:3

    %Parameters for bent fibre
    openname = strcat('Q4_Foci_5000_', num2str(k), '.mat');
    load(openname);
    output_img_H_bent = sub_ill(N, 49^2, output_img_H_bent);
    output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);

    CC = corrcoef(output_img_H_bent, output_img_H_str);

    ff = '5000';
    fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));

end

for k = 2:3

    %Parameters for bent fibre
    openname = strcat('Q4_Foci_1000_', num2str(k), '.mat');
    load(openname);
    output_img_H_bent = sub_ill(N, 49^2, output_img_H_bent);
    output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);

    CC = corrcoef(output_img_H_bent, output_img_H_str);

    ff = '1000';
    fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));

end

for kk = 300:100:500
    k=3;
    %Parameters for bent fibre
    openname = strcat('Q4_Foci_kk_', num2str(kk), '_k3.mat');
    load(openname);
    output_img_H_bent = sub_ill(N, 49^2, output_img_H_bent);
    output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);
    
    CC = corrcoef(output_img_H_bent, output_img_H_str);
    
    ff = num2str(kk); 
    fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));
    
end

fclose(ID);
