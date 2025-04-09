%Finding the speed of the spring when it is being compressed.
crank = 6500;                    % Red line RPM
tGear = 2;                       % Timing gear ratio
cam = crank/tGear;               % rpm of the cam
springCompDis = 0.551;           % Spring compression distance
rockerArm = 1.7;                 % ratio of the rocker arms

%Speed of the spring being compressed. ft/sec
compressionSpeed = cam*springCompDis*2*pi/60/12;
display(compressionSpeed,'Spring compression speed ft/sec')

%speed that the crank needs to spin for the testing 
crankSpeed = cam*rockerArm;
display(crankSpeed,'Crank speed rpm')


%Spring pressure calculation
springRate = 392;                              % lbs/in
preLoad = 160;                                 % pressure at 1.8 inch install height
springBDS = springRate*springCompDis+preLoad;   % Pressure af full compression

display(springBDS,'Total Spring Pressure lbs')
