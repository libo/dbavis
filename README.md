# dbavis

Simple script to check when there is a <b>Google Pixel<b> to buy on the “eBay of Denmark” and notify you via email. You can easily modify to look for other stuff.

## Install

```
bundle install
ruby script.rb <email-to-notify@domain.com>
```

Generally you would run this via crond

This example runs it every 10 minutes and give for granted you are running `rbenv`:
```
*/10 * * * * /bin/bash -c 'export PATH="$HOME/.rbenv/bin:$PATH" ; eval "$(rbenv init -)"; cd <path to dbavis>; ruby ~/dbavis/script.rb <email-to-notify@domain.com>' > /dev/null 2>&1
```

You might want to look into Amazon SES E-mail service to send out email. They have a free plan with 200 deliveries a day. You just need to white-list the email you want to notify and configure Postfix to use their SMPT.


