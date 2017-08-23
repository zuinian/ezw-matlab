function varargout = batch_operation(varargin)
% BATCH_OPERATION MATLAB code for batch_operation.fig
%      BATCH_OPERATION, by itself, creates a new BATCH_OPERATION or raises the existing
%      singleton*.
%
%      H = BATCH_OPERATION returns the handle to a new BATCH_OPERATION or the handle to
%      the existing singleton*.
%
%      BATCH_OPERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCH_OPERATION.M with the given input arguments.
%
%      BATCH_OPERATION('Property','Value',...) creates a new BATCH_OPERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batch_operation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batch_operation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batch_operation

% Last Modified by GUIDE v2.5 23-Apr-2017 22:10:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batch_operation_OpeningFcn, ...
                   'gui_OutputFcn',  @batch_operation_OutputFcn, ...
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

% --- Executes just before batch_operation is made visible.
function batch_operation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batch_operation (see VARARGIN)

% Choose default command line output for batch_operation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batch_operation wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear global;%清除全局变量

end

% --- Outputs from this function are returned to the command line.
function varargout = batch_operation_OutputFcn(hObject, eventdata, handles) 
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
    global fileNames pathName;
    [fileNames, pathName, filterindex] = uigetfile(filter, '选择图片', 'MultiSelect', 'on');
    
     %如果未选择图片则中断，不加这个判断时如果未选择图片后面执行下去会报错
    if isequal(fileNames, 0) | isequal(pathName, 0)
        return
    end
    global data;
    data = {};
    
    if ischar(fileNames)
        %就一张图片时fileNames为字符串类型
        fileNames = {fileNames};
    end
    data(:, 1) = fileNames;
    data(:, 2) = {'等待压缩'};
    set(handles.uitable1, 'data', data);
    set(handles.pushbutton2, 'String', '开始');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    state = get(handles.pushbutton2, 'String');
    if strcmp(state, '完成')
        msgbox('已压缩完成，请重新选择其他要压缩的图片');
        return;
    end
    
    %获取全局变量
    global fileNames pathName data compressRate;
    if isempty(fileNames)
        msgbox('请先选择图片');
        return ;
    end
    
    compressRate = get(handles.popupmenu1, 'value');
    photoType = get(handles.popupmenu2, 'value');
    dim = compressRate;
    waveBase = 'haar';
    pathNameOut = 'D:\matlab\output\batchOperation\';
    
    set(handles.pushbutton2, 'String', '压缩中');
    [rows, ~] = size(data);
    for i = 1 : rows
        data{i, 2} = '压缩中';
        set(handles.uitable1, 'data', data);
        pause(0.5);
        X = imread([pathName fileNames{i}]);
        [c, s] = wavedec2(X, dim, waveBase);
        %取最里层的低频/近似 系数。
        cai = appcoef2(c, s, waveBase, dim);
        cai = cai * (0.5 ^ dim);
        Y = uint8(cai);
        if photoType == 1 %1为jpg格式，2为格式不变
            fileName = fileNames{i};
            imwrite(Y, [pathNameOut, fileName(1 : end - 4), '.jpg']);
        else 
            imwrite(Y, [pathNameOut, fileNames{i}]);
        end
        data{i, 2} = '已完成';
        set(handles.uitable1, 'data', data);
    end

    set(handles.pushbutton2, 'String', '完成');

end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
