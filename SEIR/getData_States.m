function [tableConfirmed,tableDeaths,tableRecovered,time] = getData_States(Code)

url = ['https://api.covid19india.org/states_daily.json'];
S = webread(url)

timeSe= S.states_daily
t = length(timeSe)
tableConfirmed=zeros(t/3,1);
tableDeaths=zeros(t/3,1);
tableRecovered=zeros(t/3,1);
t1 = datetime(2020,03,14,0,0,0);
t2 = date();

time = t1:caldays(1):date();
time(end)=[];

%Code = convertStringsToChars(Code)
Code = char(Code)
disp(Code)
k = t/3;
j=1;

for i=1:3
    if(strcmp(timeSe(i).status,"Confirmed"))
        tableConfirmed(j) = str2num(timeSe(i).(Code))
    elseif(strcmp(timeSe(i).status,"Recovered"))
        tableRecovered(j) = str2num(timeSe(i).(Code))
    else
        tableDeaths(j) = str2num(timeSe(i).(Code))
    end
    if(mod(i,3)==0)
        j=j+1;
    end
end
for i = 4:t
    %%%
    if(strcmp(timeSe(i).status,"Confirmed"))
        tableConfirmed(j) = str2num(timeSe(i).(Code))+tableConfirmed(j-1)
    elseif(strcmp(timeSe(i).status,"Recovered"))
        tableRecovered(j) = str2num(timeSe(i).(Code))+tableRecovered(j-1)
    else
        tableDeaths(j) = str2num(timeSe(i).(Code))+tableDeaths(j-1)
    end
    if(mod(i,3)==0)
        j=j+1;
    end
    
    %%%
end
disp(length(tableConfirmed))
disp(j)
disp(t)
disp(i)
end
