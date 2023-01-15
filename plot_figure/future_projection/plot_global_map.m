function plot_global_map(lats, lons, sw_total, min_clr, max_clr, title_text,isxticklabel,isyticklabel)
axis equal
m_proj('miller','lat',[-60 85],'lon',[-180 180]); % robinson Mollweide
m_coast('color','k');
hold on

if isyticklabel && isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], ...
        'fontsize',8);
elseif isyticklabel && ~isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], ...
        'fontsize',8);
elseif ~isyticklabel && isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'yticklabels',[], ...
        'fontsize',8);
else
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], 'yticklabels',[], ...
        'fontsize',8);
end


m_pcolor(lons,lats,sw_total);
% M=m_shaperead('../../data/TP_shp/ROTW_China');
% for k=1:length(M.ncst)
%     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'color','k','linewidth',1);
% end


shading flat;
caxis([min_clr-1e-5,max_clr+1e-5])
%colormap(m_colmap('jet','step',10));
colormap([27, 158, 119]/255);
%m_text(-170,80,sub_text,'fontsize',10)
%colorbar

% m_contour(lons, lats, sw_total,[1500 1500],...
%     'edgecolor',[0 0 0],'linewidth',1);

t = title(title_text,'fontsize',10, 'fontweight', 'bold');
set(t, 'horizontalAlignment', 'left');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0 h1(2) h1(3)]);
set(gca, 'FontName', 'Time New Roman');

view(0,90);
hold off