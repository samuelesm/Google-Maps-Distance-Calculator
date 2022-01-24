function dist = earthDistance(in1,in2)

% https://en.wikipedia.org/wiki/Earth_ellipsoid
% https://en.wikipedia.org/wiki/Reference_ellipsoid
% the only desprepency is that there is no differntiation between North and
% South latitudes. This is only a problem if the car crosses the equator. 

a = 6378137; % Equatorial Radius (m) WGS(84)
b = 6356752.3142;% Polar Radius (m) WGS(84)
dist = zeros(5,in2-1);

for i =1:in2-1
    % converting the coordinates to radians
    lat1 = in1(1,i)*(pi/180);
    lat2 = in1(1,i+1)*(pi/180);
    lon1 = in1(2,i)*(pi/180);
    lon2 = in1(2,i+1)*(pi/180);
    
    len1 = in1(3,i);
    len2 = in1(3,i+1);
    % This is getting the displacement between each point
    N1 = (a^2)/sqrt(((a^2)*(cos(lat1)^2))+((b^2)*(sin(lat1)^2))); % radius of curvature of point 1
    x1 = (N1+len1)*cos(lat1)*cos(lon1); % x coordinate of point1
    y1 = (N1+len1)*cos(lat1)*sin(lon1); % y coordinate of point1
    z1 = (((b^2)/(a^2))*N1+len1)*sin(lat1); % z coordinate of point1    
    N2 = (a^2)/sqrt(((a^2)*(cos(lat2)^2))+((b^2)*(sin(lat2)^2))); % radius of curvature of point 2
    x2 = (N2+len2)*cos(lat2)*cos(lon2); % x coordinate of point2
    y2 = (N2+len2)*cos(lat2)*sin(lon2); % y coordinate of point2
    z2 = (((b^2)/(a^2))*N2+len2)*sin(lat2); % z coordinate of point2
    d1 = sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
    % put the value into the array
    dist(1,i) = d1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculation for finding the elevation angle between each coordinate.
    % Positive and negative values represent an upward and downward slope
    % respectively, and the values are expressed in radians
    % the following uses the same elevation as the first point to create a right triangle
    N22 = (a^2)/sqrt(((a^2)*(cos(lat2)^2))+((b^2)*(sin(lat2)^2))); % radius of curvature of point 2
    x22 = (N22+len1)*cos(lat2)*cos(lon2); % x coordinate of point2
    y22 = (N22+len1)*cos(lat2)*sin(lon2); % y coordinate of point2
    z22 = (((b^2)/(a^2))*N22+len1)*sin(lat2); % z coordinate of point2
    d2 = sqrt(((x22-x1)^2)+((y22-y1)^2)+((z22-z1)^2));
    
    % checks if there is no slope there is no need to account for vertical
    % slopes
    if (d2 ~= d1)
        ang1 = acos(d2/d1);
    end
    if (d2 == d1)
        ang1 = d1;
    end
    %checks if the slope is downwards or upwards
    if (len1 > len2)
        ang1 = ang1*(-1);
    end
    % put the value into the array
    dist(2,i) = ang1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % the following finds the plane view angle between each point 
    % its range is from 0 to 2pi and 0 rad indicates an eastward direction
    N13 = (a^2)/sqrt(((a^2)*(cos(lat1)^2))+((b^2)*(sin(lat1)^2))); % radius of curvature of point 1
    x13 = (N13+len1)*cos(lat1)*cos(lon2); % x coordinate of point1
    y13 = (N13+len1)*cos(lat1)*sin(lon2); % y coordinate of point1
    z13 = (((b^2)/(a^2))*N13+len1)*sin(lat1); % z coordinate of point1  
    d3 = sqrt(((x13-x1)^2)+((y13-y1)^2)+((z13-z1)^2));
    % converts west or negative longitudonal coordinates to 2pi rad
    % coordinates
    if (lon1 < 0)
        lon1 = 2*pi-abs(lon1);
    end
    if (lon2 < 0)
        lon2 = 2*pi-abs(lon2);
    end
    % checks if there is no slope
    if (d3 ~= d2)
        ang2 = acos(abs(d3/d2));
    end
    if (d3 == d2 && (lon2>lon1))
        ang2 = 0;
    end
    if (d3 == d2 && (lon2<lon1))
        ang2 = pi;
    end
    % the following converts the angles to the 2pi radian scale
    if ((lat1 > lat2) && (lon1 > lon2))
        ang2 = ang2+pi;
    end
    if ((lat1 < lat2) && (lon1 > lon2))
        ang2 = pi-ang2;
    end
    if ((lat1 > lat2) && (lon1 < lon2))
        ang2 = 2*pi-ang2;
    end
    % put the value into the array
    dist(3,i) = ang2;
    
end
for i =1:in2-2
    dist(4,i+1) = dist(3,i+1)-dist(3,i);
%     if (abs(dist(4,i+1)) > pi) 
%         if (dist(4,i+1) > 0)
%             dist(4,i+1) = dist(4,i+1)-(2*pi);
%         else
%             dist(4,i+1) = (2*pi)-dist(4,i+1);
%         enda
%     end
    dist(5,i) = dist(4,i) * (180/pi);
end

end