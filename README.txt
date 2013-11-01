Cheap recreation of deadmanssnitch, which alerts you when a cron job doesn't succeed as expected.

At the end of a cron job, curl a URL like this:
https://deadmanssnitch.herokuapp.com/write/YourCronJob

In Pingdom or Wormly, monitor this URL:
https://deadmanssnitch.herokuapp.com/read/YourCronJob/2h

The "read" URL will return a 500 if the "write" URL hasn't been hit within the last two hours. Change "2h" to "2d" or "two weeks" -- that string is parsed by chronic_duration.
