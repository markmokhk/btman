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
    accountInfo += "Broker Server: " + AccountServer() + "\n\n";
    accountInfo += "Symbol: " + Symbol() + "\n";
    accountInfo += "Ask Price: " + DoubleToString(Ask, Digits) + "\n";
    accountInfo += "Contract Size: " + DoubleToString(MarketInfo(Symbol(), MODE_LOTSIZE), 2) + "\n";
    
    double contractSize = MarketInfo(Symbol(), MODE_LOTSIZE);
    double totalValue = Ask * contractSize;
    accountInfo += "Ask * Contract Size: " + DoubleToString(totalValue, 2) + "\n";
    
    double leverage = AccountLeverage();
    accountInfo += "Leverage: 1:" + IntegerToString(leverage) + "\n";
    double marginFromLeverage = totalValue / leverage;
    accountInfo += "Margin Required (from Leverage): " + DoubleToString(marginFromLeverage, 2) + "\n";
    
    double marginRequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    accountInfo += "Margin Required (from Symbol): " + DoubleToString(marginRequired, 2) + "\n\n";
    
    // Add step out level and margin call level
    double stepOutLevel = AccountStopoutLevel();
    double marginCallLevel = AccountStopoutLevel(); // Assuming margin call level is the same as stopout level
    accountInfo += "Step Out Level: " + DoubleToString(stepOutLevel, 2) + "%\n";
    accountInfo += "Margin Call Level: " + DoubleToString(marginCallLevel, 2) + "%\n";
    
    // Add current balance, current equity, and free margin
    double currentBalance = AccountBalance();
    double currentEquity = AccountEquity();
    double freeMargin = AccountFreeMargin();
    accountInfo += "Current Balance: " + DoubleToString(currentBalance, 2) + "\n";
    accountInfo += "Current Equity: " + DoubleToString(currentEquity, 2) + "\n";
    accountInfo += "Free Margin: " + DoubleToString(freeMargin, 2) + "\n\n";
    accountInfo += "Currency: " + AccountCurrency() + "\n";
    
    // Add max lot size
    double maxLotSize = MarketInfo(Symbol(), MODE_MAXLOT);
    accountInfo += "Max Lot Size: " + DoubleToString(maxLotSize, 2) + "\n";
    
    // Add maximum number of orders
    int maxOrders = AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
    accountInfo += "Maximum Number of Orders: " + IntegerToString(maxOrders) + "\n";
    
    MessageBox(accountInfo, "Account Information", MB_OK);
}
