%% plot pairs

%%

%% User Inputs
file1='TiltProfile_3d_0.2Hz.xls';
file2='TiltProfile_3d_0.2Hz_lightsOffHalf.xls';

handles_1 = ObserverNoGUIfn(file1);
handles_2 = ObserverNoGUIfn(file2);

plottingOverlayfn_2(handles_1, handles_2)