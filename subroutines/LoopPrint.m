
for i = 1:100
    NUMV = [1,2,3,4,5,6,7,8];
    figure(i)
    hold on
    ylims = [-0.8,0.8];
    if  (i==1)
        plot(NUMV, GAP(2:9,i), 'bo','MarkerFaceColor',[0 0 0]);
    else
        plot(NUMV, GAP(1:8,i), 'bo','MarkerFaceColor',[0 0 0]);
    end
    ylim(ylims);
    alpha = sprintf('alpha = %f',NUM(i));
    text(1.756,0.288,alpha);
    grid on
    name = sprintf('plot%d', i);
    print(name,'-dpng');
    hold off
end
