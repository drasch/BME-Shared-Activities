%Escape Room problem Xray
clear; clc; close all;

    WidthS1=floor(rand(1)*3)+1;
    WidthO1=floor(rand(1)*8)+8;

    M=round(rand(1)*5)+2;
    m=M-1;
    WidthS=WidthS1*m;
    WidthO=WidthO1*M;
    dx=.01;
    x=[-WidthO/2-1:dx:WidthO/2+1];
    x2=[-WidthS/2-1:dx:WidthS/2+1];

    ind=find(abs(x2)<WidthS/2);
    ind2=find(abs(x)<WidthO/2);

    S=zeros(size(x2));
    O=zeros(size(x));
    S(ind)=1;
    O(ind2)=1;

    xs=[-WidthS1/2-1:dx:WidthS1/2+1];
    xo=[-WidthO1/2-1:dx:WidthO1/2+1];
    ind2=find(abs(xs)<WidthS1/2);
    ind3=find(abs(xo)<WidthO1/2);

    Source=zeros(size(xs));
    Object=zeros(size(xo));
    Source(ind2)=1;
    Object(ind3)=1;

    Result=conv(S,O);
    xRes=[x(1)+x2(1):dx:x(end)+x2(end)];

    horzlinex = linspace(min(xRes)-25, max(xRes) + 25, 100);

    Plateau = WidthO - WidthS;

%     axes(ax); % Only needed if you have multiple axes.
%     cla
    figure(1); clf;
    subplot(1,1,1);
    plot(xs, Source./max(Source) + 10, 'k-', 'LineWidth', 2)
    hold on
    x2 = [xs, fliplr(xs)];
    inBetween = [Source./max(Source) + 10, fliplr(10.*ones(1,length(xs)))];
    fill(x2, inBetween, 'r');
    plot(horzlinex, zeros(1,100)+10, 'k-', 'LineWidth', 2);
    text(max(xRes),10.5,sprintf('Source Width = %.1d', WidthS1), 'FontSize', 12, 'FontWeight', 'Bold')

    plot(xo, Object./max(Object) + 5, 'k-', 'LineWidth', 2)
    plot(horzlinex, zeros(1,100)+5, 'k-', 'LineWidth', 2);
    text(max(xRes),5.5,sprintf('Object Width = %.1d', WidthO1), 'FontSize', 12, 'FontWeight', 'Bold')

    x3 = [xo, fliplr(xo)];
    inBetween2 = [Object./max(Object) + 5, fliplr(5.*ones(1,length(xo)))];
    fill(x3, inBetween2, 'b');

    plot(xRes, Result./max(Result), 'k-', 'LineWidth', 2)
    plot(horzlinex, zeros(1,100), 'k-', 'LineWidth', 2);
    text(max(xRes),0.5,sprintf('Plateau Width = %.1d', Plateau), 'FontSize', 12, 'FontWeight', 'Bold')
    plot(linspace(Plateau/2, Plateau/2+WidthS, 100), zeros(1,100)-0.15, 'k-');
    text(mean([Plateau/2 Plateau/2+WidthS]),-0.3,'x', 'FontSize', 12, 'FontWeight', 'Bold')
    x4 = [xRes, fliplr(xRes)];
    inBetween3 = [Result./max(Result), fliplr(zeros(1,length(xRes)))];
    fill(x4, inBetween3, 'g');
    hold off

    xlim([min(xRes)-25 max(xRes)+25]);
    %axis off