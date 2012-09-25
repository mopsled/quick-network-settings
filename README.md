# QuickNet

## About
QuickNet is a fast network settings viewer. Common network settings such as interface MAC addresses, internal and external IP addresses, gateway, and wifi information are displayed. All information in the application is copyable for ease of emailing or saving for future reference.

Note: iOS applications are unable to change the network settings displayed in this application. This information displayed in QuickNet is read-only.

## Complexities

Most of the information in QuickNet can be found in the [System Configuration](http://developer.apple.com/library/ios/documentation/Networking/Reference/SysConfig/_index.html#//apple_ref/doc/uid/TP40001027) framework or built-in unix libraries. However, the gateway information for the current network (obtained through DHCP) is not publicly accessible.

In this application, the application guesses the gateway by using a modified version of [Apple's SimplePing example](https://developer.apple.com/library/mac/#samplecode/SimplePing/Introduction/Intro.html#//apple_ref/doc/uid/DTS10000716-Intro-DontLinkElementID_2) to send a ping with a TTL of 1. Essentially, this acts as a very simple traceroute, and may return the gateway as the first hop. Given that this hack relies on ICMP to work, the first hop may drop the packet and cause the gateway cell to continue waiting for a response.

## Screenshots
![Main Screen](http://mopsled.github.com/quick-network-settings/images/main.png)
![Interface Screen](http://mopsled.github.com/quick-network-settings/images/interface.png)

## License
This code contains, in part, a compilation of code from non-original sources. Those sections of code that are not original retain their original licenses. Otherwise, all code that is original to this project is released under the MIT license, and you are free to reuse or change it in whatever way you want.

Non-original code:
- AFNetworking - [Check out this wonderful networking library on github](https://github.com/AFNetworking/AFNetworking)
- NICInfo - Code found online. See the `NICInfo.h` for license

Note: The SimplePing library has been changed, and by the previous license does not retain the previous copyright.