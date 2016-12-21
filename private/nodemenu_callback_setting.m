function nodemenu_callback_setting(handles,i)

cmenu = uicontextmenu;
cmenu2 = uicontextmenu;

set(handles.RecMat(i),'UIContextMenu',cmenu);
set(handles.NodeNumberText(i),'UIContextMenu',cmenu2);

topmenu1 = uimenu(cmenu,'Label','Color','Tag','menu_RecColor');
uimenu('Parent',topmenu1,'Label','Black','Callback',{@recColor,handles.fig,i},'Checked','on');
uimenu('Parent',topmenu1,'Label','Red','Callback',{@recColor,handles.fig,i});
uimenu('Parent',topmenu1,'Label','Green','Callback',{@recColor,handles.fig,i});
uimenu('Parent',topmenu1,'Label','Blue','Callback',{@recColor,handles.fig,i});
uimenu('Parent',topmenu1,'Label','Custom','Callback',{@recColor,handles.fig,i});

topmenu2 = uimenu(cmenu,'Label','LineWidth','Tag','menu_RecWidth');
uimenu('Parent',topmenu2,'Label','Thick(2)','Callback',{@recWidth,handles.fig,i});
uimenu('Parent',topmenu2,'Label','Normal(1)','Callback',{@recWidth,handles.fig,i},'Checked','on');
uimenu('Parent',topmenu2,'Label','Thin(0.5)','Callback',{@recWidth,handles.fig,i});
uimenu('Parent',topmenu2,'Label','Custom','Callback',{@recWidth,handles.fig,i});

topmenu3 = uimenu(cmenu,'Label','Size','Tag','menu_RecSize');
uimenu('Parent',topmenu3,'Label','Big(8)','Callback',{@recSize,handles.fig,i});
uimenu('Parent',topmenu3,'Label','Normal(5)','Checked','on','Callback',{@recSize,handles.fig,i});
uimenu('Parent',topmenu3,'Label','Small(2)','Callback',{@recSize,handles.fig,i});
uimenu('Parent',topmenu3,'Label','Custom','Callback',{@recSize,handles.fig,i});

uimenu(cmenu2,'Label','Edit','Callback',{@nameEditCallback,handles.fig,i});

topmenu4 = uimenu(cmenu2,'Label','FontSize','Tag','menu_NameFontSize');
uimenu(topmenu4,'Label','Big(20)','Callback',{@nameFontsizeCallback,handles.fig,i});
uimenu(topmenu4,'Label','Normal(16)','Checked','on','Callback',{@nameFontsizeCallback,handles.fig,i});
uimenu(topmenu4,'Label','Small(12)','Callback',{@nameFontsizeCallback,handles.fig,i});
uimenu(topmenu4,'Label','Custom','Callback',{@nameFontsizeCallback,handles.fig,i});    


%///////////////////////////////////////%
%           Node setting                %
    function recColor(source,~,fig,recnumber)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Black'
                color = 'k';
            case 'Red'
                color = 'r';
            case 'Green'
                color = 'g';
            case 'Blue'
                color = 'b';
            case 'Custom'
                custom_data = inputdlg('RGB(0:255):','Node Color setting',[1 20],{'[0 0 0]'});
                [val,status] = str2num(custom_data{1});
                while ~status || length(val) ~= 3 || min(val) < 0 || max(val) > 255
                    custom_data = inputdlg('RGB(0:255):','Node Color setting',[1 20],{'[0 0 0]'});
                    [val,status] = str2num(custom_data{1});
                end
                color = round(val)/255;
        end
        set(tmp_handles.RecMat(recnumber),'EdgeColor',color);
        set(tmp_handles.NodeNumberText(recnumber),'Color',color);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        setappdata(fig,'handles',tmp_handles);
    end

    function recWidth(source,~,fig,recnumber)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Thick(2)'
                width = 2;
            case 'Normal(1)'
                width = 1;
            case 'Thin(0.5)'
                width = 0.5;
            case 'Custom'
                custom_data = inputdlg('LineWidth:','Node LineWidth setting',[1 10],{'1.0'});
                width = str2double(custom_data{1});
                while isnan(width) || min(width) <= 0
                    custom_data = inputdlg('LineWidth:','Node LineWidth setting',[1 10],{'1.0'});
                    width = str2double(custom_data{1});
                end
        end
        set(tmp_handles.RecMat(recnumber),'LineWidth',width);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        setappdata(fig,'handles',tmp_handles);
    end

    function recSize(source,~,fig,recnumber)
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Big(8)'
                size = 0.8;
            case 'Normal(5)'
                size = 0.5;
            case 'Small(2)' 
                size = 0.2;
            case 'Custom'
                custom_data = inputdlg('Size:','Node Size setting',[1 10],{'5'});
                size = str2double(custom_data{1});
                while isnan(size) || min(size) <= 0
                    custom_data = inputdlg('Size:','Node Size setting',[1 10],{'5'});
                    size = str2double(custom_data{1});
                end
                size = size/10;
        end
        tmp_pos = get(tmp_handles.RecMat(recnumber),'Position');
        tmp_size = tmp_pos(3);
        set(tmp_handles.RecMat(recnumber),'Position',[tmp_pos(1)+(tmp_size-size)/2 tmp_pos(2)+(tmp_size-size)/2 size size]);
        set(tmp_handles.NodeNumberText(recnumber),'Position',name_displace(fig,recnumber,tmp_size,size));
        tmp_handles.NodeSize(recnumber) = size*10;
        setappdata(fig,'handles',tmp_handles)
        if ~isempty(find(tmp_handles.EdgeMat~=0,1))
            replaceArrow(tmp_handles,recnumber,tmp_size/2,size/2);
        end
    end

%///////////////////////////////////%
%           Node Name setting       %
    function nameEditCallback(source,~,fig,number)
        tmp_handles = getappdata(fig,'handles');
        set(tmp_handles.NodeNumberText(number),'Editing','on');
        setappdata(fig,'handles',tmp_handles);
    end

    function nameFontsizeCallback(source,~,fig,number)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Big(20)'
                fontsize = 20;
            case 'Normal(16)'
                fontsize = 16;
            case 'Small(12)'
                fontsize = 12;
            case 'Custom'
                custom_data = inputdlg('Fontsize:','Fontsize setting',[1 10],{'16'});
                fontsize = str2double(custom_data{1});
                if isnan(fontsize) || min(fontsize) <= 0
                    return
                end
        end
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        set(tmp_handles.NodeNumberText(number),'FontSize',fontsize);
    end
end