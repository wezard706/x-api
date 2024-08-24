# README

## setup
```
$ docker-compose run --rm app bin/setup

$ docker-compose up
```

## note
- appとdbのホスト側のポートはそれぞれ3000、3006です。他のアプリと競合する場合は、docker-compose.ymlのportsを修正してください