'use strict';

const AWS = require('aws-sdk');

let mime = require('mime-types');

const s3 = new AWS.S3();

module.exports = {
    put: async (event) => {
        if (event.body !== null && event.body !== undefined) {
          const userId = event.requestContext.authorizer.claims.sub;
          let fileContent = event.isBase64Encoded ? Buffer.from(event.body, 'base64') : event.body;
          let fileName = userId;
          let contentType = event.headers['content-type'] || event.headers['Content-Type'];
          let extension = contentType ? mime.extension(contentType) : '';
          let fullFileName = extension ? `${fileName}.${extension}` : fileName;
          try {
             s3.putObject({
              Bucket: "userbucketupload",
              Key: fullFileName,
              Body: fileContent,
              Metadata: {}
            }, function(err, data){
              var params = {
                AccessToken: event.headers.Authorization,
                UserAttributes: [
                  {
                    Name: 'profile',
                    Value: fullFileName
                  }
                ]
              };
              cognitoidentityserviceprovider.updateUserAttributes(params, function(err, data) {
                if (err) console.log(err, err.stack);
                else     console.log(data);
              });
            });
            return {
              statusCode: 200,
              body: JSON.stringify(
                {
                  message: fullFileName,
                  input: event,
                },
                null,
                2
              ),
            };
          } catch (err) {
              var response_error = {
                "statusCode": 500,
                "body": JSON.stringify(err),
                "isBase64Encoded": false
              };
              return (response_error);
            }}  else {
            var response_error = {
              "statusCode": 500,
              "body": JSON.stringify("Error : body missing in request"),
              "isBase64Encoded": false
            };
            return(response_error);
          }
    },
    get: async (event) => {
      try {
        var params = {
          AccessToken: event.headers.Authorization
        };
       const filename = cognitoidentityserviceprovider.getUser(params, function(err, data) {
          if (err) console.log(err);
          else {
            return data.UserAttributes['picture'];
          }
        });
        let data = s3.getObject({Bucket: "userbucketupload", Key: filename}, function(err, data) {
          if (err) console.log(err, err.stack);
          else return(data);
        });
        return {
          statusCode: 200,
          body: JSON.stringify(
            {
              message: "Success",
              object: data,
              input: event,
            },
            null,
            2
          ),
        };
      } catch (err) {
          var response_error = {
            "statusCode": 500,
            "body": JSON.stringify(err),
            "isBase64Encoded": false
          };
          return (response_error);
        }
    },  
    delete :  async (event) => {
      if (event.body !== null && event.body !== undefined) {
        const userId = event.requestContext.authorizer.claims.sub;
        let fileContent = event.isBase64Encoded ? Buffer.from(event.body, 'base64') : event.body;
        let fileName = userId;
        let contentType = event.headers['content-type'] || event.headers['Content-Type'];
        let extension = contentType ? mime.extension(contentType) : '';
        let fullFileName = extension ? `${fileName}.${extension}` : fileName;
        try {
          let data = await s3.putObject({
            Bucket: "userbucketupload",
            Key: fullFileName,
            Body: fileContent,
            Metadata: {}
          }).promise();
          return {
            statusCode: 200,
            body: JSON.stringify(
              {
                message: 'Successfully uploaded file' + fullFileName,
                input: event,
              },
              null,
              2
            ),
          };
        } catch (err) {
            var response_error = {
              "statusCode": 500,
              "body": JSON.stringify(err),
              "isBase64Encoded": false
            };
            return (response_error);
          }}  else {
          var response_error = {
            "statusCode": 500,
            "body": JSON.stringify("Error : body missing in request"),
            "isBase64Encoded": false
          };
          return(response_error);
        }
  },
}