function thecmap=sebasColorTable()
    D = [1 1 1;
         0 0 1;
         0 1 0;
         1 1 0;
         1 0 0;];
    F = [0 0.25 0.5 0.75 1];
    G = linspace(0, 1, 256);
    thecmap = interp1(F,D,G);
%     imagesc(topbot)
%     colormap(thecmap)
%     caxis([-1 25])
end