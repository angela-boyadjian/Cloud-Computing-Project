'use strict';

const AWS = require('aws-sdk');
let mime = require('mime-types');
const Busboy = require("busboy");
const s3 = new AWS.S3();

const getContentType = (event) => {
  const contentType = event.headers['content-type']
  if (!contentType) {
      return event.headers['Content-Type'];
  }
  return contentType;
};

const parser = (event) =>  new Promise((resolve, reject) => {
    const busboy = new Busboy({
      headers: {
          'content-type': getContentType(event)
      }
  });

  var result = {};

  busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
      file.on('data', data => {
          result.file = data;
      });

      file.on('end', () => {
          result.filename = filename;
          result.contentType = mimetype;
      });
  });

  busboy.on('field', (fieldname, value) => {
      result[fieldname] = value;
  });

  busboy.on('error', error => reject(error));
  busboy.on('finish', () => {
      event.body = result;
      resolve(event);
  });

  busboy.write(event.body, event.isBase64Encoded ? 'base64' : 'binary');
  busboy.end();
});

const uploadFile =  (buffer, event) => new Promise((resolve, reject) => {
  const bucketName = "userbucketupload2";
  const userId = event.requestContext.authorizer.claims.sub;
  const contentType = getContentType(event);
  const ext = mime.extension(contentType);
  const fileName =  userId + `${Date.now()}` + ext;
  const data = {
      Bucket: bucketName,
      Key: fileName,
      Body: buffer,
      ACL: 'authenticated-read',
  };
    s3.putObject(data, (error) => {
              if (!error) {
                  resolve(fileName);
                  return fileName;
              } else {
                  reject(new Error('error during put'));
              }
          });
  });

module.exports = {
    post: async (event) => {
        if (event.body !== null && event.body !== undefined) {
            parser(event).then(event => {
              uploadFile(event.body.file, event).then(fileName => {
                var response = {
                  "statusCode": 200,
                  "body": fileName,
                  "isBase64Encoded": false
                };
                console.log(response);
                return(response);
              }).catch((err) => {
                var response_error = {
                  "statusCode": 500,
                  "body": JSON.stringify(err),
                  "isBase64Encoded": false
                };
              console.log(response_error);
              return(response_error);
              })
            });
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