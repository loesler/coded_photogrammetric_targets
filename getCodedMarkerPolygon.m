%%
% Description:
% Generates polygon of specific coded marker
%
% Author:
% Michael Loesler
%
% Original:
% Matthew Petroff (2018) Photogrammetry Targets. 
% https://mpetroff.net/2018/05/photogrammetry-targets/
%
% Generate codes for circular coded photogrammetry targets.
% Implementation of coding scheme of (expired) patent DE19733466A1.
% https://patents.google.com/patent/DE19733466A1/
% https://register.dpma.de/DPMAregister/pat/register?AKZ=197334660
% 
% This script is released into the public domain using the CC0 1.0 Public
% Domain Dedication: https://creativecommons.org/publicdomain/zero/1.0/
% 
function [marker] = getCodedMarkerPolygon(x_center, y_center, dot_radius, bits, code)
    n = 2000;
    phi = linspace(0, 360, n);
    marker = polyshape(x_center + cosd(phi) * dot_radius, y_center + sind(phi) * dot_radius);

    for i=0:bits-1
        if bitand(bitsll(1, bits - 1 - i), code)
            phi = -linspace(360 / bits * i, 360 / bits * (i + 1), n);

            x_1 = x_center + cosd(phi) * dot_radius * 2.0;
            y_1 = y_center + sind(phi) * dot_radius * 2.0;

            x_2 = x_center + cosd(phi) * dot_radius * 3.0;
            y_2 = y_center + sind(phi) * dot_radius * 3.0;

            X = [x_1 fliplr(x_2)];
            Y = [y_1 fliplr(y_2)];

            marker = union(marker, polyshape(X,Y));
        end
    end
return;