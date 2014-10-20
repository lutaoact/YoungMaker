# time limited singleton
Azure = require 'azure-media'
hash = require 'object-hash'

exports.getMediaService = (()->
  services = {}
  return (auth)->
    deferred = Q.defer()
    if services[hash(auth)] == undefined
      app = new Azure(auth);
      app.init (err)->
        if err
          deferred.reject err
        else
          delay = parseInt(app.oauth.expires_in)*1000 - 60000
          setTimeout ()->
            services[hash(auth)] = undefined;
          , delay
          services[hash(auth)] = app
          deferred.resolve app
    else
      deferred.resolve services[hash(auth)]
    return deferred.promise
)()