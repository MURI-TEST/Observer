% *********** COPYRIGHT MASSACHUSETTES INSTITUTE OF TECHNOLOGY (c) 2008 ************
% *** Contact: Charles Oman (COMAN@MIT.EDU) or Michael Newman (M_NEWMAN@MIT.EDU)****
% **********************************************************************************


% ******************* Begin initialization code - DO NOT EDIT **********************
function varargout = plotToolsAzi(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotToolsAzi_OpeningFcn, ...
                   'gui_OutputFcn',  @plotToolsAzi_OutputFcn, ...
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
%***********************************************************************************



%*************** Executes just before plottools is made visible ********************
function plotToolsAzi_OpeningFcn(hObject, eventdata, handles, varargin)

movegui(gcf,'center');
% Set background image and properties
ha = axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'bottom');
Image = imread('plotback.jpg');
plot_background = imagesc(Image);
set(ha,'handlevisibility','off','visible','off')


handles.output = hObject;
g_head = evalin('base', 'g_head');
g_est = evalin('base', 'g_est');
t_s = evalin('base', 'sim_time');
azimuth_head = evalin('base', 'azimuth_head');
azimuth_est = evalin('base', 'azimuth_est');

handles.g_head = g_head;
handles.g_est = g_est;
handles.t_s = t_s;
handles.azimuth_head = azimuth_head;
handles.azimuth_est = azimuth_est;

axes(handles.axes_3d_plot)
handles.line1 = line([0,g_head(1,1)],[0,g_head(1,2)],[0,g_head(1,3)]);
handles.line2 = line([0,g_est(1,1)],[0,g_est(1,2)],[0,g_est(1,3)]);

axis tight
view([30 15]);
grid('on');
title('Gravity','FontWeight','bold','FontSize',12)
set(gca,'nextplot','replacechildren','XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1]);
set(handles.line1,'Color',[1 0 0],'Erase','xor','LineWidth',3);
set(handles.line2,'Color',[0 0 1],'Erase','xor','LineWidth',3);
line([-1 1],[0 0],[0 0],'LineWidth',3,'Color',[0,0,0]);
line([0 0],[-1 1],[0 0],'LineWidth',3,'Color',[0,0,0]);
line([0 0],[0 0],[-1 1],'LineWidth',3,'Color',[0,0,0]);

axes(handles.axes_viewer)
plot1 = plot(handles.t_s,handles.g_est);
xlim([0 max(handles.t_s)]);
ylim([-1 1]);
set(plot1(1),'Color',[1 0 0]);
set(plot1(2),'Color',[0 0 1]);
set(plot1(3),'Color',[0 0.498 0]);
handles.line_track = line([0 0],[-1 1],[0 0],'LineWidth',2,'Color',[0,0,0]);

axes(handles.axes_azimuth)

% Convert from polar to cartesian coordinates (because matlab polar
% plotting is pretty horrible

rho = ones(length(azimuth_head),1);
[X,Y] = pol2cart(azimuth_head,rho);
handles.azimuth_head_cart = [X,Y];

rho = ones(length(azimuth_est),1);
[X,Y] = pol2cart(azimuth_est,rho);
handles.azimuth_est_cart = [X,Y];


% Draw Unit Circle

x=-1:0.01:1;
lim = length(x);
for i = 1:lim;
    y(i,1) = sqrt(1-x(i)^2);
    y(i,2) = -sqrt(1-x(i)^2);
end
plot1 = plot(x,y);
set(plot1(1),'Color',[0 0 0],'LineWidth',1);
set(plot1(2),'Color',[0 0 0],'LineWidth',1);

% Draw Degree Mark lines every 45 degrees

deg_90 = line([0,0],[-1,0]);
set(deg_90, 'Color',[0,0,0],'LineStyle',':');
deg_45 = line([.7071,0],[-.7071,0]);
set(deg_45, 'Color',[0,0,0],'LineStyle',':');

deg_90 = line([0,-1],[0,0]);
set(deg_90, 'Color',[0,0,0],'LineStyle',':');
deg_45 = line([-.7071,0],[-.7071,0]);
set(deg_45, 'Color',[0,0,0],'LineStyle',':');

deg_90 = line([0,0],[0,1]);
set(deg_90, 'Color',[0,0,0],'LineStyle',':');
deg_45 = line([-.7071,0],[.7071,0]);
set(deg_45, 'Color',[0,0,0],'LineStyle',':');

deg_90 = line([0,1],[0,0]);
set(deg_90, 'Color',[0,0,0],'LineStyle',':');
deg_45 = line([.7071,0],[.7071,0]);
set(deg_45, 'Color',[0,0,0],'LineStyle',':');


grid('off');
box('on');
set(handles.axes_azimuth,'YTick',zeros(1,0),'XTick',zeros(1,0),'YColor',[1 1 1],'XColor',[1 1 1],'Color',[1 1 1]);


handles.azimuth_line = line([0,handles.azimuth_head_cart(1,1)],[0,handles.azimuth_head_cart(1,2)]);
handles.azimuth_line_est = line([0,handles.azimuth_est_cart(1,1)],[0,handles.azimuth_est_cart(1,2)]);

set(handles.azimuth_line,'Color',[1 0 0],'LineWidth',3);
set(handles.azimuth_line_est,'Color',[0 0 1],'LineWidth',3);

xlim([-1 1]);
ylim([-1 1]);
    
    
guidata(hObject, handles);
%***********************************************************************************



% *************** Create the Output VARARGOUT Function DO NOT EDIT *****************
function varargout = plotToolsAzi_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%***********************************************************************************



% ********* Play, Pause and Close Pushbuttons. Create Plots. Plot Data ************
function visual_pushbutton_Callback(hObject, eventdata, handles)
set([handles.visual_pushbutton], 'Enable','off');
set([handles.pause_toggle], 'Enable','on');

i = 1;
while i <= length(handles.g_head)
    
    if get(handles.close_pushbutton,'Value') == get(handles.close_pushbutton,'Max')
        close Visualization;
        break;
    end
    
    axes(handles.axes_3d_plot)
    set(handles.line1,'XData',[0,handles.g_head(i,1)],'YData',[0,handles.g_head(i,2)],'ZData',[0,handles.g_head(i,3)]);
    set(handles.line2,'XData',[0,handles.g_est(i,1)],'YData',[0,handles.g_est(i,2)],'ZData',[0,handles.g_est(i,3)]);
    
    axes(handles.axes_viewer)
    set(handles.line_track,'XData',[(max(handles.t_s)*i)/length(handles.t_s),(max(handles.t_s)*i)/length(handles.t_s)],'YData',[-1,1],'ZData',[0,0]);
    
    axes(handles.axes_azimuth)
    set(handles.azimuth_line,'XData',[0,handles.azimuth_head_cart(i,1)],'YData',[0,handles.azimuth_head_cart(i,2)]);
    set(handles.azimuth_line_est,'XData',[0,handles.azimuth_est_cart(i,1)],'YData',[0,handles.azimuth_est_cart(i,2)]);
    
    
    drawnow
    
    pause(0.01)
    
    if i >= (length(handles.g_head) - floor(length(handles.g_est)/(10*max(handles.t_s))))
        set([handles.visual_pushbutton], 'Enable','on');
    end
    
    i = i + floor(length(handles.g_est)/(5*max(handles.t_s)));
end

function pause_toggle_Callback(hObject, eventdata, handles)
button_state = get(handles.pause_toggle,'Value');
    if button_state == get(handles.pause_toggle,'Max')
        uiwait;
    elseif button_state == get(handles.pause_toggle,'Min')
        uiresume;
    end

function close_pushbutton_Callback(hObject, eventdata, handles)

 if get(handles.pause_toggle,'Value') == get(handles.pause_toggle,'Max')
        uiresume;
 end
 if get(handles.visual_pushbutton,'Value') == get(handles.visual_pushbutton,'Min')
        close Visualization;
 end
%***********************************************************************************
 


% *********** Change the View of the 3D plot, between Planes and 3D ****************
function YZ_pushbutton_Callback(hObject, eventdata, handles)
axes(handles.axes_3d_plot)
view([90 0]);

set([handles.X],'Visible','off');
set(handles.X,'String','X');
set([handles.Y],'Visible','off');
set(handles.Y,'String','Y');
set([handles.Z],'Visible','on');
set(handles.Z,'String','Z');
set([handles.Bot_Axis],'Visible','on');
set(handles.Bot_Axis,'String','Y');

function XY_pushbutton_Callback(hObject, eventdata, handles)
axes(handles.axes_3d_plot)
view([0 90]);

set([handles.X],'Visible','off');
set(handles.X,'String','X');
set([handles.Y],'Visible','off');
set(handles.Y,'String','Y');
set([handles.Z],'Visible','on');
set(handles.Z,'String','Y');
set([handles.Bot_Axis],'Visible','on');
set(handles.Bot_Axis,'String','X');

function XZ_pushbutton_Callback(hObject, eventdata, handles)
axes(handles.axes_3d_plot)
view([0 0]);

set([handles.X],'Visible','off');
set(handles.X,'String','X');
set([handles.Y],'Visible','off');
set(handles.Y,'String','Y');
set([handles.Z],'Visible','on');
set(handles.Z,'String','Z');
set([handles.Bot_Axis],'Visible','on');
set(handles.Bot_Axis,'String','X');

function normal_pushbutton_Callback(hObject, eventdata, handles)
axes(handles.axes_3d_plot)
view([30 15]);

set([handles.X],'Visible','on');
set(handles.X,'String','X');
set([handles.Y],'Visible','on');
set(handles.Y,'String','Y');
set([handles.Z],'Visible','on');
set(handles.Z,'String','Z');
set([handles.Bot_Axis],'Visible','off');
set(handles.Bot_Axis,'String',' ');
%**********************************************************************************