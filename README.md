# Build & Flush

**Using CubeIDE**
Press the `Run` button to build and flush the firmware.

**Using Cube CLI**

Build & Flash the firmware using STM32_Programmer_CLI:

```bash
# First time
just import

# Build
just build

# Flash
just flash
```


# Debug

Access to serial:
```bash
$ screen /dev/cu.usbmodem21303 115200

# Kill the current window:
# 1. Press Ctrl + A
# 2. Press k (lowercase)Type
```
