function recBDCallback(hObject,~,fig,number)
%clicked nodes

handles = getappdata(fig,'handles');
rec = handles.RecMat(number);

if strcmp(fig.SelectionType,'extend') %Shift + click
    recPos = get(handles.RecMat(number),'Position');
    textPos = get(handles.NodeNumberText(number),'Position');
    vec = [textPos(1)-(recPos(1)+recPos(3)/2) textPos(2)-(recPos(2)+recPos(4)/2)];
    fig.WindowButtonMotionFcn = {@recBMCallback,number,vec}; %defined at 'recBMCallback.m'
    fig.WindowButtonUpFcn = {@recBUCallback,number}; %defined at 'recBUCallback.m'     
    setappdata(fig,'handles',handles);
    return
end

if strcmp(fig.SelectionType,'open') %double click
    if  strcmp(hObject.Type,'text') %node name is clicked
        %set(handles.NodeNumberText(number),'Editing','on');
        set(handles.NodeNumberText(number),'EdgeColor','k','PickableParts','visible',...
            'ButtonDownFcn',{@textBDCallback,handles.fig});
        set(fig,'WindowButtonDownFcn',{@text_figBDCallback,number},'WindowScrollWheelFcn',{@text_figSWCallback,number});
        set(handles.RecMat,'PickableParts','none');
        set(handles.EdgeMat(handles.EdgeMat~=0),'PickableParts','none');
        set(rec,'LineStyle','-');
        handles.ArrowStart = 0;
        handles.Clickmode = 'Text';
        setappdata(fig,'handles',handles);
        return
    end
end

if ~strcmp(handles.fig.SelectionType,'normal')
    return
end

if handles.ArrowStart == 0 %if start-node-selection
    if strcmp(handles.ClickMode,'normal')
        %set(rec,'EdgeColor','r');
        set(rec,'LineStyle',':');
        handles.ArrowStart = number;
        handles.ClickMode = 'Node';
        set(fig,'WindowButtonDownFcn',{@reccancelBDCallback,rec},'WindowScrollWheelFcn',{@recSWCallback,rec,number});
    end
elseif handles.ArrowStart == number %if start-node is cliked again
    %set(rec,'EdgeColor','k');
    set(rec,'LineStyle','-');
    handles.ArrowStart = 0;
    handles.ClickMode = 'normal';
    set(fig,'WindowButtonDownFcn','','WindowScrollWheelFcn','');
else %if end-node-selection
    set(fig,'WindowButtonDownFcn','','WindowScrollWheelFcn','');
    RecMat = handles.RecMat;
    ArrowStart = handles.ArrowStart;
    
    if handles.EdgeMat(number,ArrowStart) == 0 %if there is no edge from start node to end node
        %create edge
        %all callback functions are defined in this file
        cmenu = uicontextmenu;
        cmenu2 = uicontextmenu;
        [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,ArrowStart,number,'Normal'); %defined at 'arrow_position.m'
        mainline = line(line_data(1,:),line_data(2,:));
        arrowline1 = line(arrow1_data(1,:),arrow1_data(2,:));
        arrowline2 = line(arrow2_data(1,:),arrow2_data(2,:));
        set(mainline,'Color',handles.EdgeColorAll{1},'LineStyle',handles.EdgeStyleAll{1},'LineWidth',1.5,'Parent',handles.axes,...
                'UIContextMenu',cmenu,'Tag',['Edge' num2str(number) ',' num2str(ArrowStart)]);
        set(arrowline1,'Color',handles.EdgeColorAll{1},'LineWidth',1.5,'Parent',handles.axes,...
            'Tag',['Arrow1' num2str(number) ',' num2str(ArrowStart)]);
        set(arrowline2,'Color',handles.EdgeColorAll{1},'LineWidth',1.5,'Parent',handles.axes,...
            'Tag',['Arrow2' num2str(number) ',' num2str(ArrowStart)]);
        weighttext = text(weight_data(1),weight_data(2),'1','Color',handles.EdgeColorAll{1},'FontSize',handles.WeightFontSizeAll{1},...
            'HorizontalAlignment','center','Visible',handles.WeightVisible,...
            'ButtonDownFcn',{@weightBDCallback,handles.fig},'UIContextMenu',cmenu2,...
            'Tag',['Weight' num2str(number) ',' num2str(ArrowStart)]);
        if strcmp(handles.WeightVisible,'on') %if edges have weights
            set(weighttext,'Editing','on');
        end
        handles.EdgeMat(number,ArrowStart) = mainline;
        handles.Arrow1Mat(number,ArrowStart) = arrowline1;
        handles.Arrow2Mat(number,ArrowStart) = arrowline2;
        handles.WeightMat(number,ArrowStart) = weighttext;
        if handles.EdgeMat(ArrowStart,number) ~= 0
            %if there is already edge from end node to start node, 
            %then edges between them must be displaced 
            [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,number,ArrowStart,'Displace');
            set(handles.EdgeMat(ArrowStart,number),'XData',line_data(1,:),'YData',line_data(2,:));
            set(handles.Arrow1Mat(ArrowStart,number),'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
            set(handles.Arrow2Mat(ArrowStart,number),'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
            set(handles.WeightMat(ArrowStart,number),'Position',weight_data);
            [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,ArrowStart,number,'Displace');
            set(handles.EdgeMat(number,ArrowStart),'XData',line_data(1,:),'YData',line_data(2,:));
            set(handles.Arrow1Mat(number,ArrowStart),'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
            set(handles.Arrow2Mat(number,ArrowStart),'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
            set(handles.WeightMat(number,ArrowStart),'Position',weight_data);
        end
        %right-click-menu setting
        uimenu(cmenu,'Label','Delete','Callback',{@linemenu,handles.fig,mainline});
        topmenu = uimenu(cmenu,'Label','Color','Tag','menu_EdgeColor');
        uimenu('Parent',topmenu,'Label','Black','Callback',{@linecolor,handles.fig,mainline});
        uimenu('Parent',topmenu,'Label','Red','Callback',{@linecolor,handles.fig,mainline});
        uimenu('Parent',topmenu,'Label','Green','Callback',{@linecolor,handles.fig,mainline});
        uimenu('Parent',topmenu,'Label','Blue','Callback',{@linecolor,handles.fig,mainline});
        uimenu('Parent',topmenu,'Label','Custom','Callback',{@linecolor,handles.fig,mainline});
        set(findobj(topmenu.Children,'Label',handles.EdgeColorAll{2}),'Checked','on');
        topmenu2 = uimenu(cmenu,'Label','Style','Tag','menu_EdgeStyle');
        uimenu('Parent',topmenu2,'Label','Solid(''-'')','Callback',{@linestyle,handles.fig,mainline});
        uimenu('Parent',topmenu2,'Label','Dashed(''--'')','Callback',{@linestyle,handles.fig,mainline});
        uimenu('Parent',topmenu2,'Label','Dotted('':'')','Callback',{@linestyle,handles.fig,mainline});
        uimenu('Parent',topmenu2,'Label','Dashed and Dotted(''-.'')','Callback',{@linestyle,handles.fig,mainline});
        set(findobj(topmenu2.Children,'Label',handles.EdgeStyleAll{2}),'Checked','on');
        topmenu3 = uimenu(cmenu,'Label','Width','Tag','menu_EdgeWidth');
        uimenu('Parent',topmenu3,'Label','Thick(2.5)','Callback',{@linewidth,handles.fig,mainline});
        uimenu('Parent',topmenu3,'Label','Normal(1.5)','Callback',{@linewidth,handles.fig,mainline},'Checked','on');
        uimenu('Parent',topmenu3,'Label','Thin(0.5)','Callback',{@linewidth,handles.fig,mainline});
        uimenu('Parent',topmenu3,'Label','Custom','Callback',{@linewidth,handles.fig,mainline});
        
        uimenu(cmenu2,'Label','Edit','Callback',{@weightedit,handles.fig,weighttext});
        topmenu4 = uimenu(cmenu2,'Label','Fontsize','Tag','menu_WeightFontSize');
        uimenu(topmenu4,'Label','Big(12)','Callback',{@weightFontSize,handles.fig,weighttext});
        uimenu(topmenu4,'Label','Normal(10)','Checked','on','Callback',{@weightFontSize,handles.fig,weighttext});
        uimenu(topmenu4,'Label','Small(8)','Callback',{@weightFontSize,handles.fig,weighttext});
        uimenu(topmenu4,'Label','Custom','Callback',{@weightFontSize,handles.fig,weighttext});
        
        handles.GraphLaplacian(number,ArrowStart) = -1;
        handles.GraphLaplacian(number,number) = handles.GraphLaplacian(number,number) + 1;
    else %if there is already a edge from start node to end node 
        delete(handles.EdgeMat(number,ArrowStart));
        delete(handles.Arrow1Mat(number,ArrowStart));
        delete(handles.Arrow2Mat(number,ArrowStart));
        delete(handles.WeightMat(number,ArrowStart));
        handles.EdgeMat(number,ArrowStart) = 0;
        handles.Arrow1Mat(number,ArrowStart) = 0;
        handles.Arrow2Mat(number,ArrowStart) = 0;
        handles.WeightMat(number,ArrowStart) = 0;
        handles.GraphLaplacian(number,ArrowStart) = 0;
        handles.GraphLaplacian(number,number) = handles.GraphLaplacian(number,number) - 1;
        if handles.EdgeMat(ArrowStart,number) ~= 0
            %return displaced edge to normal position
            [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,number,ArrowStart,'Normal');
            set(handles.EdgeMat(ArrowStart,number),'XData',line_data(1,:),'YData',line_data(2,:));
            set(handles.Arrow1Mat(ArrowStart,number),'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
            set(handles.Arrow2Mat(ArrowStart,number),'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
            set(handles.WeightMat(ArrowStart,number),'Position',weight_data);
        end
    end
    set(RecMat(ArrowStart),'LineStyle','-');
    handles.ArrowStart = 0;
    handles.ClickMode = 'normal';
end
setappdata(fig,'handles',handles);


%///////////////////////////////%
%           Node Callback       %
    function reccancelBDCallback(fig,~,obj) %node is clicked again
        tmp_handles = getappdata(fig,'handles');
        if ~strcmp(fig.CurrentObject.Type,'rectangle')
            set(fig,'WindowButtonDownFcn','','WindowScrollWheelFcn','');
            set(obj,'LineStyle','-');
            tmp_handles.ClickMode = 'normal';
            tmp_handles.ArrowStart = 0;
        end
        setappdata(fig,'handles',tmp_handles);
    end

    function recSWCallback(fig,data,obj,number) %chenge node-size with mouse wheel
        tmp_handles = getappdata(fig,'handles');
        tmp_pos = get(obj,'Position');
        tmp_size = tmp_pos(3);
        size = max(0.1,tmp_size - data.VerticalScrollCount/10);
        set(obj,'Position',[tmp_pos(1)+(tmp_size-size)/2 tmp_pos(2)+(tmp_size-size)/2 size size]);
        set(tmp_handles.NodeNumberText(number),'Position',name_displace(fig,number,tmp_size,size));
        tmp_handles.NodeSize(number) = size*10;
        setappdata(fig,'handles',tmp_handles)
        if ~isempty(find(tmp_handles.EdgeMat~=0,1))
            replaceArrow(tmp_handles,number,tmp_size/2,size/2);
        end
        menu_size = findobj(get(get(obj,'UIContextMenu'),'Children'),'Label','Size');
        set(get(menu_size,'Children'),'Checked','off');
        size_custom = findobj(get(menu_size,'Children'),'Label','Custom');
        size_custom.Checked = 'on';        
    end

    function text_figSWCallback(fig,data,number) %change node name's fontsize with mouse wheel
        tmp_handles = getappdata(fig,'handles');
        tmp_fontsize = get(tmp_handles.NodeNumberText(number),'FontSize');
        set(tmp_handles.NodeNumberText(number),'FontSize',tmp_fontsize-data.VerticalScrollCount);
        setappdata(fig,'handles',tmp_handles);
    end
    function text_figBDCallback(fig,~,number) %cancel text-selection
        tmp_handles = getappdata(fig,'handles');
        if strcmp(fig.SelectionType,'normal') && (fig.CurrentObject == fig)
            set(tmp_handles.NodeNumberText,'EdgeColor','none','ButtonDownFcn',{@recBDCallback,fig,number});
            set(tmp_handles.RecMat,'PickableParts','visible');
            set(tmp_handles.EdgeMat(tmp_handles.EdgeMat~=0),'PickableParts','visible');
            set(tmp_handles.RecMat,'LineStyle','-');
            tmp_handles.ArrowStart = 0;
            tmp_handles.Clickmode = 'normal';
            setappdata(fig,'handles',tmp_handles);
        else
        end
    end
    function textBDCallback(hObject,~,fig) %node name is clicked
        switch get(fig,'SelectionType')
            case 'open' %double click
                set(hObject,'Editing','on'); %edit node name
            case 'normal' %normal click
                set(fig,'WindowButtonMotionFcn',{@textBMCallback,hObject});
                set(fig,'WindowButtonUpFcn',{@textBUCallback});
        end
        setappdata(fig,'handles',tmp_handles);
        
        function textBMCallback(fig,~,obj) %move node name
            tmp_handles = getappdata(fig,'handles');
            cp = tmp_handles.axes.CurrentPoint;
            set(obj,'Position',[cp(1,1) cp(1,2) 0]);
            setappdata(fig,'handles',tmp_handles);
        end
        function textBUCallback(fig,~) %finish moving node name
            set(fig,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
        end
    end

    function weightBDCallback(hObject,~,fig) %edit weight
        if strcmp(fig.SelectionType,'normal')
            set(fig,'WindowButtonMotionFcn',{@weightBMCallback,hObject},...
            'WindowButtonUpFcn',{@weightBUCallback,hObject});
        elseif strcmp(fig.SelectionType,'open')
            hObject.Editing = 'on';
        end
    end

%///////////////////////////////%
%           Edge setting        %
    function linemenu(source,~,fig,linehandle)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Delete'
                [tmp_ArrowEnd,tmp_ArrowStart] = find(tmp_handles.EdgeMat == double(linehandle),1);
                delete(linehandle);
                delete(tmp_handles.Arrow1Mat(tmp_ArrowEnd,tmp_ArrowStart));
                delete(tmp_handles.Arrow2Mat(tmp_ArrowEnd,tmp_ArrowStart));
                delete(tmp_handles.WeightMat(tmp_ArrowEnd,tmp_ArrowStart));
                tmp_handles.EdgeMat(tmp_ArrowEnd,tmp_ArrowStart) = 0;
                tmp_handles.Arrow1Mat(tmp_ArrowEnd,tmp_ArrowStart) = 0;
                tmp_handles.Arrow2Mat(tmp_ArrowEnd,tmp_ArrowStart) = 0;
                tmp_handles.WeightMat(tmp_ArrowEnd,tmp_ArrowStart) = 0;
                tmp_handles.GraphLaplacian(tmp_ArrowEnd,tmp_ArrowEnd) = tmp_handles.GraphLaplacian(tmp_ArrowEnd,tmp_ArrowEnd) - 1;
                tmp_handles.GraphLaplacian(tmp_ArrowEnd,tmp_ArrowStart) = 0;
                if tmp_handles.EdgeMat(tmp_ArrowStart,tmp_ArrowEnd) ~= 0
                    [tmp_line_data, tmp_arrow1_data, tmp_arrow2_data, tmp_weight_data] = arrow_position(tmp_handles,tmp_ArrowEnd,tmp_ArrowStart,'Normal');
                    set(tmp_handles.EdgeMat(tmp_ArrowStart,tmp_ArrowEnd),'XData',tmp_line_data(1,:),'YData',tmp_line_data(2,:));
                    set(tmp_handles.Arrow1Mat(tmp_ArrowStart,tmp_ArrowEnd),'XData',tmp_arrow1_data(1,:),'YData',tmp_arrow1_data(2,:));
                    set(tmp_handles.Arrow2Mat(tmp_ArrowStart,tmp_ArrowEnd),'XData',tmp_arrow2_data(1,:),'YData',tmp_arrow2_data(2,:));
                    set(tmp_handles.WeightMat(tmp_ArrowStart,tmp_ArrowEnd),'Position',tmp_weight_data);
                end
        end
        setappdata(fig,'handles',tmp_handles);
    end

    function linecolor(source,~,fig,linehandle)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat == double(linehandle));
        switch source.Label
            case 'Black'
                set(tmp_handles.EdgeMat(ind),'Color','k');
                set(tmp_handles.Arrow1Mat(ind),'Color','k');
                set(tmp_handles.Arrow2Mat(ind),'Color','k');
                set(tmp_handles.WeightMat(ind),'Color','k');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Red'
                set(tmp_handles.EdgeMat(ind),'Color','r');
                set(tmp_handles.Arrow1Mat(ind),'Color','r');
                set(tmp_handles.Arrow2Mat(ind),'Color','r');
                set(tmp_handles.WeightMat(ind),'Color','r');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Green'
                set(tmp_handles.EdgeMat(ind),'Color','g');
                set(tmp_handles.Arrow1Mat(ind),'Color','g');
                set(tmp_handles.Arrow2Mat(ind),'Color','g');
                set(tmp_handles.WeightMat(ind),'Color','g');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Blue'
                set(tmp_handles.EdgeMat(ind),'Color','b');
                set(tmp_handles.Arrow1Mat(ind),'Color','b');
                set(tmp_handles.Arrow2Mat(ind),'Color','b');
                set(tmp_handles.WeightMat(ind),'Color','b');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Custom'
                custom_data = inputdlg('RGB(0:255):','Node Color setting',[1 20],{'[0 0 0]'});
                [val,status] = str2num(custom_data{1});
                if ~status || length(val) ~= 3 || min(val) < 0 || max(val) > 255
                    return
                end
                color = round(val)/255;
                set(tmp_handles.EdgeMat(ind),'Color',color);
                set(tmp_handles.Arrow1Mat(ind),'Color',color);
                set(tmp_handles.Arrow2Mat(ind),'Color',color);
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
        end
        %guidata(tmp_handles.output,tmp_handles);
        setappdata(fig,'handles',tmp_handles);
    end

    function linestyle(source,~,fig,linehandle)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat == double(linehandle));
        switch source.Label
            case 'Solid(''-'')'
                set(tmp_handles.EdgeMat(ind),'LineStyle','-');
                %set(tmp_handles.Arrow1Mat(ind),'LineStyle','-');
                %set(tmp_handles.Arrow2Mat(ind),'LineStyle','-');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Dashed(''--'')'
                set(tmp_handles.EdgeMat(ind),'LineStyle','--');
                %set(tmp_handles.Arrow1Mat(ind),'LineStyle','--');
                %set(tmp_handles.Arrow2Mat(ind),'LineStyle','--');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Dotted('':'')'
                set(tmp_handles.EdgeMat(ind),'LineStyle',':');
                %set(tmp_handles.Arrow1Mat(ind),'LineStyle',':');
                %set(tmp_handles.Arrow2Mat(ind),'LineStyle',':');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Dashed and Dotted(''-.'')'
                set(tmp_handles.EdgeMat(ind),'LineStyle','-.');
                %set(tmp_handles.Arrow1Mat(ind),'LineStyle','-.');
                %set(tmp_handles.Arrow2Mat(ind),'LineStyle','-.');
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
        end
        %guidata(tmp_handles.output,tmp_handles);
        setappdata(fig,'handles',tmp_handles);
    end

    function linewidth(source,~,fig,linehandle)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat == double(linehandle));
        switch source.Label
            case 'Thick(2.5)'
                set(tmp_handles.EdgeMat(ind),'LineWidth',2.5);
                set(tmp_handles.Arrow1Mat(ind),'LineWidth',2.5);
                set(tmp_handles.Arrow2Mat(ind),'LineWidth',2.5);
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Normal(1.5)'
                set(tmp_handles.EdgeMat(ind),'LineWidth',1.5);
                set(tmp_handles.Arrow1Mat(ind),'LineWidth',1.5);
                set(tmp_handles.Arrow2Mat(ind),'LineWidth',1.5);
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Thin(0.5)'
                set(tmp_handles.EdgeMat(ind),'LineWidth',0.5);
                set(tmp_handles.Arrow1Mat(ind),'LineWidth',0.5);
                set(tmp_handles.Arrow2Mat(ind),'LineWidth',0.5);
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
            case 'Custom'
                custom_data = inputdlg('LineWidth:','LineWidth setting',[1 10],{'1.5'});
                val = str2double(custom_data{1});
                if isnan(val) || min(val) <= 0
                    return
                end
                set(tmp_handles.EdgeMat(ind),'LineWidth',val);
                set(tmp_handles.Arrow1Mat(ind),'LineWidth',val);
                set(tmp_handles.Arrow2Mat(ind),'LineWidth',val);
                set(source.Parent.Children,'Checked','off');
                source.Checked = 'on';
        end
        setappdata(fig,'handles',tmp_handles);
    end

%///////////////////////////////%
%           Weight setting      %
    function weightedit(~,~,fig,hObject)
        hObject.Editing = 'on';
    end

    function weightFontSize(source,~,fig,hObject)
        switch source.Label
            case 'Big(12)'
                fontsize = 12;
            case 'Normal(10)'
                fontsize = 10;
            case 'Small(8)'
                fontsize = 8;
            case 'Custom'
                custom_data = inputdlg('Fontsize:','Fontsize setting',[1 10],{'10'});
                fontsize = str2double(custom_data{1});
                if isnan(fontsize) || min(fontsize) <= 0
                    return
                end
        end
        set(hObject,'FontSize',fontsize);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
     end
end
