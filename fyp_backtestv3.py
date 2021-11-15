"""
BACKTESTING
Takes adjusted close price data from Yahoo
Run the algorithm thru the price
Arrange data into dataframes
"""

import datetime
import pandas as pd
import pandas_datareader as web
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import math

#timeframe
start = datetime.datetime(2009,12,31)
end = datetime.datetime(2020,12,31)

#Historical stock prices
Ticker = input("Type in a stock ticker (in lower caps):")
#Capital = int(input("Input capital:"))
Capital = 10000
raw = web.DataReader(Ticker,'yahoo',start, end)

bt = raw[["Adj Close"]]
bt.rename(columns={"Adj Close":"Price"}, inplace = True)
bt = bt.iloc[1:]

#print(raw)

#trendfollowings
#for EMAs, alpha = 2/N+1 where N is the lookback period. EMA and EMAslow use N=26, EMA fast use N=12
bt["100SMA"] = bt["Price"].rolling(window=100).mean()
bt["EMA"] = bt["Price"].ewm(alpha=0.074074,adjust=False).mean()

#MACDalgorithm
bt["EMAslow"] = bt["Price"].ewm(alpha=0.074074,adjust=False).mean()
bt["EMAfast"] = bt["Price"].ewm(alpha=0.153846,adjust=False).mean()
bt["MACD"] = bt["EMAfast"] - bt["EMAslow"]
bt["signal"] = bt["MACD"].ewm(alpha=0.133333333333,adjust=False).mean()

#Adding position and price returns when the algos crosses stock price
SMAPosition = []
EMAPosition = []
MACDPosition = []

#DataCollection from the bt
ticker = []
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

#SMAPositionStrat
for i in range(0,bt.shape[0]):
    if bt["Price"].iloc[i] > bt["100SMA"].iloc[i]:
        SMAPosition.append("Long")
    elif bt["Price"].iloc[i] < bt["100SMA"].iloc[i]:
        SMAPosition.append("Short")
    else:
        SMAPosition.append("NA")

bt["SMAPosition"] = SMAPosition

#EMAPositionStrat
for i in range(0,bt.shape[0]):
    if bt["Price"].iloc[i] > bt["EMA"].iloc[i]:
        EMAPosition.append("Long")
    elif bt["Price"].iloc[i] < bt["EMA"].iloc[i]:
        EMAPosition.append("Short")
    else:
        EMAPosition.append("NA")

bt["EMAPosition"] = EMAPosition

#MACDPositionStrat
for i in range(0,bt.shape[0]):
    if bt["MACD"].iloc[i] > bt["signal"].iloc[i]:
        MACDPosition.append("Long")
    elif bt["MACD"].iloc[i] < bt["signal"].iloc[i]:
        MACDPosition.append("Short")
    else:
        MACDPosition.append("NA")

bt["MACDPosition"]= MACDPosition

#Capitals and Shares
SMACapital = Capital
EMACapital = Capital
MACDCapital = Capital
SMAShares = 0
EMAShares = 0
MACDShares = 0

#HoldingValue and CashOuts
SMALong = 0
SMACash = 0
EMALong = 0
EMACash = 0
MACDLong = 0
MACDCash = 0

#Winning/Losing Counter
SMAWin = 0
SMALose = 0
EMAWin = 0
EMALose = 0
MACDWin = 0
MACDLose = 0

#Profit and Loss Values
SMAProfit = 0
SMALoss = 0
EMAProfit = 0
EMALoss = 0
MACDProfit = 0
MACDLoss = 0

#SMATransaction
for i in range(0, bt.shape[0]):
    if bt['SMAPosition'].iloc[i] == "Long":
        if bt['SMAPosition'].iloc[i-1] == "Short" and SMACapital > bt['Price'].iloc[i]:
            SMAShares += int(SMACapital/bt['Price'].iloc[i])
            SMALong = bt['Price'].iloc[i]*SMAShares
            SMACapital -=SMALong
        else:
            SMALong = SMALong
            SMACapital = SMACapital

    elif bt['SMAPosition'].iloc[i] == "Short" and SMAShares > 0:

        if bt['SMAPosition'].iloc[i-1] == "Long":
            SMACash = bt['Price'].iloc[i] * SMAShares
            SMACapital += SMACash
            if bt['Price'].iloc[i] > (SMALong/SMAShares):
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

    elif bt['SMAPosition'].iloc[-1] == "Long" and SMALong > 0:
        SMALong = bt['Price'].iloc[-1] * SMAShares
    else:
        SMALong = 0

#EMATransaction
for i in range(0, bt.shape[0]):
    if bt['EMAPosition'].iloc[i] == "Long":
        if bt['EMAPosition'].iloc[i-1] == "Short" and EMACapital > bt['Price'].iloc[i]:
            EMAShares += int(EMACapital/bt['Price'].iloc[i])
            EMALong = bt['Price'].iloc[i]*EMAShares
            EMACapital -=EMALong
        else:
            EMALong = EMALong
            EMACapital = EMACapital

    elif bt['EMAPosition'].iloc[i] == "Short" and EMAShares > 0:

        if bt['EMAPosition'].iloc[i-1] == "Long":
            EMACash = bt['Price'].iloc[i] * EMAShares
            EMACapital += EMACash
            if bt['Price'].iloc[i] > (EMALong/EMAShares):
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

    elif bt['EMAPosition'].iloc[-1] == "Long" and EMALong > 0:
        EMALong = bt['Price'].iloc[-1] * EMAShares
    else:
        EMALong = 0

#MACDTransaction
for i in range(0, bt.shape[0]):
    if bt['MACDPosition'].iloc[i] == "Long":
        if bt['MACDPosition'].iloc[i-1] == "Short" and MACDCapital > bt['Price'].iloc[i]:
            MACDShares += int(MACDCapital/bt['Price'].iloc[i])
            MACDLong = bt['Price'].iloc[i]*MACDShares
            MACDCapital -=MACDLong
        else:
            MACDLong = MACDLong
            MACDCapital = MACDCapital

    elif bt['MACDPosition'].iloc[i] == "Short" and MACDShares > 0:

        if bt['MACDPosition'].iloc[i-1] == "Long":
            MACDCash = bt['Price'].iloc[i] * MACDShares
            MACDCapital += MACDCash
            if bt['Price'].iloc[i] > (MACDLong/MACDShares):
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

    elif bt['MACDPosition'].iloc[-1] == "Long" and MACDLong > 0:
        MACDLong = bt['Price'].iloc[-1] * MACDShares
    else:
        MACDLong = 0


#DisplayGraphs
ax1 = plt.plot(bt["Price"])
ax1 = plt.plot(bt["EMA"])
ax1 = plt.plot(bt["100SMA"])
ax1 = plt.plot(bt["MACD"])
ax1 = plt.plot(bt["signal"])
ax1 = plt.title("Daily Adjusted Close from 2010 through 2020", fontsize=18)
ax1 = plt.xlabel("Date", fontsize=18)
ax1 = plt.ylabel("Price", fontsize=18)
ax1 = plt.legend(["Price","EMA", "100 day SMA","MACD","MACD Signal"], prop={"size":15},loc="upper left")
plt.grid(True)
plt.show()

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
ticker.append(Ticker)
del SMALong, SMACash, EMALong, EMACash, MACDLong, MACDCash


print("***bting Complete***")

btData = pd.DataFrame(zip(ticker,SMAProfits,SMALosses,EMAProfits,EMALosses,MACDProfits,MACDLosses,SMAWinTrade,SMALossTrade,EMAWinTrade,EMALossTrade,MACDWinTrade,MACDLossTrade), columns = ['Ticker','Gross Profit (SMA)','Gross Loss (SMA)','Gross Profit (EMA)','Gross Loss (EMA)','Gross Profit (MACD)','Gross Loss (MACD)','Win Trades (SMA)','Lose Trades (SMA)','Win Trades (EMA)','Lose Trades (EMA)','Win Trades (MACD)','Lose Trades (MACD)'])
btData.to_csv("btdata.csv") # add a hashtag in front of this code if you want to add into existing CSV file
#btData.to_csv("btdata.csv", mode='a', header=False) # remove the hashtag in front to add into existing CSV file

bt = pd.read_csv("btdata.csv")
print(bt)





