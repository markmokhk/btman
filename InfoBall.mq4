//+------------------------------------------------------------------+
//|                   Account Information Display Script             |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Your Name"
#property link      "https://www.yourwebsite.com"
#property version   "1.00"
#property strict


string BoolToString(bool value)
{
    return value ? "Yes" : "No";
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    string accountInfo = "";
    accountInfo += "Account Number: " + IntegerToString(AccountNumber()) + "\n";
    accountInfo += "Account Currency: " + AccountCurrency() + "\n";
    accountInfo += "Broker Server: " + AccountServer() + "\n\n";

    int leverage = AccountLeverage();
    accountInfo += "Leverage: 1:" + IntegerToString(leverage) + "\n";
    accountInfo += "Account Limit ORDER: " + IntegerToString(AccountInfoInteger(ACCOUNT_LIMIT_ORDERS)) + "\n\n";

    accountInfo += "Symbol: " + Symbol() + "\n\n";
    string baseCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
    string quoteCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
    accountInfo += "Base Currency: " + baseCurrency + " | Quote Currency: " + quoteCurrency + "\n";
    accountInfo += "Ask Price: " + DoubleToString(Ask, Digits) + "\n";
    accountInfo += "Contract Size: " + DoubleToString(MarketInfo(Symbol(), MODE_LOTSIZE), 2) + "\n";
    
    double contractSize = MarketInfo(Symbol(), MODE_LOTSIZE);
    double totalValue = Ask * contractSize;
    accountInfo += "Ask * Contract Size: (TV) " + DoubleToString(totalValue, 2) + "\n";

    double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
    double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
    string depositCurrency = AccountCurrency();
    accountInfo += "Tick Size: " + DoubleToString(tickSize, _Digits) + "\n";
    accountInfo += "Tick Value in Account Currency: " + DoubleToString(tickValue, 2) + " " + depositCurrency + "\n\n";
    
    
   
    double marginFromLeverage = totalValue / leverage;
    accountInfo += "Margin Required (from Leverage) = TV/Leverage (" + IntegerToString(leverage) + "): " + DoubleToString(marginFromLeverage, 2) + "\n";
    
    double marginRequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    accountInfo += "Free Margin Required to open 1 lot for buying (from Symbol Spec): " + DoubleToString(marginRequired, 2) + "\n";
    accountInfo += "Free Margin Required to open 0.1 lot for buying (from Symbol Spec): " + DoubleToString(marginRequired/10, 2) + "\n";
    accountInfo += "Free Margin Required to open 0.01 lot for buying (from Symbol Spec): " + DoubleToString(marginRequired/100, 2) + "\n\n";
    
    // Add step out level and margin call level
    //double stepOutLevel = AccountStopoutLevel();
    //double marginCallLevel = AccountStopoutLevel(); // Assuming margin call level is the same as stopout level
    //accountInfo += "Step Out Level: " + DoubleToString(stepOutLevel, 2) + "%\n";
    //accountInfo += "Margin Call Level: " + DoubleToString(marginCallLevel, 2) + "%\n";
    
   double margin_call = AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   double stop_out = AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
   accountInfo += "Margin Call Level: " + DoubleToString(margin_call, 2) + "%\n";
   accountInfo += "Stop Out Level: " + DoubleToString(stop_out, 2) + "%\n\n";

    accountInfo += "Expert Advisor Trading Allowed: " + BoolToString(AccountInfoInteger(ACCOUNT_TRADE_EXPERT)) + "\n\n";

    // Add current balance, current equity, and free margin
    double currentBalance = AccountBalance();
    double currentEquity = AccountEquity();
    double freeMargin = AccountFreeMargin();
    accountInfo += "Current Balance: " + DoubleToString(currentBalance, 2) + "\n";
    accountInfo += "Current Equity: " + DoubleToString(currentEquity, 2) + "\n";
    accountInfo += "Free Margin: " + DoubleToString(freeMargin, 2) + "\n\n";
    accountInfo += "Currency: " + AccountCurrency() + "\n\n";
    
    
    // Display Account Information
    Print("=== Account Information ===");
    Print("Account Name: ", AccountInfoString(ACCOUNT_NAME));
    Print("Account Number: ", AccountInfoInteger(ACCOUNT_LOGIN));
    Print("Account Currency: ", AccountInfoString(ACCOUNT_CURRENCY));
    Print("Account Leverage: ", AccountInfoInteger(ACCOUNT_LEVERAGE));
    Print("Account Balance: ", AccountInfoDouble(ACCOUNT_BALANCE));
    Print("Account Equity: ", AccountInfoDouble(ACCOUNT_EQUITY));
    Print("Account Free Margin: ", AccountInfoDouble(ACCOUNT_FREEMARGIN));
    Print("Account Margin Level: ", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), "%");
    Print("Account Stop Out Level: ", AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
    Print("Account Trade Mode: ", AccountInfoInteger(ACCOUNT_TRADE_MODE));
    Print("Account Limit ORDER: ", AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
        //Print("Account Margin Mode: ", AccountInfoInteger(ACCOUNT_MARGIN_MODE));
    Print("Account Profit: ", AccountInfoDouble(ACCOUNT_PROFIT));
    //Print("Is Hedging Allowed: ", BoolToString(AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE) == ACCOUNT_MARGIN_SO_MODE_MONEY));

    // Display Symbol Information
    string symbol = Symbol();
    Print("\n=== Symbol Information ===");
    Print("Symbol: ", symbol);
    Print("Bid Price: ", MarketInfo(symbol, MODE_BID));
    Print("Ask Price: ", MarketInfo(symbol, MODE_ASK));
    Print("Spread: ", MarketInfo(symbol, MODE_SPREAD));
    Print("Digits: ", MarketInfo(symbol, MODE_DIGITS));
    Print("Point: ", MarketInfo(symbol, MODE_POINT));
    Print("Contract Size: ", MarketInfo(symbol, MODE_LOTSIZE));
    Print("Tick Value: ", MarketInfo(symbol, MODE_TICKVALUE));
    Print("Tick Size: ", MarketInfo(symbol, MODE_TICKSIZE));
    Print("Swap Long: ", MarketInfo(symbol, MODE_SWAPLONG));
    Print("Swap Short: ", MarketInfo(symbol, MODE_SWAPSHORT));
    Print("Stop Level: ", MarketInfo(symbol, MODE_STOPLEVEL));
    Print("Lot Step: ", MarketInfo(symbol, MODE_LOTSTEP));
    Print("Max Lot Size: ", MarketInfo(symbol, MODE_MAXLOT));
    Print("Min Lot Size: ", MarketInfo(symbol, MODE_MINLOT));
    Print("Margin Required: ", MarketInfo(symbol, MODE_MARGINREQUIRED));
    Print("Expiration Mode: ", MarketInfo(symbol, MODE_EXPIRATION));
    Print("Margin Initial: ", MarketInfo(symbol, MODE_MARGININIT));
    Print("Margin Maintenance: ", MarketInfo(symbol, MODE_MARGINMAINTENANCE));

    // Display Market Information
    Print("\n=== Market Information ===");
    //Print("Server Time: ", TimeToString(TimeTradeServer(), TIME_DATE | TIME_MINUTES));
    Print("Local Time: ", TimeToString(TimeLocal(), TIME_DATE | TIME_MINUTES));
    Print("Time GMT Offset: ", TimeGMTOffset());
    //Print("Day of Week: ", TimeDayOfWeek());
    //Print("Day of Year: ", TimeDayOfYear());
    Print("Is Connected: ", BoolToString(TerminalInfoInteger(TERMINAL_CONNECTED)));
    Print("Is Demo Account: ", BoolToString(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO));
    Print("Is Real Account: ", BoolToString(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL));
    //Print("Is Trade Allowed: ", BoolToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_ALLOWED)));
    Print("Is Trade Mode Long Only: ", BoolToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_LONGONLY));
    Print("Is Trade Mode Short Only: ", BoolToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_SHORTONLY));

    // Display Terminal Information
    Print("\n=== Terminal Information ===");
    Print("Terminal Company: ", TerminalInfoString(TERMINAL_COMPANY));
    Print("Terminal Name: ", TerminalInfoString(TERMINAL_NAME));
    Print("Terminal Path: ", TerminalInfoString(TERMINAL_PATH));
    Print("Terminal Version: ", TerminalInfoInteger(TERMINAL_BUILD));
    //nt("CPU Usage: ", TerminalInfoDouble(TERMINAL_CPU_USAGE), "%");
    //Print("Memory Usage: ", TerminalInfoDouble(TERMINAL_MEMORY_USAGE) / 1024, " MB");
    Print("Is Terminal Connected: ", BoolToString(TerminalInfoInteger(TERMINAL_CONNECTED)));
    Print("Is Terminal Virtual Hosting: ", BoolToString(TerminalInfoInteger(TERMINAL_VPS)));
    //Print("Virtual Hosting Latency: ", TerminalInfoInteger(TERMINAL_VPS_LATENCY), " ms");

    // Display Computer Information
    Print("\n=== Computer Information ===");
    //Print("OS Version: ", TerminalInfoString(TERMINAL_OS_VERSION));
    Print("Screen DPI: ", TerminalInfoInteger(TERMINAL_SCREEN_DPI));
    //Print("Screen Width: ", TerminalInfoInteger(TERMINAL_SCREEN_WIDTH));
    //Print("Screen Height: ", TerminalInfoInteger(TERMINAL_SCREEN_HEIGHT));

    // Display Account Security Information
    Print("\n=== Account Security Information ===");
    Print("Is Password Changed: ", BoolToString(AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) == 1));
    //Print("Is OTP Enabled: ", BoolToString(AccountInfoInteger(ACCOUNT_OTP)));


   Print("Symbol=",Symbol());
   Print("Low day price=",MarketInfo(Symbol(),MODE_LOW));
   Print("High day price=",MarketInfo(Symbol(),MODE_HIGH));
   Print("The last incoming tick time=",(MarketInfo(Symbol(),MODE_TIME)));
   Print("Last incoming bid price=",MarketInfo(Symbol(),MODE_BID));
   Print("Last incoming ask price=",MarketInfo(Symbol(),MODE_ASK));
   Print("Point size in the quote currency=",MarketInfo(Symbol(),MODE_POINT));
   Print("Digits after decimal point=",MarketInfo(Symbol(),MODE_DIGITS));
   Print("Spread value in points=",MarketInfo(Symbol(),MODE_SPREAD));
   Print("Stop level in points=",MarketInfo(Symbol(),MODE_STOPLEVEL));
   Print("Lot size in the base currency=",MarketInfo(Symbol(),MODE_LOTSIZE));
   Print("Tick value in the deposit currency=",MarketInfo(Symbol(),MODE_TICKVALUE));
   Print("Tick size in points=",MarketInfo(Symbol(),MODE_TICKSIZE)); 
   Print("Swap of the buy order=",MarketInfo(Symbol(),MODE_SWAPLONG));
   Print("Swap of the sell order=",MarketInfo(Symbol(),MODE_SWAPSHORT));
   Print("Market starting date (for futures)=",MarketInfo(Symbol(),MODE_STARTING));
   Print("Market expiration date (for futures)=",MarketInfo(Symbol(),MODE_EXPIRATION));
   Print("Trade is allowed for the symbol=",MarketInfo(Symbol(),MODE_TRADEALLOWED));
   Print("Minimum permitted amount of a lot=",MarketInfo(Symbol(),MODE_MINLOT));
   Print("Step for changing lots=",MarketInfo(Symbol(),MODE_LOTSTEP));
   Print("Maximum permitted amount of a lot=",MarketInfo(Symbol(),MODE_MAXLOT));
   Print("Swap calculation method=",MarketInfo(Symbol(),MODE_SWAPTYPE));
   Print("Profit calculation mode=",MarketInfo(Symbol(),MODE_PROFITCALCMODE));
   Print("Margin calculation mode=",MarketInfo(Symbol(),MODE_MARGINCALCMODE));
   Print("Initial margin requirements for 1 lot=",MarketInfo(Symbol(),MODE_MARGININIT));
   Print("Margin to maintain open orders calculated for 1 lot=",MarketInfo(Symbol(),MODE_MARGINMAINTENANCE));
   Print("Hedged margin calculated for 1 lot=",MarketInfo(Symbol(),MODE_MARGINHEDGED));
   Print("Free margin required to open 1 lot for buying=",MarketInfo(Symbol(),MODE_MARGINREQUIRED));
   Print("Order freeze level in points=",MarketInfo(Symbol(),MODE_FREEZELEVEL)); 
    // Final message
    Print("\n=== End of Information ===");
    


    MessageBox(accountInfo, "Account Information", MB_OK);
}
