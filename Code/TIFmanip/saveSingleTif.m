function saveSingleTif(file, data,method)
if exist(file)==0
else
    delete(file)
end
if nargin==2
    method=1;
end
[m,n,p]=size(data);
if m~=n
    method=2;
end

if method==1

    tifstreamobj2 = TifStream(file, size(data,2), size(data,1), 16);
    for jj=1:size(data,3)
            tifstreamobj2.appendFrame(data(:,:,jj));
    end 
    tifstreamobj2.close;        
elseif method==2
    data=uint16(data);
    bigtiff=false;
    fname=file;
    bitspersamp=16;
     if bigtiff
        t = Tiff(fname,'w8');
    else
        t = Tiff(fname,'w');
    end
    tagstruct.ImageLength = size(data,1);
    tagstruct.ImageWidth = size(data,2);
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    if bitspersamp==16
        tagstruct.BitsPerSample = 16;
    end
    if bitspersamp==32
        tagstruct.BitsPerSample = 32;
    end
    tagstruct.SamplesPerPixel = 1;
    tagstruct.RowsPerStrip = 256;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.Software = 'MATLAB';
    t.setTag(tagstruct);
    t.write(data(:,:,1));
    numframes = size(data,3);
    divider = 10^(floor(log10(numframes))-1);
    tic
    for i=2:numframes
        t.writeDirectory();
        t.setTag(tagstruct);
        t.write(data(:,:,i));
        if (round(i/divider)==i/divider)
            fprintf('Frame %d written in %.0f seconds, %2d percent complete, time left=%.0f seconds \n', ...
                i, toc, i/numframes*100, (numframes - i)/(i/toc));
        end
    end
    t.close();    

end
    