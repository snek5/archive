"""
SIMULATION
Takes adjusted close price data from Yahoo
Calculates the mu and sigma
Simulate stock price based on mu and sigma
Run the algorithm thru the simulated stock price
Arrange data into dataframes
"""

import numpy as np
import pandas as pd
import datetime
import pandas_datareader as web
import matplotlib.pyplot as plt
from scipy.stats import norm
import datetime

#timeframe
end = datetime.datetime(2009,12,31)
start = datetime.datetime(1999,12,31)

#inputs
Ticker = input("Stock price to simulate(in lower caps):")
notrials = int(input("Number of trials to run:"))
Capital = int(input("Input Capital:"))

#data for simulation
raw = web.DataReader(Ticker, 'yahoo', start, end)['Adj Close']

#computing logarithmic returns
LogReturn = []
LogReturn = np.log(1+raw.pct_change())
raw["LogReturn"] = LogReturn

#compute drift and volatility
mu = raw["LogReturn"].mean()
var = raw["LogReturn"].var()
drift = mu
stdev = raw["LogReturn"].std()
print("Drift:",drift)
print("Volatility:",stdev)

#simulate for the next 3650 days for each trials
days = 3650
trials = 1
notrial = 1
simulation = []

#DataCollection from the simulation
SMAWinTrade = [] 
SMALossTrade = []
EMAWinTrade = []
EMALossTrade = []
MACDWinTrade = []
MACDLossTrade = []
SMAProfits = []
SMALosses = []
EMAProfits = []
EMALosses = []
MACDProfits = []
MACDLosses = []
Drift = []

#DataProcessing from the simulation

#simulation starts here
while notrial <= notrials:
    Z = norm.ppf(np.random.rand(days,trials))
    daily_returns = np.exp(drift + stdev*Z)
    PricePath = np.zeros_like(daily_returns)
    PricePath[0] = raw.iloc[1]

    for i in range(1,days):
        PricePath[i] = PricePath[i-1]*daily_returns[i]

#trendfollowings on simulated price
    simulation = pd.DataFrame(PricePath, columns = ['Simulated Price'])
    simulation['100SMA'] = simulation['Simulated Price'].rolling(window=100).mean()
    simulation['EMA'] = simulation['Simulated Price'].ewm(alpha = 0.074074, adjust = False).mean()
    simulation['EMAfast'] = simulation['Simulated Price'].ewm(alpha = 0.153846, adjust = False).mean()
    simulation['MACD'] = simulation['EMAfast'] - simulation['EMA']
    simulation['signal'] = simulation['MACD'].ewm(alpha = 0.133333, adjust = False).mean() #n=14

#SMAPositionStrat
    SMAPosition = []
    for i in range (0,simulation.shape[0]):
        if simulation['Simulated Price'].iloc[i] > simulation['100SMA'].iloc[i]:
            SMAPosition.append("Long")
        elif simulation['Simulated Price'].iloc[i] < simulation['100SMA'].iloc[i]:
            SMAPosition.append("Short")
        else:
            SMAPosition.append("NA")

    simulation['SMAPosition'] = SMAPosition


#EMAPositionStrat
    EMAPosition = []
    for i in range (0,simulation.shape[0]):
        if simulation['Simulated Price'].iloc[i] > simulation['EMA'].iloc[i]:
            EMAPosition.append("Long")
        elif simulation['Simulated Price'].iloc[i] < simulation['EMA'].iloc[i]:
            EMAPosition.append("Short")
        else:
            EMAPosition.append("NA")

    simulation['EMAPosition'] = EMAPosition

#MACDPositionStrat
    MACDPosition = []
    for i in range (0,simulation.shape[0]):
        if simulation['MACD'].iloc[i] > simulation['signal'].iloc[i]:
            MACDPosition.append("Long")
        elif simulation['MACD'].iloc[i] < simulation['signal'].iloc[i]:
            MACDPosition.append("Short")
        else:
            MACDPosition.append("NA")

    simulation['MACDPosition'] = MACDPosition
    
#Capitals and Shares
    SMACapital = Capital
    EMACapital = Capital
    MACDCapital = Capital
    SMAShares = 0
    EMAShares = 0
    MACDShares = 0

#HoldingAssetValue and CashOuts for TF algos
    SMALong = 0
    SMACash = 0
    EMALong = 0
    EMACash = 0
    MACDLong = 0
    MACDCash = 0

#Winning/Losing counter
    SMAWin = 0
    SMALose = 0
    EMAWin = 0
    EMALose = 0
    MACDWin = 0
    MACDLose = 0

#Profit and Loss Counter
    SMAProfit = 0
    SMALoss = 0
    EMAProfit = 0
    EMALoss = 0
    MACDProfit = 0
    MACDLoss = 0

#SMATransaction
    for i in range(0, simulation.shape[0]):
        if simulation['SMAPosition'].iloc[i] == "Long":
            if simulation['SMAPosition'].iloc[i-1] == "Short" and SMACapital > simulation['Simulated Price'].iloc[i]:
                SMAShares += int(SMACapital/simulation['Simulated Price'].iloc[i])
                SMALong = simulation['Simulated Price'].iloc[i]*SMAShares
                SMACapital -=SMALong
            else:
                SMALong = SMALong
                SMACapital = SMACapital

        elif simulation['SMAPosition'].iloc[i] == "Short" and SMAShares > 0:

            if simulation['SMAPosition'].iloc[i-1] == "Long":
                SMACash = simulation['Simulated Price'].iloc[i] * SMAShares
                SMACapital += SMACash
                if simulation['Simulated Price'].iloc[i] > SMALong/SMAShares:
                    SMAProfit += SMACash - SMALong
                    SMAWin += 1
                else:
                    SMALoss += SMACash - SMALong
                    SMALose += 1

                SMAShares = 0
                SMALong = 0

            else:
                SMACash = SMACash
                SMALong = 0

        elif simulation['SMAPosition'].iloc[-1] == "Long" and SMALong > 0:
            SMALong = simulation['Simulated Price'].iloc[-1] * SMAShares
        else:
            SMALong = 0

#EMATransaction
    for i in range(0, simulation.shape[0]):
        if simulation['EMAPosition'].iloc[i] == "Long":
            if simulation['EMAPosition'].iloc[i-1] == "Short" and EMACapital > simulation['Simulated Price'].iloc[i]:
                EMAShares += int(EMACapital/simulation['Simulated Price'].iloc[i])
                EMALong = simulation['Simulated Price'].iloc[i]*EMAShares
                EMACapital -=EMALong
            else:
                EMALong = EMALong
                EMACapital = EMACapital

        elif simulation['EMAPosition'].iloc[i] == "Short" and EMAShares > 0:

            if simulation['EMAPosition'].iloc[i-1] == "Long":
                EMACash = simulation['Simulated Price'].iloc[i] * EMAShares
                EMACapital += EMACash
                if simulation['Simulated Price'].iloc[i] > EMALong/EMAShares:
                    EMAProfit += EMACash - EMALong
                    EMAWin += 1
                else:
                    EMALoss += EMACash - EMALong
                    EMALose += 1

                EMAShares = 0
                EMALong = 0

            else:
                EMACash = EMACash
                EMALong = 0

        elif simulation['EMAPosition'].iloc[-1] == "Long" and EMALong > 0:
            EMALong = simulation['Simulated Price'].iloc[-1] * EMAShares
        else:
            EMALong = 0

#MACDTransaction
    for i in range(0, simulation.shape[0]):
        if simulation['MACDPosition'].iloc[i] == "Long":
            if simulation['MACDPosition'].iloc[i-1] == "Short" and MACDCapital > simulation['Simulated Price'].iloc[i]:
                MACDShares += int(MACDCapital/simulation['Simulated Price'].iloc[i])
                MACDLong = simulation['Simulated Price'].iloc[i]*MACDShares
                MACDCapital -=MACDLong
            else:
                MACDLong = MACDLong
                MACDCapital = MACDCapital

        elif simulation['MACDPosition'].iloc[i] == "Short" and MACDShares > 0:

            if simulation['MACDPosition'].iloc[i-1] == "Long":
                MACDCash = simulation['Simulated Price'].iloc[i] * MACDShares
                MACDCapital += MACDCash
                if simulation['Simulated Price'].iloc[i] > MACDLong/MACDShares:
                    MACDProfit += MACDCash - MACDLong
                    MACDWin += 1
                else:
                    MACDLoss += MACDCash - MACDLong
                    MACDLose += 1

                MACDShares = 0
                MACDLong = 0

            else:
                MACDCash = MACDCash
                MACDLong = 0

        elif simulation['MACDPosition'].iloc[-1] == "Long" and MACDLong > 0:
            MACDLong = simulation['Simulated Price'].iloc[-1] * MACDShares
        else:
            MACDLong = 0

#Display graph
    plt.plot(simulation['Simulated Price'])
    plt.plot(simulation['100SMA'])
    plt.plot(simulation['EMA'])
    plt.plot(simulation['MACD'])
    plt.plot(simulation['signal'])
    plt.xlabel("Number of Days")
    plt.ylabel("Price")
    plt.legend(['Simulated Price','100SMA','EMA','MACD','MACD Signal'], loc = "upper left")
    plt.title("Sample path generated by geometric Brownian motion with parameters \n $\mu$ ="+str(drift)+"\n $\sigma$ ="+str(stdev))
    plt.grid(True)
   # plt.show()  # Remove the hashtag in front to display graph for every simulation, not recommended for trials > 10

#Inserting neccessary data into dataframes 
    SMAWinTrade.append(SMAWin)
    SMALossTrade.append(SMALose)
    SMAProfits.append(SMAProfit)
    SMALosses.append(SMALoss)

    EMAWinTrade.append(EMAWin)
    EMALossTrade.append(EMALose)
    EMAProfits.append(EMAProfit)
    EMALosses.append(EMALoss)
    
    MACDWinTrade.append(MACDWin)
    MACDLossTrade.append(MACDLose)
    MACDProfits.append(MACDProfit)
    MACDLosses.append(MACDLoss)
    Drift.append(drift)

    del PricePath, SMALong, SMACash, EMALong, EMACash, MACDLong, MACDCash

    print("*Simulation",notrial,"complete*")
    notrial += 1

else:
    print("***Simulations Complete***")

Data = pd.DataFrame(zip(Drift,SMAProfits,SMALosses,EMAProfits,EMALosses,MACDProfits,MACDLosses,SMAWinTrade,SMALossTrade,EMAWinTrade,EMALossTrade,MACDWinTrade,MACDLossTrade), columns = ['Drift','Gross Profit (SMA)','Gross Loss (SMA)','Gross Profit (EMA)','Gross Loss (EMA)','Gross Profit (MACD)','Gross Loss (MACD)','Win Trades (SMA)','Lose Trades (SMA)','Win Trades (EMA)','Lose Trades (EMA)','Win Trades (MACD)','Lose Trades (MACD)'])
#print(Data)
Data.to_csv("simudata.csv")
#Data.to_csv("simudata.csv", mode="a", header=False) # add a hashtag in front of the line above and then remove the hashtag in front of this line to add the data into existing CSV file.
print(drift)


