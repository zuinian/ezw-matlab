function varargout = dwt_ezw(varargin)
% DWT_EZW MATLAB code for dwt_ezw.fig
%      DWT_EZW, by itself, creates a new DWT_EZW or raises the existing
%      singleton*.
%
%      H = DWT_EZW returns the handle to a new DWT_EZW or the handle to
%      the existing singleton*.
%
%      DWT_EZW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DWT_EZW.M with the given input arguments.
%
%      DWT_EZW('Property','Value',...) creates a new DWT_EZW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dwt_ezw_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dwt_ezw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dwt_ezw

% Last Modified by GUIDE v2.5 08-May-2017 19:48:49

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @dwt_ezw_OpeningFcn, ...
                       'gui_OutputFcn',  @dwt_ezw_OutputFcn, ...
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

% --- Executes just before dwt_ezw is made visible.
function dwt_ezw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dwt_ezw (see VARARGIN)

% Choose default command line output for dwt_ezw
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dwt_ezw wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%初始化时用于显示图片的坐标轴设为不可见
clear global;%清除全局变量
set(handles.axes1, 'vis', 'off');
set(handles.axes2, 'vis', 'off');
set(handles.text4, 'vis', 'off');
set(handles.text5, 'vis', 'off');
set(handles.text7, 'vis', 'off');
end

% --- Outputs from this function are returned to the command line.
function varargout = dwt_ezw_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- 打开图片按钮.
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
    [filename, pathname, filterindex] = uigetfile(filter, '选择图片');
    global X;

    if filename == 0%未选择图片
        return;
    end
    X = imread([pathname filename]);
    
    if numel(size(X))> 2
        X=rgb2gray(X);%如果是彩色的转成灰度图
    end
    
    global fileSizeIn;
    %显示原图大小
    d = dir([pathname filename]);
    fileSizeIn = d.bytes / 1024;
    set(handles.text4, 'vis', 'on');
    set(handles.text4, 'String', [sprintf('%.2f', fileSizeIn) 'KB']);
    
    axes(handles.axes1);%这句是定位到对应的坐标轴
    imshow(X);
    title('原图');
end


% --- 压缩按钮.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global X;
    if  isempty(X)
        msgbox('请先选择图片');
        return;
    end
    
    global dim;%变换级数%这个必须全局
    dim = get(handles.popupmenu1, 'value');
    [rowX, colX] = size(X);
    if log2(rowX) ~= fix(log2(rowX)) || log2(colX) ~= fix(log2(colX))
        msgbox('图片格式不对，长与宽的像素值必须为2的指数次方');
        return;
    end
    maxDim = min(log2(rowX), log2(colX))
    if dim > maxDim
        msgbox(['该图像分解级数最大为' num2str(maxDim) '，请重新选择']);
        return ;
    end
    
    scanTimes = get(handles.popupmenu2, 'value');
    global s;%解码时逐层显示用到
    [c, s] = wavedec2(X, dim, 'db1');
    %获取最里层的低频系数
    cai =  appcoef2(c, s, 'db1', dim);
    cAll = c2mat(cai, c, s, dim);
    
    global row col;%这个必须全局
    [row, col] = size(cAll);
    %获取阈值
    maxDecIm = max(max(abs(cAll)));
    T = zeros(1, scanTimes);
    T(1) = 2 ^ floor(log2(maxDecIm));
    %其他层的阈值
    for i = 2 : scanTimes
        T(i) = T(i - 1) / 2;
    end
    %编码
    [scanCodes, quantiFlags, perScanNums] = ezwEncode(cAll, T, scanTimes, handles);
    fileSizeOut = getEncodedSize(perScanNums, scanTimes);
    
    %解码
    cAllDecode = ezwDecode(T(1), scanTimes, scanCodes, perScanNums(:, 1)', quantiFlags, perScanNums(:, 2)', handles);
   
    %输出文件大小--显示在text5
    set(handles.text5, 'vis', 'on');
    set(handles.text5, 'String', [sprintf('%.2f', fileSizeOut) 'KB']);
    
    %压缩比,psnr,ssim显示模块---显示在text7中%
    global Y;
    psnrV = psnr(X, Y);
    ssimV = ssim(X, Y);
    global fileSizeIn;
    text7content = ['压缩比：' sprintf('%.2f', fileSizeIn / fileSizeOut) [' : 1']]
    text7content = [text7content char(13,10)' 'PSNR：' sprintf('%.2f', psnrV) ['dB']];
    text7content = [text7content char(13,10)' 'SSIM：' sprintf('%.2f', ssimV)];
    set(handles.text7, 'vis', 'on');
    set(handles.text7, 'string', text7content);
    
    set(handles.text6, 'string', ['进度条：完成']);
end

% ---选择级数
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
