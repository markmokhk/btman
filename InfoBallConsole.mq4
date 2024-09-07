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
    Print("Currency: ", AccountCurrency());
    Print("");
    Print("Free Margin: ", DoubleToString(AccountFreeMargin(), 2));
    Print("Current Equity: ", DoubleToString(AccountEquity(), 2));
    Print("Current Balance: ", DoubleToString(AccountBalance(), 2));
    
    // Add step out level and margin call level
    double stepOutLevel = AccountStopoutLevel();
    double marginCallLevel = AccountStopoutLevel(); // Assuming margin call level is the same as stopout level
    Print("Margin Call Level: ", DoubleToString(marginCallLevel, 2), "%");
    Print("Step Out Level: ", DoubleToString(stepOutLevel, 2), "%");
    
    Print("");
    double marginRequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    Print("Margin Required (from Symbol): ", DoubleToString(marginRequired, 2));
    
    double leverage = AccountLeverage();
    double contractSize = MarketInfo(Symbol(), MODE_LOTSIZE);
    double totalValue = Ask * contractSize;
    double marginFromLeverage = totalValue / leverage;
    Print("Margin Required (from Leverage): ", DoubleToString(marginFromLeverage, 2));
    
    Print("Ask * Contract Size: ", DoubleToString(totalValue, 2));
    
    Print("Contract Size: ", DoubleToString(MarketInfo(Symbol(), MODE_LOTSIZE), 2));
    Print("Ask Price: ", DoubleToString(Ask, Digits));
    Print("Symbol: ", Symbol());
    Print("");
    Print("Broker Server: ", AccountServer());
    Print("Account Number: ", AccountNumber());
    Print("Account Information:");
}
