function menubar_callback_setting(fig)
%create uimenus and defined their callback functions

handles = getappdata(fig,'handles');
menu_file = uimenu(fig,'Label','File');
uimenu(menu_file,'Label','Open','Callback',{@openfigure,handles.fig},'Accelerator','O');
uimenu(menu_file,'Label','Save','Separator','on','Callback',{@savefigure,handles.fig},'Accelerator','S');
uimenu(menu_file,'Label','Save as','Callback',{@savefigure,handles.fig});
submenu_option = uimenu(menu_file,'Label','Save Option');
uimenu(submenu_option,'Label','Clear BackColor','Callback',{@saveoption,handles.fig});
submenu_export = uimenu(menu_file,'Label','Export Matrix','Separator','on');
uimenu(submenu_export,'Label','Graph Laplacian','Callback',{@export,handles.fig});
uimenu(submenu_export,'Label','Adjacency Matrix','Callback',{@export,handles.fig});
menu_edit = uimenu('Label','Edit');

uimenu(menu_edit,'Label','Weight on','Callback',{@weight_setting,handles.fig},'Accelerator','W');

submenu_nodesetting = uimenu(menu_edit,'Label','All Node setting','Separator','on');
subsubmenu_nodecolor = uimenu(submenu_nodesetting,'Label','Color');
uimenu(subsubmenu_nodecolor,'Label','Black','Checked','on','Callback',{@node_color,handles.fig});
uimenu(subsubmenu_nodecolor,'Label','Red','Callback',{@node_color,handles.fig});
uimenu(subsubmenu_nodecolor,'Label','Green','Callback',{@node_color,handles.fig});
uimenu(subsubmenu_nodecolor,'Label','Blue','Callback',{@node_color,handles.fig});
uimenu(subsubmenu_nodecolor,'Label','Custom','Callback',{@node_color,handles.fig});

subsubmenu_nodewidth = uimenu(submenu_nodesetting,'Label','LineWidth');
uimenu(subsubmenu_nodewidth,'Label','Thick(2)','Callback',{@node_width,handles.fig});
uimenu(subsubmenu_nodewidth,'Label','Normal(1)','Checked','on','Callback',{@node_width,handles.fig});
uimenu(subsubmenu_nodewidth,'Label','Thin(0.5)','Callback',{@node_width,handles.fig});
uimenu(subsubmenu_nodewidth,'Label','Custom','Callback',{@node_width,handles.fig});

subsubmenu_nodesize = uimenu(submenu_nodesetting,'Label','Size');
uimenu(subsubmenu_nodesize,'Label','Big(8)','Callback',{@node_size,handles.fig});
uimenu(subsubmenu_nodesize,'Label','Normal(5)','Callback',{@node_size,handles.fig});
uimenu(subsubmenu_nodesize,'Label','Small(2)','Callback',{@node_size,handles.fig});
uimenu(subsubmenu_nodesize,'Label','Custom','Callback',{@node_size,handles.fig});

submenu_edgesetting = uimenu(menu_edit,'Label','All Edge setting');
subsubmenu_edgecolor = uimenu(submenu_edgesetting,'Label','Color');
uimenu(subsubmenu_edgecolor,'Label','Black','Checked','on','Callback',{@edge_color,handles.fig});
uimenu(subsubmenu_edgecolor,'Label','Red','Callback',{@edge_color,handles.fig});
uimenu(subsubmenu_edgecolor,'Label','Green','Callback',{@edge_color,handles.fig});
uimenu(subsubmenu_edgecolor,'Label','Blue','Callback',{@edge_color,handles.fig});
uimenu(subsubmenu_edgecolor,'Label','Custom','Callback',{@edge_color,handles.fig});

subsubmenu_edgestyle = uimenu(submenu_edgesetting,'Label','Style');
uimenu(subsubmenu_edgestyle,'Label','Solid(''-'')','Checked','on','Callback',{@edge_style,handles.fig});
uimenu(subsubmenu_edgestyle,'Label','Dashed(''--'')','Callback',{@edge_style,handles.fig});
uimenu(subsubmenu_edgestyle,'Label','Dotted('':'')','Callback',{@edge_style,handles.fig});
uimenu(subsubmenu_edgestyle,'Label','Dashed and Dotted(''-.'')','Callback',{@edge_size,handles.fig});

subsubmenu_edgewidth = uimenu(submenu_edgesetting,'Label','LineWidth');
uimenu(subsubmenu_edgewidth,'Label','Thick(2.5)','Callback',{@edge_width,handles.fig});
uimenu(subsubmenu_edgewidth,'Label','Normal(1.5)','Checked','on','Callback',{@edge_width,handles.fig});
uimenu(subsubmenu_edgewidth,'Label','Thin(0.5)','Callback',{@edge_width,handles.fig});
uimenu(subsubmenu_edgewidth,'Label','Custom','Callback',{@edge_width,handles.fig});

submenu_namefontsize = uimenu(menu_edit,'Label','All Name FontSize');
uimenu(submenu_namefontsize,'Label','Big(20)','Callback',{@name_fontsize,handles.fig});
uimenu(submenu_namefontsize,'Label','Normal(16)','Checked','on','Callback',{@name_fontsize,handles.fig});
uimenu(submenu_namefontsize,'Label','Small(12)','Callback',{@name_fontsize,handles.fig});
uimenu(submenu_namefontsize,'Label','Custom','Callback',{@name_fontsize,handles.fig});

submenu_weightfontsize = uimenu(menu_edit,'Label','All Weight FontSize','Enable','off');
uimenu(submenu_weightfontsize,'Label','Big(12)','Callback',{@weight_fontsize,handles.fig});
uimenu(submenu_weightfontsize,'Label','Normal(10)','Checked','on','Callback',{@weight_fontsize,handles.fig});
uimenu(submenu_weightfontsize,'Label','Small(8)','Callback',{@weight_fontsize,handles.fig});
uimenu(submenu_weightfontsize,'Label','Custom','Callback',{@weight_fontsize,handles.fig});


uimenu(menu_edit,'Label','Axes on','Separator','on','Callback',{@axes_grid,handles.fig},'Accelerator','X');
uimenu(menu_edit,'Label','Grid on','Callback',{@axes_grid,handles.fig},'Accelerator','G')
menu_display = uimenu('Label','Display');
uimenu(menu_display,'Label','Graph Laplacian','Callback',{@displayCallback,handles.fig},'Accelerator','L');
uimenu(menu_display,'Label','Adjacency Matrix','Callback',{@displayCallback,handles.fig},'Accelerator','A');
setappdata(fig,'handles',handles);


%///////////////////////////////////////%
%           Callback Function           %
%///////////////////////////////////////%

%///////////////////////////////////////%
%               Open                    %
    function openfigure(source,~,fig)
        [filename,pathname] = uigetfile({'*.fig','Figure(*.fig)'},'Select Figure');
        newfig = openfig([pathname filename]);
        if ~strcmp(newfig.Tag,'Made with Graph Editor')
            close newfig;
            display('Error:this file was not made with graph_editor!!');
            return
        end
        renewObject(newfig);
    end
        
%///////////////////////////////////////%
%               Save                    %
    function savefigure(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        if strcmp(tmp_handles.savePlace,'') || strcmp(source.Label,'Save as')
            [filename,pathname] = uiputfile({'*.fig','Figure(*.fig)';'*.png','png files(*.png)';...
                '*.jpg','jpg files(*.jpg)';'*.eps','eps files(*.eps)';'*.svg','svg files(*.svg)'},'Save Image','graph.fig');
            if isequal(filename,0)
                return
            end
            tmp_handles.savePlace = [pathname filename];
        end
        if tmp_handles.Clear ~= 0
            tmp_handles.fig.Color = 'none';
        end
        if strcmp(tmp_handles.savePlace(end-3:end),'.svg')
            saveas(fig,tmp_handles.savePlace(1:end-4),'svg');
        elseif strcmp(tmp_handles.savePlace(end-3:end),'.eps')    
            saveas(fig,tmp_handles.savePlace(1:end-4),'epsc');
        else
            saveas(fig,tmp_handles.savePlace);
        end
        tmp_handles.fig.Color = 'w';
        setappdata(fig,'handles',tmp_handles);
    end
    
%///////////////////////////////////////%
%           Save Option                 %
    function saveoption(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Clear BackColor'
                if strcmp(source.Checked,'off')
                    source.Checked = 'on';
                    tmp_handles.Clear = 1;
                else
                    source.Checked = 'off';
                    tmp_handles.Clear = 0;
                end
        end
        setappdata(fig,'handles',tmp_handles);
    end

%///////////////////////////////////////%
%               Export                  %
    function export(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Graph Laplacian'
                matrix = tmp_handles.WeightMat;
                matrix(matrix~=0) = str2double(get(matrix(matrix~=0),'String'));
                diagmat = diag(sum(matrix,2));
                matrix = diagmat-matrix;
                gl = matrix;
                uisave('gl','gl');
            case 'Adjacency Matrix'
                matrix = tmp_handles.WeightMat;
                matrix(matrix~=0) = str2double(get(matrix(matrix~=0),'String'));
                ad = matrix;
                uisave('ad','ad');
        end
    end

%///////////////////////////////%
%           Node setting        %
    function node_color(source,~,fig)
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
        set(tmp_handles.RecMat,'EdgeColor',color);
        set(tmp_handles.NodeNumberText,'Color',color);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        rec = findobj(fig,'Tag','menu_RecColor');
        for i = 1:length(rec)
            custom_obj = findobj(rec(i),'Label',source.Label);
            set(get(rec(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
    end

    function node_width(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Thick(2)'
                width = 2;
            case 'Normal(1)'
                width = 1;
            case 'Thin(0.5)'
                width = 0.5;
            case 'Custom'
                custom_data = inputdlg('LineWidth:','LineWidth setting',[1 10],{'1.0'});
                width = str2double(custom_data{1});
                while isnan(width) || min(width) <= 0
                    custom_data = inputdlg('LineWidth:','LineWidth setting',[1 10],{'1.0'});
                    width = str2double(custom_data{1});
                end
        end
        set(tmp_handles.RecMat,'LineWidth',width);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        rec = findobj(fig,'Tag','menu_RecWidth');
        for i = 1:length(rec)
            custom_obj = findobj(rec(i),'Label',source.Label);
            set(get(rec(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
    end

    function node_size(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Big(8)'
                size = 0.8;
            case 'Normal(5)'
                size = 0.5;
            case 'Small(2)' 
                size = 0.2;
            case 'Custom'
                custom_data = inputdlg('Size:','Size setting',[1 10],{'5'});
                size = str2double(custom_data{1});
                while isnan(size) || min(size) <= 0
                    custom_data = inputdlg('Size:','Size setting',[1 10],{'5'});
                    size = str2double(custom_data{1});
                end
                size = size/10;
        end
        recpos = get(tmp_handles.RecMat,'Position');
        for i = 1:length(recpos)
            tmp_pos = recpos{i};
            tmp_size = tmp_pos(3);
            set(tmp_handles.RecMat(i),'Position',[tmp_pos(1)+(tmp_size-size)/2 tmp_pos(2)+(tmp_size-size)/2 size size]);
            set(tmp_handles.NodeNumberText(i),'Position',name_displace(fig,i,tmp_size,size));
            tmp_handles.NodeSize(i) = size*10;
            setappdata(fig,'handles',tmp_handles)
            if ~isempty(find(tmp_handles.EdgeMat~=0,1))
                replaceArrow(tmp_handles,i,tmp_size/2,size/2);
            end
            tmp_handles = getappdata(fig,'handles');
        end
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        rec = findobj(fig,'Tag','menu_RecSize');
        for i = 1:length(rec)
            custom_obj = findobj(rec(i),'Label',source.Label);
            set(get(rec(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
    end


%///////////////////////////////%
%           Edge setting        %
    function edge_color(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat~=0);
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
        set(tmp_handles.EdgeMat(ind),'Color',color);
        set(tmp_handles.Arrow1Mat(ind),'Color',color);
        set(tmp_handles.Arrow2Mat(ind),'Color',color);
        set(tmp_handles.WeightMat(ind),'Color',color);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        edge = findobj(fig,'Tag','menu_EdgeColor');
        for i = 1:length(edge)
            custom_obj = findobj(edge(i),'Label',source.Label);
            set(get(edge(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
        tmp_handles.EdgeColorAll = {color;source.Label};
        setappdata(fig,'handles',tmp_handles);
    end

    function edge_style(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat~=0);
        switch source.Label
            case 'Solid(''-'')'
                style = '-';
            case 'Dashed(''--'')'
                style = '--';
            case 'Dotted('':'')'
                style = ':';
            case 'Dashed and Dotted(''-.'')'
                style = '-.';
        end
        set(tmp_handles.EdgeMat(ind),'LineStyle',style);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        edge = findobj(fig,'Tag','menu_EdgeStyle');
        for i = 1:length(edge)
            custom_obj = findobj(edge(i),'Label',source.Label);
            set(get(edge(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
        tmp_handles.EdgeStyleAll = {style;source.Label};
        setappdata(fig,'handles',tmp_handles);
    end

    function edge_width(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.EdgeMat~=0);
        switch source.Label
            case 'Thick(2.5)'
                width = 2.5;
            case 'Normal(1.5)'
                width = 1.5;
            case 'Thin(0.5)'
                width = 0.5;
            case 'Custom'
                custom_data = inputdlg('LineWidth:','LineWidth setting',[1 10],{'1.5'});
                width = str2double(custom_data{1});
                while isnan(width) || min(width) <= 0
                    custom_data = inputdlg('LineWidth:','LineWidth setting',[1 10],{'1.5'});
                    width = str2double(custom_data{1});
                end
        end
        set(tmp_handles.EdgeMat(ind),'LineWidth',width);
        set(tmp_handles.Arrow1Mat(ind),'LineWidth',width);
        set(tmp_handles.Arrow2Mat(ind),'LineWidth',width);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        edge = findobj(fig,'Tag','menu_EdgeWidth');
        for i = 1:length(edge)
            custom_obj = findobj(edge(i),'Label',source.Label);
            set(get(edge(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
        tmp_handles.EdgeWidthAll = {width;source.Label};
        setappdata(fig,'handles',tmp_handles);
    end

%///////////////////////////////%
%           Weigth fontsize     %
    function weight_fontsize(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        ind = (tmp_handles.WeightMat ~= 0);
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
                while isnan(fontsize) || min(fontsize) <= 0
                    custom_data = inputdlg('Fontsize:','Fontsize setting',[1 10],{'10'});
                    fontsize = str2double(custom_data{1});
                end
        end
        set(tmp_handles.WeightMat(ind),'FontSize',fontsize);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        weight = findobj(fig,'Tag','menu_WeightFontSize');
        for i = 1:length(weight)
            custom_obj = findobj(weight(i),'Label',source.Label);
            set(get(weight(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
        tmp_handles.WeightFontSizeAll = {fontsize;source.Label};
        setappdata(fig,'handles',tmp_handles);
    end

%///////////////////////////////%
%           Name fontsize       %
    function name_fontsize(source,~,fig)
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
                while isnan(fontsize) || min(fontsize) <= 0
                    custom_data = inputdlg('Fontsize:','Fontsize setting',[1 10],{'16'});
                    fontsize = str2double(custom_data{1});
                end
        end
        set(tmp_handles.NodeNumberText,'FontSize',fontsize);
        set(source.Parent.Children,'Checked','off');
        source.Checked = 'on';
        name = findobj(fig,'Tag','menu_NameFontSize');
        for i = 1:length(name)
            custom_obj = findobj(name(i),'Label',source.Label);
            set(get(name(i),'Children'),'Checked','off');
            set(custom_obj,'Checked','on');
        end
    end

%///////////////////////////////%
%           Weight on           %
    function weight_setting(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        ind = find(tmp_handles.WeightMat~=0);
        menu_weight = findobj(source.Parent.Children,'Label','All Weight FontSize');
        if strcmp(source.Checked,'off')
            source.Checked = 'on';
            if ~isempty(ind)
                set(tmp_handles.WeightMat(ind),'Visible','on');
            end
            tmp_handles.WeightVisible = 'on';
            set(menu_weight,'Enable','on');
        else
            source.Checked = 'off';
            if ~isempty(ind)
                set(tmp_handles.WeightMat(ind),'Visible','off');
            end
            tmp_handles.WeightVisible = 'off';
            set(menu_weight,'Enable','off');
        end
        setappdata(fig,'handles',tmp_handles);
    end

%///////////////////////////%
%           Axes Grid       %
    function axes_grid(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        switch source.Label
            case 'Axes on'
                if strcmp(tmp_handles.axes.Visible,'off')
                    tmp_handles.axes.Visible = 'on';
                    source.Checked = 'on';
                else
                    tmp_handles.axes.Visible = 'off';
                    source.Checked = 'off';
                end
            case 'Grid on'
                if strcmp(tmp_handles.axes.Visible,'off')
                    return
                end
                if strcmp(tmp_handles.axes.XGrid,'off')
                    tmp_handles.axes.XGrid = 'on';
                    tmp_handles.axes.YGrid = 'on';
                    source.Checked = 'on';
                else
                    tmp_handles.axes.XGrid = 'off';
                    tmp_handles.axes.YGrid = 'off';
                    source.Checked = 'off';
                end
        end
    end
                    
                
%///////////////////////////%
%           Display         %
    function displayCallback(source,~,fig)
        tmp_handles = getappdata(fig,'handles');
        dispcell = cell(1,tmp_handles.NodeNumber+1);
        switch source.Label
            case 'Graph Laplacian'
                matrix = tmp_handles.WeightMat;
                [row,col] = size(char(get(matrix(matrix~=0),'String')));
                blank = max(col+2,2);
                matrix(matrix~=0) = str2double(get(matrix(matrix~=0),'String'));
                if strcmp(tmp_handles.WeightVisible,'off')
                    matrix(matrix~=0) = 1;
                end    
                diagmat = diag(sum(matrix,2));
                matrix = diagmat-matrix;
                dispcell{1} = 'Graph Laplacian = ';
            case 'Adjacency Matrix'
                matrix = tmp_handles.WeightMat;
                [row,col] = size(char(get(matrix(matrix~=0),'String')));
                blank = max(col+1,2);
                matrix(matrix~=0) = str2double(get(matrix(matrix~=0),'String'));
                if strcmp(tmp_handles.WeightVisible,'off')
                    matrix(matrix~=0) = 1;
                end    
                dispcell{1} = 'Adjacency Matrix = ';
        end
        for j = 1:tmp_handles.NodeNumber
            for i = 1:tmp_handles.NodeNumber
                strgl = num2str(matrix(i,j));
                if j == 1
                    if i == 1
                        dispcell{i+1} = ['[',strgl,blanks(blank-length(strgl))];
                    else
                        dispcell{i+1} = [' ',strgl,blanks(blank-length(strgl))];
                    end
                elseif j == tmp_handles.NodeNumber
                    if i == tmp_handles.NodeNumber
                        dispcell{i+1} = horzcat(dispcell{i+1},[strgl,';]']);
                    else
                        dispcell{i+1} = horzcat(dispcell{i+1},[strgl,';']);
                    end
                else
                    dispcell{i+1} = horzcat(dispcell{i+1},[strgl,blanks(blank-length(strgl))]);
                end
            end
        end
        display(char(dispcell));             
    end
end
