'use strict';

var AWS = require('aws-sdk');
AWS.config.update({region: 'eu-west-2'});
const s3 = new AWS.S3();
var client = ses.createClient(C.emailServiceCredentials);

var pdf = require("pdf-creator-node");
var mailComposer = require('mailcomposer');
var fs = require('fs');

async function crawl_dynamodb() {
  var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});
  var params = {
      TableName: "user_finances"
    };
  let rslt = [];
  do {
    let items = await ddb.scan(params).promise();
    items.Items.forEach((item) => rslt.push(item));
    params.ExclusiveStartKey = items.LastEvaluatedKey;
  } while (typeof items.LastEvaluatedKey != "undefined");
  console.log(rslt);
  return(rslt);
}

function PdfbyUser(list){
  var html = fs.readFileSync('template.html', 'utf8');
  var options = {
    format: "A3",
    orientation: "portrait",
    border: "10mm",
  };
  var document = {
    html: html,
    data: {
        receipts: list.receipts
    },
    path: "./test.pdf"
  };
  pdf.create(document, options)
    .then(res => {
        console.log(res)
    })
    .catch(error => {
        console.error(error)
    });
    return(document.path);
}

async function sendPdfToS3(pdfPath) {
  var params = {
    key : 'test.pdf',
    body : pdfPath,
    bucket : 'reporting-bucket',
    contentType : 'application/pdf'
  }
  var response = await s3.putObject(params).promise();
  console.log(response);
}

function send_email(pdfPath) {
  mailComposer({
    from: 'cloud-computing-reporting@bankinapp.com',
    replyTo: '',
    to: 'elias.benzaoui@gmail.com',
    subject: 'Receipts reporting',
    text: 'Receipts reporting',
    attachments: [
      {
        path: pdfPath
      },
    ],
  }).build((err, message) => {
    if (err) {
      console.error(`Email encoding error: ${err}`);
    }
    client.sendRawEmail(
      {
        from: 'cloud-computing-reporting@bankinapp.com',
        rawMessage: message
      },
      function (err, data, res) {
        if (err)
          console.error(`Email encoding error: ${err}`);
        else console.log(res);
      }
    )
  });
}

async function main() {
  crawl_dynamodb().then(db => {
      var pdfPath = PdfbyUser(db);
      const resp = sendPdfToS3(pdfPath).promise();
      console.log(resp);
      send_email(pdfPath);
    }).catch(err => {
      console.log(err);
  }) 
}

main().then(console.log).catch(console.error);