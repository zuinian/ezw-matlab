function varargout = my_dwt(varargin)
% MY_DWT MATLAB code for my_dwt.fig
%      MY_DWT, by itself, creates a new MY_DWT or raises the existing
%      singleton*.
%
%      H = MY_DWT returns the handle to a new MY_DWT or the handle to
%      the existing singleton*.
%
%      MY_DWT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_DWT.M with the given input arguments.
%
%      MY_DWT('Property','Value',...) creates a new MY_DWT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before my_dwt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to my_dwt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help my_dwt

% Last Modified by GUIDE v2.5 04-May-2017 00:43:42

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @my_dwt_OpeningFcn, ...
                       'gui_OutputFcn',  @my_dwt_OutputFcn, ...
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

% --- Executes just before my_dwt is made visible.
function my_dwt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to my_dwt (see VARARGIN)

    % Choose default command line output for my_dwt
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes my_dwt wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    clear global;%清除全局变量
    set(handles.axes1, 'vis', 'off');
    %set(handles.listbox1, 'vis', 'off');
end

% --- Outputs from this function are returned to the command line.
function varargout = my_dwt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


% --- Executes on button press in pushbutton1.
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
    global X;
    %读取图片并显示
    X = imread([pathName fileName]);

    if numel(size(X)) > 2
       X=rgb2gray(X);%如果是彩色的转成灰度图
    end
    
    dim = 1;
    X = sizePrune(X, dim);
    show(1, handles);
end

function show(dim, handles)
    global X;
    X = sizePrune(X, dim);
    [cAll, sAll] = myWaveDec2(X, dim, 'haar');
    Y = [];%输出图像
    %获取低频系数
    ca = cAll{1};
    ca(end, :) = 255;
    ca(:, end) = 255;
    %获取各层高频系数
    for i = 1 : dim
        ch = cAll{(i - 1) * 3 + 2};
        cv = cAll{(i - 1) * 3 + 3};
        cd = cAll{(i - 1) * 3 + 4};
        %{
        把细节系数亮度调高
        ch = ch * 5;
        cv = cv * 5;
        cd = cd * 5;
        %}
       %边框设置成白色线
        if i < dim
            ch(end, :) = 255;
            ch(:, end) = 255;
            cv(end, :) = 255;
            cv(:, end) = 255;
            cd(end, :) = 255;
            cd(:, end) = 255;
        else
            ch(:, end)=255;
            cv(end, :)=255;
        end
        ca = [ca cv ; ch cd];
    end
    Y = uint8(ca);
    axes(handles.axes1);
    set(handles.listbox1, 'value', dim);
    imshow(Y);
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
    dim = get(handles.listbox1, 'value');
    show(dim, handles);
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
