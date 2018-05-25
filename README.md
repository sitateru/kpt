# 概要

KPT用のApplicaitonを作成するためのWebAPI


## 開発フロー

- Githubフローとし、masterがmain repositoryです
- PullRequestを出して開発を行う
- 追加コードには、それをカバーするRspecを必須とする


## 仕様について

- KPTはIssueモデルとして扱い、Keep, Problem, Statusをstatusとして持つ

## Getting Start(for MacOS)

- `$ brew update`
- `$ brew install postgresql`
- `$ brew install ruby-build`


- `$ rbenv install ${RUBY_VERSION}`
- `$ cd ${this_repo}`
- `$ gem install bundler foreman`
- `$ bundle install` 
- `$ foreman start`
- `$ rails db:create db:migrate`

localhost:8000 にアクセス

## Getting Start(for Docker)

- install Docker for Mac https://docs.docker.com/docker-for-mac/install/

- `$ cd ${this_repo}`
- `$ docker-compose build`
- `$ docker-compose up -d`
- `$ docker ps`
- `$ docker-compose run web rake db:create db:migrate`

localhost:8000 にアクセス

## 参考資料

- http://guides.rubyonrails.org/
- http://www.betterspecs.org/jp/
- https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
- https://qiita.com/_daisuke/items/13996621cf51f835494b
- http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md


## カバレッジ

[![Coverage Status](https://coveralls.io/repos/github/sitateru/kpt/badge.svg?branch=add-coverall-add-coverage)](https://coveralls.io/github/sitateru/kpt?branch=add-coverall-add-coverage)
