#!/bin/bash
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT='/lan'
