# <img src="https://github.com/sem-con/sc-tawes/raw/master/app/assets/images/oyd_blue.png" width="60"> ZAMG Weather Data    
This [Semantic Container](https://www.ownyourdata.eu/semcon) provides data from measurements of automatic weather stations in Austria maintained by [ZAMG](https://www.zamg.ac.at).    

Docker Image: https://hub.docker.com/r/semcon/sc-tawes
 

## Usage   
To get a general introduction to the use of Semantic Containers please refer to the [SemCon Tutorial](https://github.com/sem-con/Tutorials).    
Start container locally:    
```
$ docker pull semcon/sc-tawes
$ docker run -d -p 3000:3000 semcon/sc-tawes
```

Access data:    
```
$ curl http://localhost:3000/api/data
```

## Examples    
This section lists examples how to use this Semantic Container.

### Aggregate    
Perform the following steps to build up a local weather archive.    

* start an empty container that accepts data in CSV format    
    ```
    $ wget https://raw.githubusercontent.com/sem-con/sc-base/master/spec/fixtures/files/init_format_csv.trig
    $ docker run -d -p 3000:3000 semcon/sc-tawes /bin/init.sh "$(< init_format_csv.trig)"
    ```

* setup a cron script to fetch data on an hourly basis (replace `id=xyz` with your actual location)    
    ```
    $ (crontab -l; echo "0 * * * * curl https://vownyourdata.zamg.ac.at:9610/api/data/plain?id=xyz | curl -H "Content-Type: application/json" -d @- -X POST http://localhost:3000/api/data") | crontab
    ```

### Billing
Semantic Containers support selling access to data. Perform the following steps to use this functionality:

* start a dedicated billing service:    
    a template is available on [Github](https://github.com/sem-con/srv-billing) and [Dockerhub](https://github.com/sem-con/srv-billing); see also [Swagger documentation](https://api-docs.ownyourdata.eu/semcon-billing/)    
    ```
    $ docker run -d --name srv-billing -p 4800:3000 -v $PWD/key:/key --env-file .env semcon/srv-billing
    ```

* start container with `AUTH=billing`:    
    ```
    $ docker run -p 4000:3000 -d --name billing -e AUTH=billing --link srv-billing semcon/sc-base /bin/init.sh "$(< init.trig)"
    ```

* access to container is restricted:    
    ```
    $ curl -s http://localhost:4000/api/data | jq
    {
        "billing": {
            "payment-info": "...free text information...",
            "payment-methods": [ "Ether" ],
            "provider": "seller@domain.com",
            "provider-pubkey-id": "..."
        },
        "provision": {...},
        "validation": {...}
    }
    ```

* request to buy data:    
    provide information about buyer in `buyer_info.json`:    
    ```
    {
        "buyer":"buyer@domain.com",
        "buyer-pubkey-id":"...",
        "buyer-info":{ ... hash with additional information ... },
        "request":"option1=value1&option2=value2",
        "usage-policy":"...",
        "payment-method":"Ether",
        "signature":"...request signed with private GPG key and base64 encoded..."
    }
    ```    
    and send request:    
    ```
    $ curl -s -H "Content-Type: application/json" \
        -d "$(< buyer_info.json)" \
        -X POST http://localhost:4000/api/buy | jq
    {
        "billing": {
            "uid": "123..................................def",
            "signature": "...uid signed with private GPG key and base64 encoded...",
            "provider": "seller@domain.com",
            "provider-pubkey-id": "...",
            "offer-timestamp": "2019-01-02T03:04:05.678Z",
            "offer-info": "...free text information...",
            "payment-method": "Ether",
            "payment-address": "0x123..................................def",
            "cost": 0.123,
            "payment-info": "...free text information..."
        },
        "provision": {...},
        "validation": {...}
    }
    ```    

* confirm transaction and access data:
    transfer the stated cost and use the uid from above in the `input` field; confirm the payment by sending the transaction hash:    
    ```
    $ curl -s "http://localhost:4000/api/paid?tx=0x123def" | jq
    {
        "key": "...oauth access key...",
        "secret": "...oauth secret encrypted with public key from buyer and base64 encoded..."
    }
    ```    
    Base64 decode and decrypt the secret to retrieve the Oauth2 secret and request a token:    
    ```
    $ curl -s -d grant_type=client_credentials \
      -d client_id=$OAUTH_KEY \
      -d client_secret=$OAUTH_SECRET \
      -d scope=read \
      -X POST http://localhost:4000/oauth/token
    ```
    And finally request the data:
    ```
    $ curl -s -H "Authorization: Bearer $OATH_TOKEN" "http://localhost:4000/api/data?option1=value1&option2=value2"
    ```    


## Improve this Semantic Container    

Please report any bugs or feature requests in the [GitHub Issue-Tracker](https://github.com/sem-con/sc-tawes/issues) and follow the [Contributor Guidelines](https://github.com/twbs/ratchet/blob/master/CONTRIBUTING.md).

If you want to develop yourself, follow these steps:

1. Fork it!
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Send a pull request

&nbsp;    

## Lizenz

[MIT Lizenz 2019 - OwnYourData.eu](https://raw.githubusercontent.com/sem-con/sc-tawes/master/LICENSE)

