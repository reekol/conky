# conky


```bash
apt-get install -y jq lm-sensors conky-all curl gcalcli sox
sensors-detect
gcalcli agenda
cd ~
#Execute sudo in case you do not have permissions for port stats in ~/.conky/.conkyrc
sudo ping -c 1 -w 1 127.0.0.1
git clone https://github.com/reekol/conky.git ./.conky
cd ./.conky
bash start.sh
```
![Example](./demo.png)
