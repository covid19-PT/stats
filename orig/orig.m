% coronavirus 

clear all; close all;
%
casos=[2 2 2 3 4 8 9 9 2 18 19 34 57 76 86] ;
recuperados=[0 0 0 0 0 0 0 0 0 0 0 1 0 1 1];
casossuspeitos=[25 51 59 70 85  85 101 117 147 181 224 281 339 375 471 1308 1704 2271 2908];
ndiasplus=9;
tdata=1:(length(casos)+ndiasplus);

temposuspeitos=1:length(casossuspeitos);
curvesuspeitos=fit( temposuspeitos', casossuspeitos', 'exp1');
tdatasuspeitos=1:(length(casossuspeitos)+3);
cdatasuspeitos=curvesuspeitos.a*exp(curvesuspeitos.b.*tdatasuspeitos);
rsq2 = 1 - norm(casossuspeitos-cdatasuspeitos(1:19))^2 / norm(casossuspeitos-mean(casossuspeitos))^2;

figure, plot(temposuspeitos,casossuspeitos,'ko','MarkerSize',12), hold on, ...
        plot(tdatasuspeitos,cdatasuspeitos,'ro-','LineWidth',2)
title(['Model y = ' num2str(curvesuspeitos.a) '* exp(' num2str(curvesuspeitos.b) '*x)  R^2 = ' num2str(rsq2)])
xlabel('tempo (dias)'); ylabel('casos suspeitos')
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on
% print('-djpeg','-r300','CasosSuspeitosCorona.jpg')
%%
casosefectivos=casos-recuperados;
tempo=1:length(casos);
%cumulative
cumul(1)=0;
cumulefectivos(1)=0;
cumulrecuperados(1)=0;
for i=2:length(casos)
    cumul(i)=sum(casos(1:i));
    cumulefectivos(i)=sum(casosefectivos(1:i));
    cumulrecuperados(i)=sum(recuperados(1:i));
end
% casos brutos
% clear cdata;
curve=fit( tempo', cumul', 'exp1');
curve.a; curve.b;
cdata=curve.a*exp(curve.b.*tdata);
rsq2 = 1 - norm(cumul-cdata(1:length(casos)))^2 / norm(cumul-mean(cumul))^2;

% casos efectivos brutos-recuperados
curveefectivos=fit( tempo', cumul', 'exp1');
curveefectivos.a; curve.b;
cdataefectivos=curveefectivos.a*exp(curveefectivos.b.*tdata);
rsq2efectivos = 1 - norm(cumulefectivos-cdataefectivos(1:length(casos)))^2 / norm(cumulefectivos-mean(cumulefectivos))^2;

%long term simulation
tdatalong=1:(length(casos)+45);
cdatalong=curveefectivos.a*exp(curveefectivos.b.*tdatalong);

%% gráfico
figure, subplot(1,2,1), plot(tempo,cumul,'ko','MarkerSize',12), hold on, ...
                        plot(tdata,cdata,'ro-','LineWidth',2), 
%                         fvline(12,'b--','Medidas')
serie0=['Model y = ' num2str(curve.a) '* exp(' num2str(curve.b) '*x)  R^2 = ' num2str(rsq2)];
legend('Dados',serie0)
xlabel('tempo (dias)'); ylabel('casos totais')
title(['Casos totais' date])
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on

        subplot(1,2,2), plot(tempo,cumulefectivos,'b*','MarkerSize',12), hold on, ...
                        plot(tdata,cdataefectivos,'bo-','LineWidth',2),
% %                     fvline(12,'b--','Medidas de contenção')
serie1=['Model y = ' num2str(curveefectivos.a) '* exp(' num2str(curveefectivos.b) '*x)  R^2 = ' num2str(rsq2efectivos)];
legend('Dados',serie1)
title(['Casos efectivos' date])
xlabel('tempo (dias)'); ylabel('casos efectivos')
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on
print('-djpeg','-r300',['CasosCorona_' date '.jpg'])
%%
%Pessoas infectadas e pessoas recuperadas
figure, plot(tempo,cumul,'ko','MarkerFaceColor','k'), hold on, ...
        plot(tdata,cdataefectivos,'ko-','LineWidth',2),
        plot(tempo,-cumulrecuperados,'bs-','MarkerFaceColor','b','LineWidth',2)
%         fvline(12,'m--','Medidas de contenção')
legend('Infectados','Modelo','Recuperados','location','NorthWest')
xlabel('tempo (dias)'); ylabel('casos')
title(['Casos: infectados e recuperados' date])
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on
print('-djpeg','-r300',['CasosCorona_RecuperadosInfectados' date '.jpg'])

%% 
%close all
tx1=datetime(2020,03,02,0,0,0); tx2=datetime(2020,04,10,0,0,0);
ttx=tx1:tx2; 
lcdata=length(cdata);
figure, 
yyaxis left;
plot(ttx(1:15),cumul,'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
plot(ttx(1:lcdata),cdata(1:lcdata),'ro--','LineWidth',3,'MarkerSize',6,'MarkerFaceColor','r'),
set(gca, 'xtick', ttx(1:2:lcdata));  %,'YTickLabel',[]
datetick('x','dd','keepticks');
set(gca,'XMinorTick','on','Ycolor','k')
xlabel('Março'); 
% ylabel('casos confirmados')

yyaxis right;
plot(ttx(1:15),cumul,'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
plot(ttx(1:lcdata),cdata(1:lcdata),'ro--','LineWidth',3,'MarkerSize',6,'MarkerFaceColor','r'),
set(gca, 'xtick', ttx(1:2:lcdata));
datetick('x','dd','keepticks');
set(gca,'XMinorTick','on','Ycolor','k')
ylabel('casos confirmados')

title(['Evolução Casos Confirmados (dados DGS ' date ')']);   %['Dados DGS  ' date '  12:00'])   
ax = gca;
ax.YRuler.Exponent = 0;
set(gca,'linewidth',3,'fontsize',26)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on

% zoom
nnzoom=3;
axes('position',[.20 .52 .37 .35])
box on % put box around new pair of axes
yyaxis left;
plot(ttx(1:15),cumul(1:15),'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
        plot(ttx(1:15+nnzoom),cdata(1:15+nnzoom),'ro--','LineWidth',3,'MarkerSize',6,'MarkerFaceColor','r'),
    yticks([0 200 400 600 800 1000])
set(gca,'XMinorTick','on','Ycolor','k') %,'YTickLabel',[]   
% ylabel('casos confirmados','fontsize',20)

yyaxis right;
plot(ttx(1:15),cumul(1:15),'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
        plot(ttx(1:15+nnzoom),cdata(1:15+nnzoom),'ro--','LineWidth',3,'MarkerSize',6,'MarkerFaceColor','r'),
    yticks([0 200 400 600 800 1000])
set(gca,'XMinorTick','on','Ycolor','k')    
set(gca, 'xtick', ttx(1:2:16+nnzoom));
datetick('x','dd','keepticks');
set(gca,'XMinorTick','on','Ycolor','k')
%         axis tight; xtickformat('dd/MM')
serie1=['y = ' num2str(curve.a) '* exp(' num2str(curve.b) '*x)  R^2 = ' num2str(rsq2)];
h1=legend('Dados DGS',serie1,'location','NorthWest');
h1.FontSize=16;
set(gca,'linewidth',2,'fontsize',18)  
ylabel('casos confirmados','fontsize',20)

title('Zoom')
print('-djpeg','-r600',['InfoCasosCoronaEfectivos_' date '.jpg'])
%% semilogy
figure, semilogy(ttx(1:15),cumul,'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
        semilogy(ttx(1:20),cdata(1:20),'ro--','LineWidth',3,'MarkerSize',6,'MarkerFaceColor','r'),
                   % fvline(12,'b--','Medidas de contenção')
                   xtickformat('dd/MM')
serie1=['Modelo y = ' num2str(curveefectivos.a) '* exp(' num2str(curveefectivos.b) '*x)  R^2 = ' num2str(rsq2efectivos)];
h1=legend('Dados',serie1,'location','NorthWest');
h1.FontSize=16;
title(['Evolução Casos Confirmados (dados DGS ' date ')'])
xlabel('tempo (dias)'); 
ylabel('casos confirmados')
ax = gca;
ax.YRuler.Exponent = 0;
set(gca,'linewidth',3,'fontsize',26)
% ytickformat('%.4g')
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on

print('-djpeg','-r600',['InfoCasosCoronaConfirmados_' date '.jpg'])

%% long term simulation with exp model
figure, plot(tempo,cumul,'ko','MarkerSize',12,'MarkerFaceColor','k'), hold on, ...
        plot(tdatalong,cdatalong,'ro-','LineWidth',2), 
%         fvline(12,'b','Medidas de contenção')
serie0=['Model y = ' num2str(curveefectivos.a) '* exp(' num2str(curveefectivos.b) '*x)  R^2 = ' num2str(rsq2)];
legend('Dados',serie0,'location','NorthWest')
xlabel('tempo (dias)'); ylabel('casos')
title(['Longo prazo com modelo exponencial (sujeito a erros) ' date])
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on
print('-djpeg','-r300',['LTSim_ExponentialModel' date '.jpg'])

%% polynomial
[ypoly2, S2]=polyfit(tempo', cumul',2);
R22 = 1 - (S2.normr/norm(cumul - mean(cumul)))^2;
[ypoly3, S3]=polyfit(tempo', cumul',3);
R23 = 1 - (S3.normr/norm(cumul - mean(cumul)))^2;
cpoly2=polyval(ypoly2,tdata);
cpoly3=polyval(ypoly3,tdata);

figure, plot(tempo,cumul,'ko','MarkerSize',12,'MarkerFaceColor',[.5 .5 .5]), hold on, plot(tdata,cdata,'ro-','LineWidth',2), ...
        plot(tdata,cpoly2,'b*-','LineWidth',2), plot(tdata,cpoly3,'ms-','MarkerFaceColor','m','LineWidth',2), 
    plot(tempo,cumul,'ko','MarkerSize',12,'MarkerFaceColor',[.5 .5 .5])
% title([date '   Model y = ' num2str(curve.a) '* exp(' num2str(curve.b) '*x)  R^2 = ' num2str(rsq2)])
title(date)
Str1=['y = ' num2str(curve.a) '*exp(' num2str(curve.b) '*x)  R^2=' num2str(rsq2) ];
Str2=['y = ' num2str(ypoly2(1)) '*x^2 ' num2str(ypoly2(2)) '*x +' num2str(ypoly2(3))    ' R^2=' num2str(R22) ];
Str3=['y = ' num2str(ypoly3(1)) '*x^3 ' num2str(ypoly3(2)) '*x^2 + ' num2str(ypoly3(3)) ...
                                        '*x' num2str(ypoly3(4))    ' R^2=' num2str(R23) ];
legend('Dados',Str1,Str2, Str3,'location','NorthWest')
xlabel('tempo (dias)'); ylabel('casos')
set(gca,'linewidth',2,'fontsize',16)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
grid on
print('-djpeg','-r300',['Poly' date '.jpg'])

%%
% time to double
tdouble=log(2)/(curve.b)
msgbox(['Tempo para duplicar o número de casos ' num2str(tdouble) ' dias'])