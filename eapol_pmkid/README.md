
# EAPOL PMKID

## Setup

```bash
chmod +x ./0_clear_all ./1_setup_mon ./2_start_capture ./3_analyze_capture

sudo ./install_requirements
```

## Usage

```bash
ifconfig
# i.e. WLANDEV=wlx0022c01b6254

sudo ./1_setup_mon $WLANDEV
sudo ./2_start_capture $WLANDEV
sudo ./3_analyze_capture
```
