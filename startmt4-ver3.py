import os
import time
import subprocess
import signal
from bs4 import BeautifulSoup
import datetime
import threading
import logging
import shutil
import uuid
import base64
import tempfile
import pprint
import time
import threading
from datetime import datetime, timedelta
import subprocess
import psutil
import time

PROG_FOLDER = r"c:\btman"
REPORT_NAME = "MAReport.htm"
my_start_ini = os.path.join(PROG_FOLDER, "start.ini")
mother_folder = os.path.join(PROG_FOLDER, "MOTHER_MT4", "MT4_UM")
SON_MT4_FOLDER = os.path.join(PROG_FOLDER, "SON_MT4" , ".")


def get_temp_file():
    """
    Create a temporary file and return its path.
    
    Returns:
    str: Path to the temporary file.
    """
    temp_file = tempfile.NamedTemporaryFile(delete=False)
    temp_file_path = temp_file.name
    temp_file.close()
    return temp_file_path

def encode_start_ini(ini_path):
    """
    Encode the contents of the start.ini file to a base64 string.
    
    Args:
    ini_path (str): Path to the start.ini file.
    
    Returns:
    str: Base64 encoded string of the start.ini file contents.
    """
    with open(ini_path, 'rb') as file:
        encoded_content = base64.b64encode(file.read()).decode('utf-8')
    return encoded_content

def decode_start_ini(encoded_content, output_path):
    """
    Decode a base64 string and write it to a start.ini file.
    
    Args:
    encoded_content (str): Base64 encoded string of the start.ini file contents.
    output_path (str): Path to save the decoded start.ini file.
    """
    decoded_content = base64.b64decode(encoded_content.encode('utf-8'))
    with open(output_path, 'wb') as file:
        file.write(decoded_content)

def copy_to_random_folder(mother_folder):
    random_folder_name = "_mt4_"+str(uuid.uuid4())
    random_folder_path = os.path.join(os.path.dirname(SON_MT4_FOLDER), random_folder_name)
    shutil.copytree(mother_folder, random_folder_path)
    return random_folder_path

def delete_random_folder(folder_path):
    if os.path.exists(folder_path):
        shutil.rmtree(folder_path)
    else:
        logging.warning(f"Folder {folder_path} does not exist.")

def delete_random_folder(folder_path, max_attempts=5, delay=1):
    for attempt in range(max_attempts):
        try:
            if os.path.exists(folder_path):
                shutil.rmtree(folder_path)
                logging.info(f"Successfully deleted folder {folder_path}")
                return
            else:
                logging.warning(f"Folder {folder_path} does not exist.")
                return
        except PermissionError as e:
            if attempt < max_attempts - 1:
                logging.warning(f"Unable to delete folder {folder_path}. Retrying in {delay} seconds...")
                time.sleep(delay)
            else:
                logging.error(f"Failed to delete folder {folder_path} after {max_attempts} attempts: {str(e)}")

def update_start_ini(ini_path, item, value):
    item_found = False
    with open(ini_path, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if line.startswith(f'{item}='):
            lines[i] = f'{item}={value}\n'
            item_found = True
            break

    if not item_found:
        lines.append(f'{item}={value}\n')

    with open(ini_path, 'w') as file:
        file.writelines(lines)

def format_date(date):
    """
    Convert a date string from "YYYYMMDD" format or a datetime object to "YYYY.MM.DD" format.
    
    Args:
    date (str or datetime): Date string in "YYYYMMDD" format or a datetime object.
    
    Returns:
    str: Date string in "YYYY.MM.DD" format.
    """
    if isinstance(date, datetime):
        return date.strftime("%Y.%m.%d")
    elif isinstance(date, str):
        return f"{date[:4]}.{date[4:6]}.{date[6:]}"
    else:
        raise ValueError("Input must be a string in 'YYYYMMDD' format or a datetime object")

def terminate_process_and_children(proc_pid):
    try:
        process = psutil.Process(proc_pid)
        # Terminate child processes first
        for child in process.children(recursive=True):
            child.terminate()
        # Terminate the main process
        process.terminate()
        
        # Wait for processes to terminate
        _, still_alive = psutil.wait_procs([process] + process.children(recursive=True), timeout=5)
        # If still alive, kill them forcefully
        #for p in still_alive:
            #p.kill()
        print(f"Process {proc_pid} and its children have been terminated.")
    except psutil.NoSuchProcess:
        print(f"Process {proc_pid} does not exist or has already been terminated.")

def run_mt4_report(terminal_folder, start_ini_path, setfile_path, thread_number=0):
    # Start the terminal.exe with the specified ini file
    terminal_exe_path = os.path.join(terminal_folder, "terminal.exe")
    
    # Copy the setfile to the terminal folder's "tester" subfolder
    tester_folder = os.path.join(terminal_folder, "tester")
    os.makedirs(tester_folder, exist_ok=True)
    shutil.copy(setfile_path, tester_folder)
    setfile_name = os.path.basename(setfile_path)
    # Check if the setfile was successfully copied
    copied_setfile_path = os.path.join(tester_folder, setfile_name)
    if os.path.exists(copied_setfile_path):
        logging.info(f"Copied setfile {setfile_name} to {tester_folder}")
    else:
        logging.error(f"Failed to copy setfile {setfile_name} to {tester_folder}")
        raise FileNotFoundError(f"Setfile not found at {copied_setfile_path}. Halting program.")

    # Start the terminal.exe with the specified ini file
    logging.info(f"Starting terminal.exe with {start_ini_path} in {terminal_folder}")
    process = subprocess.Popen([terminal_exe_path, start_ini_path, "/portable"])
    #process.wait()  # Wait for the process to finish

   
    report_path = os.path.join(terminal_folder, "MAReport.htm")
    #logging.info(f"Report path: {report_path}")

    # Check if the report file is created with a timeout
    start_time = time.time()
    timeout = 3000   # 5 minutes timeout
    while True:
        elapsed_time = int(time.time() - start_time)
        print(f"\rWaiting for MAReport.htm in {terminal_folder}... ({elapsed_time} seconds)", end="", flush=True)
        if os.path.exists(report_path):
            print()  # Move to a new line
            logging.info(f"Report Found in {terminal_folder}!")
            # Copy report_path to terminal folder's Report directory and rename it to YYYYDDMMHHmmss.htm
            report_directory = os.path.join(PROG_FOLDER, 'Report')
            if not os.path.exists(report_directory):
                os.makedirs(report_directory)
            
            timestamp = time.strftime('%Y%m%d%H%M%S')
            unique_id = uuid.uuid4()
            new_report_name = f"{timestamp}_Thread_{thread_number}_{unique_id}.htm"
            new_report_path = os.path.join(report_directory, new_report_name)
            
            shutil.copy(report_path, new_report_path)
            logging.info(f"Copied report to {new_report_path}")
            break
        if elapsed_time > timeout:
            print()  # Move to a new line
            logging.error(f"Timeout waiting for report in {terminal_folder}")
            return None
        time.sleep(1)

    # Attempt to terminate the terminal.exe process
    logging.info(f"Attempting to terminate terminal.exe in {terminal_folder}")
    pprint.pprint(process)
    terminate_process_and_children(process.pid)
    # Wait for up to 10 seconds for the process to terminate with a progress bar
   
    # Load the HTML file
    with open(report_path, 'r', encoding='utf-8') as file:
        soup = BeautifulSoup(file, 'html.parser')
        logging.info(f"Report loaded from {report_path}")



    # Extract data from the report
    data = {}
    fields = {
        "Initial deposit": "Initial Deposit",
        "Symbol": "Symbol",
        "Period": "Period",
        "Total net profit": "Total Net Profit",
        "Gross profit": "Gross Profit",
        "Maximal drawdown": "Maximum Drawdown",
        "Total trades": "Total Trades",
        "Bars in test": "Bars in test",
        "Profit factor": "Profit factor",
        "Spread": "Spread",
        "Gross profit": "Gross Profit",
        "Gross loss": "Gross Loss",
        "Model": "Model",
        "Parameters": "Parameters",
        "Expected payoff": "Expected Payoff",
        "Profit trades (% of total)": "Profit Trades (% of total)",
        "Loss trades (% of total)": "Loss Trades (% of total)",
    }
    for field, key in fields.items():
        value = soup.find(string=field).find_next("td").text.strip()
        data[key] = value



    # Delete MAReport.htm if it exists
    try:
        if os.path.exists(report_path):
            os.remove(report_path)
            logging.info(f"Deleted MAReport.htm in {terminal_folder}")
        else:
            logging.warning(f"MAReport.htm not found in {terminal_folder}")
    except FileNotFoundError:
        logging.warning(f"MAReport.htm not found in {terminal_folder}")



    return data

def run_report_thread(start_ini_path, setfile_path, thread_number=0):

    random_folder = copy_to_random_folder(mother_folder)
    result = run_mt4_report(random_folder, start_ini_path, setfile_path,thread_number)
    #time.sleep(1)
    delete_random_folder(random_folder, max_attempts=10, delay=1)

# Create a thread for running the report
def run_multiple_reports(start_ini_paths, setfile_path):
    import time

    start_time = time.time()
    threads = []
    total_threads = len(start_ini_paths)
    max_concurrent_threads = 10

    print(f"Starting {total_threads} threads...")

    for start_ini_path in start_ini_paths:
        while len(threads) >= max_concurrent_threads:
            for thread in threads:
                if not thread.is_alive():
                    threads.remove(thread)
            time.sleep(0.1)  # Small delay to prevent busy waiting

        thread_number = total_threads - len(start_ini_paths) + len(threads)
        thread = threading.Thread(target=run_report_thread, args=(start_ini_path, setfile_path, thread_number))
        threads.append(thread)
        
        print(f"Thread {thread_number} is started.")
        thread.start()

    for thread in threads:
        thread.join()

    print(f"All {total_threads} reports completed.")

    end_time = time.time()
    total_time = end_time - start_time
    print(f"Total time used: {total_time:.2f} seconds")


# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def bt(symbol, expert, setfile, period, from_date, to_date, every_period):
        # Error checking for required parameters
    required_params = {
        'symbol': symbol,
        'expert': expert,
        'setfile': setfile,
        'period': period,
        'from_date': from_date,
        'to_date': to_date,
        'every_period': every_period
    }

    missing_params = [param for param, value in required_params.items() if value is None]

    if missing_params:
        error_message = f"Error: Missing required parameters: {', '.join(missing_params)}"
        logging.error(error_message)
        raise ValueError(error_message)

    # Additional checks
    if not isinstance(from_date, datetime) or not isinstance(to_date, datetime):
        error_message = "Error: from_date and to_date must be datetime objects"
        logging.error(error_message)
        raise ValueError(error_message)
    valid_periods = ['M1', 'M5', 'M15', 'M30', 'H1', 'H4', 'D', 'W']
    if period not in valid_periods:
        error_message = f"Error: Invalid period '{period}'. Must be one of {', '.join(valid_periods)}"
        logging.error(error_message)
        raise ValueError(error_message)

    if from_date >= to_date:
        error_message = "Error: from_date must be earlier than to_date"
        logging.error(error_message)
        raise ValueError(error_message)

    if not os.path.isfile(setfile):
        error_message = f"Error: setfile '{setfile}' does not exist"
        logging.error(error_message)
        raise FileNotFoundError(error_message)

    logging.info("All required parameters are provided and valid. Proceeding with the operation.")
    # Prepare the start.ini file
    start_ini_content = f"""
[Common]
TestSymbol={symbol}
TestExpert={expert}
TestExpertParameters={setfile}
Period={every_period}
TestFromDate={format_date(from_date)}
TestToDate={format_date(to_date)}
TestPeriod={period}
;Login=4044335
;Password=A@q6m9UH
;Server=UltimaMarkets-Demo
EnableNews=false
TestModel=0
TestSpread=10
TestDateEnable=true
TestReplaceReport=false
TestReport=MAReport
AutoConfiguration=false
EnableDDE=false
    """
    
    # Create a temporary start.ini file
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.ini') as temp_file:
        temp_file.write(start_ini_content)
        temp_start_ini_path = temp_file.name

        # Create an array to store the paths of temporary start.ini files
        temp_start_ini_paths = []

        # Calculate the number of periods
        total_days = (to_date - from_date).days
        
        interval_days = int(every_period.rstrip('D')) if every_period.endswith('D') else 1
        # Create start.ini files for each period
        current_date = from_date
        while current_date <= to_date:
            period_end = min(current_date + timedelta(days=interval_days - 1), to_date)
            
            # Ensure TestToDate is at least 1 day later than TestFromDate
            if period_end == current_date:
                period_end = current_date + timedelta(days=1)
            
            period_start_ini_content = start_ini_content.replace(
                f"TestFromDate={format_date(from_date)}",
                f"TestFromDate={format_date(current_date)}"
            ).replace(
                f"TestToDate={format_date(to_date)}",
                f"TestToDate={format_date(period_end)}"
            )
            
            with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.ini') as temp_file:
                temp_file.write(period_start_ini_content)
                temp_start_ini_paths.append(temp_file.name)

            current_date += timedelta(days=interval_days)



        # Log the created temporary start.ini files
        print("Created temporary start.ini files:")
        for idx, temp_path in enumerate(temp_start_ini_paths, 1):
            print(f"{idx}. {temp_path}")
        print(f"Total temporary files created: {len(temp_start_ini_paths)}")
        print("Running multiple reports...")

        # Run multiple reports using the temporary start.ini files
        run_multiple_reports(temp_start_ini_paths, setfile)

        # Clean up temporary files
        for temp_path in temp_start_ini_paths:
            os.unlink(temp_path)


# Example usage:
start_ini_paths = []
for _ in range(20):
    start_ini_paths.append(r"c:\btman\start.ini")

#run_multiple_reports(start_ini_paths, os.path.join(PROG_FOLDER, "TestExpertParameters.set"))

bt(symbol="AUDNZD", expert="Moving Average", setfile="TestExpertParameters.set", period="H1", from_date=datetime(2024, 5, 15), to_date=datetime(2024, 7, 31), every_period="3D")

#run_mt4_report(r"C:\btman\MOTHER_MT4\MT4_UM", r"C:\btman\start.ini", r"C:\btman\TestExpertParameters.set")