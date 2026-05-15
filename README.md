# ⏱️ Pace Converter

**PaceConverter** is a specialized Garmin Connect IQ app designed for track athletes and runners. It eliminates the need for "track math" by instantly converting your target pace into the exact time (hours, minutes, seconds) required to cover specific distances.

Whether you're hitting 400m repeats or 5km intervals, Pace Converter tells you exactly what time your watch should show at every checkpoint.
PaceConverter calculates the required time for etch distance define in the app.


## Getting Started

### Prerequisites & Setup

To run or modify this app, you need the Garmin **Connect IQ (CIQ)** environment:

1.  **Install VS Code:** Download [Visual Studio Code](https://code.visualstudio.com/).
2.  **Get the SDK:** Use the [Garmin SDK Manager](https://developer.garmin.com/connect-iq/sdk/) to download the Monkey C SDK and Device Skins.
3.  **Monkey C Extension:** Install the "Monkey C" extension inside VS Code.
4.  **Developer Key:** Generate a developer key ($Ctrl+Shift+P$ -> `Connect IQ: Generate a Developer Key`).
   
    (full tutorial in the [garmin developers docs](https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/))


---
### Installing & Executing program

1. Clone the Project - ```git clone https://github.com/random551923/almond-ipam.git```

2. Press $Ctrl+Shift+P$ to open the Command Palette.

3. Type and select Monkey C: Build Project.

4. Choose a device to simulate (e.g. Fenix 7).


---

### ⌚ Executing App on Your Physical Watch 

#### 1. Build the PRG File
1.  In VS Code, press `Ctrl+Shift+P`.
2.  Select Monkey C: Build For Device.
3.  Choose your specific watch model (e.g., *Forerunner 255* or *Fenix 7*).
4.  Choose a folder to save the output; this will generate a `.prg` file.

#### 2. Connect Your Watch
*   Connect your watch to your computer via USB.
*   Windows/Mac (Mass Storage): It should appear as a USB drive.

#### 3. Sideload the App
1.  Open the watch drive on your computer.
2.  Navigate to the folder: `/GARMIN/APPS/`.
3.  Copy your generated `.prg` file into this `/APPS/` folder.
4.  Safely eject/disconnect your watch.

#### 4. Launch
The app will appear in your watch's **Activities & Apps** list (usually at the very bottom).
