import threading
import time
import random

# Total number of threads to be created
total_threads = 10

# Counter for finished threads
finished_threads = 0

# Lock to protect the finished_threads counter
counter_lock = threading.Lock()

# Function to run in a thread
def thread_function(thread_id):
    global finished_threads
    print(f"Thread {thread_id} starting")
    # Simulate some work with random sleep time
    
    time.sleep(random.uniform(1, 10))
    #print(f"Thread {thread_id} finished")
    
    # Safely update the finished threads counter
    with counter_lock:
        finished_threads += 1

# Function to display the progress in real-time
def display_progress():
    while True:
        with counter_lock:
            print(f"\rThreads finished: {finished_threads}/{total_threads}", end="", flush=True)
        # Break the loop when all threads are finished
        if finished_threads == total_threads:
            break
        time.sleep(1)

# Create threads
threads = []
for i in range(total_threads):
    t = threading.Thread(target=thread_function, args=(i,))
    threads.append(t)
    t.start()

# Start the progress display thread
progress_thread = threading.Thread(target=display_progress)
progress_thread.start()

# Wait for all threads to complete
for t in threads:
    t.join()

# Wait for the progress display thread to finish
progress_thread.join()

print("\rAll threads have finished.")
