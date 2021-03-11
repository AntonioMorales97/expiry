const WebSocket = require('ws');
const rabbit = require('./rabbit/connection');

const wss = new WebSocket.Server({ port: 8080 });

const mockedUsers = [
  {
    id: 1,
    firstname: 'John',
    lastname: 'Doe',
  },
];

rabbit.startRabbit((connection) => {
  connection.createChannel(function (error1, channel) {
    if (error1) {
      throw error1;
    }

    const exchange = 'notification'; // name of exchange

    channel.assertQueue(
      '',
      {
        //durable: RabbitMQ will remember if it crashes. exclusive: when this connection closes, queue will be deleted
        durable: true,
        exclusive: true,
      },
      (error2, q) => {
        if (error2) {
          throw error2;
        }

        console.log(' [*] Waiting for messages in %s. To exit press CTRL+C');

        channel.bindQueue(q.queue, exchange, 'notify');

        channel.consume(
          q.queue,
          function (msg) {
            wss.clients.forEach((client) => {
              if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(mockedUsers));
              }
            });

            console.log(msg.content.toString());
          },
          {
            noAck: true, // if consumer dies: false = the job won't be lost
          }
        );
      }
    );
  });
});

wss.on('connection', (ws) => {
  ws.on('message', (data) => {
    console.log(data);

    let message = null;

    try {
      message = JSON.parse(data);
    } catch (error) {
      console.log(error);
      return;
    }

    if (message.type === 'get-users') {
      ws.send(JSON.stringify(mockedUsers));
    }

    if (message.type === 'broadcast') {
      wss.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify(mockedUsers));
        }
      });
    }
  });
});
/*

const http = require('http');
const express = require('express');

const app = express();

const server = http.createServer(app);

const PORT = 3000;
server.listen(PORT);
console.log(`Server listening on port ${PORT}`);
*/
