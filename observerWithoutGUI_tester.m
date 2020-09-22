%*********************** LOAD VALUES AND START SIMULATION **************************
%% user inputs

%File to load
file_to_open = 'TiltProfile.xls';

% Initialize gravity condition. g = 1 is earth gravity
g = 1;

% Initialize tilt angle
x_tilt_IC = 0;
y_tilt_IC = 0;
z_tilt_IC = 1;

%Internal Model SCC Time Constant is Set to CNS time constant,
tau_scc_edit_text = 5.7;

% Initialize scc time constants [x y z]'
tau_scc = 5.7;

% Initialize scc adaptation time constants
tau_a_value = 80.0;

% Initialize the low-pass filter frequency for scc
f_oto = 2.0;

% Initialize the lpf frequency for otolith
f_scc = 2.0;

% Initialize the Ideotropic Bias Amount 'w'
w = 0;

% Initialize Kww feedback gain
kww = 8.0;

% Initialize Kfg feedback gain
kfg = 4.0;

% Initialize Kfw feedback gain
kfw_edit_text = 8.0;

% Initialize Kaa feedback gain
ka_edit_text = -4.0;

% Initialize Kwg feedback gain
kwf_edit_text = 1.0;

% Initialize Kvg feedback gain
tilt_visual_edit_text = 5.0;

% Initialize Kvw feedback gain
omega_visual_edit_text = 10.0;

% Initialize Kxdotva feedback gain
velocity_visual_edit_text = 0.75;

% Initialize Kxvv feedback gain
position_visual_edit_text = 0.1;

% Initialize Visual Position LPF Frequency
position_LPF_visual_edit_text = 2.0;

% Initialize Visual Velocity LPF Frequency
velocity_LPF_visual_edit_text = 2.0;

% Initialize Visual Angular Velocity LPF Frequency
omega_LPF_visual_edit_text = 0.2;

% Initialize  X Leaky Integration Time Constant
x_leak = 0.6;

% Initialize  Y Leaky Integration Time Constant
y_leak = 0.6;

% Initialize  X Leaky Integration Time Constant
z_leak = 10.0; 



%% Compute Initial Conditions from User Input

%Initialize the GRAVITY input to the model [gx0 gy0 gz0]'
G0=[0 0 -g]'; 
assignin('base', 'G0', G0);

% Initialize the internal GRAVITY STATE of the model
GG0=G0;
assignin('base', 'GG0', GG0);

% Tilt Angle
g_x = x_tilt_IC;
g_y = y_tilt_IC;
g_z = z_tilt_IC;
g_mag = sqrt(g_x*g_x + g_y*g_y + g_z*g_z);
g_norm = [g_x/g_mag g_y/g_mag g_z/g_mag]';
assignin('base', 'g_norm', g_norm);

% Initialize Quaternions
if g_norm(1) == G0(1) && g_norm(2) == G0(2)
    Q0 = [1 0 0 0]';
    VR_IC = [0 0 0 0];
else
    % Perpendicular Vector
    E_vec = CROSS(g_norm,[0 0 -1]);
    % Normalize E vector
    E_mag = sqrt(E_vec(1)*E_vec(1) + E_vec(2)*E_vec(2) + E_vec(3)*E_vec(3));
    E = E_vec./E_mag;
    % Calculate Rotation angle
    E_angle = acos(DOT(g_norm,[0 0 -1]));
    % Calculate Quaternion
    Q0 = [cos(E_angle/2) E(1)*sin(E_angle/2) E(2)*sin(E_angle/2) E(3)*sin(E_angle/2)]';
    VR_IC = [E,E_angle];
end

assignin('base', 'Q0', Q0);
assignin('base', 'VR_IC', VR_IC);


% Preload Idiotropic Vecdtor
h = [0 0 -1];
assignin('base', 'h', h);

% Preload Idiotropic Bias
w = 0;
assignin('base', 'w', w);

% Initialize scc time constants [x y z]'
tau_scc_value = tau_scc_edit_text;
tau_scc=tau_scc_value*[1 1 1]';
assignin('base', 'tau_scc', tau_scc);

%Internal Model SCC Time Constant is Set to CNS time constant,
tau_scc_cap=tau_scc;
assignin('base', 'tau_scc_cap', tau_scc_cap);

% Initialize scc adaptation time constants
tau_a=tau_a_value*[1 1 1]';
assignin('base', 'tau_a', tau_a);

% Initialize the low-pass filter frequency for scc
assignin('base', 'f_oto', f_oto);

% Initialize the lpf frequency for otolith
assignin('base', 'f_scc', f_scc);

% Initialize the Ideotropic Bias Amount 'w'
assignin('base', 'w', w);

% Initialize Kww feedback gain
assignin('base', 'kww', kww);

% Initialize Kfg feedback gain
assignin('base', 'kfg', kfg);

% Initialize Kfw feedback gain
kfw = kfw_edit_text*[1 1 1]';
assignin('base', 'kfw', kfw);

% Initialize Kaa feedback gain
kaa = ka_edit_text*[1 1 1]';
assignin('base', 'kaa', kaa);

% Initialize Kwg feedback gain
kwg = kwf_edit_text*[1 1 1]';
assignin('base', 'kwg', kwg);

% Initialize Kvg feedback gain
kgvg = tilt_visual_edit_text*[1 1 1]';
assignin('base', 'kgvg', kgvg);

% Initialize Kvw feedback gain
kwvw = omega_visual_edit_text*[1 1 1]';
assignin('base', 'kwvw', kwvw);

% Initialize Kxdotva feedback gain
kxdotva = velocity_visual_edit_text*[1 1 1]';
assignin('base', 'kxdotva', kxdotva);

% Initialize Kxvv feedback gain
kxvv = position_visual_edit_text*[1 1 1]';
assignin('base', 'kxvv', kxvv);

% Initialize Visual Position LPF Frequency
f_visX = position_LPF_visual_edit_text;
assignin('base', 'f_visX', f_visX);

% Initialize Visual Velocity LPF Frequency
f_visV = velocity_LPF_visual_edit_text;
assignin('base', 'f_visV', f_visV);

% Initialize Visual Angular Velocity LPF Frequency
f_visO = omega_LPF_visual_edit_text;
assignin('base', 'f_visO', f_visO);

% Initialize Graviceptor Gain
oto_a = 60*[1 1 1]';
assignin('base','oto_a', oto_a);

% Initialize Adapatation time constant
oto_Ka = 1.3*[1 1 1]';
assignin('base','oto_Ka', oto_Ka);

% Initialize  X Leaky Integration Time Constant
assignin('base', 'x_leak', x_leak);

% Initialize  Y Leaky Integration Time Constant
assignin('base', 'y_leak', y_leak);

% Initialize  X Leaky Integration Time Constant
assignin('base', 'z_leak', z_leak);

%Load data file
input_file= xlsread(file_to_open);
time = input_file(:,1);
x_in = [input_file(:,2),input_file(:,3),input_file(:,4)];
omega_in = [input_file(:,5),input_file(:,6),input_file(:,7)];
xv_in = [input_file(:,8),input_file(:,9),input_file(:,10)];
xvdot_in = [input_file(:,11),input_file(:,12),input_file(:,13)];
omegav_in = [input_file(:,14),input_file(:,15),input_file(:,16)];
gv_in = [input_file(:,17),input_file(:,18),input_file(:,19)];
g_variable_in =input_file(:,20);
pos_ON =input_file(:,21);
vel_ON =input_file(:,22);
angVel_ON =input_file(:,23);
g_ON =input_file(:,24);

handles.switch_xvdot = vel_ON;
handles.switch_xv = vel_ON;
handles.switch_omegav = angVel_ON;
handles.switch_gv = g_ON;

handles.x_in = x_in;


% Time and Tolerance Properties set by data input file to ensure a correct
% sampling rate.
delta_t = time(2) - time (1);
duration = length(time)*delta_t;
sample_rate = 1/delta_t;
t = time;
handles.t = t;
tolerance = 0.02;

% Differentiate Position to Velcoity to Acceleration
v_in = zeros(size(x_in,1),3);
v_in(1:size(x_in,1)-1,:) = diff(x_in,1)/delta_t;

a_in = zeros(size(x_in,1),3);
a_in(1:size(x_in,1)-2,:) = diff(x_in,2)/(delta_t*delta_t);

% If we want to input straight acceleration NEED TO COMMENT OUT ABOVE and
% uncomment the below. Note that Actual Position and Actual velocity plots
% will be innaccurate if we do so.
%a_in = x_in;
%v_in = a_in;

% Read Data to Workspace
assignin('base', 't', t);
assignin('base', 'x_in', x_in);
assignin('base', 'xv_in', xv_in);
assignin('base', 'a_in', a_in);
assignin('base', 'v_in', v_in);
assignin('base', 'xvdot_in', xvdot_in);
assignin('base', 'omega_in', omega_in);
assignin('base', 'omegav_in', omegav_in);
assignin('base', 'gv_in', gv_in);
assignin('base', 'g_variable_in', g_variable_in);
assignin('base', 'pos_ON', pos_ON);
assignin('base', 'vel_ON', vel_ON);
assignin('base', 'angVel_ON', angVel_ON);
assignin('base', 'g_ON', g_ON);
assignin('base', 'delta_t', delta_t);
assignin('base', 'duration', duration);
assignin('base', 'tolerance', tolerance);

% Load the VR model or the non VR model depending on state of VR tookbox.
checkVR = vrinstall('-check','viewer');

if(checkVR == 1)
    model='observerModel';
    vrsetpref('DefaultViewer','internal');
else
    model='observerModelnoVR';
end
tic;
% Execute Simulink Model
options=simset('Solver','ode45','MaxStep',tolerance,'RelTol',tolerance,'AbsTol',tolerance);
[t_s, XDATA, a_est, gif_est, gif_head, a_head, omega_head,g_head,g_est,omega_est,x_est,lin_vel_est,lin_vel,x,alpha_omega] = sim(model,duration,options,[]);

% Calculate Time of simulation
sim_Time = num2str(toc);

% Bring variables from GUI to workspace
sim_time = t_s;
assignin('base', 'model', model);
assignin('base', 't_s', t_s);
assignin('base', 'sim_time', sim_time);
assignin('base', 'a_est', a_est);
assignin('base', 'omega_est', omega_est);
assignin('base', 'gif_est', gif_est);
assignin('base', 'gif_head', gif_head);
assignin('base', 'a_head', a_head);
assignin('base', 'omega_head', omega_head);
assignin('base', 'g_head', g_head);
assignin('base', 'g_est', g_est);
assignin('base', 'x_est', x_est);
assignin('base', 'lin_vel_est', lin_vel_est);
assignin('base', 'lin_vel', lin_vel);
assignin('base', 'x', x);
assignin('base', 'alpha_omega', alpha_omega);


%Calculate Angular Accelerations for SDAT

%Calculate the time step from simulink
sim_dt = t_s(size(t_s,1)) - t_s(size(t_s,1)-1);

omega_dot_head = zeros(size(omega_head,1),3);
omega_dot_head(1:size(omega_head,1)-1,:) = diff(omega_head,1)/sim_dt;

omega_dot_est = zeros(size(omega_est,1),3);
omega_dot_est(1:size(omega_est,1)-1,:) = diff(omega_est*180/pi,1)/sim_dt;

assignin('base', 'omega_dot_head', omega_dot_head);
assignin('base', 'omega_dot_est', omega_dot_est);
assignin('base', 'sim_dt', sim_dt);

%Calculate Vertical, SVV, Tilt, and Estimated Tilt, along with Errors
tilt_estTEMP(:,1) = tilt_est(1,1,:);
tiltTEMP(:,1) = tilt(1,1,:);
tilt = tiltTEMP;
tilt_est = tilt_estTEMP;
SVV = SVV*180/3.14159;
SVV_est = SVV_est*180/3.14159;
tilt = real(tilt*180/3.14159);
tilt_est = real(tilt_est*180/3.14159);
plot_SVV(:,1) = SVV;
plot_SVV(:,2) = SVV_est;
plot_tilt(:,1) = tilt;
plot_tilt(:,2) = tilt_est;
handles.plot_tilt = plot_tilt;
handles.plot_SVV = plot_SVV;
assignin('base', 'plot_tilt', plot_tilt);
assignin('base', 'plot_SVV', plot_SVV);
assignin('base', 'azimuth_est', azimuth_est);
assignin('base', 'azimuth_head', azimuth_head);
assignin('base', 'euler_head', euler_head);
assignin('base', 'euler_est', euler_est);
assignin('base', 'tilt_est', tilt_est);
assignin('base', 'SVV_est', SVV_est);
assignin('base', 'tilt', tilt);
assignin('base', 'SVV', SVV);
assignin('base', 'g_world', g_world);


% Load Variables in the handle structure
handles.t_s = t_s;
handles.a_est = a_est;
handles.omega_est = omega_est;
handles.gif_est = gif_est;
handles.gif_head = gif_head;
handles.a_head = a_head;
handles.omega_head = omega_head;
handles.g_est = g_est;
handles.g_head = g_head;
handles.x_est = x_est;
handles.lin_vel_est = lin_vel_est;
handles.lin_vel = lin_vel;
handles.x = x;
handles.azimuth_head = azimuth_head;
handles.azimuth_est = azimuth_est;
handles.euler_head = euler_head;
handles.euler_est = euler_est;
handles.tilt = tilt;
handles.SVV = SVV;
handles.tilt_est = tilt_est;
handles.SVV_est = SVV_est;
handles.g_world = g_world;
