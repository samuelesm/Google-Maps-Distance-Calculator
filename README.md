# Google-Maps-Distance-Calculator
Matlab code for Georgia Tech EcoCAR 3 competition in 2016-2017 for generating precise real world distances

In the innovation category, our team is proposing a program that will use map data on a 
set GPS route to optimize battery charge. The program would get various data including, 
coordinates, elevation, distance, average speed, average time, and change in angle for every
segment traveled. Using this information, the car would know how to use its energy better. For 
example, if the hill is sloped downward, the car will know that it should attempt to recover the 
unnecessary kinetic energy. The unit that we will be using to handle all of this is a GPS device 
called TomTom. However, due to it coming so late, we had to create our first iteration of our 
algorithms elsewhere. I was responsible for getting the map and route data, and I wrote the code 
in MATLAB and I used data requested from Google maps. The next step is to convert all of our 
work into code to be used by the TomTom. 

In the MATLAB code I have written, coordinates, elevation, change in pitch and yaw, and 
distances are retrieved. To run the code, simply open the main file, locationdata2.m and put the 
starting and end point as the inputs. 

[out,out2] = locationData2(start, dest)

Here is how the code works in order. 
- The code first gets a polyline from Google. 
- Then the polyline is run in another function called googlePolylineDecoder.m, which 
converts the polyline into an array of coordinates. (extra MATLAB toolboxes required)
This code is from the Mathworks website. 
- Then elevation data is retrieved from Google for all of the coordinate points. 
- The elevation data is requested at a rate of 100 coordinates at a time, because if all are 
requested at once, Google’s servers get overloaded. Also, they are not requested 
individually as Google only allows 1000 free queries per day. 
- The coordinates and corresponding coordinates are then run in another function called 
earthDistance.m, which them calculates the distance between each point as well as the 
pitch and yaw angles. Earth is not completely sphereical, so they use ellipsoidal formulae, 
distance formula, and trigonometry to calculate the data. The standard it’s following is 
WGS (84), which is commonly used by GPS navigation systems. The tested distances are 
the same as what Google outputs.
