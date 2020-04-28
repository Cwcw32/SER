function [tableConfirmed,tableDeaths,tableRecovered,time] = getData_INDIA()

url = ['https://api.covid19india.org/data.json'];
S = webread(url)



timeSe= S.cases_time_series
disp(timeSe)
t = length(timeSe)
tableConfirmed=zeros(t,1);
tableDeaths=zeros(t,1);
tableRecovered=zeros(t,1);


disp(length(timeSe))


for i = 1:t
    tableConfirmed(i) = str2num(timeSe(i).totalconfirmed());
    tableDeaths(i) = str2num(timeSe(i).totaldeceased());
    tableRecovered(i) = str2num(timeSe(i).totalrecovered());
end

t1 = datetime(2020,01,30,0,0,0);
t2 = date()

time = t1:caldays(1):date()
time(end)=[]

disp(tableConfirmed);
disp(tableDeaths);
disp(tableRecovered);
disp(time);

end
