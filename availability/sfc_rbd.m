format long

avP = 0.998125919
avS = 0.998111247
avIH = 0.997328184

% first possible configuration
 
costP = 9;
costS = costP;
costIH = 18.5;

redP = 3;
redS = 2;
redIH = 2;

parallel = (1-(1-avP)^redP)*(1-(1-avS)^redS)*(1-(1-avIH)^redIH)
cost = costP*redP + costS * redS + costIH * redIH