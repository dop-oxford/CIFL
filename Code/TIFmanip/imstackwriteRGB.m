function imstackwriteRGB(ImStack,FileName)
for ii=1:size(ImStack,4)
    %disp(['image writing Z: ' num2str(ii)]);
    imwrite(ImStack(:,:,:,ii),[FileName(1:end-4) sprintf('%04d',ii-1) '.tif'],'tif');
end