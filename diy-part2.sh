#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# echo >> feeds.conf.default
# echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
# echo 'src-git jerrykuku https://github.com/jerrykuku/luci-app-jd-dailybonus.git;master' >> feeds.conf.default
# ./scripts/feeds update nas
# ./scripts/feeds install -a -p nas
# it clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git

# svn co https://github.com/small-5/Openwrt-Compile/trunk/Small_5/package/ipk/luci-app-adblock-plus package/luci-app-adblock-plus

svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-dnsfilter package/luci-app-dnsfilter
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-passwall  package/luci-app-passwall
# svn co https://github.com/281677160/openwrt-package/trunk/luci-theme-neobird package/luci-theme-neobird
