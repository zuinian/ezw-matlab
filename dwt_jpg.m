function varargout = dwt_jpg(varargin)
% DWT_JPG MATLAB code for dwt_jpg.fig
%      DWT_JPG, by itself, creates a new DWT_JPG or raises the existing
%      singleton*.
%
%      H = DWT_JPG returns the handle to a new DWT_JPG or the handle to
%      the existing singleton*.
%
%      DWT_JPG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DWT_JPG.M with the given input arguments.
%
%      DWT_JPG('Property','Value',...) creates a new DWT_JPG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dwt_jpg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dwt_jpg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dwt_jpg

% Last Modified by GUIDE v2.5 17-Apr-2017 16:56:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dwt_jpg_OpeningFcn, ...
                   'gui_OutputFcn',  @dwt_jpg_OutputFcn, ...
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
end

% --- Executes just before dwt_jpg is made visible.
function dwt_jpg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dwt_jpg (see VARARGIN)

% Choose default command line output for dwt_jpg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dwt_jpg wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clear global;%清除全局变量
%初始化时用于显示图片的坐标轴设为不可见
set(handles.axes1, 'vis', 'off');
set(handles.axes2, 'vis', 'off');
%压缩比与滚动条
set(handles.listbox1, 'vis', 'off');
set(handles.slider1, 'vis', 'off');
%text
set(handles.text2, 'vis', 'off');
set(handles.text3, 'vis', 'off');
set(handles.text4, 'vis', 'off');
set(handles.text5, 'vis', 'off');
%保存按钮
set(handles.pushbutton2, 'vis', 'off');
end

% --- Outputs from this function are returned to the command line.
function varargout = dwt_jpg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%{
% --- Executes on button press in pushbutton1.
选择按钮
选择要压缩的图片并显示
%}
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % 图像文件类型过滤
    filter = { ...
            '*.bmp; *.jpg; *.gif; *.png; *.tif', '所有图像文件 (*.bmp; *.jpg; *.gif; *.png; *.tif)'; ...
            '*.bmp',  '位图文件 (*.bmp)'; ...
            '*.jpg', 'JPEG文件 (*.jpg)'; ...
            '*.gif', 'GIF文件 (*.gif)'; ...
            '*.png', '图元文件 (*.png)'; ...
            '*.*',  '所有文件 (*.*)' ...
    };

    %弹出选择图片文件的对话框
    [fileName, pathName, filterindex] = uigetfile(filter, '选择图片');

    %如果未选择图片则中断，不加这个判断时如果未选择图片后面执行下去会报错
    if isequal(fileName, 0) | isequal(pathName, 0)
        return
    end

    %读取图片并显示
    global X;
    X = imread([pathName fileName]);
    axes(handles.axes1);%这句是定位到对应的坐标轴
    imshow(X);
    title('原图');

    %获取图片真实大小
    fileId = fopen([pathName fileName]);
    fseek(fileId,0,'eof');
    fileSizeIn = ftell(fileId)/1024;
    fileSizeIn =round(fileSizeIn);%取整
    set(handles.text4, 'String', [num2str(fileSizeIn) 'KB']);
    
    show(1, 0.5, handles);
    set(handles.listbox1, 'value', 2);%默认4:1
    set(handles.slider1, 'value', 0.5);%默认0.5
    
    %压缩比与滚动条显示
    set(handles.listbox1, 'vis', 'on');
    set(handles.slider1, 'vis', 'on');
    %text
    set(handles.text2, 'vis', 'on');
    set(handles.text3, 'vis', 'on');
    set(handles.text4, 'vis', 'on');
    set(handles.text5, 'vis', 'on');
    %保存按钮
set(handles.pushbutton2, 'vis', 'on');
end

function show(dim, lightWeight, handles)
    global X;
     if  isempty(X)
        msgbox('请先选择图片');
        return;
    end
    %dwt变换，暂时只做两层分解%
    waveBase = 'db1';
    [c, s] = wavedec2(X, dim, waveBase);
    %取最里层的低频/近似 系数。
    cai = appcoef2(c, s, waveBase, dim);
    axes(handles.axes2);
    global Y;
    Y = uint8(cai * lightWeight);
    imshow(Y);
    title('压缩后的图片');
    
    %获取输出图像大小
    filename = 'tmp.jpg';
    imwrite(Y, filename);
    fileId = fopen(filename);
    fseek(fileId,0,'eof');
    fileSizeOut = ftell(fileId)/1024;
    fileSizeOut =round(fileSizeOut);%取整
    set(handles.text5, 'String', [num2str(fileSizeOut) 'KB']);
    %delete(filename);
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
    global CompressRate;
    CompressRate = get(handles.listbox1, 'value');
    if CompressRate == 1
        msgbox('请选择压缩比');
        return;
    end
    dim = CompressRate -1;
    lightWeight = 0.5 ^ dim;
    show(dim, lightWeight, handles);
    %设置滚动条默认值
    set(handles.slider1, 'value', lightWeight);
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global CompressRate;
    CompressRate = get(handles.listbox1, 'value');
    dim = CompressRate -1;
    global lightWeight;
    lightWeight = get(handles.slider1, 'value');
    show(dim, lightWeight, handles);
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- 保存按钮
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %暂时只支持保存成jpg格式
    filter = { '*.jpg', 'JPEG文件 (*.jpg)'; };
    [filename, pathname] = uiputfile(filter, 'Save Picture', 'D:\matlab\output\unTitled.jpg');
    if isequal(filename,0) | isequal(pathname,0)
        return
    end
    global Y;
    imwrite(Y, [pathname, filename]);
    msgbox('保存成功');
end
