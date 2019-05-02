#!/bin/bash
#
# Bash script for system administrators to
# maintain the /etc/resolv.conf file or even
# use their own resolver configuration file.
#
# (root)Usage:
# presolv [option] [type] [value]
#
# (user)Usage :
# presolv -f [file] [option] [type] [value]
#
if [ $UID != 0 ] && [ $# == 0 ]
then
	echo "You must be root to modify /etc/resolv.conf, use the -f option"
        exit 0
fi
#Check if user is root
if [ $UID == 0 ]
then     
	if [ $# == 0 ]
        then
                cat /etc/resolv.conf
                exit 1
	fi

        ipadd=$(echo $3 | egrep '^(25[0-5].|2[0-4][0-9].|1[0-9][0-9].|[0-9][0-9].|[0-9].)
                                		{3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])$')

        if [ $1 == '-a' ] && [ $2 == 'nameserver' ] && [ "$ipadd" != "" ]
        then
                echo $2 $ipadd >> /etc/resolv.conf
        elif [ $1 == '-d' ] && [ $2 == 'nameserver' ] && [ "$ipadd" != "" ]
        then
                sed -i "/$2 $ipadd/d" /etc/resolv.conf
        elif [ $1 == '-a' ] && [ $2 == 'domain' ] && [ "$3" != "" ]
        then
                domain=$(echo $3 | grep '\.')
                if [ "$domain" != "" ]
                then
                echo $2 $3 >> /etc/resolv.conf
                fi
        elif [ $1 == '-d' ] && [ $2 == 'domain' ] && [ "$3" != "" ]
        then
                sed -i "/$2 $3/d" /etc/resolv.conf
        elif [ $1 == '-a' ] && [ $2 == 'search' ] && [ "$3" != "" ]
        then
		search=$(echo $3 | grep '\.')
                if [ "$search" != "" ]
                then
                echo $2 $3 >> /etc/resolv.conf
                fi
        fi

        if [ $1 = '-a' ] && [ $2 == 'sortlist' ] && [ "$3" != "" ] && [ "$4" != "" ]
        then
                ip=$(echo $3 | tr '/' '\n' | head -1 | egrep '^(25[0-5].|2[0-4][0-9].|1[0-9][0-9].|[0-9][0-9].|[0-9].)
                                                               		 {3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])$')
                ip2=$(echo $3 | tr '/' '\n' | tail -1 | egrep '^(25[0-5].|2[0-4][0-9].|1[0-9][0-9].|[0-9][0-9].|[0-9].)
                                                               		 {3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])$')
                ip3=$(echo $4 | egrep '^(25[0-5].|2[0-4][0-9].|1[0-9][0-9].|[0-9][0-9].|[0-9].)
                                        		{3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])$')

                if [ "$ip" != "" ] && [ "$ip2" != "" ] && [ "$ip3" != "" ]
                then
                        echo $2 $3 $4 >> /etc/resolv.conf
                fi
        fi

        if [ $1 == '-d' ] && [ $2 == 'options' ] && [ "$3" != "" ]
        then
                optiontype=$(echo $3 | grep 'timeout:\|attempts:\|rotate')
		timeout=$(echo $3 | cut -c9- | egrep '^([1-9]|1[0-9]|2[0-9]|30)$')
                attempts=$(echo $3 | cut -c10- | egrep '^([1-5])$')

                if [ "$optiontype" != "" ] && [ "$timeout" != "" ]
                then
                        sed -i "/$2 $3/d" /etc/resolv.conf
                elif [ "$optiontype" != "" ] && [ "$attempts" != "" ]
                then
                        sed -i "/$2 $3/d" /etc/resolv.conf
                elif [ $optiontype == 'rotate' ]
                then
                        sed -i "/$2 $3/d" /etc/resolv.conf
                fi
        fi

        if [ $1 == '-a' ] && [ $2 == 'options' ] && [ "$3" != "" ] && [ "$4" == "" ]
        then
                optiontype=$(echo $3 | grep 'timeout:\|attempts:\|rotate')
                timeout=$(echo $3 | cut -c9- | egrep '^([1-9]|1[0-9]|2[0-9]|30)$')
                attempts=$(echo $3 | cut -c10- | egrep '^([1-5])$')

                if [ "$optiontype" != "" ] && [ "$timeout" != "" ]
                then
                        echo $2 $optiontype >> /etc/resolv.conf
                elif [ "$optiontype" != "" ] && [ "$attempts" != "" ]
                then
                        echo $2 $optiontype >> /etc/resolv.conf
                elif [ $optiontype == 'rotate' ]
                then
                        echo  $2 $optiontype >> /etc/resolv.conf
                fi
        fi

        if [ $1 == '-a' ] && [ $2 == 'options' ] && [ "$3" != "" ] && [ "$4" != "" ] && [ "$5" == "" ] || [ "$5" != "" ]
        then
                optiontype=$(echo $3 | tr ':' '\n' | head -1 | grep 'timeout\|attempts\|rotate')
                timeout=$(echo $3 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-9]|1[0-9]|2[0-9]|30)$')
                attempts=$(echo $3 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-5])$')

                optiontype2=$(echo $4 | tr ':' '\n' | head -1 | grep 'timeout\|attempts\|rotate')
                timeout2=$(echo $4 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-9]|1[0-9]|2[0-9]|30)$')
                attempts2=$(echo $4 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-5])$')

		optiontype3=$(echo $5 | tr ':' '\n' | head -1 | grep 'timeout\|attempts\|rotate')
                timeout3=$(echo $5 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-9]|1[0-9]|2[0-9]|30)$')
                attempts3=$(echo $5 | tr ':' '\n' | head -2 | tail -1 | egrep '^([1-5])$')

                if [ "$optiontype" != "$optiontype2" ] && [ "$optiontype" != "$optiontype3" ]
                then
                        if [ "$optiontype" == 'timeout' ] && [ "$timeout" >  '0' ] && [ "$timeout" -le  '30' ]
                        then
                                echo $2 $3 >> /etc/resolv.conf
                        elif [ "$optiontype" == 'attempts' ] && [ "$attempts" > '0' ] && [ "$attempts" -le '5' ]
                        then
                                echo $2 $3 >> /etc/resolv.conf
                        elif [ "$optiontype" == 'rotate' ]
                        then
                                echo $2 $3 >> /etc/resolv.conf
                        fi
                fi

                if [ "$optiontype2" != "$optiontype" ] && [ "$optiontype2" != "$optiontype3" ]
                then
                        if [ "$optiontype2" == 'timeout' ] && [ "$timeout2" >  '0' ] && [ "$timeout2" -le  '30' ]
                        then
                                echo $2 $4 >> /etc/resolv.conf
                        elif [ "$optiontype2" == 'attempts' ] && [ "$attempts2" > '0' ] && [ "$attempts2" -le '5' ]
                        then
                                echo $2 $4 >> /etc/resolv.conf
                        elif [ "$optiontype2" == 'rotate' ]
                        then
                                echo $2 $4 >> /etc/resolv.conf
                        fi
                fi
                if [ "$optiontype3" != "$optiontype" ] && [ "$optiontype3" != "$optiontype2" ]
                then
                        if [ "$optiontype3" == 'timeout' ] && [ "$timeout3" >  '0' ] && [ "$timeout3" -le  '30' ]
                        then
                                echo $2 $5 >> /etc/resolv.conf
                        elif [ "$optiontype3" == 'attempts' ] && [ "$attempts3" > '0' ] && [ "$attempts3" -le '5' ]
                        then
                                echo $2 $5 >> /etc/resolv.conf
                        elif [ "$optiontype3" == 'rotate' ]
                        then
                                echo $2 $5 >> /etc/resolv.conf
                        fi
	 fi
        fi
fi

#Check if user is not root.
if [ $UID -gt 0 ]
then
        
	if [ $1 != '-f' ]
	then	
		echo "You must be root to modify /etc/resolv.conf, use the -f option"
        	exit 0
	fi
	
	if [ $1 == '-f' ] && [ "$2" != "" ] && [ "$3" == "" ]
        	then
		if [ -a $2 ]
                	then
                        		cat ./$2
                        		exit 1
		else			
			echo "File must be in your PWD."
			exit 2
                	fi
        	fi

        file=$(ls ./ | grep -w "$2$")
        ipadd=$(echo $5 | egrep '^(25[0-5].|2[0-4][0-9].|1[0-9][0-9].|[0-9][0-9].|[0-9].){3}
				(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])$')

        if [ $1 == '-f' ] && [ "$2" != "" ] && [ $3 == '-a' ] && [ $4 == 'nameserver' ] && [ "$5" != "" ]
        then
                if [ "$file" != "" ] && [ "$ipadd" != "" ]
                then
                        echo $4 $ipadd >> $file
                fi
        elif [ $1 == '-f' ] && [ "$2" != "" ] && [ "$3" == '-d' ] && [ $4 == 'domain' ] && [ "$5" != "" ]
        then
                if [ "$file" != "" ]
                then
                        sed -i "/$4 $5/d" $file
                fi
        elif [ $1 == '-f' ] && [ "$2" != "" ] && [ "$3" == '-a' ] && [ $4 == 'search' ] && [ "$5" != "" ]
        then
                search=$(echo $5 | grep '\.')
                if [ "$file" != "" ] && [ "$search" != "" ]
                then
                        echo $4 $5 >> $file
                fi
        fi
fi
