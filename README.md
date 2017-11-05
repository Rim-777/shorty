## Introduction

Cute-Urls. - Ruby Grape application for REST API with ActiveRecord, RSpec

## Dependencies:
- Ruby 2.4.2
- PostgreSQL

## Using Docker:

To run application on docker:

- Install Docker and Docker-Compose
- Clone the project
- Run these commands on project root:

```shell
$ docker-compose build
$ docker-compose up

# Open another terminal and run:
$ docker-compose run web bundle exec rake db:create db:migrate
```

## Tests:

To execute tests, run following commands:
 
```shell
 $ docker-compose run web bundle exec rspec
```

## License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).