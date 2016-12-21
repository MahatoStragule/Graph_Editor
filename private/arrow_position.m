function [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,ArrowStart,ArrowEnd,mode)
%mode 'Normal' : calculate normal position of edge
%mode 'Displace' : calculate displaced position of edge
RecMat = handles.RecMat;
if strcmp(mode,'Normal')
    s_pos = get(RecMat(ArrowStart),'Position');
    s_pos_x = s_pos(1)+handles.NodeSize(ArrowStart)/20;
    s_pos_y = s_pos(2)+handles.NodeSize(ArrowStart)/20;
    e_pos = get(RecMat(ArrowEnd),'Position');
    e_pos_x = e_pos(1)+handles.NodeSize(ArrowEnd)/20;
    e_pos_y = e_pos(2)+handles.NodeSize(ArrowEnd)/20;
    distance_x = e_pos_x-s_pos_x;
    distance_y = e_pos_y-s_pos_y;
    s_pos_x = s_pos_x + handles.NodeSize(ArrowStart)/20/sqrt(distance_x^2+distance_y^2)*distance_x;
    s_pos_y = s_pos_y + handles.NodeSize(ArrowStart)/20/sqrt(distance_x^2+distance_y^2)*distance_y;
    e_pos_x = e_pos_x - handles.NodeSize(ArrowEnd)/20/sqrt(distance_x^2+distance_y^2)*distance_x;
    e_pos_y = e_pos_y - handles.NodeSize(ArrowEnd)/20/sqrt(distance_x^2+distance_y^2)*distance_y;
    ax = -0.4/sqrt(distance_x^2+distance_y^2)*distance_x;
    ay = -0.4/sqrt(distance_x^2+distance_y^2)*distance_y;
    a_theta = pi/15;
    a_pos_x = e_pos_x+ax*cos(a_theta)-ay*sin(a_theta);
    a_pos_y = e_pos_y+ax*sin(a_theta)+ay*cos(a_theta);
    a_pos_x2 = e_pos_x+ax*cos(-a_theta)-ay*sin(-a_theta);
    a_pos_y2 = e_pos_y+ax*sin(-a_theta)+ay*cos(-a_theta);
    line_data = [s_pos_x e_pos_x; s_pos_y e_pos_y];
    arrow1_data = [e_pos_x a_pos_x; e_pos_y a_pos_y];
    arrow2_data = [e_pos_x a_pos_x2; e_pos_y a_pos_y2];
    weight_pos_x = (s_pos_x*5+e_pos_x*4)/9-0.3/sqrt(distance_x^2+distance_y^2)*distance_y;
    weight_pos_y = (s_pos_y*5+e_pos_y*4)/9+0.3/sqrt(distance_x^2+distance_y^2)*distance_x;
    weight_data = [weight_pos_x weight_pos_y 0];
elseif strcmp(mode,'Displace')
    xdata = get(handles.EdgeMat(ArrowEnd,ArrowStart),'XData');
    ydata = get(handles.EdgeMat(ArrowEnd,ArrowStart),'YData');
    s_pos_x = xdata(1);
    s_pos_y = ydata(1);
    e_pos_x = xdata(2);
    e_pos_y = ydata(2);
    s_rec_pos = get(RecMat(ArrowStart),'Position');
    e_rec_pos = get(RecMat(ArrowEnd),'Position');
    s_rec_center_x = s_rec_pos(1)+s_rec_pos(3)/2;
    s_rec_center_y = s_rec_pos(2)+s_rec_pos(4)/2;
    e_rec_center_x = e_rec_pos(1)+e_rec_pos(3)/2;
    e_rec_center_y = e_rec_pos(2)+e_rec_pos(4)/2;
    s_vec = [s_pos_x-s_rec_center_x;s_pos_y-s_rec_center_y];
    theta = pi/9;
    s_rot_vec = [s_vec(1)*cos(theta)-s_vec(2)*sin(theta);s_vec(1)*sin(theta)+s_vec(2)*cos(theta)];
    s_pos = s_rot_vec+[s_rec_center_x;s_rec_center_y];
    temp_s_pos = [s_pos_x; s_pos_y];
    %s_pos_x = s_pos(1);
    %s_pos_y = s_pos(2);
    s_delta = s_pos - temp_s_pos;
    e_vec = [e_pos_x-e_rec_center_x;e_pos_y-e_rec_center_y];
    e_rot_vec = [e_vec(1)*cos(-theta)-e_vec(2)*sin(-theta);e_vec(1)*sin(-theta)+e_vec(2)*cos(-theta)];
    e_pos = e_rot_vec+[e_rec_center_x;e_rec_center_y];
    temp_e_pos = [e_pos_x; e_pos_y];
    %e_pos_x = e_pos(1);
    %e_pos_y = e_pos(2);
    e_delta = e_pos - temp_e_pos;
    temp_rec_xdata = get(handles.EdgeMat(ArrowEnd,ArrowStart),'XData');
    temp_rec_ydata = get(handles.EdgeMat(ArrowEnd,ArrowStart),'YData');
    temp_arrow1_xdata = get(handles.Arrow1Mat(ArrowEnd,ArrowStart),'XData');
    temp_arrow1_ydata = get(handles.Arrow1Mat(ArrowEnd,ArrowStart),'YData');
    temp_arrow2_xdata = get(handles.Arrow2Mat(ArrowEnd,ArrowStart),'XData');
    temp_arrow2_ydata = get(handles.Arrow2Mat(ArrowEnd,ArrowStart),'YData');
    temp_weight_pos = get(handles.WeightMat(ArrowEnd,ArrowStart),'Position');
    line_data_x = [temp_rec_xdata(1)+s_delta(1) temp_rec_xdata(2)+e_delta(1)];
    line_data_y = [temp_rec_ydata(1)+s_delta(2) temp_rec_ydata(2)+e_delta(2)];
    arrow1_data_x = temp_arrow1_xdata + e_delta(1);
    arrow1_data_y = temp_arrow1_ydata + e_delta(2);
    arrow2_data_x = temp_arrow2_xdata + e_delta(1);
    arrow2_data_y = temp_arrow2_ydata + e_delta(2);
    line_data = [line_data_x; line_data_y];
    arrow1_data = [arrow1_data_x; arrow1_data_y];
    arrow2_data = [arrow2_data_x; arrow2_data_y];
    weight_data = temp_weight_pos+[((s_delta+e_delta)/2)' 0];
    %{
    s_pos_xdata = [temp_rec_xdata(1)-s_delta(1); temp_arrow1_xdata(1)-e_delta(1); temp_arrow2_xdata(1)-e_delta(1)];
    s_pos_ydata = [temp_rec_ydata(1)-s_delta(2); temp_arrow1_ydata(1)-e_delta(2); temp_arrow2_ydata(1)-e_delta(2)];
    e_pos_xdata = [temp_rec_xdata(2)-e_delta(1); temp_arrow1_xdata(2)-e_delta(1); temp_arrow2_xdata(2)-e_delta(1)];
    e_pos_ydata = [temp_rec_ydata(2)-e_delta(2); temp_arrow1_ydata(2)-e_delta(2); temp_arrow2_ydata(2)-e_delta(2)];
    set(handles.EdgeMat(ArrowStart,number),'XData',temp_rec_xdata-[s_delta(1) e_delta(1)],...
        'YData',temp_rec_ydata-[s_delta(2) e_delta(2)]);
    set(handles.Arrow1Mat(ArrowStart,number),'XData',temp_arrow1_xdata-[e_delta(1) e_delta(1)],...
        'YData',temp_arrow1_ydata-[e_delta(2) e_delta(2)]);
    set(handles.Arrow2Mat(ArrowStart,number),'XData',temp_arrow2_xdata-[e_delta(1) e_delta(1)],...
        'YData',temp_arrow2_ydata-[e_delta(2) e_delta(2)]);
    set(handles.WeightMat(ArrowStart,number),'Position',temp_weight_pos-[((s_delta+e_delta)/2)' 0]);
    %}
else
        display('Error:Unknown arrow_position''s mode!');
end
end