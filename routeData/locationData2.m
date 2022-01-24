function [out,out2] = locationData2(start, dest)
% Put starting and ending addresses in start and dest respectively as a
% string
% The following turns the address into a format for web data request from
% Google's API
strt = strsplit(start); % split starting address string
dst = strsplit(dest); % split ending address string
snum = numel(strt); % count the number of elements for the for loops
dnum = numel(dst); % count the number of elements for the for loops
% This loops adds '+''s in between each element of the starting address
addr1 = '';
for i = 1:snum-1
    addr1 = [addr1,strt{i},'+'];
end
addr1 = [addr1,strt{snum}];
% This loops adds '+''s in between each element of the ending address
addr2 = '';
for i = 1:dnum-1
    addr2 = [addr2,dst{i},'+'];
end
addr2 = [addr2,dst{dnum}];
% Both address strings are now completed
datatxt = 'https://maps.googleapis.com/maps/api/directions/json?origin='; % Base URL
keydirections = 'AIzaSyCjy8ZLVpZmOXvZ7SS-iEVKAYd2w9AsLbA'; % API Key for Google data request
% Construct the URL for data from Google in format data = webread('https://maps.googleapis.com/maps/api/directions/json?origin=470+16th+st+nw,+atlanta,+ga&destination=6000 N Terminal Pkwy,+GA&key= AIzaSyCjy8ZLVpZmOXvZ7SS-iEVKAYd2w9AsLbA ');
dataStr = [datatxt,addr1,'&destination=',addr2,'&key=',keydirections];
data = webread(dataStr);
%this gets all of the points from Google's polyline
len = length(data.routes.legs.steps); % This gets the number of polylines there are
% The first iteration is done outside of the loop to lessen complications
polywhirl = data.routes.legs.steps{1,1}.polyline.points; 
[latOut,lonOut] = googlePolyLineDecoder(polywhirl,0); % Decode the polyline using googlePolyLine.m
latlon = [latOut;lonOut]; %array of coordinates for the polyline of each stint
for i = 2:len
    polywhirl = data.routes.legs.steps{i,1}.polyline.points;
    [latOut,lonOut] = googlePolyLineDecoder(polywhirl,0);
    platlon = [latOut;lonOut];
    latlon = [latlon,platlon];
end
% Now we're getting the elevation for each of the points 
len2 = length(latlon); % This gets the number of points
z = zeros(1,len2); 
latlon = [latlon;z]; % This adds a 3rd row of 0's. 
keyelevation = 'AIzaSyCiEeTU6VkUe4UW7m9Qoafz3eHLCdi7eF8'; % Key for elevation
elet = 'https://maps.googleapis.com/maps/api/elevation/json?locations='; % Base web address

m1 = mod(len2,100);
m2 = floor(len2/100);

if (m2 > 0)
    for x = 1:m2
        eletxt = []; % Initialize text array
        for y = 1+100*(x-1):100*(x) % Index is calculated to request 350 at a time. It can only request about this much at a time. This part may take a while
            latTxt = num2str(latlon(1,y)); % Index for latitude and convert it into string
            lonTxt = num2str(latlon(2,y)); % Index for latitude and convert it into string
            eletxt = [eletxt,latTxt,',',lonTxt,'|']; % Concatenate necessasry coordinates
        end
        eletxt(end) = []; % removes extra or
        eletxt = [elet,eletxt,'&key=',keyelevation]; % Create web address string for elevation request
% Constructs address like this elevation = webread('https://maps.googleapis.com/maps/api/elevation/json?locations=33.6396206,-84.4425787&key= AIzaSyCiEeTU6VkUe4UW7m9Qoafz3eHLCdi7eF8 ');
        elevation = webread(eletxt); % Request access to elevation for coordinates
        for y = 1+100*(x-1):100*(x) % put the results in the data array
            latlon(3,y) = elevation.results(y-100*(x-1)).elevation;
        end
    end
end
eletxt = [];
for y = 1+100*m2:m1+100*m2 % Index is for the remainder is now added for the final request
    latTxt = num2str(latlon(1,y)); % Index for latitude and convert it into string
    lonTxt = num2str(latlon(2,y)); % Index for latitude and convert it into string
    eletxt = [eletxt,latTxt,',',lonTxt,'|']; % Concatenate necessasry coordinates
end
eletxt(end) = []; % removes extra '|'
eletxt = [elet,eletxt,'&key=',keyelevation]; % Create web address string for elevation request
% Constructs address like this elevation = webread('https://maps.googleapis.com/maps/api/elevation/json?locations=33.6396206,-84.4425787&key= AIzaSyCiEeTU6VkUe4UW7m9Qoafz3eHLCdi7eF8 ');
elevation = webread(eletxt); % Request access to elevation for coordinates
for y = 1+100*m2:m1+100*m2
    latlon(3,y) = elevation.results(y-100*m2).elevation;
end

distances = earthDistance(latlon,len2);
% distance key: AIzaSyC4mgKr72_u-KSbBLiVSW_BBuo6OUzn3yM

%sp = speed(latlon);

out = distances;
out2 = latlon;%data;

end