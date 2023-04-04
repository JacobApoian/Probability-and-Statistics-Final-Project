clear all;
%%%%%% #1 %%%%%%
%50, 100, 1000, 2000,
%3000, 10000, and 100000 tosses.
t = [50 100 1000 2000 3000 10000 100000];
w = [.133 .0666 .133 .0666 .133 .0666 .133 .0666 .133 .0666];
sum=0;
r = randi([1 10],1,50);
disp (r)
for i = 1:50
    if mod(r(i),2)~=0
        sum=sum+1;
    end

end
prob=sum/50
disp(prob)

% a
for i = 1 : 7
    p=tossdie(t(i));
    disp(p);
end


% b
%based on probability theory should be 1/2

% c
% yes this agrees with part a

%d

disp('------');
% Y = randsample(10,5,true,w)
% if mod(Y(2),2)==0
%     disp('yay')
% end
for i = 1:7
   p=tossBiasedDie(t(i),w);
   disp(p);
end

% d part 2
%see attached photo, should be 2/3
%d
%the theoretical results agree


%%%%%%%% #4 %%%%%%%%%
% a,b,c
% disp('-------')
% disp('-------')
t2= [1 2 3 10 30 100];
X=0;
for i =1:6
% ZnF= zeros(1,10000);
ZnF=Zn1(t2(i));
figure(i)
histogram(ZnF,'Normalization','pdf');
hold on;
x =linspace(0,12,1000);
d=(1.3333/t2(i)); % we are plotting Zn, so var is changing 4/3/n
y = gaussmf(x,[d,5]); %first variable is sigma
plot(x,y, 'LineWidth',2);
xlabel('x')
ylabel('probability density')
title('pdf of Zn (n= %d)', t2(i))
hold off;
end

for i =1:6
ZnF1=Zn1Biased(t2(i),w);
figure(i+6)
histogram(ZnF1,'Normalization','pdf', 'BinWidth', 1/(t2(i)+1)); %, 1/(t(i)+1) last parameter
hold on;
x =linspace(0,12,1000);
y = gaussmf(x,[.5,5.33]); %first variable is sigma %(2/3)*t2(i),(2/9)*t2(i) <-- first attempt
plot(x,y, 'LineWidth',2);
xlabel('x')
ylabel('probability density')
title('pdf of Zn (n= %d)', t2(i))
hold off;
end



%%% number 2 %%%
file=dlmread('/MATLAB Drive/data.txt');
n=100000;
sigma1=0; %sigma IS SIGMA SQUARED
sum=0;
for i =1:n
    sum = file(i)+sum;
end
uMLE=sum/n;
% disp('above is mean')
for i = 1:n
    sigma1 = sigma1 + (file(i)-uMLE)*(file(i)-uMLE);
end
sigmaMLE = sigma1/n;
% disp('above is sigma')


%part c
figure(200)
histogram(file,'Normalization','pdf')
hold on;
x =linspace(-20,60,1000);
y = gaussmf(x,[(sigmaMLE/10),uMLE])*.4; %first variable is sigma
plot(x,y, 'LineWidth',2);
title('probability of Xi')
xlabel('x')
ylabel('probability densiy')
hold off;


%% number 3 %%%
% a %%
T = readtable('/MATLAB Drive/user_data.csv');
figure(99)
histogram(T.Bought);
title('Bought PMF');
xlabel('buy                  did not buy')
ylabel('occurrences')

figure(100)
histogram(T.SpenderType);
title('Spender Type PMF');
xlabel('    big spender    medium spender    small spender')
ylabel('occurrences')

figure(101)
histogram(T.Sex);
title('Sex PMF');
xlabel('male                  female')
ylabel('occurrences')

figure(102)
histogram(T.Age, 'NumBins',50)
title('Age PMF');
xlabel('Ages')
ylabel('occurrences')
%% b %%

%zero counts
bZeroCnt=0;
bZeroCount=0;
bZeroMaleCount=0;
bZeroFemaleCount=0;
bZeroSpender1Count=0;
bZeroSpender2Count=0;
bZeroSpender3Count=0;
%oneCounts
bOneCount=0;
bOneMaleCount=0;
bOneFemaleCount=0;
bOneSpender1Count=0;
bOneSpender2Count=0;
bOneSpender3Count=0;
for i=1 : 887
    if T.Bought(i)==1
        bOneCount=bOneCount+1;
       if(T.SpenderType(i)==1)
            bOneSpender1Count=bOneSpender1Count+1;
       elseif(T.SpenderType(i)==2)
            bOneSpender2Count=bOneSpender2Count+1;
       else
            bOneSpender3Count=bOneSpender3Count+1;
       end

       if(T.Sex(i)==1)
           bOneMaleCount=bOneMaleCount+1;
       else
           bOneFemaleCount=bOneFemaleCount+1;
       end
    elseif (T.Bought(i)==0)
           bZeroCount=bZeroCount+1;
       if(T.SpenderType(i)==1)
            bZeroSpender1Count=bZeroSpender1Count+1;
       elseif(T.SpenderType(i)==2)
            bZeroSpender2Count=bZeroSpender2Count+1;
       else
            bZeroSpender3Count=bZeroSpender3Count+1;
       end

       if(T.Sex(i)==1)
           bZeroMaleCount=bZeroMaleCount+1;
       else
           bZeroFemaleCount=bZeroFemaleCount+1;
       end
    end

end
B1Ages=zeros(1,bOneCount);
B0Ages=zeros(1,bZeroCount);
for i= 1:887
    if (T.Bought(i)==1)
        B1Ages(i)=T.Age(i);
    elseif (T.Bought(i)==0)
        B0Ages(i)=T.Age(i);
    end
end
%refining array (getting rid of zero values)
B1AgesFinal=zeros(1,bOneCount);
j=1;
for i=1:887
    if(B1Ages(i)~=0)
        B1AgesFinal(j)=B1Ages(i);
        j=j+1;
    end
end
%refining array for other age array(getting rid of zero values)
B0AgesFinal=zeros(1,bZeroCount);
j=1;
for i=1:885
    if(B0Ages(i)~=0)
        B0AgesFinal(j)=B0Ages(i);
        j=j+1;
    end
end
%spender type
ProbB1T1=bOneSpender1Count/bOneCount;
ProbB1T2=bOneSpender2Count/bOneCount;
ProbB1T3=bOneSpender3Count/bOneCount;
% if didn't buy
ProbB0T1=bZeroSpender1Count/bZeroCount;
ProbB0T2=bZeroSpender2Count/bZeroCount;
ProbB0T3=bZeroSpender3Count/bZeroCount;
%male or female
ProbB1Male=bOneMaleCount/bOneCount;
ProbB1Female=bOneFemaleCount/bOneCount;
%if didn't buy
ProbB0Male=bZeroMaleCount/bZeroCount;
ProbB0Female=bZeroFemaleCount/bZeroCount;
%Age bought

%Age did not buy

figure(50)
y= [ProbB1T1 ProbB1T2 ProbB1T3];
x= [1  2  3];
bar(x,y);
xlabel('    big spender    medium spender    small spender')
ylabel('probability')
title('Spenders who purchased')
figure(51)
y1 = [ProbB0T1 ProbB0T2 ProbB0T3];
x1 = [1 2 3];
bar(x1,y1);
xlabel('    big spender    medium spender    small spender')
ylabel('probability')
title('Spenders who did not purchase')
figure(52)
y2= [ProbB1Male ProbB1Female];
x2= [0 1];
bar(x2,y2);
xlabel('male                  female')
ylabel('probability')
title('Purchase by sex')

figure(53)
y3=[ProbB0Male ProbB0Female];
x3=[0 1];
bar(x3,y3);
xlabel('male                  female')
ylabel('probability')
title('No purchase by sex')

figure (60)
histogram(B0AgesFinal, 'Normalization', 'pdf', 'NumBins',50);
xlabel('Ages')
ylabel('probability')
title('Ages that did not buy')

figure (61)
histogram(B1AgesFinal,'Normalization', 'pdf', 'NumBins',50);
xlabel('Ages')
ylabel('probability')
title('Ages that did buy')
%%%%% functions for #1 %%%%%
function [prob] =  tossdie(t)
    sum=0;
    prob=0;
    r = randi([1,10],1,t);
    for i = 1: t
        if mod(r(i),2)~=0
            sum=sum+1;
        end
    end
    prob=sum/t;
end

function [prob] = tossBiasedDie(t,w)
    sum=0;
    prob=0;
    Y = randsample(10,t,true,w);
    for i = 1:t
        if mod(Y(i),2)~=0
            sum=sum+1;
        end
    end
    prob=sum/t;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% functions for #4 %%%%%
function [Zn] = Zn1 (t2)
   Zn= zeros(1,10000);
   for j=1:10000
       X=0;
   for i=1:t2
    X=X + randi([3, 7]);
   end
   Zn(j)=X/t2;
   end
end

function [Zn] = Zn1Biased (t2,w)
Zn=zeros(1,10000);
for j=1:10000
   X=0;
   Y = randsample(10,t2,true,w); % switching Xi from [3,7] to Biased die 0-10
   for i=1:t2
    X=X + Y(i);
   end
   Zn(j)=X/t2;
end
end
