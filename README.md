# conky


```bash
apt-get install -y jq lm-sensors conky-all curl gcalcli sox zenity imagemagick nmap net-tools ncal
sensors-detect
gcalcli agenda
cd ~
#Execute sudo in case you do not have permissions for port stats in ~/.conky/.conkyrc

git clone https://github.com/reekol/conky.git ./.conky

```
![Example](./demo.png)

## Create ./.myconkyrc containing:

```
conky.config = {
    background=true,
}

conky.text = [[
 ${exec cd ~/.conky/ && conky -c ./.conkyrc }
 ${exec cd ~/.conky/ && zenity --password | sudo -S echo 1 && for i in $(ls ./.conky-*); do conky -c $i; done }
]]

```

## Configation is stored in *./.config* file
## To start use:

```bash
conky -c ./.myconkyrc
```
