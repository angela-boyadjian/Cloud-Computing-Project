'use strict';

const AWS = require('aws-sdk');
let mime = require('mime-types');

const s3 = new AWS.S3();

module.exports.update = async (event, context, callback) => {
  if (event.body !== null && event.body !== undefined) {
    let fileContent = event.isBase64Encoded ? Buffer.from(event.body.image, 'base64') : event.body.image;
    let fileName = event.body.profileId;
    let contentType = event.headers['content-type'] || event.headers['Content-Type'];
    let extension = contentType ? mime.extension(contentType) : '';
    let fullFileName = extension ? `${fileName}.${extension}` : fileName;
    try {
      let data = await s3.putObject({
        Bucket: "user-asset-bucket",
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
        callback(response_error);
      }}  else {
      var response_error = {
        "statusCode": 500,
        "body": JSON.stringify("Error : body missing in request"),
        "isBase64Encoded": false
      };
      callback(response_error);
    }
};
