FROM amazon/lambda-build-node10.x

WORKDIR /usr/src

COPY /src .

RUN npm install

CMD ["node", "app.js"]