% By Raphael Turcotte (2021)
% rturcotte861@gmail.com

clear

Results = 'Results_Q4_illumination_correlation_speckle.txt';
ID = fopen(Results,'a+');

%Parameters for straight fibre
load("Q1-120-120-49.mat");
output_img_H_str = output_img_H;
output_img_H_str = reshape(output_img_H_str, [N^2*49^2, 1]);

for k = 0:4
    for kk = 2500
        %Parameters for bent fibre
        openname = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        load(openname);
        output_img_H_bent = output_img_H;
        output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);
        
        CC = corrcoef(output_img_H_bent, output_img_H_str);
        
        ff = num2str(kk);
        fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));
    end
end

for k = 2:3
    for kk = 5000
        %Parameters for bent fibre
        openname = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        load(openname);
        output_img_H_bent = output_img_H;
        output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);
        
        CC = corrcoef(output_img_H_bent, output_img_H_str);
        
        ff = num2str(kk);
        fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));
    end
end

for k = 2:3
    for kk = 1000
        %Parameters for bent fibre
        openname = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        load(openname);
        output_img_H_bent = output_img_H;
        output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);
        
        CC = corrcoef(output_img_H_bent, output_img_H_str);
        
        ff = num2str(kk);
        fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));
    end
end

for k = 3
    for kk = 300:100:900
        %Parameters for bent fibre
        openname = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        load(openname);
        output_img_H_bent = output_img_H;
        output_img_H_bent = reshape(output_img_H_bent, [N^2*49^2, 1]);
        
        CC = corrcoef(output_img_H_bent, output_img_H_str);
        
        ff = num2str(kk);
        fprintf(ID,[ff '\t%10.4f\t%10.4f\n'], k, CC(2,1));
    end
end

fclose(ID);
