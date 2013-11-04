Cheap recreation of Dead Man's Snitch, which alerts you when a cron job doesn't succeed as expected.

At the end of a cron job, curl a URL like this:
# curl https://<your_poor_mans_snitch>.herokuapp.com/write/your_cron_job

In Pingdom or Wormly, monitor this URL:
https://<your_poor_mans_snitch>.herokuapp.com/read/your_cron_job/2h

The "read" URL will return a 500 if the "write" URL hasn't been hit within the last two hours.

To run on Heroku:
# git clone https://github.com/apeckham/poormanssnitch.git
# cd poormanssnitch
# heroku create mypoormanssnitch
# heroku addons:add rediscloud
# git push heroku master