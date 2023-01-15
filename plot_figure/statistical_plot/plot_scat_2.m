function plot_scat_2(a,b, x_label, y_label,max_value,max_value_y)
min_value_y = 0;
min_value = 0;

hold on
filters = a>0 & b>0 & a<1000 & b<1000;
a = a(filters);
b = b(filters);
R = corrcoef(a,b);
R = R(1,2);
R2 = R^2;
%scatplot(a, b);
f1 = scatter(a, b, 5,'MarkerEdgeColor','none',...
              'MarkerFaceColor',[85 37 1]/100)
f1.MarkerFaceAlpha = 0.02;

[b3,bint,r,rint,stats] = regress(b, [ ones(size(b,1),1) a ]);
dif_x = max_value - min_value;
plot([min_value max_value], [ b3(1,1) + min_value*b3(2,1) b3(1,1) + max_value*b3(2,1) ],'color', [85 37 1]/100, 'linewidth', 1)
dif_y = max_value_y - min_value_y;
%text(min_value + dif_x/20,max_value_y - 1*dif_y/10,['R^2=' num2str(R2,'%4.2f')],'fontsize',8,'fontname','time new roman', 'color', 'red')

if max_value_y >0.03
    if(b3(1,1)>=0)
        text(min_value + 8.4*dif_x/20,min_value_y + 1*dif_y/10,['y = ' num2str(b3(2,1),'%4.2f') 'x + ' num2str(b3(1,1),'%4.2f') ],'fontweight','bold','fontsize',10,'fontname','time new roman', 'color', [85 37 1]/100)
    else
        text(min_value + 8.4*dif_x/20,min_value_y + 1*dif_y/10,['y = ' num2str(b3(2,1),'%4.2f') 'x - ' num2str(abs(b3(1,1)),'%4.2f') ],'fontweight','bold','fontsize',10,'fontname','time new roman', 'color', [85 37 1]/100)
    end
else
    if(b3(1,1)>=0)
        text(min_value + 6.8*dif_x/20,min_value_y + 1*dif_y/10,['y = ' num2str(b3(2,1),'%4.3f') 'x + ' num2str(b3(1,1),'%4.3f') ],'fontweight','bold','fontsize',10,'fontname','time new roman', 'color', [85 37 1]/100)
    else
        text(min_value + 6.8*dif_x/20,min_value_y + 1*dif_y/10,['y = ' num2str(b3(2,1),'%4.3f') 'x - ' num2str(abs(b3(1,1)),'%4.3f') ],'fontweight','bold','fontsize',10,'fontname','time new roman', 'color', [85 37 1]/100)
    end
end
box on
set(gca,'fontsize',10,'fontname','time new roman','linewidth',1,'fontweight','bold')
xlabel(x_label)
ylabel(y_label)
axis([min_value max_value min_value_y max_value_y])

