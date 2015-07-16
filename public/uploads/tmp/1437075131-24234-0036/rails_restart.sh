#!/bin/bash
res=$(curl -I 192.168.0.9 | grep "HTTP/" |  awk {'print $2'})
if [ "$res" -ne 200 ] 
	then {
#/home/ror/rails/komit_api/

		if [ -f /home/ror/rails/komit_api/shared/pids/unicorn.pid ] 
		then {
 		kill  `cat /home/ror/rails/komit_api/shared/pids/unicorn.pid`
		}
		fi;	

		cd /home/ror/rails/komit_api/current/
		#source ~/.bash_profile
		bundle exec unicorn -c /home/ror/rails/komit_api/current/config/unicorn.rb -E production -D
		echo "unicorn restart"
	}
fi;
## sites/faqdb/shared/unicorn.sock

#!/bin/bash
res=$(curl -I faqdb.ru | grep "HTTP/" |  awk {'print $2'})
if [ "$res" -ne 200 ]
        then {

                if [ -f /home/www/sites/faqdb/shared/pids/unicorn.pid ]
                then {
                        kill  `cat /home/www/sites/faqdb/shared/pids/unicorn.pid`
                }
                fi;

                if [ -S /home/www/sites/faqdb/shared/unicorn.sock ]
                then
                        rm /home/www/sites/faqdb/shared/unicorn.sock
                fi

                #cd /home/www/sites/faqdb/current/
                #source ~/.bash_profile
                rvm_version=$(~/.rvm/bin/rvm current)
                cd /home/www/sites/faqdb/current && ( RAILS_ENV=production ~/.rvm/bin/rvm $rvm_version do bundle exec unicorn -c /home/www/sites/faqdb/current/config/unicorn.rb -D )
                #bundle exec unicorn -c /home/www/sites/faqdb/current/config/unicorn.rb -E production -D
                echo "unicorn restart"
        }
fi;

rests=$(curl -I 'faqdb.ru/search?utf8=✓&q=google' | grep "HTTP/" |   awk {'print $2'})
if [ "$rests" -ne 200 ]
        then {
                if [ -f /home/www/sites/faqdb/current/log/production.sphinx.pid ]
                then {
                kill `cat /home/www/sites/faqdb/current/log/production.sphinx.pid`
        }
        fi;

                #cd /home/www/sites/faqdb/current/
                rvm_version=$(~/.rvm/bin/rvm current)
                cd /home/www/sites/faqdb/current && ( RAILS_ENV=production ~/.rvm/bin/rvm $rvm_version do rake ts:start)
                #source ~/.bash_profile
                #rake ts:start  RAILS_ENV=production
                }
fi;

