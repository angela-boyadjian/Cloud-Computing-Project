'use strict';

const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const FileType = require('file-type');
const Jimp = require('jimp');


      

module.exports = {
    post: async (event, context, callback) => {
      //Verify body type
      if (event.body === undefined || event.body === null || event.body === '') {
        return {
          statusCode: 400,
          error: "No data sent in body."
        }
      }
      const allowedExt = ['png', 'jpg'];
      let decodedImage = Buffer.from(event.body, 'base64');
      const type = await FileType.fromBuffer(decodedImage);
      if (allowedExt.indexOf(type.ext) < 0) {
        return {
          statusCode: 422,
          body: JSON.stringify({ description: 'Picture file extension is invalid. (Only png and jpg supported)', result: 'error', ext: type.ext})
        }
      }
      //Transform to PNG if JPEG
      if (type.ext === "jpg") {
        try {
          let jimpManipulation = await Jimp.read(decodedImage);
          decodedImage = await jimpManipulation.getBufferAsync("image/png");
        } catch(err) {
          console.log("An error occured: " + err);
          return {
            statusCode: 500, 
            body: JSON.stringify({ description: 'something went wrong', result: 'error'})
          }
        }
      }

      //Upload to S3 Bucket
      const userId = event.requestContext.authorizer.claims.sub;
      const params = {
        "Body": decodedImage,
        "Bucket": "users-profile-picture",
        "Key": userId+".png"
      };
      try {
        await s3.putObject(params).promise();
      } catch(err) {
        console.log(err);
        return {
          statusCode: 500, 
          body: JSON.stringify({ description: 'something went wrong', result: 'error'})
        }
      }

      // Update Cognito picture attrbute
      const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({
        apiVersion: '2016-04-18'
      });
      try {
        await cognitoidentityserviceprovider.adminUpdateUserAttributes({
          UserAttributes: [
            {
              Name: 'picture',
              Value: 'https://users-profile-picture.s3.eu-west-2.amazonaws.com/'+userId+'.png'
            }
          ],
          UserPoolId: "eu-west-2_kT5EeqP0M",
          Username:  event.requestContext.authorizer.claims['cognito:username']
        }).promise();
        return {
          statusCode: 200,
          body: JSON.stringify({ description: 'Profile picture uploaded',
          result: 'ok'
        })
        }
      } catch(err) {
        console.log("An error occured: " + err);
        return {
          statusCode: 500, 
          body: JSON.stringify({ description: 'something went wrong', result: 'error'})
        }
      }
    },
    get: async (event, res, callback) => {
      const userId = event.requestContext.authorizer.claims.sub;
      let params = {
        "Bucket": "users-profile-picture",
        "Key": userId+".png",
      };

      //Verify picture exist
      try {
          const headCode = await s3.headObject(params).promise();
          console.log(headCode);
          //object = await s3.getObject(params).promise();
      } catch(err) {
        return {
          statusCode: 404, 
          body: JSON.stringify({ description: 'No picture', result: 'error'})
        }
      }

      //Get a signed URL for S3 Bucket item
      let object = {};
      try {
        params["Expires"] = 60 * 15 //Seconds (15 Minutes)
        object = await s3.getSignedUrlPromise('getObject', params);
      } catch(err) {
        console.log("An error occured: "+ err);
        return {
          statusCode: 500, 
          body: JSON.stringify({ description: 'something went wrong', result: 'error'})
        }
      }
      return {
        statusCode: 200,
        body: JSON.stringify({url: object})
      };
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