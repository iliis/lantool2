#!/bin/bash
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile # RAILS_RELATIVE_URL_ROOT='/lan'
