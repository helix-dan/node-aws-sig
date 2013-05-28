var http  = require('http'),
    qstr  = require('querystring'),
    url   = require('url'),
    redis = require('redis');

var client = redis.createClient('6379', '127.0.0.1');

var server = http.createServer(function(request, response){
  var metaRequest = '';

  request.setEncoding('utf-8');

  request.on('data', function(chunk){
    metaRequest += chunk;
  })

  request.on('end', function(){
    var decode;
    if (request.method === 'GET') {
      request.query = decodeURIComponent(request.query);
      var metaQuery = url.parse(request.url, true).query;
    } else {
      decode = decodeURIComponent(metaRequest);
      var metaQuery = qstr.parse(decode);
    }

    if (metaQuery.key) {
      client.hgetall('sig:' + metaQuery.key, function(err, data){
        if(err){console.log(err);}
        if (data) {
          var finalData = {};
          finalData['rv'] = '0';
          finalData['x']  = data['x'];
          finalData['y']  = data['y'];
          finalData['name'] = data['name'];
          finalData['addr'] = data['addr'];
          response.end(JSON.stringify(finalData), 'utf8');
        } else {
          response.end(JSON.stringify({'rv':'0', 'msg':'can not find the address'}), 'utf8');
        }
      });
    } else {
      response.end(JSON.stringify({'rv':'404', 'msg':'can not find this path'}), 'utf8');
    }
  });
});

server.listen(1236);

console.log('connect to server success');
