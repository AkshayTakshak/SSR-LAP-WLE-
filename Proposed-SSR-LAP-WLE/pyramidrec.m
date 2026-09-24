function imgRec = pyramidrec(imgDec)

level = numel(imgDec);        % number of pyramid levels
imgRec = imgDec{level};       % start from base layer

for i = level-1:-1:1
    imgRec = imgDec{i} + pyramidexpand(imgRec);
end

end
