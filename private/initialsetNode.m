function initialsetNode(number,fig)
%create nodes and define their callback functions

handles = getappdata(fig,'handles');
handles.RecMat = zeros(1,number);
handles.NodeNumberText = zeros(1,number);
handles.NamePosition = 2*ones(1,number);
ns = 5;
handles.NodeSize = ns*ones(1,number);
cmenu = zeros(1,number);
cmenu2 = cmenu;
for i = 1:number
    cmenu(i) = uicontextmenu; %create right-click-menu of each node
    cmenu2(i) = uicontextmenu;
    theta = pi/2-(i-1)*2*pi/number; %the angle between 2 nodes
    pos = [3*cos(theta)-ns/10/2,3*sin(theta)-ns/10/2];
    handles.RecMat(i) = rectangle('Position',[pos(1) pos(2) ns/10 ns/10],'FaceColor','w','Curvature',1,'LineWidth',1,...
        'ButtonDownFcn',{@recBDCallback,handles.fig,i},'Parent',handles.axes,...
        'Tag',['Rec' num2str(i)]); %defined at 'recBDCallback.m'
    handles.NodeNumberText(i) = text(pos(1)+ns/10/2+0.6*cos(theta),pos(2)+ns/10/2+0.6*sin(theta),num2str(i),'FontSize',16,'HorizontalAlignment','center',...
        'ButtonDownFcn',{@textBDCallback,handles.fig,i},'Parent',handles.axes,...
        'Tag',['Name' num2str(i)]);
    nodemenu_callback_setting(handles,i); %defined at 'nodemenu_callback_setting.m'
end
handles.EdgeNumber = 0;
handles.GraphLaplacian = zeros(number);
handles.GraphMat = zeros(number);
handles.NodeNumber = number;
handles.ArrowStart = 0;
handles.EdgeMat = zeros(number,number);
handles.Arrow1Mat = zeros(number,number);
handles.Arrow2Mat = zeros(number,number);
handles.WeightMat = zeros(number,number);
handles.radius = 3;
setappdata(fig,'handles',handles);

%///////////////////////////////%
%       Callback function       %
%///////////////////////////////%

%///////////////////////////////%
%       Node Text Callback      %
    function textBDCallback(hObject,~,fig,number)
        tmp_handles = getappdata(fig,'handles');
        if ~strcmp(tmp_handles.ClickMode,'normal') || ~strcmp(fig.SelectionType,'normal')
            return
        end
        tmp_handles.ArrowStart = 0;
        tmp_handles.Clickmode = 'Text';
        set(tmp_handles.RecMat(number),'LineStyle','-');
        set(hObject,'EdgeColor','k');
        set(fig,'WindowButtonMotionFcn',{@textBMCallback,hObject,number});
        set(fig,'WindowButtonUpFcn',{@textBUCallback,hObject,number});
        setappdata(fig,'handles',tmp_handles)
    end
    function textmodeBDCallback(hObject,~,fig,number) %text-selection mode
        if strcmp(fig.SelectionType,'open')
            hObject.Editing = 'on';
        elseif strcmp(fig.SelectionType,'normal')
            textBDCallback(hObject,0,fig,number);
        end
    end
    function textBMCallback(fig,~,obj,number) %move text
        tmp_handles = getappdata(fig,'handles');
        cp = tmp_handles.axes.CurrentPoint;
        set(obj,'Position',[cp(1,1) cp(1,2) 0],'Edge','none');
        setappdata(fig,'handles',tmp_handles);
    end
    function textBUCallback(fig,~,obj,number) %change to text-selection
        set(obj,'EdgeColor','k','ButtonDownFcn',{@textmodeBDCallback,fig,number});
        set(fig,'WindowButtonDownFcn',{@textcancelBDCallback,obj,number},'WindowButtonMotionFcn','',...
            'WindowButtonUpFcn','','WindowScrollWheelFcn',{@textSWCallback,number});
        function textSWCallback(fig,data,number) %chenge fontsize with mouse wheel
            tmp_handles = getappdata(fig,'handles');
            tmp_fontsize = get(tmp_handles.NodeNumberText(number),'FontSize');
            set(tmp_handles.NodeNumberText(number),'FontSize',max(tmp_fontsize-data.VerticalScrollCount,1));
            uicmenu = get(tmp_handles.NodeNumberText(number),'UIContextMenu');
            fontsize = findobj(uicmenu,'Label','FontSize');
            fontsize_custom = findobj(fontsize,'Label','Custom');
            set(get(fontsize,'Children'),'Checked','off');
            fontsize_custom.Checked = 'on';
        end
    end
    function textcancelBDCallback(fig,~,obj,number) %cancel text-selection
        tmp_handles = getappdata(fig,'handles');
        if fig.CurrentObject ~= obj
            set(fig,'WindowButtonDownFcn','','WindowScrollWheelFcn','');
            set(obj,'EdgeColor','none','ButtonDownFcn',{@textBDCallback,fig,number});
            tmp_handles.ClickMode = 'normal';
        end
        setappdata(fig,'handles',tmp_handles);
    end
end