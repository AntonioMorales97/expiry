const WebSocket = require('ws');
const rabbit = require('./rabbit/connection');

const mockedUser = {
  id: 1,
  name: 'Gallerian',
};

const mockedUsers = [
  mockedUser,
  {
    id: 2,
    name: 'Nacka',
  },
];

const wss = new WebSocket.Server({
  port: 8080,
  verifyClient: (info, cb) => {
    let token = {}; //info.req.headers.token;

    if (!token) cb(false, 401, 'Unauthorized');
    else {
      info.req.user = mockedUser;

      cb(true);
      /*
      jwt.verify(token, 'secret-key', function (err, decoded) {
        if (err) {
          cb(false, 401, 'Unauthorized');
        } else {
          info.req.user = decoded; //[1]
          cb(true);
        }
      });
      */
    }
  },
});

const exchange = 'notification';

let rabbitChannel = null;

const clients = new Map();

rabbit.startRabbit((connection) => {
  connection.createChannel(function (error1, channel) {
    if (error1) {
      throw error1;
    }

    rabbitChannel = channel;

    clients.forEach((value, key, mapObject) => {
      setUpQueue(value.user, value.ws);
    });
  });
});

const setUpQueue = (user, ws) => {
  rabbitChannel.assertQueue(
    user.name,
    {
      //durable: RabbitMQ will remember if it crashes. exclusive: when this connection closes, queue will be deleted
      durable: true,
      exclusive: false,
    },
    (error2, queueConn) => {
      if (error2) {
        throw error2;
      }

      console.log(' [*] Waiting for messages');

      rabbitChannel.bindQueue(queueConn.queue, exchange, user.name);
      rabbitChannel.bindQueue(queueConn.queue, exchange, 'notify');

      rabbitChannel.consume(
        queueConn.queue,
        (msg) => {
          ws.send(JSON.stringify(msg.content.toString()));
          console.log(msg.content.toString());
        },
        {
          noAck: false, // if consumer dies: false = the job won't be lost
          consumerTag: user.name,
        }
      );
    }
  );
};

const setUpUser = (user, ws) => {
  clients.set(user.id, {
    user: user,
    ws: ws,
  });
};

wss.on('connection', (ws, req) => {
  const id = req.url.substring(req.url.length - 1, req.url.length);
  req.user = mockedUsers[parseInt(id)];
  setUpUser(req.user, ws);
  setUpQueue(req.user, ws);

  //TODO: Call RON to set online status and that this user will not have any messages in queue

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
      ws.send(JSON.stringify('Hej'));
    }

    if (message.type === 'broadcast') {
      wss.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify('Hej'));
        }
      });
    }
  });

  ws.on('close', () => {
    if (clients.has(req.user.id)) {
      rabbitChannel.cancel(req.user.name); // stop consuming from queue for this user
      clients.delete(req.user.id);
      //TODO: Call RON to set offline status
      //TODO: Call RON to tell him that this user has messages in queue
    }
  });
});

/*
const clientsPrintout = () => {
  console.log('[');
  clients.forEach((value, key, mapObject) => {
    console.log(mapObject);
  });
  console.log(']');
  setTimeout(clientsPrintout, 2000);
};

clientsPrintout();
*/

/*
const http = require('http');
const express = require('express');

const app = express();

const server = http.createServer(app);

const PORT = 3000;
server.listen(PORT);
console.log(`Server listening on port ${PORT}`);
*/
