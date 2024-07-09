%by Clemence Rausa
%San Diego State University

clear all;
clc;


folder = 'D:\Human Breast Cancer Sample Project\Patient 22\dPPFC\p.2\Data';
%initialize
sum_Pre = 0;
sum_Post = 0;

for i= 1:8 %what runs do you want to include from your data set?  
   
    filename = [folder '\Slide_' num2str(i) '.mat'] 
    load(filename)
    AllPre(i,:) = Pre;
    Allpost(i,:) = Post;
    fractPrePost(i,:) = Post./Pre;
    sum_Pre= Pre + sum_Pre; %cells before shear
    sum_Post = Post + sum_Post; %cells after shear
   

end
meanfract = mean(fractPrePost,1,"omitnan");
sefract = std(fractPrePost,1,"omitnan")/sqrt(i);


%shear values 
raw_shr = shear;
%raw_shr = load('\\169.228.232.5\EnglerLabStorage\Madison Kane\ComsolShears');

%survival fraction
raw_y = sum_Post./sum_Pre; 

raw_yerror = sefract;



% % % %plot if cell lines = 1
ft_rawdata = fittype( 'exp(-(x/m)^b)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0];
opts.StartPoint = [1 1];
opts.Upper = [15 5000];





% If using two cell lines, comment out liens 41-46. Then uncomment 54-60
%plot if cell lines = 2
% eqn = 'p*exp(-(x/m)^b)+(1-p)*exp(-(x/810.4)^1.4154)';
% ft_rawdata = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
% opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts.Display = 'Off';
% opts.Lower = [0.5 0 0];
% opts.StartPoint = [2 100 0.5];
% opts.Upper = [15 810.4 1];
%         
% [raw_shr, raw_y, raw_yerror] = prepareCurveData(raw_shr(~isnan(raw_y)), raw_y(~isnan(raw_y)), raw_yerror(~isnan(raw_y)));
[raw_shr, raw_y] = prepareCurveData( raw_shr(~isnan(raw_y)), raw_y(~isnan(raw_y)));
myfit_rawdata = fit(raw_shr,raw_y,ft_rawdata,opts);
m_raw = myfit_rawdata.m;
b_raw = myfit_rawdata.b;





% Prediction Interval Calculation
p11 = predint(myfit_rawdata,raw_shr,0.95,'functional','on');   




figure(1);
hold all
errorbar(raw_shr,raw_y,raw_yerror,'o')


figure(1);
set(gcf,'position',[200 200 600 400]);
cl = get(groot,'defaultAxesColorOrder');

hold on ;
scatter(raw_shr,raw_y,10,cl(1,:),'filled');
[f, gof] = fit(raw_shr,raw_y,ft_rawdata, opts );
p = f(raw_shr);

 [fx, fxx] = differentiate(f, raw_shr);


%Calculation for 95% confidence interval of T50
confidenceinterval = confint(myfit_rawdata);
b_conf_values = confidenceinterval(:,1);
m_conf_values = confidenceinterval(:,2);
m = myfit_rawdata.m;
b = myfit_rawdata.b;
delta_m = m - m_conf_values(1);
delta_b = b- b_conf_values(1);

delta_t50 = (log(2)^b)*sqrt(delta_m.^2+(m*log(log(2))*delta_b)^2);
tau50 = f.m*(-log(0.5))^(1/f.b);
r2 = gof.rsquare;
plus = '+/-';
txt1 = strcat('Tau50 with 95% CI: ', {' '}, num2str(tau50), {' '},  plus, {' '},  num2str(delta_t50));
txt2 = strcat('R Square =', {' '}, num2str(r2));

%Plot fitted curve
fancyPlot({raw_shr},{p},{'xlabel','Shear Stess (dynes/cm^2)'},...
    {'ylabel','Survival Fraction'},{'lineStyle','-'},{'ylim',[0,1.2]},...
    {'spline'},{'lineWidth',2},{'fontSize',18},{'color',cl(1,:)});


set(gca, 'XScale', 'log')

figure(1)
                              
% Plot 95%Confidence and Prediction Intervals 
plot(raw_shr,p11,'r--','LineWidth',2.2)        
text(1.2,0.5,txt1, 'FontSize', 13)
text(1.2, 0.3, txt2, 'Fontsize', 13)



