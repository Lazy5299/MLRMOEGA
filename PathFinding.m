                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         function varargout = PathFinding(varargin)
%      用户界面
% %       Built by Chong Liu & Aizun Liu
% %       Northeastern University,Shenyang,China
% %       2000371@stu.neu.edu.cn
%      PATHFINDING MATLAB code for PathFinding.fig
%      PATHFINDING, by itself, creates a new PATHFINDING or raises the existing
%      singleton*.
%
%      H = PATHFINDING returns the handle to a new PATHFINDING or the handle to
%      the existing singleton*.
%
%      PATHFINDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PATHFINDING.M with the given input
%      arguments.XDCF.
%
%      PATHFINDING('Property','Value',...) creates a new PATHFINDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PathFinding_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PathFinding_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PathFinding

% Last Modified by GUIDE v2.5 07-Jun-2022 08:37:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PathFinding_OpeningFcn, ...
                   'gui_OutputFcn',  @PathFinding_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before PathFinding is made visible.
function PathFinding_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PathFinding (see VARARGIN)

% Choose default command line output for PathFinding
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global startflag
startflag = 0; %全局变量startflag
% UIWAIT makes PathFinding wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PathFinding_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function row_Callback(hObject, eventdata, handles)
% hObject    handle to row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row as text
%        str2double(get(hObject,'String')) returns contents of row as a double


% --- Executes during object creation, after setting all properties.
function row_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function column_Callback(hObject, eventdata, handles)
% hObject    handle to column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of column as text
%        str2double(get(hObject,'String')) returns contents of column as a double


% --- Executes during object creation, after setting all properties.
function column_CreateFcn(hObject, eventdata, handles)
% hObject    handle to column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global startflag mapmatrix mapdata phandles edittype SandEpoint maprisk mapfar row column maze mapspeed mapz mapG 
if startflag
    startflag = 0;
    set(handles.startbutton,'string','start');
else
    cla reset;
    
    startflag = 1;
    edittype = 100;
    set(handles.startbutton,'string','stop');
    row = str2double(get(handles.row,'string'));
    column = str2double(get(handles.column,'string')); %获取编辑框中的行列值
    nr=str2double(get(handles.normalrisk,'string'));
    nc=str2double(get(handles.normalcost,'string'));
    shangebianchang=str2double(get(handles.lengthofperblock,'string'));
    normalspeed=str2double(get(handles.normalspeed,'string'));
    topnb=shangebianchang/normalspeed;    %每个平地方格消耗时间
    SandEpoint = [1,1;row-1,column-1];
    mapmatrix = ones(row,column);
    mapdata = nc*ones(row,column);
    maprisk = nr*ones(row,column);
    mapfar  =shangebianchang*ones(row,column);
    mapspeed =topnb*ones(row,column);
    maze = zeros(row,column);
    mapz = zeros(row,column);
    mapG = zeros(row,column);
    colormap('winter');
    phandles = pcolor(1:row+1,1:column+1,[mapmatrix mapmatrix(:,end); mapmatrix(end,:) mapmatrix(end,end)]);
    hold on; %保持已经画的图
    set(phandles,'ButtonDownFcn',{@mapClickCallback,handles});
end
%%%
function mapClickCallback(hObject, eventdata, handles) %点击地图选择不同地形 
global startflag mapmatrix mapdata mapfar maprisk phandles edittype SandEpoint maze  mapspeed mapz mapG
if startflag
    n = str2double(get(handles.column,'string')); %获取编辑框中的行列值
    shangebianchang=str2double(get(handles.lengthofperblock,'string'));  %每个栅格边长
    hightofnormal=str2double(get(handles.hightofnormal,'string'));       %平台高度
    upladderhight=str2double(get(handles.hightofupladder,'string'));     %竖梯高度
    hightofsmallwall=str2double(get(handles.hightofsmallwall,'string')); %矮墙高度
    hightofwall=str2double(get(handles.hightofwall,'string'));           %墙高度
    breadthoflittleriver=str2double(get(handles.breadthoflittleriver,'string')); %小溪宽度
    
    normalspeed=str2double(get(handles.normalspeed,'string'));     %平地行进速度
    climbspeed=str2double(get(handles.upladderspeed,'string'));    %爬梯子速度
    swingspeed=str2double(get(handles.ladderspeed,'string'));      %摆荡速度
    anglespeed=str2double(get(handles.anglespeed,'string'));       %斜坡速度
    jumpspeed=str2double(get(handles.jumpspeedperm,'string'));     %跳高速度
    throwoverspeed=str2double(get(handles.throwoverspeed,'string'));   %翻越速度
    longjumpspeed=str2double(get(handles.longjumpspeed,'string'));    %跳远速度
    
    
    topnb=shangebianchang/normalspeed;    %每个平地方格消耗时间
    toplb=shangebianchang/swingspeed;     %摆荡时间
    topab=shangebianchang/anglespeed;     %斜坡时间
    tocu=upladderhight/climbspeed;        %爬梯子时间
    tojump=hightofsmallwall/jumpspeed;    %跳高时间
    tothrowover=hightofwall/throwoverspeed; %翻越时间
    tolongjump=breadthoflittleriver/longjumpspeed; %跳远时间
    
    
    
    
    axesHandle = get(hObject,'Parent');
    temp = get(axesHandle,'CurrentPoint');%获取最近一次点击的位置
    coordinates = floor(temp(1,1:2));
    switch edittype
        case 1     %平地
            mapmatrix(coordinates(2),coordinates(1)) =1; %白色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.normalcost,'string'))*shangebianchang; 
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.normalrisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = topnb;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = hightofnormal ;
            mapG(coordinates(2),coordinates(1)) = 0 ;
        case 2     %高墙
            if mapmatrix(coordinates(2),coordinates(1)) ~=4  &&  mapmatrix(coordinates(2),coordinates(1)) ~=2
                mapmatrix(coordinates(2),coordinates(1)) =4; %黑色
                mapdata(coordinates(2),coordinates(1)) = inf;
                mapfar (coordinates(2),coordinates(1)) = inf;
                maprisk(coordinates(2),coordinates(1)) = inf;
                mapspeed(coordinates(2),coordinates(1)) = inf;
                maze(coordinates(2),coordinates(1)) = 1 ;
                mapz(coordinates(2),coordinates(1)) = inf;
                mapG(coordinates(2),coordinates(1)) = 1 ;
                if coordinates(2)-1 > 0 
                    maprisk(coordinates(2)-1,coordinates(1)) = maprisk(coordinates(2)-1,coordinates(1))+(0.05*shangebianchang);
                end
                if coordinates(2)+1 < n  
                    maprisk(coordinates(2)+1,coordinates(1)) = maprisk(coordinates(2)+1,coordinates(1))+(0.05*shangebianchang) ;
                end
                if coordinates(1)-1 > 0 
                    maprisk(coordinates(2),coordinates(1)-1) = maprisk(coordinates(2),coordinates(1)-1)+(0.05*shangebianchang);
                end
                if coordinates(1)+1 < n 
                    maprisk(coordinates(2),coordinates(1)+1) = maprisk(coordinates(2),coordinates(1)+1)+(0.05*shangebianchang);
                end
                if coordinates(2)+1 < n &&  coordinates(1)-1 > 0 
                    maprisk(coordinates(2)+1,coordinates(1)-1) = maprisk(coordinates(2)+1,coordinates(1)-1)+ (0.03*shangebianchang) ;
                end
                if coordinates(2)-1 > 0 &&  coordinates(1)+1 < n
                    maprisk(coordinates(2)-1,coordinates(1)+1) = maprisk(coordinates(2)-1,coordinates(1)+1)+ (0.03*shangebianchang);
                end
                if coordinates(2)+1 < n &&  coordinates(1)+1 < n 
                    maprisk(coordinates(2)+1,coordinates(1)+1) = maprisk(coordinates(2)+1,coordinates(1)+1)+ (0.03*shangebianchang) ;
                end
                if coordinates(2)-1 > 0 &&  coordinates(1)-1 > 0 
                    maprisk(coordinates(2)-1,coordinates(1)-1) = maprisk(coordinates(2)-1,coordinates(1)-1)+ (0.03*shangebianchang);
                end
                else
                mapmatrix(coordinates(2),coordinates(1)) =4; %黑色
                mapdata(coordinates(2),coordinates(1)) = inf;
                mapfar (coordinates(2),coordinates(1)) = inf;
                maprisk(coordinates(2),coordinates(1)) = inf;
                mapspeed(coordinates(2),coordinates(1)) = inf;
                maze(coordinates(2),coordinates(1)) = 1 ;
                mapz(coordinates(2),coordinates(1)) = inf;
                mapG(coordinates(2),coordinates(1)) = 1 ; 
            end
        case 3     %河
            if mapmatrix(coordinates(2),coordinates(1)) ~=4  &&  mapmatrix(coordinates(2),coordinates(1)) ~=2
                mapmatrix(coordinates(2),coordinates(1)) =2; %蓝色
                mapdata(coordinates(2),coordinates(1)) = inf;
                mapfar (coordinates(2),coordinates(1)) = inf;
                maprisk(coordinates(2),coordinates(1)) = inf;
                mapspeed(coordinates(2),coordinates(1)) = inf;
                maze(coordinates(2),coordinates(1)) = 1 ;
                mapz(coordinates(2),coordinates(1)) = inf;
                mapG(coordinates(2),coordinates(1)) = 1 ;
                if coordinates(2)-1 > 0 
                    maprisk(coordinates(2)-1,coordinates(1)) = maprisk(coordinates(2)-1,coordinates(1))+(0.05*shangebianchang);
                end
                if coordinates(2)+1 < n  
                    maprisk(coordinates(2)+1,coordinates(1)) = maprisk(coordinates(2)+1,coordinates(1))+(0.05*shangebianchang) ;
                end
                if coordinates(1)-1 > 0 
                    maprisk(coordinates(2),coordinates(1)-1) = maprisk(coordinates(2),coordinates(1)-1)+(0.05*shangebianchang);
                end
                if coordinates(1)+1 < n 
                    maprisk(coordinates(2),coordinates(1)+1) = maprisk(coordinates(2),coordinates(1)+1)+(0.05*shangebianchang);
                end
                if coordinates(2)+1 < n &&  coordinates(1)-1 > 0 
                    maprisk(coordinates(2)+1,coordinates(1)-1) = maprisk(coordinates(2)+1,coordinates(1)-1)+ (0.03*shangebianchang) ;
                end
                if coordinates(2)-1 > 0 &&  coordinates(1)+1 < n
                    maprisk(coordinates(2)-1,coordinates(1)+1) = maprisk(coordinates(2)-1,coordinates(1)+1)+ (0.03*shangebianchang);
                end
                if coordinates(2)+1 < n &&  coordinates(1)+1 < n 
                    maprisk(coordinates(2)+1,coordinates(1)+1) = maprisk(coordinates(2)+1,coordinates(1)+1)+ (0.03*shangebianchang) ;
                end
                if coordinates(2)-1 > 0 &&  coordinates(1)-1 > 0 
                    maprisk(coordinates(2)-1,coordinates(1)-1) = maprisk(coordinates(2)-1,coordinates(1)-1)+ (0.03*shangebianchang);
                end
                else
                mapmatrix(coordinates(2),coordinates(1)) =2; %蓝色
                mapdata(coordinates(2),coordinates(1)) = inf;
                mapfar (coordinates(2),coordinates(1)) = inf;
                maprisk(coordinates(2),coordinates(1)) = inf;
                mapspeed(coordinates(2),coordinates(1)) = inf;
                maze(coordinates(2),coordinates(1)) = 1 ;
                mapz(coordinates(2),coordinates(1)) = inf;
                mapG(coordinates(2),coordinates(1)) = 1 ;   
            end
        case 4     %斜面
            mapmatrix(coordinates(2),coordinates(1)) = 3; %品红
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.anglecost,'string'))*shangebianchang;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.anglerisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = topab;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;
 
        case 5     %云梯
            mapmatrix(coordinates(2),coordinates(1)) = 5; %红色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.laddercost,'string'))*shangebianchang;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.ladderrisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = toplb;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;
  
        case 6
            mapmatrix(SandEpoint(1,2),SandEpoint(1,1)) = 1;
            SandEpoint(1,:) = coordinates;
            mapmatrix(coordinates(2),coordinates(1)) = 10;
            maze(coordinates(2),coordinates(1)) = 2 ;
            mapG(coordinates(2),coordinates(1)) = 0 ;
        case 7
            mapmatrix(SandEpoint(2,2),SandEpoint(2,1)) = 1;
            SandEpoint(2,:) = coordinates;
            mapmatrix(coordinates(2),coordinates(1)) = 10;
            maze(coordinates(2),coordinates(1)) = 3 ;
            mapG(coordinates(2),coordinates(1)) = 0 ;
        case 8    %竖梯
            mapmatrix(coordinates(2),coordinates(1)) = 6; %黄色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.upladdercost,'string'))*upladderhight;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.upladderrisk,'string'))*upladderhight;
            mapspeed(coordinates(2),coordinates(1)) = tocu;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = upladderhight;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 9    %矮墙
            mapmatrix(coordinates(2),coordinates(1)) = 7; %LightSlateGray 
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costofjumpperm,'string'))*hightofsmallwall;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.jumpriskperm,'string'))*hightofsmallwall;
            mapspeed(coordinates(2),coordinates(1)) = tojump;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 10    %墙
            mapmatrix(coordinates(2),coordinates(1)) = 8; %DimGrey
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costofthrowover,'string'))*hightofwall;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.throwoverrisk,'string'))*hightofwall;
            mapspeed(coordinates(2),coordinates(1)) = tothrowover;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 11    %溪流
            mapmatrix(coordinates(2),coordinates(1)) = 9; %DeepSkyBlue
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costoflongjumpperm,'string'))*breadthoflittleriver;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.riskoflongjumpperm,'string'))*breadthoflittleriver;
            mapspeed(coordinates(2),coordinates(1)) = tolongjump;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0 ;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        otherwise
            return;
    end
    row = str2double(get(handles.row,'string'));
    column = str2double(get(handles.column,'string'));
    map=[1 1 1;  %白
        0 0 1;   %蓝
        1 0 1;   %品红
        0 0 0;   %黑
        1 0 0;   %红
        1 1 0;   %黄
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %绿
    colormap(map);
    phandles = pcolor(1:row+1,1:column+1,[mapmatrix mapmatrix(:,end); mapmatrix(end,:) mapmatrix(end,end)]);
    set(phandles,'ButtonDownFcn',{@mapClickCallback,handles}); 
end


% --- Executes on button press in ladder.  梯子
function ladder_Callback(hObject, eventdata, handles)
% hObject    handle to ladder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ladder
global edittype 
if get(handles.ladder,'value')
    edittype = 5;
    set(handles.normalground,'value',0);  
    set(handles.wall,'value',0);
    set(handles.river,'value',0);
    set(handles.angle,'value',0);
    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
    set(handles.upladder,'value',0);
    set(handles.smallwall,'value',0);
    set(handles.tallwall,'value',0);
    set(handles.littleriver,'value',0);
end


function laddercost_Callback(hObject, eventdata, handles)
% hObject    handle to laddercost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laddercost as text
%        str2double(get(hObject,'String')) returns contents of laddercost as a double
global laddercost
laddercost=str2double(get(handles.laddercost,'string'));


% --- Executes during object creation, after setting all properties.
function laddercost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laddercost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in angle.坡
function angle_Callback(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of angle
global edittype 
if get(handles.angle,'value')
    edittype = 4;
   set(handles.upladder,'value',0);
   set(handles.ladder,'value',0);
   set(handles.normalground,'value',0);  
   set(handles.smallwall,'value',0);
   set(handles.wall,'value',0);
   set(handles.tallwall,'value',0);
   set(handles.littleriver,'value',0);
   set(handles.river,'value',0);
   set(handles.startpoint,'value',0);
   set(handles.endpoint,'value',0);
end

% --- Executes on button press in river.河
function river_Callback(hObject, eventdata, handles)
% hObject    handle to river (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of river
global edittype 
if get(handles.river,'value')
    edittype = 3;
    set(handles.upladder,'value',0);
    set(handles.ladder,'value',0);
    set(handles.angle,'value',0);
    set(handles.normalground,'value',0);  
    set(handles.smallwall,'value',0);
    set(handles.wall,'value',0);
    set(handles.tallwall,'value',0);
    set(handles.littleriver,'value',0);

    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
end


function anglecost_Callback(hObject, eventdata, handles)
% hObject    handle to anglecost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anglecost as text
%        str2double(get(hObject,'String')) returns contents of anglecost as a double
global anglecost
anglecost=str2double(get(handles.anglecost,'string'));

% --- Executes during object creation, after setting all properties.
function anglecost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anglecost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wall.
function wall_Callback(hObject, eventdata, handles)
% hObject    handle to wall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wall
global edittype 
if get(handles.wall,'value')
    edittype = 10;
    set(handles.upladder,'value',0);
    set(handles.ladder,'value',0);
    set(handles.angle,'value',0);
    set(handles.normalground,'value',0);  
    set(handles.smallwall,'value',0);
    set(handles.tallwall,'value',0);
    set(handles.littleriver,'value',0);
    set(handles.river,'value',0);
    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
end

% --- Executes on button press in normalground.
function normalground_Callback(hObject, eventdata, handles)
% hObject    handle to normalground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalground
global edittype 
if get(handles.normalground,'value')
    edittype = 1;
set(handles.upladder,'value',0);
set(handles.ladder,'value',0);
set(handles.angle,'value',0); 
set(handles.smallwall,'value',0);
set(handles.wall,'value',0);
set(handles.tallwall,'value',0);
set(handles.littleriver,'value',0);
set(handles.river,'value',0);
set(handles.startpoint,'value',0);
set(handles.endpoint,'value',0);
end


% --- Executes on button press in startpoint.
function startpoint_Callback(hObject, eventdata, handles)
% hObject    handle to startpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startpoint
global edittype 
if get(handles.startpoint,'value')
    edittype = 6;
set(handles.upladder,'value',0);
set(handles.ladder,'value',0);
set(handles.angle,'value',0);
set(handles.normalground,'value',0);  
set(handles.smallwall,'value',0);
set(handles.wall,'value',0);
set(handles.tallwall,'value',0);
set(handles.littleriver,'value',0);
set(handles.river,'value',0);

set(handles.endpoint,'value',0);
end

% --- Executes on button press in endpoint.
function endpoint_Callback(hObject, eventdata, handles)
% hObject    handle to endpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of endpoint
global edittype 
if get(handles.endpoint,'value')
    edittype = 7;
set(handles.upladder,'value',0);
set(handles.ladder,'value',0);
set(handles.angle,'value',0);
set(handles.normalground,'value',0);  
set(handles.smallwall,'value',0);
set(handles.wall,'value',0);
set(handles.tallwall,'value',0);
set(handles.littleriver,'value',0);
set(handles.river,'value',0);
set(handles.startpoint,'value',0);

end

function anglerisk_Callback(hObject, eventdata, handles)
% hObject    handle to anglerisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anglerisk as text
%        str2double(get(hObject,'String')) returns contents of anglerisk as a double


% --- Executes during object creation, after setting all properties.
function anglerisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anglerisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called 

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ladderrisk_Callback(hObject, eventdata, handles)
% hObject    handle to ladderrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ladderrisk as text
%        str2double(get(hObject,'String')) returns contents of ladderrisk as a double


% --- Executes during object creation, after setting all properties.
function ladderrisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ladderrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function normalrisk_Callback(hObject, eventdata, handles)  %normalrisk编辑框
% hObject    handle to normalrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalrisk as text
%        str2double(get(hObject,'String')) returns contents of normalrisk as a double


% --- Executes during object creation, after setting all properties.
function normalrisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function normalcost_Callback(hObject, eventdata, handles)       %normalcost编辑框
% hObject    handle to normalcost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalcost as text
%        str2double(get(hObject,'String')) returns contents of normalcost as a double


% --- Executes during object creation, after setting all properties.
function normalcost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalcost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lengthofperblock_Callback(hObject, eventdata, handles)   %栅格边长编辑框
% hObject    handle to lengthofperblock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lengthofperblock as text
%        str2double(get(hObject,'String')) returns contents of lengthofperblock as a double


% --- Executes during object creation, after setting all properties.
function lengthofperblock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lengthofperblock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function mapaxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate mapaxes


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
global startflag
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startflag = 0;
str1 = [ ];
set(handles.textshow1,'string',str1);
set(handles.textshow2,'string',str1);
set(handles.textshow3,'string',str1);
set(handles.time,'string',str1);
set(handles.textshow12,'string',str1);
cla reset;



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax = gca;
b= datetime;
exportgraphics(gca,'map.png','Resolution',300);



function riskweight_Callback(hObject, eventdata, handles)
% hObject    handle to riskweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of riskweight as text
%        str2double(get(hObject,'String')) returns contents of riskweight as a double


% --- Executes during object creation, after setting all properties.
function riskweight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to riskweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function farweight_Callback(hObject, eventdata, handles)
% hObject    handle to farweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of farweight as text
%        str2double(get(hObject,'String')) returns contents of farweight as a double


% --- Executes during object creation, after setting all properties.
function farweight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to farweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costweight_Callback(hObject, eventdata, handles)
% hObject    handle to costweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costweight as text
%        str2double(get(hObject,'String')) returns contents of costweight as a double


% --- Executes during object creation, after setting all properties.
function costweight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costweight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in upladder.
function upladder_Callback(hObject, eventdata, handles)
% hObject    handle to upladder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of upladder
global edittype 
if get(handles.upladder,'value')
    edittype = 8;
    set(handles.normalground,'value',0);  
    set(handles.wall,'value',0);
    set(handles.river,'value',0);
    set(handles.angle,'value',0);
    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
    set(handles.ladder,'value',0);
    set(handles.smallwall,'value',0);
    set(handles.littleriver,'value',0);
    set(handles.tallwall,'value',0);
end



function upladderrisk_Callback(hObject, eventdata, handles)
% hObject    handle to upladderrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upladderrisk as text
%        str2double(get(hObject,'String')) returns contents of upladderrisk as a double


% --- Executes during object creation, after setting all properties.
function upladderrisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upladderrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upladdercost_Callback(hObject, eventdata, handles)
% hObject    handle to upladdercost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upladdercost as text
%        str2double(get(hObject,'String')) returns contents of upladdercost as a double


% --- Executes during object creation, after setting all properties.
function upladdercost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upladdercost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mapmatrix mapdata mapfar maprisk  maze mapspeed mapG 
save('mapmatrix.mat','mapmatrix');    %其中name是要存储的名字，data是要存储的矩阵，前者是输出，后者输入。
save('mapdata.mat','mapdata');
save('mapfar.mat','mapfar');
save('maprisk.mat','maprisk');
save('maze.mat','maze');
save('mapspeed.mat','mapspeed');
save('mapG.mat','mapG');


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mapmatrix mapdata mapfar maprisk  maze phandles mapspeed startflag   edittype SandEpoint  mapz mapG 
load('mapmatrix.mat','mapmatrix');   
load('mapdata.mat','mapdata');
load('mapfar.mat','mapfar');
load('maprisk.mat','maprisk');
load('maze.mat','maze');
load('mapspeed.mat','mapspeed');
load('mapG.mat','mapG');



    row = str2double(get(handles.row,'string'));
    column = str2double(get(handles.column,'string'));
    map=[1 1 1;  %白
        0 0 1;   %蓝
        1 0 1;   %品红
        0 0 0;   %黑
        1 0 0;   %红
        1 1 0;   %黄
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %绿
    colormap(map);
    phandles = pcolor(1:row+1,1:column+1,[mapmatrix mapmatrix(:,end); mapmatrix(end,:) mapmatrix(end,end)]);
    set(phandles,'ButtonDownFcn',{@mapClickCallback,handles});   


if startflag
    shangebianchang=str2double(get(handles.lengthofperblock,'string'));  %每个栅格边长
    hightofnormal=str2double(get(handles.hightofnormal,'string'));       %平台高度
    upladderhight=str2double(get(handles.hightofupladder,'string'));     %竖梯高度
    hightofsmallwall=str2double(get(handles.hightofsmallwall,'string')); %矮墙高度
    hightofwall=str2double(get(handles.hightofwall,'string'));           %墙高度
    breadthoflittleriver=str2double(get(handles.breadthoflittleriver,'string')); %小溪宽度
    
    normalspeed=str2double(get(handles.normalspeed,'string'));     %平地行进速度
    climbspeed=str2double(get(handles.upladderspeed,'string'));    %爬梯子速度
    swingspeed=str2double(get(handles.ladderspeed,'string'));      %摆荡速度
    anglespeed=str2double(get(handles.anglespeed,'string'));       %斜坡速度
    jumpspeed=str2double(get(handles.jumpspeedperm,'string'));     %跳高速度
    throwoverspeed=str2double(get(handles.throwoverspeed,'string'));   %翻越速度
    longjumpspeed=str2double(get(handles.longjumpspeed,'string'));    %跳远速度
    
    
    topnb=shangebianchang/normalspeed;    %每个平地方格消耗时间
    toplb=shangebianchang/swingspeed;     %摆荡时间
    topab=shangebianchang/anglespeed;     %斜坡时间
    tocu=upladderhight/climbspeed;        %爬梯子时间
    tojump=hightofsmallwall/jumpspeed;    %跳高时间
    tothrowover=hightofwall/throwoverspeed; %翻越时间
    tolongjump=breadthoflittleriver/longjumpspeed; %跳远时间
    

    
    
    axesHandle = get(hObject,'Parent');
    temp = get(axesHandle,'CurrentPoint');%获取最近一次点击的位置
    coordinates = floor(temp(1,1:2));
    switch edittype
        case 1     %平地
            mapmatrix(coordinates(2),coordinates(1)) =1; %白色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.normalcost,'string'))*shangebianchang; 
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.normalrisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = topnb;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = hightofnormal ;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 2     %高墙
            if mapmatrix(coordinates(2),coordinates(1)) ~=4 && mapmatrix(coordinates(2),coordinates(1)) ~=2
            mapmatrix(coordinates(2),coordinates(1)) =4; %黑色
            mapdata(coordinates(2),coordinates(1)) = inf;
            mapfar (coordinates(2),coordinates(1)) = inf;
            maprisk(coordinates(2),coordinates(1)) = inf;
            mapspeed(coordinates(2),coordinates(1)) = inf;
            maze(coordinates(2),coordinates(1)) = 1 ;
            mapz(coordinates(2),coordinates(1)) = inf;
            mapG(coordinates(2),coordinates(1)) = 1 ;
            if coordinates(2)-1 > 0 
                maprisk(coordinates(2)-1,coordinates(1)) = maprisk(coordinates(2)-1,coordinates(1))+(0.05*shangebianchang);
            end
            if coordinates(2)+1 < n  
                maprisk(coordinates(2)+1,coordinates(1)) = maprisk(coordinates(2)+1,coordinates(1))+(0.05*shangebianchang) ;
            end
            if coordinates(1)-1 > 0 
                maprisk(coordinates(2),coordinates(1)-1) = maprisk(coordinates(2),coordinates(1)-1)+(0.05*shangebianchang);
            end
            if coordinates(1)+1 < n 
                maprisk(coordinates(2),coordinates(1)+1) = maprisk(coordinates(2),coordinates(1)+1)+(0.05*shangebianchang);
            end
            if coordinates(2)+1 < n &&  coordinates(1)-1 > 0 
                maprisk(coordinates(2)+1,coordinates(1)-1) = maprisk(coordinates(2)+1,coordinates(1)-1)+ (0.03*shangebianchang) ;
            end
            if coordinates(2)-1 > 0 &&  coordinates(1)+1 < n
                maprisk(coordinates(2)-1,coordinates(1)+1) = maprisk(coordinates(2)-1,coordinates(1)+1)+ (0.03*shangebianchang);
            end
            if coordinates(2)+1 < n &&  coordinates(1)+1 < n 
                maprisk(coordinates(2)+1,coordinates(1)+1) = maprisk(coordinates(2)+1,coordinates(1)+1)+ (0.03*shangebianchang) ;
            end
            if coordinates(2)-1 > 0 &&  coordinates(1)-1 > 0 
                maprisk(coordinates(2)-1,coordinates(1)-1) = maprisk(coordinates(2)-1,coordinates(1)-1)+ (0.03*shangebianchang);
            end
            else
            mapmatrix(coordinates(2),coordinates(1)) =4; %黑色
            mapdata(coordinates(2),coordinates(1)) = inf;
            mapfar (coordinates(2),coordinates(1)) = inf;
            maprisk(coordinates(2),coordinates(1)) = inf;
            mapspeed(coordinates(2),coordinates(1)) = inf;
            maze(coordinates(2),coordinates(1)) = 1 ;
            mapz(coordinates(2),coordinates(1)) = inf;
            mapG(coordinates(2),coordinates(1)) = 1 ; 
            end
        case 3     %河
            if  mapmatrix(coordinates(2),coordinates(1)) ~=2 && mapmatrix(coordinates(2),coordinates(1)) ~=4
            mapmatrix(coordinates(2),coordinates(1)) =2; %蓝色
            mapdata(coordinates(2),coordinates(1)) = inf;
            mapfar (coordinates(2),coordinates(1)) = inf;
            maprisk(coordinates(2),coordinates(1)) = inf;
            mapspeed(coordinates(2),coordinates(1)) = inf;
            maze(coordinates(2),coordinates(1)) = 1 ;
            mapz(coordinates(2),coordinates(1)) = inf;
            mapG(coordinates(2),coordinates(1)) = 1 ;
            if coordinates(2)-1 > 0 
                maprisk(coordinates(2)-1,coordinates(1)) = maprisk(coordinates(2)-1,coordinates(1))+(0.05*shangebianchang);
            end
            if coordinates(2)+1 < n  
                maprisk(coordinates(2)+1,coordinates(1)) = maprisk(coordinates(2)+1,coordinates(1))+(0.05*shangebianchang) ;
            end
            if coordinates(1)-1 > 0 
                maprisk(coordinates(2),coordinates(1)-1) = maprisk(coordinates(2),coordinates(1)-1)+(0.05*shangebianchang);
            end
            if coordinates(1)+1 < n 
                maprisk(coordinates(2),coordinates(1)+1) = maprisk(coordinates(2),coordinates(1)+1)+(0.05*shangebianchang);
            end
            if coordinates(2)+1 < n &&  coordinates(1)-1 > 0 
                maprisk(coordinates(2)+1,coordinates(1)-1) = maprisk(coordinates(2)+1,coordinates(1)-1)+ (0.03*shangebianchang) ;
            end
            if coordinates(2)-1 > 0 &&  coordinates(1)+1 < n
                maprisk(coordinates(2)-1,coordinates(1)+1) = maprisk(coordinates(2)-1,coordinates(1)+1)+ (0.03*shangebianchang);
            end
            if coordinates(2)+1 < n &&  coordinates(1)+1 < n 
                maprisk(coordinates(2)+1,coordinates(1)+1) = maprisk(coordinates(2)+1,coordinates(1)+1)+ (0.03*shangebianchang) ;
            end
            if coordinates(2)-1 > 0 &&  coordinates(1)-1 > 0 
                maprisk(coordinates(2)-1,coordinates(1)-1) = maprisk(coordinates(2)-1,coordinates(1)-1)+ (0.03*shangebianchang);
            end
            else
            mapmatrix(coordinates(2),coordinates(1)) =2; %蓝色
            mapdata(coordinates(2),coordinates(1)) = inf;
            mapfar (coordinates(2),coordinates(1)) = inf;
            maprisk(coordinates(2),coordinates(1)) = inf;
            mapspeed(coordinates(2),coordinates(1)) = inf;
            maze(coordinates(2),coordinates(1)) = 1 ;
            mapz(coordinates(2),coordinates(1)) = inf;
            mapG(coordinates(2),coordinates(1)) = 1 ;
            end
        case 4     %斜面
            mapmatrix(coordinates(2),coordinates(1)) = 3; %品红
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.anglecost,'string'))*shangebianchang;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.anglerisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = topab;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 5     %云梯
            mapmatrix(coordinates(2),coordinates(1)) = 5; %红色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.laddercost,'string'))*shangebianchang;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.ladderrisk,'string'))*shangebianchang;
            mapspeed(coordinates(2),coordinates(1)) = toplb;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 6
            mapmatrix(SandEpoint(1,2),SandEpoint(1,1)) = 1;
            SandEpoint(1,:) = coordinates;
            mapmatrix(coordinates(2),coordinates(1)) = 10;
            maze(coordinates(2),coordinates(1)) = 2 ;
            mapG(coordinates(2),coordinates(1)) = 0 ;
        case 7
            mapmatrix(SandEpoint(2,2),SandEpoint(2,1)) = 1;
            SandEpoint(2,:) = coordinates;
            mapmatrix(coordinates(2),coordinates(1)) = 10;
            maze(coordinates(2),coordinates(1)) = 3 ;
            mapG(coordinates(2),coordinates(1)) = 0 ;
        case 8    %竖梯
            mapmatrix(coordinates(2),coordinates(1)) = 6; %黄色
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.upladdercost,'string'))*upladderhight;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.upladderrisk,'string'))*upladderhight;
            mapspeed(coordinates(2),coordinates(1)) = tocu;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = upladderhight;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 9    %矮墙
            mapmatrix(coordinates(2),coordinates(1)) = 7; %LightSlateGray 
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costofjumpperm,'string'))*hightofsmallwall;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.jumpriskperm,'string'))*hightofsmallwall;
            mapspeed(coordinates(2),coordinates(1)) = tojump;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 10    %墙
            mapmatrix(coordinates(2),coordinates(1)) = 8; %DimGrey
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costofthrowover,'string'))*hightofwall;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.throwoverrisk,'string'))*hightofwall;
            mapspeed(coordinates(2),coordinates(1)) = tothrowover;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        case 11    %溪流
            mapmatrix(coordinates(2),coordinates(1)) = 9; %DeepSkyBlue
            mapdata(coordinates(2),coordinates(1)) = str2double(get(handles.costoflongjumpperm,'string'))*breadthoflittleriver;
            mapfar (coordinates(2),coordinates(1)) = shangebianchang;
            maprisk(coordinates(2),coordinates(1)) = str2double(get(handles.riskoflongjumpperm,'string'))*breadthoflittleriver;
            mapspeed(coordinates(2),coordinates(1)) = tolongjump;
            maze(coordinates(2),coordinates(1)) = 0 ;
            mapz(coordinates(2),coordinates(1)) = 0;
            mapG(coordinates(2),coordinates(1)) = 0 ;

        otherwise
            return;
    end

    row = str2double(get(handles.row,'string'));
    column = str2double(get(handles.column,'string'));
    map=[1 1 1;  %白
        0 0 1;   %蓝
        1 0 1;   %品红
        0 0 0;   %黑
        1 0 0;   %红
        1 1 0;   %黄
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %绿
    colormap(map);
    phandles = pcolor(1:row+1,1:column+1,[mapmatrix mapmatrix(:,end); mapmatrix(end,:) mapmatrix(end,end)]);
    set(phandles,'ButtonDownFcn',{@mapClickCallback,handles}); 
end


% --- Executes during object creation, after setting all properties.
function pushbutton12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textshow2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textshow2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function normalspeed_Callback(hObject, eventdata, handles)
% hObject    handle to normalspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of normalspeed as text
%        str2double(get(hObject,'String')) returns contents of normalspeed as a double


% --- Executes during object creation, after setting all properties.
function normalspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anglespeed_Callback(hObject, eventdata, handles)
% hObject    handle to anglespeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anglespeed as text
%        str2double(get(hObject,'String')) returns contents of anglespeed as a double


% --- Executes during object creation, after setting all properties.
function anglespeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anglespeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ladderspeed_Callback(hObject, eventdata, handles)
% hObject    handle to ladderspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ladderspeed as text
%        str2double(get(hObject,'String')) returns contents of ladderspeed as a double


% --- Executes during object creation, after setting all properties.
function ladderspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ladderspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upladderspeed_Callback(hObject, eventdata, handles)
% hObject    handle to upladderspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upladderspeed as text
%        str2double(get(hObject,'String')) returns contents of upladderspeed as a double


% --- Executes during object creation, after setting all properties.
function upladderspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upladderspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hightofupladder_Callback(hObject, eventdata, handles)
% hObject    handle to hightofupladder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hightofupladder as text
%        str2double(get(hObject,'String')) returns contents of hightofupladder as a double


% --- Executes during object creation, after setting all properties.
function hightofupladder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hightofupladder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in smallwall.
function smallwall_Callback(hObject, eventdata, handles)
% hObject    handle to smallwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smallwall
global edittype
if get(handles.smallwall,'value')
    edittype = 9;
    set(handles.upladder,'value',0);
    set(handles.ladder,'value',0);
    set(handles.angle,'value',0);
    set(handles.normalground,'value',0); 
    set(handles.wall,'value',0);
    set(handles.tallwall,'value',0);
    set(handles.littleriver,'value',0);
    set(handles.river,'value',0);
    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
end


function hightofwall_Callback(hObject, eventdata, handles)
% hObject    handle to hightofwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hightofwall as text
%        str2double(get(hObject,'String')) returns contents of hightofwall as a double


% --- Executes during object creation, after setting all properties.
function hightofwall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hightofwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hightofsmallwall_Callback(hObject, eventdata, handles)
% hObject    handle to hightofsmallwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hightofsmallwall as text
%        str2double(get(hObject,'String')) returns contents of hightofsmallwall as a double


% --- Executes during object creation, after setting all properties.
function hightofsmallwall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hightofsmallwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tallwall.
function tallwall_Callback(hObject, eventdata, handles)
% hObject    handle to tallwall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tallwall
global edittype 
if get(handles.tallwall,'value')
    edittype = 2;
   set(handles.upladder,'value',0);
   set(handles.ladder,'value',0);
   set(handles.angle,'value',0);
   set(handles.normalground,'value',0);  
   set(handles.smallwall,'value',0);
   set(handles.wall,'value',0);
   set(handles.littleriver,'value',0);
   set(handles.river,'value',0);
   set(handles.startpoint,'value',0);
   set(handles.endpoint,'value',0);
end

% --- Executes on button press in littleriver.
function littleriver_Callback(hObject, eventdata, handles)
% hObject    handle to littleriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of littleriver
global edittype 
if get(handles.littleriver,'value')
    edittype = 11;
    set(handles.upladder,'value',0);
    set(handles.ladder,'value',0);
    set(handles.angle,'value',0);
    set(handles.normalground,'value',0);  
    set(handles.smallwall,'value',0);
    set(handles.wall,'value',0);
    set(handles.tallwall,'value',0);
    set(handles.river,'value',0);
    set(handles.startpoint,'value',0);
    set(handles.endpoint,'value',0);
end


function jumpriskperm_Callback(hObject, eventdata, handles)
% hObject    handle to jumpriskperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumpriskperm as text
%        str2double(get(hObject,'String')) returns contents of jumpriskperm as a double


% --- Executes during object creation, after setting all properties.
function jumpriskperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumpriskperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costofjumpperm_Callback(hObject, eventdata, handles)
% hObject    handle to costofjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costofjumpperm as text
%        str2double(get(hObject,'String')) returns contents of costofjumpperm as a double


% --- Executes during object creation, after setting all properties.
function costofjumpperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costofjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function throwoverrisk_Callback(hObject, eventdata, handles)
% hObject    handle to throwoverrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of throwoverrisk as text
%        str2double(get(hObject,'String')) returns contents of throwoverrisk as a double


% --- Executes during object creation, after setting all properties.
function throwoverrisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to throwoverrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costofthrowover_Callback(hObject, eventdata, handles)
% hObject    handle to costofthrowover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costofthrowover as text
%        str2double(get(hObject,'String')) returns contents of costofthrowover as a double


% --- Executes during object creation, after setting all properties.
function costofthrowover_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costofthrowover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function throwoverspeed_Callback(hObject, eventdata, handles)
% hObject    handle to throwoverspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of throwoverspeed as text
%        str2double(get(hObject,'String')) returns contents of throwoverspeed as a double


% --- Executes during object creation, after setting all properties.
function throwoverspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to throwoverspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function jumpspeedperm_Callback(hObject, eventdata, handles)
% hObject    handle to jumpspeedperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumpspeedperm as text
%        str2double(get(hObject,'String')) returns contents of jumpspeedperm as a double


% --- Executes during object creation, after setting all properties.
function jumpspeedperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumpspeedperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function longjumpspeed_Callback(hObject, eventdata, handles)
% hObject    handle to longjumpspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of longjumpspeed as text
%        str2double(get(hObject,'String')) returns contents of longjumpspeed as a double


% --- Executes during object creation, after setting all properties.
function longjumpspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longjumpspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function riskoflongjumpperm_Callback(hObject, eventdata, handles)
% hObject    handle to riskoflongjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of riskoflongjumpperm as text
%        str2double(get(hObject,'String')) returns contents of riskoflongjumpperm as a double


% --- Executes during object creation, after setting all properties.
function riskoflongjumpperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to riskoflongjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costoflongjumpperm_Callback(hObject, eventdata, handles)
% hObject    handle to costoflongjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costoflongjumpperm as text
%        str2double(get(hObject,'String')) returns contents of costoflongjumpperm as a double


% --- Executes during object creation, after setting all properties.
function costoflongjumpperm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costoflongjumpperm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function breadthoflittleriver_Callback(hObject, eventdata, handles)
% hObject    handle to breadthoflittleriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of breadthoflittleriver as text
%        str2double(get(hObject,'String')) returns contents of breadthoflittleriver as a double


% --- Executes during object creation, after setting all properties.
function breadthoflittleriver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to breadthoflittleriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hightofnormal_Callback(hObject, eventdata, handles)
% hObject    handle to hightofnormal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hightofnormal as text
%        str2double(get(hObject,'String')) returns contents of hightofnormal as a double


% --- Executes during object creation, after setting all properties.
function hightofnormal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hightofnormal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mapmatrix mapdata mapfar maprisk  maze mapspeed mapz 
nr=str2double(get(handles.normalrisk,'string'));
nc=str2double(get(handles.normalcost,'string'));
shangebianchang=str2double(get(handles.lengthofperblock,'string'));
normalspeed=str2double(get(handles.normalspeed,'string'));
topnb=shangebianchang/normalspeed;    %每个平地方格消耗时间


posofstartgoal=find(mapmatrix==10);
posofstart=posofstartgoal(1);
posofgoal=posofstartgoal(2);
mapmatrix(posofstart)=1;
mapmatrix(posofgoal)=1;
mapdata(posofstart)=nc;
mapdata(posofgoal)=nc;
maprisk(posofstart)=nr;
maprisk(posofgoal)=nr;
mapfar(posofstart)=shangebianchang;
mapfar(posofgoal)=shangebianchang;
maze(posofstart)=0;
maze(posofgoal)=0;
mapspeed(posofstart)=topnb;
mapspeed(posofgoal)=topnb;
mapz(posofstart)=0;
mapz(posofgoal)=0;


    row = str2double(get(handles.row,'string'));
    column = str2double(get(handles.column,'string'));
    map=[1 1 1;  %白
        0 0 1;   %蓝
        1 0 1;   %品红
        0 0 0;   %黑
        1 0 0;   %红
        1 1 0;   %黄
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %绿
    colormap(map);
    phandles = pcolor(1:row+1,1:column+1,[mapmatrix mapmatrix(:,end); mapmatrix(end,:) mapmatrix(end,end)]);
    set(phandles,'ButtonDownFcn',{@mapClickCallback,handles}); 


% --- Executes on button press in GApathfinding.
function GApathfinding_Callback(hObject, eventdata, handles)
% hObject    handle to GApathfinding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tic
global  mapG  mapmatrix mapspeed mapdata maprisk  x_goal y_goal inflection in_point_num n

%GA与gui索引起点不同排列不同，所以将索引对齐，将点击地图的索引转化为GA地图中的索引
n = str2double(get(handles.row,'string'));
indexeslimit=n*n-1;  %GA地图中索引的上限
indexeslist=0:indexeslimit;  %GA地图中所有索引数字
mapindex1=reshape(indexeslist,[n,n]);   %组成矩阵
mapindex2=mapindex1';            %矩阵转秩
sgpoint=find(mapmatrix==10);    
New_startposind=sgpoint(1); 
New_goalposind=sgpoint(2);        
start=mapindex2(New_startposind);   
goal=mapindex2(New_goalposind);               
G = mapG;
D = mapdata;
S = mapspeed;
R = maprisk;
M = mapmatrix;


%得到参数
gatime=str2double(get(handles.GAtime,'string'));
gasmooth=str2double(get(handles.GAsmooth,'string'));
gacost=str2double(get(handles.GAcost,'string'));
garisk=str2double(get(handles.GArisk,'string'));
runtimes=str2double(get(handles.runtimes,'string'));
initial_population_size=str2double(get(handles.initial_population_size,'string'));
itertaion_limit=str2double(get(handles.iteration_limit,'string'));

%调用GA
% GApathfinding(R,D,S,M,G,start,goal,n,gatime,gasmooth,gacost,garisk);
[finaldata,min_path]=MLRMOEGApathfinding(R,D,S,M,G,start,goal,n,gatime,gasmooth,gacost,garisk,runtimes,initial_population_size,itertaion_limit);

sum5=finaldata(1);
sum1=finaldata(3);
sum4=finaldata(4);
sum2=finaldata(2);

str1 = ['energy consumption: ' num2str(sum1)];
str2 = ['time: ' num2str(sum5),'s'];
str3 = ['falling risk: ' num2str(sum4)];
str4 = ['total angle: ' num2str(sum2)];

set(handles.textshow1,'string',str1);
set(handles.textshow2,'string',str2);
set(handles.textshow3,'string',str3);
set(handles.textshow12,'string',str4);

toc
time=toc;
set(handles.time,'string',time);

%找出路线拐点
[inflection] = find_inflection(min_path,n);
[in_point_num,~]=size(inflection);

%计算终点x，y左边加入到拐点队列
x_goal = mod(goal, n) + 1;
y_goal = fix(goal / n) + 1;

inflection(in_point_num+1,1)=x_goal;
inflection(in_point_num+1,2)=y_goal;
inflection






function GArisk_Callback(hObject, eventdata, handles)
% hObject    handle to GArisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GArisk as text
%        str2double(get(hObject,'String')) returns contents of GArisk as a double


% --- Executes during object creation, after setting all properties.
function GArisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GArisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GAcost_Callback(hObject, eventdata, handles)
% hObject    handle to GAcost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GAcost as text
%        str2double(get(hObject,'String')) returns contents of GAcost as a double


% --- Executes during object creation, after setting all properties.
function GAcost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GAcost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GAsmooth_Callback(hObject, eventdata, handles)
% hObject    handle to GAsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GAsmooth as text
%        str2double(get(hObject,'String')) returns contents of GAsmooth as a double


% --- Executes during object creation, after setting all properties.
function GAsmooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GAsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GAtime_Callback(hObject, eventdata, handles)
% hObject    handle to GAtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GAtime as text
%        str2double(get(hObject,'String')) returns contents of GAtime as a double


% --- Executes during object creation, after setting all properties.
function GAtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GAtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function runtimes_Callback(hObject, eventdata, handles)
% hObject    handle to runtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of runtimes as text
%        str2double(get(hObject,'String')) returns contents of runtimes as a double


% --- Executes during object creation, after setting all properties.
function runtimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iteration_limit_Callback(hObject, eventdata, handles)
% hObject    handle to iteration_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iteration_limit as text
%        str2double(get(hObject,'String')) returns contents of iteration_limit as a double


% --- Executes during object creation, after setting all properties.
function iteration_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iteration_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_population_size_Callback(hObject, eventdata, handles)
% hObject    handle to initial_population_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_population_size as text
%        str2double(get(hObject,'String')) returns contents of initial_population_size as a double


% --- Executes during object creation, after setting all properties.
function initial_population_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_population_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MapAnalysis.
function MapAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to MapAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mapmatrix
M=mapmatrix;
[~,x]=size(M);
[all_area] = Map_analysis(M,x)


% --- Executes on button press in DWAbutton.
function DWAbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DWAbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_goal y_goal inflection in_point_num n mapdata ob_list obstacle
R=mapdata';
ob=find(R==inf)
[ob_num,~]=size(ob);
ob_list=[];
for i=1:ob_num
    x_ob = mod((ob(i)-1), n)  + 1;
    y_ob = fix((ob(i)-1) / n) + 1;
    ob_list(i,1)=x_ob;
    ob_list(i,2)=y_ob;
end
ob_list=ob_list+ones(ob_num,2)*0.5;
% dwa_main(x_goal,y_goal,inflection,in_point_num,n,ob_list);


%%DWA算法实现
disp('Dynamic Window Approach sample program start!!')
%% 机器人的初期状态[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]

start_Rate=(inflection(1,2)-1)/(inflection(1,1)-1);
start_angle=atan(start_Rate);

% x=[0 0 pi/2 0 0]'; % 5x1矩阵 列矩阵  位置 0，0 航向 pi/2 ,速度、角速度均为0
%x = [1.5 1.5 pi/2 0 0]'; 
x = [1.5 1.5 start_angle 0 0]'; 

% 下标宏定义 状态[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
POSE_X      = 1;  %坐标 X
POSE_Y      = 2;  %坐标 Y
YAW_ANGLE   = 3;  %机器人航向角
V_SPD       = 4;  %机器人速度
W_ANGLE_SPD = 5;  %机器人角速度 

goal = [x_goal,y_goal];   % 目标点位置 [x(m),y(m)]

% 障碍物位置列表 [x(m) y(m)]
% obstacle=[%0 2;
%           3 20*rand(1);
% %           4 4;
% %          5 4;
% %            5 5;
%           6 20*rand(1);
% %          5 9
% %          7 8
%           8 20*rand(1);
%           2 5;      
%           4 2;
%           7 7;
%           9 9
%             ];
obstacle=ob_list;
[ob_num,~]=size(ob_list);
%边界障碍物，防止跑出图外
 for i =-1
    for j = -1:n+3
        obstacle = [obstacle; [i,j]];
    end
 end     
for i =n+3
    for j = -1:n+3
        obstacle = [obstacle; [i,j]];
    end
end 
for j =-1
    for i = -1:n+3
        obstacle = [obstacle; [i,j]];
    end
end 
for j=n+3
    for i= -1:n+3
        obstacle = [obstacle; [i,j]];
    end
end 

%动态障碍物位置
% obstacle = [obstacle; [13,15]];
% obstacle = [obstacle; [9,12]];
% obstacle = [obstacle; [20,9]];

[ob_num,~]=size(obstacle);
obstacleR = 0.5;% 冲突判定用的障碍物半径
global dt; 
dt = 0.1;% 时间[s]

% 机器人运动学模型参数
% 最高速度m/s],最高旋转速度[rad/s],加速度[m/ss],旋转加速度[rad/ss],
% 速度分辨率[m/s],转速分辨率[rad/s]]
Kinematic = [0.7,pi,0.2,toRadian(50.0),0.01,toRadian(1)];
%定义Kinematic的下标含义
MD_MAX_V    = 0.7;%   最高速度m/s]
MD_MAX_W    = pi;%   最高旋转速度[rad/s]
MD_ACC      = 3;%   加速度[m/ss]
MD_VW       = 4;%   旋转加速度[rad/ss]
MD_V_RESOLUTION  = 5;%  速度分辨率[m/s]
MD_W_RESOLUTION  = 6;%  转速分辨率[rad/s]]


% 评价函数参数 [heading,dist,velocity,predictDT]
% 航向得分的比重、距离得分的比重、速度得分的比重、向前模拟轨迹的时间
evalParam = [0.05, 0.05 ,0.1, 3.0];
% evalParam = [2, 0.2 ,0.2, 3.0];

%画出的区域范围
area  = [1 n+1 1 n+1];% 模拟区域范围 [xmin xmax ymin ymax]
% area  = [-1 n+3 -1 n+3];



% 模拟实验的结果
result.x=[];   %累积存储走过的轨迹点的状态值
tic; % 估算程序运行时间开始
flag_obstacle = [1-2*rand(1) 1-2*rand(1) 1-2*rand(1)];
% flag_obstacle = [1 1 1];
vel_obstacle = 0.05;
temp = 0;
abc = 0;
%movcount=0;
goal_list=inflection+ones(in_point_num+1, 2)*0.5;

in_point_num=in_point_num+1;

for goal_num=1:in_point_num
    goal=goal_list(goal_num,:);
    %% Main loop   循环运行 5000次 指导达到目的地 或者 5000次运行结束
    for i = 1:5000  
        % DWA参数输入 返回控制量 u = [v(m/s),w(rad/s)] 和 轨迹
        [u,traj] = DynamicWindowApproach(x,Kinematic,goal,evalParam,obstacle,obstacleR,goal_num,in_point_num);%算出下发速度u/当前速度u
        u
%         pub_vel(u(1),u(2));
        x = f(x,u);% 机器人移动到下一个时刻的状态量 根据当前速度和角速度推导 下一刻的位置和角度
        abc = abc+1;
        % 历史轨迹的保存
        result.x = [result.x; x'];  %最新结果 以行的形式 添加到result.x，保存的是所有状态参数值，包括坐标xy、朝向、线速度、角速度，其实应该是只取坐标就OK
        
        
        % 是否到达目的地        
        if goal_num<in_point_num
            arrival_dis=0.5;
        else
            arrival_dis=0.15;
        end

        
        if norm(x(POSE_X:POSE_Y)-goal')<arrival_dis   % norm函数来求得坐标上的两个点之间的距离
            disp('==========Arrive Goal!!==========');
            break;
        end
        
        
        %====Animation====
        hold off;               % 关闭图形保持功能。 新图出现时，取消原图的显示。
        ArrowLength = 0.5;      % 箭头长度

        % 机器人
        % quiver(x,y,u,v) 在 x 和 y 中每个对应元素对组所指定的坐标处将向量绘制为箭头
        quiver(x(POSE_X), x(POSE_Y), ArrowLength*cos(x(YAW_ANGLE)), ArrowLength*sin(x(YAW_ANGLE)),'ok'); 
        % 绘制机器人当前位置的航向箭头
        hold on;                                                     
        %启动图形保持功能，当前坐标轴和图形都将保持，从此绘制的图形都将添加在这个图形的基础上，并自动调整坐标轴的范围

        plot(result.x(:,POSE_X),result.x(:,POSE_Y),'-b');hold on;    % 绘制走过的所有位置 所有历史数据的 X、Y坐标
        plot(goal(1),goal(2),'*r');hold on;                          % 绘制目标位置

%%动态障碍物
%         for j = 1:3
%                 if obstacle(j,2) > 10 && flag_obstacle(j) > 0 || obstacle(j,2) < 0 && flag_obstacle(j) < 0
%                     obstacle(j) = flag_obstacle(j);
%                 end
%                 obstacle(j,2)=obstacle(j,2)+flag_obstacle(j)*vel_obstacle;
%         end
        
        plot(obstacle(:,1),obstacle(:,2),'.w');
        hold on;              % 绘制所有障碍物位置
        DrawObstacle_plot(obstacle,obstacleR);


        % 探索轨迹 画出待评价的轨迹
        if ~isempty(traj) %轨迹非空
            for it=1:length(traj(:,1))/5    %计算所有轨迹数  traj 每5行数据 表示一条轨迹点
                ind = 1+(it-1)*5; %第 it 条轨迹对应在traj中的下标 
                plot(traj(ind,:),traj(ind+1,:),'-g');hold on;  %根据一条轨迹的点串画出轨迹   traj(ind,:) 表示第ind条轨迹的所有x坐标值  traj(ind+1,:)表示第ind条轨迹的所有y坐标值
            end
        end

        axis(area); %根据area设置当前图形的坐标范围，分别为x轴的最小、最大值，y轴的最小最大值
        grid on;
        
        drawnow limitrate;  %刷新屏幕. 当代码执行时间长，需要反复执行plot时，Matlab程序不会马上把图像画到figure上，这时，要想实时看到图像的每一步变化情况，需要使用这个语句。
        for j = 1:3
            if norm(obstacle(j,:)-x(1:2)')-obstacleR < 0
               disp('==========Hit an obstacle!!==========');
               temp = 1;
               break;
            end
        end
    %     if temp == 1
    %         break;
    %     end
       % movcount = movcount+1;
       % mov(movcount) = getframe(gcf);%  记录动画帧
    end
    toc;  %输出程序运行时间  形式：时间已过 ** 秒。
    disp(abc)
    %movie2avi(mov,'movie.avi');  %录制过程动画 保存为 movie.avi 文件
end


% --- Executes on button press in updataob.
function updataob_Callback(hObject, eventdata, handles)
% hObject    handle to updataob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  obstacle
new_ob_x=str2double(get(handles.new_ob_x,'string'));
new_ob_y=str2double(get(handles.new_ob_y,'string'));
obstacle=[obstacle;[new_ob_x,new_ob_y]];






function new_ob_x_Callback(hObject, eventdata, handles)
% hObject    handle to new_ob_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_ob_x as text
%        str2double(get(hObject,'String')) returns contents of new_ob_x as a double


% --- Executes during object creation, after setting all properties.
function new_ob_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_ob_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function new_ob_y_Callback(hObject, eventdata, handles)
% hObject    handle to new_ob_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_ob_y as text
%        str2double(get(hObject,'String')) returns contents of new_ob_y as a double


% --- Executes during object creation, after setting all properties.
function new_ob_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_ob_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newR_Callback(hObject, eventdata, handles)
% hObject    handle to newR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newR as text
%        str2double(get(hObject,'String')) returns contents of newR as a double


% --- Executes during object creation, after setting all properties.
function newR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
