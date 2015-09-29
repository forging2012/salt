#!/bin/bash
#Version 1.9
#Auth: guomaoqiu
#For CentOS_mini
#Made on 2015-06-19
echo "   "
echo "#############################################################################"
echo "#  Initialize for the CentOS 6.4/6.5 mini_installed.                        #"
echo "#                                                                           #"
echo "#  Please affirm this OS connected net already before running this script ! #" 
echo "#                                                                           #"
echo "#  must first connect to the Internet. because yum need it.                  #"
echo "#############################################################################"
echo "   "

format() {
          #echo -e "\033[42;37m ########### Finished ########### \033[0m"        
          sleep 5
          echo -e "\033[42;37m ########### Finished ########### \033[0m" 
          echo "  "
         }

##########################################################################
# Set time 时区/时间同步设置
echo "Set time."	
/bin/cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &> /dev/null
yum -y install ntpdate &> /dev/null
ntpdate  0.centos.pool.ntp.org &> /dev/null
hwclock -w
format

####################################################################################
#Set network 网卡开机自启动
#sed -i "s/ONBOOT=no/ONBOOT=yes/g"  /etc/sysconfig/network-scripts/ifcfg-eth0
#sed -i "s/NM_CONTROLLED=no/NM_CONTROLLED=no/g"/etc/sysconfig/network-scripts/ifcfg-eth0
#/etc/init.d/network restart &>/dev/null
#echo "==================================" >> $LOG
#format

##########################################################################
# Create Log 创建该脚本运行记录日志
echo "Create log file."
DATE1=`date +"%F %H:%M"`
LOG=/var/log/sysinitinfo.log
echo $DATE1 >> $LOG
echo "------------------------------------------" >> $LOG
echo "For CentOS_mini" >> $LOG
echo "==================================" >> $LOG
echo "Set timezone is Shanghai" >> $LOG
echo "Finished ntpdate" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Disabled Selinux 禁用Selinux
echo "Disabled SELinux."
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
echo "=================================================="
echo "Disabled SELinux." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Stop iptables 禁用iptables
echo "Stop iptables."
service iptables stop &> /dev/null
chkconfig --level 35 iptables off
echo "Stop iptables." >> $LOG
echo "==================================" >> $LOG
format


###########################################################################
# Disable ipv6 禁用IPV6
echo "Disable ipv6."
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
chkconfig --level 35 ip6tables off
echo "Disable ipv6.">> $LOG
echo "==================================" >> $LOG
format

##########################################################################
#Set history commands  设置命令历史记录参数
echo "Set history commands."
echo "HISTFILESIZE=4000" >> /etc/bashrc
echo "HISTSIZE=4000" >> /etc/bashrc
echo "HISTTIMEFORMAT='%F/%T'" >> /etc/bashrc
source /etc/bashrc
echo "==================================" >> $LOG
format


##########################################################################
# Epel 升级epel源
echo "Install epel"
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm &> /dev/null
sed -i "s/^#base/base/g" /etc/yum.repos.d/epel.repo
sed -i "s/^mirr/#mirr/g" /etc/yum.repos.d/epel.repo
echo "=================================================="
echo "Install epel" >> $LOG
echo "==================================" >> $LOG
format

##########################################################################
#Yum install Development tools  安装开发包组及必备软件
echo "Install Development tools(It will be a moment,wait......)"
yum groupinstall -y "Development tools" &> /dev/null
#yum groupinstall -y "Server Platform Development" &> /dev/null
#yum groupinstall -y "Desktop Platform Development" &> /dev/null
#yum groupinstall -y "chinese-support" &>/dev/null
 yum -y install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes  cmake libcom_err-devel.i686 libcom_err-devel.x86_64
echo "=================================================="
echo "Install Development tools" >> $LOG
echo "==================================" >> $LOG
format

##########################################################################
# Yum update bash and openssl  升级bash/openssl
echo "Update bash and openssl"
yum -y update bash &> /dev/null
yum -y update openssl &> /dev/null
echo "=================================================="
echo "Update bash and openssl" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Set ssh 设置ssh登录策略
echo "Disabled EmptyPassword."
echo "Disabled SSH-DNS."
echo "Set timeout is 6m."
sed -i "s/^#PermitEmptyPasswords/PermitEmptyPasswords/" /etc/ssh/sshd_config
sed -i "s/^#LoginGraceTime 2m/LoginGraceTime 6m/" /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config 
echo "=================================================="
echo "Disabled EmptyPassword." >> $LOG
echo "Disabled SSH-DNS." >> $LOG
echo "Set timeout is 6m." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Set default init 3  设置系统默认初始化
echo "Default init 3."
sed -i 's/^id:5:initdefault:/id:3:initdefault:/' /etc/inittab
echo "=================================================="
echo "Default init 3." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Stop Service  关闭不必要的服务
echo "Some services are turned off now."
for SER in rpcbind postfix portreserve certmonger mdmonitor blk-availability lvm2-monitor udev-post cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans messagebus microcode_ctl netfs nfs nfslock nscd acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed pcscd portmap readahead_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd
 do
    /sbin/chkconfig --list $SER &> /dev/null
  if [ $? -eq 0 ]
    then
      chkconfig --level 35  $SER off
    echo "$SER" >> $LOG
  fi
 done
echo "=================================================="
echo "Some services are turned off now:" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Del unnecessary users 删除不必要的用户
echo "Del unnecessary users."
for USERS in adm lp sync shutdown halt mail news uucp operator games gopher
 do
  grep $USERS /etc/passwd &>/dev/null
  if [ $? -eq 0 ]
   then
    userdel $USERS &> /dev/null
    echo $USERS >> $LOG
  fi
 done
echo "=================================================="
echo "Del unnecessary users." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Del unnecessary groups 删除不必要的用户组
echo "Del unnecessary groups."
for GRP in adm lp mail news uucp games gopher mailnull floppy dip pppusers popusers slipusers daemon
 do
  grep $GRP /etc/group &> /dev/null
  if [ $? -eq 0 ]
   then
    groupdel $GRP &> /dev/null
    echo $GRP >> $LOG
  fi
 done
echo "=================================================="
echo "Del unnecessary groups." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Disabled reboot by keys ctlaltdelete 禁用ctlaltdelete重启功能
echo "Disabled reboot by keys ctlaltdelete"
sed -i 's/^exec/#exec/' /etc/init/control-alt-delete.conf
echo "=================================================="
echo "Disabled reboot by keys ctlaltdelete" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Set ulimit  设置文件句柄数
echo "Set ulimit 1000000"
echo "*    soft    nofile  1000000" >> /etc/security/limits.conf
echo "*    hard    nofile  1000000" >> /etc/security/limits.conf
echo "*    soft    nproc 102400" >> /etc/security/limits.conf
echo "*    hard    nproc 102400" >> /etc/security/limits.conf
sed -i 's/102400/1000000/' /etc/security/limits.d/90-nproc.conf
echo "=================================================="
echo "Set ulimit 1000000" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Record SUID and SGID files 
DATE2=`date +"%F"`
echo "Record SUID and SGID files."
echo "SUID --- " > /var/log/SuSg_"$DATE2".log
find / -path '/proc'  -prune -o -perm -4000 >> /var/log/SuSg_"$DATE2".log
echo "------------------------------------------------------ " >> /var/log/SuSg_"$DATE2".log
echo "SGID --- " >> /var/log/SuSg_"$DATE2".log
find / -path '/proc'  -prune -o -perm -2000 >> /var/log/SuSg_"$DATE2".log
echo "=================================================="
echo "Record SUID and SGID." >> $LOG
echo "Record is in /var/log/SuSg_"$DATE2".log" >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Disabled crontab send mail 禁用执行任务计划时向root发送邮件
echo "Disable crontab send mail."
sed -i 's/^MAILTO=root/MAILTO=""/' /etc/crontab 
sed -i 's/^mail\.\*/mail\.err/' /etc/rsyslog.conf
echo "=================================================="
echo "Disable crontab send mail." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Set ntp client 设置时间服务客户端
echo "Set ntp client."
SED() {
    cp -p /etc/ntp.conf /etc/ntp.conf.bak
    sed -i '/^server/d' /etc/ntp.conf
    sed -i '/^includefile/ i\server 0.centos.pool.ntp.org iburst' /etc/ntp.conf
    sed -i '/0.centos.pool.ntp.org/ a\server 1.centos.pool.ntp.org iburst' /etc/ntp.conf
    sed -i '/1.centos.pool.ntp.org/ a\server 2.centos.pool.ntp.org iburst' /etc/ntp.conf
    sed -i '/2.centos.pool.ntp.org/ a\server 3.centos.pool.ntp.org iburst' /etc/ntp.conf
    chkconfig --level 35 ntpd on &> /dev/null
    echo "=================================================="
}
rpm -q ntp &> /dev/null
if [ $? -eq 0 ]
  then
    SED
  else
   yum -y install ntp &> /dev/null
   SED
fi
echo "Set ntp client." >> $LOG
echo "==================================" >> $LOG
format

###########################################################################
# Set sysctl.conf 设置内核参数
echo "Set sysctl.conf"
#:web应用中listen函数的backlog默认会将内核参数的net.core.somaxconn限制到128，而nginx定义的NGX_LISTEN_BACKLOG默认是511，所以必须调整,一般调整为2048
echo "net.core.somaxconn = 2048" >> /etc/sysctl.conf

echo "net.core.rmem_default = 262144" >> /etc/sysctl.conf
echo "net.core.wmem_default = 262144" >> /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 4096 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 4096 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 786432 2097152 3145728" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 16384" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 20000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_orphans = 131072" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf
echo "Set sysctl.conf ---- " >> $LOG
/sbin/sysctl  -p >> $LOG
echo "==================================" >> $LOG
format
###########################################################################
# Done
echo "Finished,You can check infomations in $LOG ."
#echo "System will reboot in 60s."
#shutdown -r 1

