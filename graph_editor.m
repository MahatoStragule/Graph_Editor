function graph_editor(edgeNumber)
if size(edgeNumber) > 1 %if edgeNumber is Adjacency Matrix or Graph Laplacian
    [n,m] = size(edgeNumber);
    if n ~= m || (max(abs(sum(edgeNumber,2)))~=0 && max(abs(diag(edgeNumber))) ~= 0)
        display('Error:this is an unsupported matrix');
        return
    end
    datamatrix = edgeNumber;
    edgeNumber = n;
    flag_data2graph = 1;
else %if edgeNumber is the number of edges
    flag_data2graph = 0;
end

%figure setting
scrsz = get(groot,'ScreenSize');
handles = struct;
handles.fig = figure();
handles.fig.Tag = 'Made with Graph Editor';
%handles.fig.Position = [1 scrsz(4) scrsz(3)/2 scrsz(4)/2];
handles.fig.Position = [scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2];
handles.fig.InvertHardcopy = 'off';
set(handles.fig,'NumberTitle','off','Name','MATLAB Graph Editor',...
    'ToolBar','none','MenuBar','none');
handles.fig.Color = 'w';
handles.fig.CloseRequestFcn = {@graph_delete,handles}; %defined at 'graph_delete.m'
handles.fig.Renderer = 'painters';
handles.axes = gca;
axis([-5 5 -5 5]);
axis square;
handles.axes.XTick = [-5 -4 -3 -2 -1 0 1 2 3 4 5];
handles.axes.Box = 'on';
handles.axes.Clipping = 'off';
handles.axes.Visible = 'off';

%variables setting
handles.NodeNumber = edgeNumber;
handles.GraphLaplacian = zeros(handles.NodeNumber);
handles.ClickMode = 'normal';
handles.savePlace = '';
handles.Clear = 0;
handles.WeightVisible = 'off';
handles.EdgeColorAll = {'k';'Black'};
handles.EdgeStyleAll = {'-';'Solid(''-'')'};
handles.EdgeWidthAll = {1.5;'Normal(1.5)'};
handles.WeightFontSizeAll = {10;'Normal(10)'};
setappdata(handles.fig,'handles',handles);

menubar_callback_setting(handles.fig); %defined at 'menubar_callback_setting.m'
initialsetNode(edgeNumber,handles.fig); %defined at 'initialsetNode.m'

if flag_data2graph == 1
    data2graph(datamatrix,handles.fig);
end
end