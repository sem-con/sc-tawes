# sc-tawes

# <img src="https://github.com/sem-con/sc-tawes/raw/master/app/assets/images/oyd_blue.png" width="92"> ZAMG Weather Data    
This [Semantic Container](https://www.ownyourdata.eu/semcon) provides data from measurements of automatic weather stations in Austria provided by [ZAMG](https://www.zamg.ac.at).    

Docker Image: https://hub.docker.com/r/semcon/sc-tawes
 

## Usage   
Start container locally:    
```
$ docker pull semcon/sc-tawes
```

Access data online:    
```
$ curl https://vownyourdata.zamg.ac.at:9600/api/data
```

## Examples    
This section lists examples how to use this Semantic Container. To get a general introduction to the use of Semantic Containers please refer to the [SemCon Tutorial](https://github.com/sem-con/Tutorials).

### Aggregate    
Run the following code to query data on an hourly basis and build up a local weather archive.    
```
$ docker run
```

## Improve the Semantic Container    

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

