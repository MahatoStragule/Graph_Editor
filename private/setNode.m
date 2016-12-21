function setNode(number,fig)
handles = getappdata(fig,'handles');
if handles.NodeNumber == number
    return
end
delete(handles.RecMat);
delete(handles.NodeNumberText)
handles.RecMat = zeros(1,number);
handles.NodeNumberText = zeros(1,number);
r = ceil(number/4) + 2;
%{
figpos = handles.fig.Position;
figwidth = figpos(3)*r/handles.radius;
figheight = figpos(4)*r/handles.radius;
figpos(1) = figpos(1)-(figwidth-figpos(3))/2;
figpos(2) = figpos(2)-(figheight-figpos(4))/2;
handles.fig.Position = [figpos(1) figpos(2) figpos(3)*r/handles.radius figpos(4)*r/handles.radius];
%}
handles.radius = r;
ax = handles.fig.CurrentAxes;
ax.XLim = [-r-2 r+2];
ax.YLim = [-r-2 r+2];
cmenu = uicontextmenu;
for i = 1:number
    pos = [r*cos(pi/2+(i-1)*2*pi/number)-0.5,r*sin(pi/2+(i-1)*2*pi/number)-0.5];
    handles.RecMat(i) = rectangle('Position',[pos(1) pos(2) 1 1],'FaceColor','w','Curvature',1,'LineWidth',1,...
        'ButtonDownFcn',{@recBDCallback,handles.fig,i},'Parent',handles.axes,...
        'UIContextMenu',cmenu);
    handles.NodeNumberText(i) = text(pos(1)+0.5,pos(2)+0.5,num2str(i),'FontSize',16,'HorizontalAlignment','center',...
        'PickableParts','none','Parent',handles.axes);
end

m1 = uimenu(cmenu,'Label','Color','Callback','');

if handles.EdgeNumber == 0
    handles.GraphLaplacian = zeros(number);
    handles.GraphMat = zeros(number);
    handles.NodeNumber = number;
    guidata(handles.output,handles);
    setappdata(fig,'handles',handles);
    return
end

gl = handles.GraphLaplacian;
graphmat = handles.GraphMat;
edge = handles.Edge;
arrow1 = handles.Arrow1;
arrow2 = handles.Arrow2;
handles.GraphLaplacian = zeros(number);
handles.GraphMat = zeros(number);
handles.EdgeNumber = 0;
handles.Edge = 0;
handles.Arrow1 = 0;
handles.Arrow2 = 0;
if handles.NodeNumber < number
        for i = 1:handles.NodeNumber
            for j = 1:handles.NodeNumber
                if gl(i,j) == -1
                    n = graphmat(i,j);
                    delete(edge(n));
                    delete(arrow1(n));
                    delete(arrow2(n));
                    handles.ArrowStart = j;
                    setappdata(fig,'handles',handles);
                    recBDCallback(handles.RecMat(i),1,fig,i);
                    handles = getappdata(fig,'handles');
                end
            end
        end
else
    for i = number+1:handles.NodeNumber
        for j = 1:handles.NodeNumber
            if gl(i,j) == -1
                n = graphmat(i,j);
                delete(edge(n));
                delete(arrow1(n));
                delete(arrow2(n));
            end
        end
    end
    for i = 1:number
        for j = number+1:handles.NodeNumber
            if gl(i,j) == -1
                n = graphmat(i,j);
                delete(edge(n));
                delete(arrow1(n));
                delete(arrow2(n));
            end
        end
    end
    for i = 1:number
        for j = 1:number
            if gl(i,j) == -1
                n = graphmat(i,j);
                delete(edge(n));
                delete(arrow1(n));
                delete(arrow2(n));
                handles.ArrowStart = j;
                setappdata(fig,'handles',handles);
                recBDCallback(handles.RecMat(i),1,fig,i);
                handles = getappdata(fig,'handles');
            end
        end
    end
end
set(handles.Edge(handles.Edge~=0),'LineWidth',2);
set(handles.Arrow1(handles.Arrow1~=0),'LineWidth',2);
set(handles.Arrow2(handles.Arrow2~=0),'LineWidth',2);
handles.NodeNumber = number;
handles.ArrowStart = 0;
delete(handles.output.CurrentAxes);
guidata(handles.output,handles);
setappdata(fig,'handles',handles);