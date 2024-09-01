# rtop
**rtop** is a performance monitor designed for the Rockchip RK3566/68/88 processors.<br>

![Screenshot_20240807_111347](https://github.com/user-attachments/assets/7cace014-41de-4bfb-ba25-27138e74c6f3)
<br>

## rtop for the original Rock OS.<br/>
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)<br/><br/>
Specifically built for Rockchip processors using Qt5 by [Q-engineering](https://qengineering.eu/)

##### If you have the Ubuntu OS by Joshua Riek, please install https://github.com/Qengineering/rtop-Ubuntu

------------

## Installing rtop.
To install **rtop**, download the repository, make the install script executable, and run it:<br/>
```script
$ git clone https://github.com/Qengineering/rtop-KDE.git
$ cd rtop-KDE.git
$ sudo chmod +x ./install_rtop.sh 
$ sudo ./install_rtop.sh 
```

------------

## Running rtop.
To run **rtop** from the command line in the terminal:<br/> 
```
$ rtop
```
![Screenshot_20240807_111431](https://github.com/user-attachments/assets/ae2d2d4f-0154-46cd-8f80-5e80482ceb3b)


------------

## Permissions.
As noted in the appendix, some information requires sudo permissions.<br>
The installation script should handle this automatically.<br><br>
If you don't see RGA bars, it could indicate a permissions issue.<br>
To resolve this, try running **rtop** with sudo:<br>
```
$ sudo /usr/local/bin/rtop
```
Alternatively, you can disable the password prompt globally using `sudo visudo`.<br><br>
If the NPU bars are not visible, ensure the NPU is enabled by following the commands provided in the appendix.<br>

------------

## Qt5.
For your convenience, the Qt5 code is included.<br/> 

------------

### Appendix.
The used commands are:<br/> 
```
#CPU load
$ cat /proc/stat
#CPU freq
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq (or cpu1, cpu2 etc)
#GPU load
$ cat /sys/class/devfreq/fb000000.gpu/load
#GPU freq
$ cat /sys/class/devfreq/fb000000.gpu/cur_freq
#NPU load
$ sudo cat /sys/kernel/debug/rknpu/load
#NPU freq
$ cat /sys/class/devfreq/fdab0000.npu/cur_freq
#RGA load
$ sudo cat /sys/kernel/debug/rkrga/load
#RGA freq
$ sudo cat /sys/kernel/debug/clk/clk_summary | grep rga
#MEM
auto memInfo = readMemInfo(); (C++)
#SWAP
auto memInfo = readMemInfo(); (C++)
#TEMP
$ cat /sys/class/thermal/thermal_zone0/temp
#FAN
$ cat /sys/class/thermal/cooling_device4/cur_state
#DEVICE
$ cat /sys/firmware/devicetree/base/compatible

```

------------

[![paypal](https://qengineering.eu/images/TipJarSmall4.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CPZTM5BB3FCYL) 
