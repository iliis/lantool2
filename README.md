lantool2
========

Complete reimplementation of lantool in Rails. No more ugly PHP.

Status: __In Planning. Not much real content so far.__


New Features (planned)
============

- Management of multiple LANs.
- Complete integration of registration, polls, payments and mailing-list into one tool.
- Easy synchronization to other server (for offline use).


Random Ideas (implement if bored)
============

- Fetch gravatars (and chache them locally for offline usage).
- for more stuff: see https://github.com/iliis/lantool/issues


Installation
============

1. Clone into new directory.
1. Run `bundle install`
1. Run `rake db:migrate` to create the appropriate databases
1. Configure databases in `config/database.yml`
1. Configure stuff in `config/environments/development.erb` / `production.erb`
1. Configure stuff in `config/initializers/settings.rb` (alternatively, you can also set these things in the database. Use `rails console` and `Settings.foo = "bar"`.)
