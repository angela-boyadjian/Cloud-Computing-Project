'use strict';

const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const FileType = require('file-type');

module.exports = {
    post: async (event, context, callback) => {
      if (event.body === undefined || event.body === null || event.body === '') {
        return {
          statusCode: 400,
          error: "No data sent in body."
        }
      }
      const allowedExt = ['png', 'jpg'];
      const decodedImage = Buffer.from(event.body, 'base64');
      const type = await FileType.fromBuffer(decodedImage);
      console.log(type);
      if (allowedExt.indexOf(type.ext) < 0) {
        return {
          statusCode: 422,
          body: JSON.stringify({ description: 'Picture file extension is invalid. (Only png and jpg supported)', result: 'error', ext: type.ext})
        }
      }

      const userId = event.requestContext.authorizer.claims.sub;
      console.log("userId: " + userId);
      const params = {
        "Body": decodedImage,
        "Bucket": "users-profile-picture",
        "Key": userId+"."+type.ext  
      };
      try {
        await s3.putObject(params).promise();
        console.log("done");
      } catch(err) {
        console.log(err);
        return {
          statusCode: 500, 
          body: JSON.stringify({ description: 'something went wrong', result: 'error'})
        }
      }

      // UPDATE COGNITO
      const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({
        apiVersion: '2016-04-18'
      });
      try {
        await cognitoidentityserviceprovider.adminUpdateUserAttributes({
          UserAttributes: [
            {
              Name: 'picture',
              Value: 'https://users-profile-picture.s3.eu-west-2.amazonaws.com/'+userId+'.'+type.ext
            }
          ],
          UserPoolId: "eu-west-2_kT5EeqP0M",
          Username:  event.requestContext.authorizer.claims['cognito:username']
        }).promise();
        return {
          statusCode: 200,
          body: JSON.stringify({ description: 'Profile picture uploaded', result: 'ok' })
        }
      } catch(err) {
        console.log(err);
        return {
          statusCode: 500, 
          body: JSON.stringify({ description: 'something went wrong', result: 'error', debug: event.requestContext})
        }
      }
    },
    get: async (event, res, callback) => {
      try {
        const tmp = JSON.parse(event.body);
        var filename = tmp.filepath;
        console.log(filename);
        var params = {
          Bucket: "userbucketupload2", 
          Key: filename
        };
        s3.getObject(params, function(err, data) {
          if (err)
            return err;
          let objectData = data.Body;
          let response = {
            "statusCode": 200,
            "body": `${objectData}`,
            "isBase64Encoded": false
          };
          console.log(response);
          return(response);
        });
      } catch (err) {
          callback(err, null);
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
            await s3.putObject({
              Bucket: "userbucketupload2",
              Key: fullFileName,
              Body: fileContent,
              Metadata: {}
            }).promise();
          return {
            "statusCode": 200,
            "body": 'Successfully uploaded file' +`${fullFileName}`,
            "isBase64Encoded": false
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