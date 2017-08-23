%{
%离散余弦变换（DCT）与小波变换（DWT）的性能比较
%将图像分别经过两种变换后，保留生成的低频系数的1/4，其他3/4置0，
%再进行相应的逆变换恢复图像，比较低频系数1/4的能量占总能量的比例，
%以及经过处理的后图像与原图的峰值信噪比（PSNR），结构相似性(SSIM)
%}
function varargout = dct_vs_dwt(varargin)
% DCT_VS_DWT MATLAB code for dct_vs_dwt.fig
%      DCT_VS_DWT, by itself, creates a new DCT_VS_DWT or raises the existing
%      singleton*.
%
%      H = DCT_VS_DWT returns the handle to a new DCT_VS_DWT or the handle to
%      the existing singleton*.
%
%      DCT_VS_DWT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCT_VS_DWT.M with the given input arguments.
%
%      DCT_VS_DWT('Property','Value',...) creates a new DCT_VS_DWT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dct_vs_dwt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dct_vs_dwt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dct_vs_dwt

% Last Modified by GUIDE v2.5 22-Jan-2017 14:45:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dct_vs_dwt_OpeningFcn, ...
                   'gui_OutputFcn',  @dct_vs_dwt_OutputFcn, ...
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

% --- Executes just before dct_vs_dwt is made visible.
function dct_vs_dwt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dct_vs_dwt (see VARARGIN)

% Choose default command line output for dct_vs_dwt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dct_vs_dwt wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%初始化时用于显示图片的三个坐标轴设为不可见
set(handles.axes1, 'vis', 'off');
set(handles.axes2, 'vis', 'off');
set(handles.axes3, 'vis', 'off');

%表格设为不可见
set(handles.uitable1, 'vis', 'off');

end

% --- Outputs from this function are returned to the command line.
function varargout = dct_vs_dwt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% “打开图像”按钮的回调函数
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

%如果未选择图片则中断，不加这个判断时如果未选择图片后面执行下去会报错
if isequal(filename,0) | isequal(pathname,0)
    return
end

%读取图片并显示
X = imread([pathname filename]);
if numel(size(X))> 2
    X=rgb2gray(X);%如果是彩色的转成灰度图
end
axes(handles.axes1);%这句是定位到对应的坐标轴
imshow(X);
title('原图');

sizeX = size(X);
sizeTarget = size(X);
%取原图像矩阵的四分一
switch nnz(sizeTarget)
    case 2
        sizeTarget = sizeTarget .* [0.5 0.5];
    case 3
        sizeTarget = sizeTarget .* [0.5 0.5 1];
    otherwise
        %报错
end
%注意这里不能用uint8，范围太小
uint16(sizeTarget);


%dct变换统一处理版本%
cDct = dct2(X);
cDctBak = cDct;
%垂直与斜线部分置0
%           矩阵行数/2   + 1 ：最后一行 ，1列：最后一列
cDct((sizeTarget(1, 1) + 1) : sizeX(1, 1), 1 : sizeX(1, 2)) = 0;
%水平部分置0
%     1 : 矩阵行数/2行    ,          矩阵列数/2+1   :最后一列
cDct(1 : sizeTarget(1, 1), (sizeTarget(1, 2) + 1) : sizeX(1, 2)) = 0;
Dct = idct2(cDct, sizeX);
Dct = uint8(Dct);
axes(handles.axes2);
imshow(Dct);
title('dct变换后复原');

%求能量比
e1 = sum(sum(abs(cDct)));
e2 = sum(sum(abs(cDctBak)));
%tableData的内容详见fig文件
tableData = zeros(3, 2);
tableData(1, 1) = e1 / e2 * 100;
tableData(2, 1) = psnr(Dct, X);
[ssimval, ssimmap] = ssim(Dct, X);
tableData(3, 1) = ssimval * 100;
%dct变换结束%

%{
%dct变换8*8分块处理版本%
fun1=@dct2;
cDct=blkproc(X, [8 8], fun1);
cDctBak = cDct;
T = zeros(8, 8);
T(1 : 4, 1 : 4) = 1;
cDct=blkproc(cDct, [8 8],'P1.*x',T);
fun2=@idct2;
Dct = blkproc(cDct, [8 8], fun2);
Dct = uint8(Dct);
axes(handles.axes2);
imshow(Dct);
title('dct变换后复原');

%求能量比
e1 = sum(sum(abs(cDct)));
e2 = sum(sum(abs(cDctBak)));
%tableData的内容详见fig文件
tableData = zeros(3, 2);
tableData(1, 1) = e1 / e2 * 100;
tableData(2, 1) = psnr(Dct, X);
[ssimval, ssimmap] = ssim(Dct, X);
tableData(3, 1) = ssimval * 100;
%dct变换结束%
%}
%dwt变换%
waveBase = 'db10';
[cDwt, sDwt] = wavedec2(X, 1, waveBase);
cDwtBak = cDwt;
%把cDwt长度1/4后面的全变成0
cDwt((sDwt(1,1) * sDwt(1,2) + 1) : length(cDwt)) = 0;
%逆变换并显示图像
Dwt = waverec2(cDwt, sDwt, waveBase);
Dwt = uint8(Dwt);
axes(handles.axes3);
imshow(Dwt);
title('小波变换后复原');

e1 = sum(abs(cDwt));
e2 = sum(abs(cDwtBak));
tableData(1, 2) = e1 / e2 * 100;
tableData(2, 2) = psnr(Dwt, X);
[ssimval, ssimmap] = ssim(Dwt, X);
tableData(3, 2) = ssimval * 100;
%dwt变换结束%

%将各项信息填入table中并显示表格
set(handles.uitable1, 'data', tableData);
set(handles.uitable1, 'vis', 'on');

end
