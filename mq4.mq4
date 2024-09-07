//+------------------------------------------------------------------+
//|                   Account Information Display Script             |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Your Name"
#property link      "https://www.yourwebsite.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    string accountInfo = "";
    accountInfo += "Account Number: " + IntegerToString(AccountNumber()) + "\n";
    accountInfo += "Broker Server: " + AccountServer() + "\n";
    accountInfo += "Symbol: " + Symbol() + "\n";
    accountInfo += "Ask Price: " + DoubleToString(Ask, Digits) + "\n";
    accountInfo += "Contract Size: " + DoubleToString(MarketInfo(Symbol(), MODE_LOTSIZE), 2) + "\n";
    
    double contractSize = MarketInfo(Symbol(), MODE_LOTSIZE);
    double totalValue = Ask * contractSize;
    accountInfo += "Ask * Contract Size: " + DoubleToString(totalValue, 2) + "\n";
    
    double leverage = AccountLeverage();
    double marginFromLeverage = totalValue / leverage;
    accountInfo += "Margin Required (from Leverage): " + DoubleToString(marginFromLeverage, 2) + "\n";
    
    double marginRequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    accountInfo += "Margin Required (from Symbol): " + DoubleToString(marginRequired, 2) + "\n";
    
    MessageBox(accountInfo, "Account Information", MB_OK);
}

