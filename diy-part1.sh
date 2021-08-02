  
#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#





# 单独拉取特定的插件或者文件，比如单独拉取插件包的luci-app-clash

# svn co https://github.com/281677160/openwrt-package/trunk/luci-app-clash package/luci-app-clash
# 这个关系就跟上面差不多了，就不多说了，重点要说的是这个链接是有改变的，怎么改变法呢？整个链接真正的链接看下面的，这个原始链接怎么来呢?比如你在别人的仓库看到某个插件，再点开那个插件的文件夹，然后在浏览器复制完整链接就是了。如果有分支的，你想要分支的插件，就先选择了分支再打开插件文件夹然后在复制链接就可以了。

# https://github.com/281677160/openwrt-package/tree/master/luci-app-clash  <--- 在浏览器上复制出来的真正链接

# https://github.com/281677160/openwrt-package/trunk/luci-app-clash        <--- 用的时候修改过的链接，认真对比一下就懂了
# 大家看清楚没有？链接里面是带有分支名称的，还有一个tree，就是这个了 tree/master 把这里替换成 trunk 就可以了，主仓库就这样拉取，如果要拉取分支的呢？也简单的，把tree改成branches就行，比如

# https://github.com/281677160/openwrt-package/tree/19.07/luci-app-eqos   <--- 在浏览器上复制出来的真正链接

# https://github.com/281677160/openwrt-package/branches/19.07/luci-app-eqos   <--- 用的时候修改过的链接

# svn co https://github.com/281677160/openwrt-package/branches/19.07/luci-app-eqos package/luci-app-eqos  <--- 完整拉取链接




# 修改openwrt登陆地址,把下面的192.168.2.2修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# 修改主机名字，把OpenWrt-123修改你喜欢的就行（不能纯数字或者使用中文）
sed -i '/uci commit system/i\uci set system.@system[0].hostname='nzsm'' package/lean/default-settings/files/zzz-default-settings

# 版本号里显示一个自己的名字（281677160 build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
sed -i "s/OpenWrt /nzsm build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# 编译K3的时候会出很多其他牌子路由器固件的，这个代码使用之后只出K3固件
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
#sed -i '$a src-git hwfuture https://github.com/hongweifuture/openwrt-packages' feeds.conf.default
#sed -i '$a src-git pwdep https://github.com/hongweifuture/pwdep.git' feeds.conf.default
#sed -i '$a src-git 281677160 https://github.com/281677160/openwrt-package' feeds.conf.default
#sed -i '$a src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default
#sed -i '$a src-git small-5 https://github.com/small-5/luci-app-adblock-plus' feeds.conf.default
#sed -i '$a src-git garypang13 https://github.com/garypang13/openwrt-packages' feeds.conf.default


svn co https://github.com/small-5/luci-app-adblock-plus package/luci-app-adblock-plus
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall package/luci-app-passwall
#svn co https://github.com/kenzok8/openwrt-packages/branches/luci-app-passwall package/luci-app-passwall


#echo '添加passwall和bypass软件源'
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
#cat feeds.conf.default
#echo '====================Add feed source OK!===================='

echo '添加jerrykuku的argon-mod主题'
rm -rf package/lean/luci-theme-argon  
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/lean/luci-theme-argon

echo '添加lwz322的K3屏幕插件'
rm -rf package/lean/luci-app-k3screenctrl
git clone https://github.com/lwz322/luci-app-k3screenctrl.git package/lean/luci-app-k3screenctrl
ls -la package/lean/ |grep luci-app-k3screenctrl
echo '====================Add k3screen Plug OK!===================='

echo '替换lwz322的K3屏幕驱动'
rm -rf package/lean/k3screenctrl
git clone https://github.com/lwz322/k3screenctrl_build.git package/lean/k3screenctrl/
#sed -i 's/@TARGET_bcm53xx_DEVICE_phicomm-k3 +@KERNEL_DEVMEM //g' package/lean/k3screenctrl/Makefile
cat package/lean/k3screenctrl/Makefile |grep DEPENDS
echo '====================Add k3screen Drive OK!===================='

#echo '移除bcm53xx中的其他机型'
#sed -i '421,453d' target/linux/bcm53xx/image/Makefile
#sed -i '140,412d' target/linux/bcm53xx/image/Makefile
#sed -i 's/k3screenctrl/luci-app-k3screenctrl/g' target/linux/bcm53xx/image/Makefile
#cat target/linux/bcm53xx/image/Makefile |grep DEVICE_PACKAGES
#echo '====================Remove other devices of bcm53xx!===================='

echo '替换K3的无线驱动为asus-dhd24'
wget -nv https://github.com/Hill-98/phicommk3-firmware/raw/master/brcmfmac4366c-pcie.bin.asus-dhd24 -O package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
#echo '替换K3的无线驱动为ac86u'
#wget -nv https://github.com/Hill-98/phicommk3-firmware/raw/master/brcmfmac4366c-pcie.bin.ac88u -O package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
#echo '替换K3的无线驱动为69027'
#wget -nv https://github.com/Hill-98/phicommk3-firmware/raw/master/brcmfmac4366c-pcie.bin.69027 -O package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
echo '====================Replace k3wireless firmware OK!===================='
© 2021 GitHub, Inc.
