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

**setup can interface**
```bash
sudo ip link set can0 down && \
sudo ip link set can0 type can bitrate 500000 && \
sudo ip link set dev can0 txqueuelen 1000 && \
sudo ip link set can0 up

# Check the settings
ip -details link show can0

# Detail settings/status (e.g., errors)
ip -details -statistics link show can0
```


# Debug

Access to serial:
```bash
$ screen /dev/cu.usbmodem21303 115200

# Kill the current window:
# 1. Press Ctrl + A
# 2. Press k (lowercase)Type
```
