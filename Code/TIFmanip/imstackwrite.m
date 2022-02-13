function imstackwrite(ImStack,FileName)

Tiff(FileName,'w');
for ii=2:size(ImStack,3)
    disp(['image writing Z: ' num2str(ii)]);
    Tiff(ImStack(:,:,ii),FileName,'tif','writemode','append');
    %tiff(ImStack(:,:,ii),FileName,'tif','writemode','append');
end