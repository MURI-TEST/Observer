%% Create Sinusodial Tilt Profiles for Observer

%% User input
frequency = 0.5; %frequency of tilt in Hz (this also defines the time taken)
displacement = 3; %total degrees at end of motion
simFrequency = 100;

%% Constant Calculations
totalTime = 1/frequency; %time in seconds
timeConstant = 2*pi/totalTime; %normalizing constant
time = linspace(0, totalTime, totalTime*simFrequency); %time vector
magnitudeConstant = displacement/(totalTime/timeConstant - sin(totalTime*timeConstant)/timeConstant/timeConstant); %normalizing constant

%% Compute p, v and a
angularAccelerationX = sin(time*timeConstant)*magnitudeConstant;
angularVelocityX = (1/timeConstant - cos(time*timeConstant)/timeConstant)*magnitudeConstant;
angularPositionX = (time/timeConstant - sin(time*timeConstant)/timeConstant/timeConstant)*magnitudeConstant;

%% plot
plot(time, angularAccelerationX);
hold on;
plot(time, angularVelocityX);
plot(time, angularPositionX);

%% Write to xlsx that Observer can read
currentFolder = pwd;

% set up what senses are 'on'
g_zvis = ones(1,length(time))*-1;
angularVelocityXvisual = angularVelocityX;
POS_on = ones(1,length(time));
VEL_on = ones(1,length(time));
ANGVEL_on = ones(1,length(time));
g_on = ones(1,length(time));

% Observer is set up to take 24 columns of input data.
writeToXlsx = time';
columnHeaders = {
   'time';
   'xvest';
   'yvest';
   'zvest';
   'angularVelocityX'; %in x
   'wyvest';
   'wzvest';
   'xvis';
   'yvis';
   'zvis';
   'xdotvis';
   'ydotvis';
   'zdotvis';
   'angularVelocityXvisual';
   'wyvis';
   'wzvis';
   'g_xvis';
   'g_yvis';
   'g_zvis';
   'g';
   'POS_on';
   'VEL_on';
   'ANGVEL_on';
   'g_on'};

% set up write array

for i = 2:24
    try write = eval(columnHeaders{i})';
        writeToXlsx = [writeToXlsx,write];
    catch
        writeToXlsx = [writeToXlsx, zeros(length(time),1)];
    end
end

% write column headers
xlswrite([currentFolder,'\','TiltProfile.xls'], columnHeaders', 'Sheet1', 'A1');
% write array
xlswrite([currentFolder,'\','TiltProfile.xls'], writeToXlsx, 'Sheet1', 'A2');