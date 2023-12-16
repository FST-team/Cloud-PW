format long

avP = 0.998259001;
avS = avP;
avIH = 0.997671992;

% first possible configuration

costP = 9;
costS = costP;
costIH = 18.5;

redP = 2;
redS = 3;
redIH = 2;

parallel = (1-(1-avP)^redP)*(1-(1-avS)^redS)*(1-(1-avIH)^redIH)
cost = costP*redP + costS * redS + costIH * redIH