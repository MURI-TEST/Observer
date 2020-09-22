% Code provided for educational purposes courtesy or Torin Clark, Charles
% Oman, and Michael Newman. Please do not distribute.


% ******************* Begin initialization code - DO NOT EDIT **********************
function varargout = observer(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @observer_OpeningFcn, ...
                   'gui_OutputFcn',  @observer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% **********************************************************************************


% **************Executes just before observer is made visible **********************
function observer_OpeningFcn(hObject, eventdata, handles, varargin)

% Check VR Toolbox Installation
checkVR = vrinstall('-check','viewer');
if(checkVR == 1)
    %If Installed make VR Bustton Viewable
    set(handles.VR_pushbutton,'Enable','on');
    set(handles.VR_pushbutton,'CData',imread('vrON.jpg'));
else
    %If not Make Button Invisible and Display Warning Dialog
    set(handles.VR_pushbutton,'Enable','inactive');
    set(handles.VR_pushbutton,'CData',imread('vrOFF.jpg'));
    err = errordlg('You do not have VR TOOLBOX Viewer Installed Some Features on the GUI will be disabled. If you have purchased VR TOOLBOX type "vrinstall" in the Command Window to install the viewer and reload the GUI.','Observer Warning!','modal');
    figure(err);
    uiwait(err);
end

% Load GUI and turn off warnings
warning('off', 'all');
movegui('center');

% Set background image and properties
ha = axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'bottom');
Image = imread('back2.jpg');
plot_background = imagesc(Image);
set(ha,'handlevisibility','off','visible','off')

% Set Button Pictures as Inactive
set(handles.start_simulation,'CData',imread('startOFF.jpg'));
set(handles.export_Data,'CData',imread('exportOFF.jpg'));
set(handles.plot_pushbutton,'CData',imread('plotOFF.jpg'));
set(handles.gif_visual_pushbutton,'CData',imread('3dOFF.jpg'));
set(handles.VR_pushbutton,'CData',imread('vrOFF.jpg'));

%********************************* GAIN VALUES*************************************
%Values to Load when GUI starts
opening_kw = '8.0';
set(handles.kw_edit_text,'String',opening_kw);
opening_kf = '4.0';
set(handles.kf_edit_text,'String',opening_kf);
opening_kfw = '8.0';
set(handles.kfw_edit_text,'String',opening_kfw);
opening_ka = '-4.0';
set(handles.ka_edit_text,'String',opening_ka);
opening_kwf = '1.0';
set(handles.kwf_edit_text,'String',opening_kwf);
opening_kvg = '5.0';
set(handles.tilt_visual_edit_text,'String',opening_kvg);
opening_kvw = '10.0';
set(handles.omega_visual_edit_text,'String',opening_kvw);
opening_kxdotva = '0.75';
set(handles.velocity_visual_edit_text,'String',opening_kxdotva);
opening_kxvv = '0.1';
set(handles.position_visual_edit_text,'String',opening_kxvv);
opening_X_LPF = '2.0';
set(handles.position_LPF_visual_edit_text,'String',opening_X_LPF);
opening_Xdot_LPF = '2.0';
set(handles.velocity_LPF_visual_edit_text,'String',opening_Xdot_LPF);
opening_Omega_LPF = '0.2';
set(handles.omega_LPF_visual_edit_text,'String',opening_Omega_LPF);
opening_leak_x = '0.6';
set(handles.leak_x_edit_text,'String',opening_leak_x);
opening_leak_y = '0.6';
set(handles.leak_y_edit_text,'String',opening_leak_y);
opening_leak_z = '10.0';
set(handles.leak_z_edit_text,'String',opening_leak_z);
%***********************************************************************************

%********************** Preload Initial  Button Selections *************************
%Gravity Set to 1G
handles.g = 1.0;

%Idiotropic SVV w*h value set to 0
w = 0;
handles.w = w;
assignin('base', 'w', w);

% Choose default command line output for observer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%***********************************************************************************

% ****************** Select Directory to Load Data Files ***************************
if nargin == 3,
    initial_dir = pwd;
    initial_dir_acc = pwd;
elseif nargin > 4
    if strcmpi(varargin{1},'dir')
        if exist(varargin{2},'dir')
            initial_dir = varargin{2};
            initial_dir_acc = varargin{2};
        else
            errordlg({'Input argument must be a valid','directory'},'Input Argument Error!')
            return
        end
    else
        errordlg('Unrecognized input argument','Input Argument Error!');
        return;
    end
end
% Populate the listbox's
load_listbox(initial_dir,handles)
% **********************************************************************************



% *************** Create the Output VARARGOUT Function DO NOT EDIT *****************
function varargout = observer_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
% **********************************************************************************



% ********************** All Preset Feedback Schemes *******************************
function feedback_popup_Callback(hObject, eventdata, handles)

val = get(hObject,'Value');
switch val
case 1
% User selected the first item
case 2
    %Human Preset Values (From Haselwanter 2000)
    handles.haselwanter_human_00_kw = '1.0';
    handles.haselwanter_human_00_kf = '10.0';
    handles.haselwanter_human_00_kfw = '1.0';
    handles.haselwanter_human_00_ka = '-1.0';
    handles.haselwanter_human_00_kwf = '1.0';
    set(handles.kw_edit_text,'String',handles.haselwanter_human_00_kw);
    set(handles.kf_edit_text,'String',handles.haselwanter_human_00_kf);
    set(handles.kfw_edit_text,'String',handles.haselwanter_human_00_kfw);
    set(handles.ka_edit_text,'String',handles.haselwanter_human_00_ka);
    set(handles.kwf_edit_text,'String',handles.haselwanter_human_00_kwf);
case 3
    %Monkey Preset Values (From Merfeld 1993)
    handles.merfeld_monkey_93_kw = '3.0';
    handles.merfeld_monkey_93_kf = '2.0';
    handles.merfeld_monkey_93_kfw = '20';
    handles.merfeld_monkey_93_ka = '-0.9';
    handles.merfeld_monkey_93_kwf = '1.0';
    set(handles.kw_edit_text,'String',handles.merfeld_monkey_93_kw);
    set(handles.kf_edit_text,'String',handles.merfeld_monkey_93_kf);
    set(handles.kfw_edit_text,'String',handles.merfeld_monkey_93_kfw);
    set(handles.ka_edit_text,'String',handles.merfeld_monkey_93_ka);
    set(handles.kwf_edit_text,'String',handles.merfeld_monkey_93_kwf);

case 4
    %Human Preset Values (From Merfeld, Zupan 2002)
    handles.merfeld_human_02_kw = '3.0';
    handles.merfeld_human_02_kf = '2.0';
    handles.merfeld_human_02_kfw = '2.0';
    handles.merfeld_human_02_ka = '-2.0';
    handles.merfeld_human_02_kwf = '1.0';
    set(handles.kw_edit_text,'String',handles.merfeld_human_02_kw);
    set(handles.kf_edit_text,'String',handles.merfeld_human_02_kf);
    set(handles.kfw_edit_text,'String',handles.merfeld_human_02_kfw);
    set(handles.ka_edit_text,'String',handles.merfeld_human_02_ka);
    set(handles.kwf_edit_text,'String',handles.merfeld_human_02_kwf);
case 5
    %Monkey Preset Values (From Merfeld, Zupan 2002)
    handles.merfeld_monkey_02_kw = '5.0';
    handles.merfeld_monkey_02_kf = '10.0';
    handles.merfeld_monkey_02_kfw = '100.0';
    handles.merfeld_monkey_02_ka = '-5.0';
    handles.merfeld_monkey_02_kwf = '1.0';
    set(handles.kw_edit_text,'String',handles.merfeld_monkey_02_kw);
    set(handles.kf_edit_text,'String',handles.merfeld_monkey_02_kf);
    set(handles.kfw_edit_text,'String',handles.merfeld_monkey_02_kfw);
    set(handles.ka_edit_text,'String',handles.merfeld_monkey_02_ka);
    set(handles.kwf_edit_text,'String',handles.merfeld_monkey_02_kwf);
case 6
    %Human Preset Values (From Vingerhoets 2007)
    handles.vingerhoets_human_07_kw = '8.0';
    handles.vingerhoets_human_07_kf = '4.0';
    handles.vingerhoets_human_07_kfw = '8.0';
    handles.vingerhoets_human_07_ka = '-4.0';
    handles.vingerhoets_human_07_kwf = '1.0';
    set(handles.kw_edit_text,'String',handles.vingerhoets_human_07_kw);
    set(handles.kf_edit_text,'String',handles.vingerhoets_human_07_kf);
    set(handles.kfw_edit_text,'String',handles.vingerhoets_human_07_kfw);
    set(handles.ka_edit_text,'String',handles.vingerhoets_human_07_ka);
    set(handles.kwf_edit_text,'String',handles.vingerhoets_human_07_kwf);
end
guidata(hObject,handles);
% **********************************************************************************



% ************Gravity Environment Selection Buttons ********************************
function gravity_panel_SelectionChangeFcn(hObject, eventdata, handles)

% Gravity Switch Box
switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radio_1g'
        set([handles.hyper_edit_text],'Visible','off');
        handles.g = 1.0;
    case 'radio_38g'
        set([handles.hyper_edit_text],'Visible','off');
        handles.g = 3/8.;
    case 'radio_16g'
        set([handles.hyper_edit_text],'Visible','off');
        handles.g = 1/6.;
    case 'radio_0g'
        set([handles.hyper_edit_text],'Visible','off');
        handles.g = 0;
    case 'radio_hyper'
        set([handles.hyper_edit_text],'Visible','on');
        set([handles.hyper_edit_text],'String','1.0');
        
      
end
guidata(hObject,handles);
%***********************************************************************************



% ************************Idiotropic Logic Switch **********************************
function idiot_checkbox_Callback(hObject, eventdata, handles)

% Idiotropic Check Box and Popup Edit Text Box
if (get(hObject,'Value') == get(hObject,'Max'))
	%Idiotropic Bias
    set([handles.w_edit_text],'Visible','on');
    set([handles.w_edit_text],'String','0.0');
else
	%Idiotropic
    set([handles.w_edit_text],'Visible','off');
    set([handles.w_edit_text],'String','0.0');
end
guidata(hObject,handles);
% **********************************************************************************



% ************** Load Angular Velocity Data File List Box **************************
function load_listbox(dir_path, handles)
cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.import_list_box,'String',handles.file_names,...
	'Value',1)
set(handles.import_text,'String',pwd)
% **********************************************************************************



% *List Box File/Dir Selection and Creation/Deletion of additional directory Paths *
function import_list_box_Callback(hObject, eventdata, handles)

get(handles.figure1,'SelectionType');
% If double click
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.import_list_box,'Value');
    file_list = get(handles.import_list_box,'String');
    % Item selected in list box
    filename = file_list{index_selected};
    % If directory
    if  handles.is_dir(handles.sorted_index(index_selected))
        cd (filename)
        % Load list box with new directory.
        load_listbox(pwd,handles)
    else
        [path,name,ext] = fileparts(filename);
        switch ext
            case '.xls'
                % Load in Data File and Change Text
                set(handles.loaded_file_text,'String',[name, '.xls']);
                handles.file_to_open = [path,name,ext];
                assignin('base', 'file', handles.file_to_open);
                set([handles.start_simulation],'Enable','on')
                set([handles.duration_text],'Visible','off');
                set([handles.sim_Time_text],'Visible','off');
                set([handles.sample_rate_text],'Visible','off');
                set([handles.plot_pushbutton],'Enable','inactive');
                set([handles.gif_visual_pushbutton],'Enable','inactive');
                set([handles.export_Data],'Enable','inactive');
                set([handles.VR_pushbutton],'Enable','inactive');
                set(handles.start_simulation,'CData',imread('startON.jpg'));
                set(handles.export_Data,'CData',imread('exportOFF.jpg'));
                set(handles.plot_pushbutton,'CData',imread('plotOFF.jpg'));
                set(handles.gif_visual_pushbutton,'CData',imread('3dOFF.jpg'));
                set(handles.VR_pushbutton,'CData',imread('vrOFF.jpg'));
                guidata(hObject,handles);
            otherwise
                errordlg('Data file must be of .xls extension.', 'Invalid Input File')
        end
    end
end

function import_list_box_CreateFcn(hObject, eventdata, handles)

usewhitebg = 0;
if usewhitebg
    set(hObject,'BackgroundColor','white');
else
    %set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function figure1_CreateFcn(hObject, eventdata, handles)

setappdata(hObject, 'StartPath', pwd);
addpath(pwd);

function figure1_DeleteFcn(hObject, eventdata, handles)

if isappdata(hObject, 'StartPath')
    rmpath(getappdata(hObject, 'StartPath'));
end
% **********************************************************************************



%*********************** LOAD VALUES AND START SIMULATION **************************
function start_simulation_Callback(hObject, eventdata, handles)

%Disable buttons
set([handles.plot_pushbutton],'Enable','inactive');
set([handles.gif_visual_pushbutton],'Enable','inactive');
set([handles.start_simulation],'Enable','inactive');
set([handles.export_Data],'Enable','inactive');
set([handles.VR_pushbutton],'Enable','inactive');
set(handles.start_simulation,'CData',imread('startOFF.jpg'));
set(handles.export_Data,'CData',imread('exportOFF.jpg'));
set(handles.plot_pushbutton,'CData',imread('plotOFF.jpg'));
set(handles.gif_visual_pushbutton,'CData',imread('3dOFF.jpg'));
set(handles.VR_pushbutton,'CData',imread('vrOFF.jpg'));


%Start progress bar and check if gravity state is a predefined quantity or
%if the user inputed its own value in the edit text box.
pause(0.5);
progress = waitbar(0,'Please wait...');

if strcmp(get([handles.hyper_edit_text],'Visible'),'on')
    handles.g = str2double(get(handles.hyper_edit_text, 'String'));
end


% Initial Conditions 

%Initialize the GRAVITY input to the model [gx0 gy0 gz0]'
G0=[0 0 -handles.g]'; 
assignin('base', 'G0', G0);

% Initialize the internal GRAVITY STATE of the model
GG0=G0;
assignin('base', 'GG0', GG0);

% Tilt Angle
g_x = str2double(get(handles.x_tilt_IC, 'String'));
g_y = str2double(get(handles.y_tilt_IC, 'String'));
g_z = str2double(get(handles.z_tilt_IC, 'String'));
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
handles.tau_scc_value = str2double(get(handles.tau_scc_edit_text, 'String'));
tau_scc=handles.tau_scc_value*[1 1 1]';
assignin('base', 'tau_scc', tau_scc);

%Internal Model SCC Time Constant is Set to CNS time constant,
tau_scc_cap=tau_scc;
assignin('base', 'tau_scc_cap', tau_scc_cap);

% Initialize scc adaptation time constants
handles.tau_a_value = str2double(get(handles.tau_a_edit_text, 'String'));
tau_a=handles.tau_a_value*[1 1 1]';
assignin('base', 'tau_a', tau_a);

% Initialize the low-pass filter frequency for scc
handles.f_oto = str2double(get(handles.f_oto_edit_text, 'String'));
f_oto=handles.f_oto;
assignin('base', 'f_oto', f_oto);

% Initialize the lpf frequency for otolith
handles.f_scc = str2double(get(handles.f_scc_edit_text, 'String'));
f_scc=handles.f_scc;
assignin('base', 'f_scc', f_scc);

% Initialize the Ideotropic Bias Amount 'w'
handles.w = str2double(get(handles.w_edit_text, 'String'));
w=handles.w;
assignin('base', 'w', w);

% Initialize Kww feedback gain
handles.kww = str2double(get(handles.kw_edit_text,'String'))*[1 1 1]';
assignin('base', 'kww', handles.kww);
guidata(hObject,handles);

% Initialize Kfg feedback gain
handles.kfg = str2double(get(handles.kf_edit_text,'String'))*[1 1 1]';
assignin('base', 'kfg', handles.kfg);
guidata(hObject,handles);

% Initialize Kfw feedback gain
handles.kfw = str2double(get(handles.kfw_edit_text,'String'))*[1 1 1]';
assignin('base', 'kfw', handles.kfw);
guidata(hObject,handles);

% Initialize Kaa feedback gain
handles.kaa = str2double(get(handles.ka_edit_text,'String'))*[1 1 1]';
assignin('base', 'kaa', handles.kaa);
guidata(hObject,handles); 

% Initialize Kwg feedback gain
handles.kwg = str2double(get(handles.kwf_edit_text,'String'))*[1 1 1]';
assignin('base', 'kwg', handles.kwg);
guidata(hObject,handles); 

% Initialize Kvg feedback gain
handles.kgvg = str2double(get(handles.tilt_visual_edit_text,'String'))*[1 1 1]';
assignin('base', 'kgvg', handles.kgvg);
guidata(hObject,handles); 

% Initialize Kvw feedback gain
handles.kwvw = str2double(get(handles.omega_visual_edit_text,'String'))*[1 1 1]';
assignin('base', 'kwvw', handles.kwvw);
guidata(hObject,handles); 

% Initialize Kxdotva feedback gain
handles.kxdotva = str2double(get(handles.velocity_visual_edit_text,'String'))*[1 1 1]';
assignin('base', 'kxdotva', handles.kxdotva);
guidata(hObject,handles); 

% Initialize Kxvv feedback gain
handles.kxvv = str2double(get(handles.position_visual_edit_text,'String'))*[1 1 1]';
assignin('base', 'kxvv', handles.kxvv);
guidata(hObject,handles); 

% Initialize Visual Position LPF Frequency
handles.f_visX = str2double(get(handles.position_LPF_visual_edit_text,'String'));
assignin('base', 'f_visX', handles.f_visX);
guidata(hObject,handles); 

% Initialize Visual Velocity LPF Frequency
handles.f_visV = str2double(get(handles.velocity_LPF_visual_edit_text,'String'));
assignin('base', 'f_visV', handles.f_visV);
guidata(hObject,handles); 

% Initialize Visual Angular Velocity LPF Frequency
handles.f_visO = str2double(get(handles.omega_LPF_visual_edit_text,'String'));
assignin('base', 'f_visO', handles.f_visO);
guidata(hObject,handles);

% Initialize Graviceptor Gain
oto_a = 60*[1 1 1]';
assignin('base','oto_a', oto_a);
guidata(hObject,handles); 

% Initialize Adapatation time constant
oto_Ka = 1.3*[1 1 1]';
assignin('base','oto_Ka', oto_Ka);
guidata(hObject,handles); 

% Initialize  X Leaky Integration Time Constant
handles.x_leak = str2double(get(handles.leak_x_edit_text,'String'));
assignin('base', 'x_leak', handles.x_leak);
guidata(hObject,handles); 

% Initialize  Y Leaky Integration Time Constant
handles.y_leak = str2double(get(handles.leak_y_edit_text,'String'));
assignin('base', 'y_leak', handles.y_leak);
guidata(hObject,handles); 

% Initialize  X Leaky Integration Time Constant
handles.z_leak = str2double(get(handles.leak_z_edit_text,'String'));
assignin('base', 'z_leak', handles.z_leak);
guidata(hObject,handles); 

%Load data file
input_file= xlsread(handles.file_to_open);
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

% Time and Tolerance Properties set by data input file to ensure a correct
% sampling rate.
delta_t = time(2) - time (1);
duration = length(time)*delta_t;
handles.duration = duration;
handles.sample_rate = 1/delta_t;
guidata(hObject,handles);
t = time;
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


% Set File Information GUI strgns
duration_string =num2str(duration);
delta_t_string =num2str(1/delta_t);
set([handles.duration_text],'Visible','on');
set([handles.sample_rate_text],'Visible','on');
set(handles.duration_text,'String',[duration_string, ' secs']);
set(handles.sample_rate_text,'String',[delta_t_string, ' HZ']);

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
handles.t = t;
handles.x_in = x_in;

% Load the VR model or the non VR model depending on state of VR tookbox.
checkVR = vrinstall('-check','viewer');

if(checkVR == 1)
    model='observerModel';
    vrsetpref('DefaultViewer','internal');
else
    model='observerModelnoVR';
end
waitbar(0.2);
tic;
% Execute Simulink Model
options=simset('Solver','ode45','MaxStep',tolerance,'RelTol',tolerance,'AbsTol',tolerance);
[t_s, XDATA, a_est, gif_est, gif_head, a_head, omega_head,g_head,g_est,omega_est,x_est,lin_vel_est,lin_vel,x,alpha_omega] = sim(model,duration,options,[]);

% Calculate Time of simulation
sim_Time = num2str(toc);
set(handles.sim_Time_text,'String',[sim_Time, ' secs']);
set([handles.sim_Time_text],'Visible','on');

waitbar(0.5);

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
handles.switch_xvdot = xvdot_switch;
handles.switch_xv = xv_switch;
handles.switch_omegav = omegav_switch;
handles.switch_gv = gv_switch;
handles.azimuth_head = azimuth_head;
handles.azimuth_est = azimuth_est;
handles.euler_head = euler_head;
handles.euler_est = euler_est;
handles.tilt = tilt;
handles.SVV = SVV;
handles.tilt_est = tilt_est;
handles.SVV_est = SVV_est;
handles.g_world = g_world;

%Calculate Angular Accelerations for SDAT

%Calculate the time step from simulink
sim_dt = t_s(size(t_s,1)) - t_s(size(t_s,1)-1);

omega_dot_head = zeros(size(omega_head,1),3);
omega_dot_head(1:size(omega_head,1)-1,:) = diff(omega_head,1)/sim_dt;

omega_dot_est = zeros(size(omega_est,1),3);
omega_dot_est(1:size(omega_est,1)-1,:) = diff(omega_est*180/pi,1)/sim_dt;

handles.omega_dot_head = omega_dot_head;
handles.omega_dot_est = omega_dot_est;

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
assignin('base', 'switch_xvdot', handles.switch_xvdot(:,1));
assignin('base', 'switch_xv', handles.switch_xv(:,1));
assignin('base', 'switch_omegav', handles.switch_omegav(:,1));
assignin('base', 'switch_gv', handles.switch_gv(:,1));
assignin('base', 'tilt_est', tilt_est);
assignin('base', 'SVV_est', SVV_est);
assignin('base', 'tilt', tilt);
assignin('base', 'SVV', SVV);
assignin('base', 'g_world', g_world);

waitbar(1.0);
close(progress)

% Re-enable all buttons
set([handles.plot_pushbutton],'Enable','on');
set([handles.export_Data],'Enable','on');
set([handles.gif_visual_pushbutton],'Enable','on');
set([handles.start_simulation],'Enable','on');
set([handles.VR_pushbutton],'Enable','on');
set(handles.start_simulation,'CData',imread('startON.jpg'));
set(handles.export_Data,'CData',imread('exportON.jpg'));
set(handles.plot_pushbutton,'CData',imread('plotON.jpg'));
set(handles.gif_visual_pushbutton,'CData',imread('3dON.jpg'));
set(handles.VR_pushbutton,'CData',imread('vrON.jpg'));
guidata(hObject,handles);
% **********************************************************************************



% ***************************** MENU ITEMS *****************************************
function menu_close_Callback(hObject, eventdata, handles)

close(handles.figure1);

function menu_help_Callback(hObject, eventdata, handles)

HelpPath = which('help.htm');
  web(HelpPath); 

function menu_about_Callback(hObject, eventdata, handles)

HelpPath = which('About.html');
  web(HelpPath, '-noaddressbox'); 
% **********************************************************************************



% ***************Visualization, VR and Signal Builder Buttons **********************
function gif_visual_pushbutton_Callback(hObject, eventdata, handles)
plotToolsAzi;

function VR_pushbutton_Callback(hObject, eventdata, handles)
load_system('observerModel')
load_system('observerModel/VR Visualization (actual)')
open_system('observerModel/VR Visualization (actual)/Actual Movement')
close_system('observerModel/VR Visualization (actual)')
open_system('observerModel/VR Visualization (estimated)/Estimated Motion')
load_system('observerModel/VR Visualization (estimated)')
close_system('observerModel/VR Visualization (estimated)')
% **********************************************************************************



% ************************************* PLOTTING ***********************************
function plot_pushbutton_Callback(hObject, eventdata, handles)

if get(handles.gif_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,1);
        to_plot_est(:,num_col) = handles.gif_est(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,2);
        to_plot_est(:,num_col) = handles.gif_est(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,3);
        to_plot_est(:,num_col) = handles.gif_est(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','GIF','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('GIF','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','G_x');
    if y_on == 1
        set(plot1(2),'DisplayName','G_y');
        if z_on == 1
            set(plot1(3),'DisplayName','G_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','G_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','G_y');
        if z_on == 1
            set(plot1(2),'DisplayName','G_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','G_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated GIF','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','G_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','G_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','G_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','G_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','G_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','G_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','G_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end








if get(handles.lin_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,1);
        to_plot_est(:,num_col) = handles.a_est(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,2);
        to_plot_est(:,num_col) = handles.a_est(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,3);
        to_plot_est(:,num_col) = handles.a_est(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','ACC','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Acceleration','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','A_x');
    if y_on == 1
        set(plot1(2),'DisplayName','A_y');
        if z_on == 1
            set(plot1(3),'DisplayName','A_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','A_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','A_y');
        if z_on == 1
            set(plot1(2),'DisplayName','A_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','A_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Acceleration','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','A_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','A_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','A_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','A_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','A_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','A_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','A_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end






if get(handles.ang_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     handles.omega_est_plot = handles.omega_est*180/pi;
     
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,1);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,2);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,3);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','OMEGA','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Angular Velocity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','Omega_x');
    if y_on == 1
        set(plot1(2),'DisplayName','Omega_y');
        if z_on == 1
            set(plot1(3),'DisplayName','Omega_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','Omega_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','Omega_y');
        if z_on == 1
            set(plot1(2),'DisplayName','Omega_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','Omega_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('deg/sec','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Angular Velocity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','Omega_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','Omega_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','Omega_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','Omega_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','Omega_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','Omega_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','Omega_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('deg/sec','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end



if get(handles.gravity_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,1);
        to_plot_est(:,num_col) = handles.g_est(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,2);
        to_plot_est(:,num_col) = handles.g_est(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,3);
        to_plot_est(:,num_col) = handles.g_est(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','G','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Gravity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','g_x');
    if y_on == 1
        set(plot1(2),'DisplayName','g_y');
        if z_on == 1
            set(plot1(3),'DisplayName','g_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','g_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','g_y');
        if z_on == 1
            set(plot1(2),'DisplayName','g_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','g_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Gravity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','g_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','g_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','g_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','g_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','g_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','g_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','g_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end


if get(handles.cue_plot_check,'Value')==1.0
     
figure1 = figure('Name','Cues','NumberTitle','on');

% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'On','Off'},'YTick',[0 1],...
    'Position',[0.13 0.7673 0.775 0.1577],...
    'FontSize',12);
% Uncomment the following line to preserve the X-limits of the axes
xlim([0 max(handles.t_s)]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim([-0.5 1.5]);
box('on');
hold('all');

% Create title
title('Visual Position Cue','FontWeight','bold','FontSize',12);

% Create plot
plot(handles.t_s,handles.switch_xv(:,1),'Parent',axes1,'LineWidth',3,'LineStyle',':',...
    'DisplayName','switch_xv vs t_s',...
    'Color',[0 0 0]);

% Create axes
axes2 = axes('Parent',figure1,'YTickLabel',{'On','Off'},'YTick',[0 1],...
    'Position',[0.13 0.5482 0.775 0.1577],...
    'FontSize',12);
% Uncomment the following line to preserve the X-limits of the axes
xlim([0 max(handles.t_s)]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim([-0.5 1.5]);
box('on');
hold('all');

% Create title
title('Visual Linear Velocity Cue','FontWeight','bold','FontSize',12);

% Create plot
plot(handles.t_s,handles.switch_xvdot(:,1),'Parent',axes2,'LineWidth',3,'LineStyle',':',...
    'Color',[0 0.498 0],...
    'DisplayName','switch_xvdot vs t_s');

% Create axes
axes3 = axes('Parent',figure1,'YTickLabel',{'On','Off'},'YTick',[0 1],...
    'Position',[0.13 0.3291 0.775 0.1577],...
    'FontSize',12);
% Uncomment the following line to preserve the X-limits of the axes
xlim([0 max(handles.t_s)]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim([-0.5 1.5]);
box('on');
hold('all');

% Create title
title('Visual Angular Velocity','FontWeight','bold','FontSize',12);

% Create plot
plot(handles.t_s,handles.switch_omegav(:,1),'Parent',axes3,'LineWidth',3,'LineStyle',':',...
    'Color',[1 0 0],...
    'DisplayName','switch_omegav vs t_s');

% Create subplot
subplot1 = subplot(4,1,4,'Parent',figure1,'YTickLabel',{'On','Off'},...
    'YTick',[0 1],...
    'FontSize',12);
% Uncomment the following line to preserve the X-limits of the axes
xlim([0 max(handles.t_s)]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim([-0.5 1.5]);
box('on');
hold('all');

% Create title
title('Visual Tilt (Gravity) Vector','FontWeight','bold','FontSize',12);

% Create plot
plot(handles.t_s,handles.switch_gv(:,1),'Parent',subplot1,'MarkerSize',8,'LineWidth',3,...
    'LineStyle',':',...
    'DisplayName','switch_gv vs t_s');

% Create xlabel
xlabel('Time(sec)','FontSize',12);

 
end









if get(handles.position_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t),1);
     to_plot_est = zeros(length(handles.t_s),1);
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,1);
        to_plot_est(:,num_col) = handles.x_est(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,2);
        to_plot_est(:,num_col) = handles.x_est(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,3);
        to_plot_est(:,num_col) = handles.x_est(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','DISP','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Displacement','FontSize',14);

plot1 = plot(handles.t,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','D_x');
    if y_on == 1
        set(plot1(2),'DisplayName','D_y');
        if z_on == 1
            set(plot1(3),'DisplayName','D_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','D_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','D_y');
        if z_on == 1
            set(plot1(2),'DisplayName','D_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','D_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('Meter''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Displacement','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','D_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','D_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','D_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','D_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','D_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','D_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','D_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('Meter''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end

if get(handles.vert_plot_check,'Value')==1.0
% Create figure
figure6 = figure('Name','TILT','NumberTitle','on');

% Create subplot
subplot1 = subplot(2,1,1,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);
box('on');
hold('all');


% Create title
title('Verticality Perception','FontSize',14);

plot1 = plot(handles.t_s,handles.plot_SVV,'LineWidth',2);
set(plot1(2),'DisplayName','SVV','Color','r');
set(plot1(1),'DisplayName','Actual Vertical','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create subplot
subplot2 = subplot(2,1,2,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Tilt Angle Based on Gravity','FontSize',14);


plot2 = plot(handles.t_s,handles.plot_tilt,'LineWidth',2);
set(plot2(1),'DisplayName','Tilt Angle','Color','r');
set(plot2(2),'DisplayName','Estimated Tilt Angle','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);



% Create legend
legend1 = legend(subplot1,'show');


% Create legend
legend2 = legend(subplot2,'show');

end


if get(handles.euler_plot_check,'Value')==1.0
% Create figure
figure6 = figure('Name','ANGLE','NumberTitle','on');

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);
box('on');
hold('all');


% Create title
title('Roll','FontSize',14);

plot1 = plot(handles.t_s,[handles.euler_head(:,1),handles.euler_est(:,1)],'LineWidth',2);
set(plot1(1),'DisplayName','Roll Angle','Color','r');
set(plot1(2),'DisplayName','Estimated Roll Angle','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Pitch','FontSize',14);


plot2 = plot(handles.t_s,[handles.euler_head(:,2),handles.euler_est(:,2)],'LineWidth',2);
set(plot2(1),'DisplayName','Pitch Angle','Color','r');
set(plot2(2),'DisplayName','Estimated Pitch Angle','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);


% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Yaw','FontSize',14);


plot3 = plot(handles.t_s,[handles.euler_head(:,3),handles.euler_est(:,3)],'LineWidth',2);
set(plot3(1),'DisplayName','Yaw Angle','Color','r');
set(plot3(2),'DisplayName','Estimated Yaw Angle','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create legend
legend1 = legend(subplot1,'show');


% Create legend
legend2 = legend(subplot2,'show');

% Create legend
legend3 = legend(subplot3,'show');

end



if get(handles.lin_vel_plot_check,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     
    if get(handles.naso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,1);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,1);
        x_on = 1;
    end
    
    if get(handles.inter_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,2);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,2);
        y_on = 1;
    end
    
    if get(handles.dorso_checkbox,'Value')==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,3);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,3);
        z_on = 1;
    end
    
    
        
figure1 = figure('Name','LINVEL','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est))) + 0.1*max(max(abs(to_plot_est)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Linear Velocity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','V_x');
    if y_on == 1
        set(plot1(2),'DisplayName','V_y');
        if z_on == 1
            set(plot1(3),'DisplayName','V_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','V_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','V_y');
        if z_on == 1
            set(plot1(2),'DisplayName','V_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','V_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('m/s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if get(handles.scale_checkbox,'Value')==1.0 && (get(handles.naso_checkbox,'Value')==1.0 || get(handles.inter_checkbox,'Value')==1.0 ||get(handles.dorso_checkbox,'Value')==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Linear Velocity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','V_xest');
    if y_on == 1
        set(plot2(2),'DisplayName','V_yest');
        if z_on == 1
            set(plot2(3),'DisplayName','V_zest');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','V_zest');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','V_yest');
        if z_on == 1
            set(plot2(2),'DisplayName','V_zest');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','V_zest');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('m/s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end
% **********************************************************************************



% ************************************* Export Data ********************************
function export_Data_Callback(hObject, eventdata, handles)


set([handles.plot_pushbutton],'Enable','inactive');
set([handles.gif_visual_pushbutton],'Enable','inactive');
set([handles.start_simulation],'Enable','inactive');
set([handles.export_Data],'Enable','inactive');
set([handles.VR_pushbutton],'Enable','inactive');
set(handles.start_simulation,'CData',imread('startOFF.jpg'));
set(handles.export_Data,'CData',imread('exportOFF.jpg'));
set(handles.plot_pushbutton,'CData',imread('plotOFF.jpg'));
set(handles.gif_visual_pushbutton,'CData',imread('3dOFF.jpg'));
set(handles.VR_pushbutton,'CData',imread('vrOFF.jpg'));

set([handles.wait_text],'Visible','on');

pause(0.5);
warning off MATLAB:xlswrite:AddSheet;

% Create File Name
time_date = clock;
year = num2str(time_date(1));
month = num2str(time_date(2));
day = num2str(time_date(3));
hour = num2str(time_date(4));
minute = num2str(time_date(5));
second = num2str(floor(time_date(6)));
file_export = strcat('Observer Data Export-',month,'-',day,'-',year,'-',hour,'_',minute,'_',second);

% Write Data File Details Sheet

%A Column
info_string(1,1) = {'Data File Details'};
info_string(6,1) = {'SCC and Otolith Parameters'};
info_string(13,1) = {'Vestibular Feedback Gains'};
info_string(20,1) = {'Gravity Enviroment'};
info_string(23,1) = {'Visual Parameters'};
info_string(28,1) = {'Visual Feedback Gains'};

%B Column
info_string(2,2) = {'File Name'};
info_string(3,2) = {'Duration'};
info_string(4,2) = {'Sample Rate'};
info_string(7,2) = {'SCC Time Constant'};
info_string(8,2) = {'SCC Adaptation Constant'};
info_string(9,2) = {'SCC Low Pass Filter Frequency'};
info_string(10,2) = {'Otolith Low Pass Filter Frequency'};
info_string(11,2) = {'Idiotropic Bias Value'};
info_string(14,2) = {'SCC Feedback Gain (kw)'};
info_string(15,2) = {'GIF Feedback Gain (kf)'};
info_string(16,2) = {'GIF Omega Feedback Gain (kfw)'};
info_string(17,2) = {'Acceleration Feedback Gain (ka)'};
info_string(18,2) = {'Omega GIF Feedback Gain (kwf)'};
info_string(21,2) = {'G Level'};
info_string(24,2) = {'Position LPF Frequency'};
info_string(25,2) = {'Velocity LPF Frequency'};
info_string(26,2) = {'Angular Velocity LPF Frequency'};
info_string(29,2) = {'Linear Position Gain (kxvv)'};
info_string(30,2) = {'Linear Velocity Gain (kxdotva)'};
info_string(31,2) = {'Angular Velocity Gain (kwvw)'};
info_string(32,2) = {'Tilt Angle Gain (kgvg)'};




%C Column
info_string(2,3) = {handles.file_to_open};
info_string(3,3) = {handles.duration};
info_string(4,3) = {handles.sample_rate};
info_string(7,3) = {handles.tau_scc_value};
info_string(8,3) = {handles.tau_a_value};
info_string(9,3) = {handles.f_scc};
info_string(10,3) = {handles.f_oto};
info_string(11,3) = {handles.w};
info_string(14,3) = {handles.kww(1)};
info_string(15,3) = {handles.kfg(1)};
info_string(16,3) = {handles.kfw(1)};
info_string(17,3) = {handles.kaa(1)};
info_string(18,3) = {handles.kwg(1)};
info_string(21,3) = {handles.g};
info_string(24,3) = {handles.f_visX};
info_string(25,3) = {handles.f_visV};
info_string(26,3) = {handles.f_visO};
info_string(29,3) = {handles.kxvv(1)};
info_string(30,3) = {handles.kxdotva(1)};
info_string(31,3) = {handles.kwvw(1)};
info_string(32,3) = {handles.kgvg(1)};


%D Column
info_string(3,4) = {'sec'};
info_string(4,4) = {'Hz'};
info_string(7,4) = {'sec'};
info_string(8,4) = {'sec'};
info_string(9,4) = {'Hz'};
info_string(10,4) = {'Hz'};
info_string(21,4) = {'G'};
info_string(24,4) = {'Hz'};
info_string(25,4) = {'Hz'};
info_string(26,4) = {'Hz'};


% Write Entire String
xlswrite(file_export,info_string,'File Data','A1');


%Angular Velocity
ang_info_string(1,1) = {'Angular Velocity Data'};
ang_info_string(2,1) = {'omega x'};
ang_info_string(2,2) = {'omega y'};
ang_info_string(2,3) = {'omega z'};
ang_info_string(1,5) = {'Estimated Angular Velocity Data'};
ang_info_string(2,5) = {'omega x est'};
ang_info_string(2,6) = {'omega y est'};
ang_info_string(2,7) = {'omega z est'};
xlswrite(file_export,handles.t_s,'Angular Velocity','A3');
xlswrite(file_export,ang_info_string,'Angular Velocity','B1');
xlswrite(file_export,handles.omega_head,'Angular Velocity','B3');
omega_est_plot = handles.omega_est*180/pi;
xlswrite(file_export,omega_est_plot,'Angular Velocity','F3');

%Angular Acceleration
ang_acc_info_string(1,1) = {'Angular Acceleration Data'};
ang_acc_info_string(2,1) = {'omega dot x'};
ang_acc_info_string(2,2) = {'omega dot y'};
ang_acc_info_string(2,3) = {'omega dot z'};
ang_acc_info_string(1,5) = {'Estimated Angular Acceleration Data'};
ang_acc_info_string(2,5) = {'omega dot x est'};
ang_acc_info_string(2,6) = {'omega dot y est'};
ang_acc_info_string(2,7) = {'omega dot z est'};
xlswrite(file_export,handles.t_s,'Angular Acceleration','A3');
xlswrite(file_export,ang_acc_info_string,'Angular Acceleration','B1');
xlswrite(file_export,handles.omega_dot_head,'Angular Acceleration','B3');
xlswrite(file_export,handles.omega_dot_est,'Angular Acceleration','F3');

%Linear Acceleration
lin_info_string(1,1) = {'Linear Acceleration Data'};
lin_info_string(2,1) = {'a x'};
lin_info_string(2,2) = {'a y'};
lin_info_string(2,3) = {'a z'};
lin_info_string(1,5) = {'Estimated Linear Acceleration Data'};
lin_info_string(2,5) = {'a x est'};
lin_info_string(2,6) = {'a y est'};
lin_info_string(2,7) = {'a z est'};
xlswrite(file_export,handles.t_s,'Linear Acceleration','A3');
xlswrite(file_export,lin_info_string,'Linear Acceleration','B1');
xlswrite(file_export,handles.a_head,'Linear Acceleration','B3');
xlswrite(file_export,handles.a_est,'Linear Acceleration','F3');


%Displacement
disp_info_string(1,1) = {'Displacement Data'};
disp_info_string(2,1) = {'d x'};
disp_info_string(2,2) = {'d y'};
disp_info_string(2,3) = {'d z'};
disp_info_string(1,5) = {'Estimated Displacement Data'};
disp_info_string(2,5) = {'d x est'};
disp_info_string(2,6) = {'d y est'};
disp_info_string(2,7) = {'d z est'};
xlswrite(file_export,handles.t_s,'Displacement','A3');
xlswrite(file_export,disp_info_string,'Displacement','B1');
xlswrite(file_export,handles.x_in,'Displacement','B3');
xlswrite(file_export,handles.x_est,'Displacement','F3');


%GIF
gif_info_string(1,1) = {'GIF Data'};
gif_info_string(2,1) = {'GIF x'};
gif_info_string(2,2) = {'GIF y'};
gif_info_string(2,3) = {'GIF z'};
gif_info_string(1,5) = {'Estimated GIF Data'};
gif_info_string(2,5) = {'GIF x est'};
gif_info_string(2,6) = {'GIF y est'};
gif_info_string(2,7) = {'GIF z est'};
xlswrite(file_export,handles.t_s,'GIF','A3');
xlswrite(file_export,gif_info_string,'GIF','B1');
xlswrite(file_export,handles.gif_head,'GIF','B3');
xlswrite(file_export,handles.gif_est,'GIF','F3');

%G
g_info_string(1,1) = {'Gravity Data'};
g_info_string(2,1) = {'g x'};
g_info_string(2,2) = {'g y'};
g_info_string(2,3) = {'g z'};
g_info_string(1,5) = {'Estimated Gravity Data'};
g_info_string(2,5) = {'g x est'};
g_info_string(2,6) = {'g y est'};
g_info_string(2,7) = {'g z est'};
xlswrite(file_export,handles.t_s,'Gravity','A3');
xlswrite(file_export,g_info_string,'Gravity','B1');
xlswrite(file_export,handles.g_head,'Gravity','B3');
xlswrite(file_export,handles.g_est,'Gravity','F3');


%SVV and  Tilt
tilt_info_string(1,1) = {'Subjective Visual Vertical Data'};
tilt_info_string(2,1) = {'Actual Vertical'};
tilt_info_string(2,2) = {'SVV'};
tilt_info_string(1,5) = {'Tilt (G) Angle Data'};
tilt_info_string(2,5) = {'Tilt Angle'};
tilt_info_string(2,6) = {'Estimated Tilt Angle'};
xlswrite(file_export,handles.t_s,'SVV and Tilt','A3');
xlswrite(file_export,tilt_info_string,'SVV and Tilt','B1');
xlswrite(file_export,handles.plot_SVV,'SVV and Tilt','B3');
xlswrite(file_export,handles.plot_tilt,'SVV and Tilt','F3');


%Linear Velocity
lin_vel_info_string(1,1) = {'Linear Velocity Data'};
lin_vel_info_string(2,1) = {'V x'};
lin_vel_info_string(2,2) = {'V y'};
lin_vel_info_string(2,3) = {'V z'};
lin_vel_info_string(1,5) = {'Estimated Linear Velocity Data'};
lin_vel_info_string(2,5) = {'V x est'};
lin_vel_info_string(2,6) = {'V y est'};
lin_vel_info_string(2,7) = {'V z est'};
xlswrite(file_export,handles.t_s,'Linear Velocity','A3');
xlswrite(file_export,lin_vel_info_string,'Linear Velocity','B1');
xlswrite(file_export,handles.lin_vel,'Linear Velocity','B3');
xlswrite(file_export,handles.lin_vel_est,'Linear Velocity','F3');


%Euler Angles
euler_info_string(1,1) = {'Euler Angle Data'};
euler_info_string(2,1) = {'Roll'};
euler_info_string(2,2) = {'Pitch'};
euler_info_string(2,3) = {'Yaw'};
euler_info_string(1,5) = {'Estimated Euler Angle Data'};
euler_info_string(2,5) = {'Roll est'};
euler_info_string(2,6) = {'Pitch est'};
euler_info_string(2,7) = {'Yaw est'};
xlswrite(file_export,handles.t_s,'Euler Angles','A3');
xlswrite(file_export,euler_info_string,'Euler Angles','B1');
xlswrite(file_export,handles.euler_head,'Euler Angles','B3');
xlswrite(file_export,handles.euler_est,'Euler Angles','F3');


set([handles.wait_text],'Visible','off');
set([handles.plot_pushbutton],'Enable','on');
set([handles.gif_visual_pushbutton],'Enable','on');
set([handles.start_simulation],'Enable','on');
set([handles.export_Data],'Enable','on');
set([handles.VR_pushbutton],'Enable','on');
set(handles.start_simulation,'CData',imread('startON.jpg'));
set(handles.export_Data,'CData',imread('exportON.jpg'));
set(handles.plot_pushbutton,'CData',imread('plotON.jpg'));
set(handles.gif_visual_pushbutton,'CData',imread('3dON.jpg'));
set(handles.VR_pushbutton,'CData',imread('vrON.jpg'));
% **********************************************************************************