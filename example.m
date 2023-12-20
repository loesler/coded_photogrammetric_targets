clear variables;
close all;
format long g;
clc;

dot_radius = 1;
bits       = 8;
codes      = getRingCodes(bits);
columns    = 4;
rows       = ceil(numel(codes)/columns);

plotParameterMarker = {};
plotParameterMarker.FaceAlpha = 1.0;
plotParameterMarker.EdgeAlpha = 1.0;
plotParameterMarker.LineStyle = 'none';
plotParameterMarker.LineWidth = 1;
plotParameterMarker.FaceColor = [0 0 0];
plotParameterMarker.EdgeColor = [0 0 0];

fig = figure('Name', ['Coded Markers (', num2str(bits), ' bit)'], 'Units', 'centimeters'); 
for i=1:rows
    for j=1:columns
        num = columns * (i - 1) + j;
        subplot(rows, columns, num);
        hold on;

        if num <= numel(codes)
            code = codes(num);
            marker = getCodedMarkerPolygon(0, 0, dot_radius, bits, code);
            plot(marker, plotParameterMarker);
            text(3.5*dot_radius, 3.5*dot_radius, num2str(num), 'Color', [0 0 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
        end
        xlim([-4, 4])
        ylim([-4, 4])
        xticks([]);
        yticks([]);
        xticklabels({});
        yticklabels({});
        box on;
        axis equal;
        hold off;
    end
end
