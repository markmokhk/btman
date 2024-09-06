from bs4 import BeautifulSoup

# Load the HTML file
with open('MAReport.htm', 'r', encoding='utf-8') as file:
    soup = BeautifulSoup(file, 'html.parser')

# Find and extract the required information
def extract_data(soup):
    data = {}

    # Extract Initial Deposit
    initial_deposit = soup.find(text="Initial deposit").find_next("td").text.strip()
    data['Initial Deposit'] = initial_deposit

    # Extract Symbol
    symbol = soup.find(text="Symbol").find_next("td").text.strip()
    data['Symbol'] = symbol

    # Extract Period
    period = soup.find(text="Period").find_next("td").text.strip()
    data['Period'] = period

    # Extract Total Net Profit
    total_net_profit = soup.find(text="Total net profit").find_next("td").text.strip()
    data['Total Net Profit'] = total_net_profit

    # Extract Gross Profit
    gross_profit = soup.find(text="Gross profit").find_next("td").text.strip()
    data['Gross Profit'] = gross_profit

    # Extract Maximum Drawdown
    max_drawdown = soup.find(text="Maximal drawdown").find_next("td").text.strip()
    data['Maximum Drawdown'] = max_drawdown

    # Extract Total Trades
    total_trades = soup.find(text="Total trades").find_next("td").text.strip()
    data['Total Trades'] = total_trades

    return data

# Call the function and print the extracted data
extracted_data = extract_data(soup)
for key, value in extracted_data.items():
    print(f"{key}: {value}")
