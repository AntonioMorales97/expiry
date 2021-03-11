const amqp = require('amqplib/callback_api');

let amqpConn = null;
let rabbitURL = 'amqp://guest:guest@localhost';

const startRabbit = (cb) => {
  amqp.connect(rabbitURL + '?heartbeat=60', function (err, conn) {
    if (err) {
      console.error('[AMQP]', err.message);
      return setTimeout(() => startRabbit(cb), 3000);
    }

    conn.on('error', function (err) {
      if (err.message !== 'Connection closing') {
        console.error('[AMQP] conn error', err.message);
      }
    });

    conn.on('close', function () {
      console.error('[AMQP] reconnecting');
      return setTimeout(() => startRabbit(cb), 3000);
    });

    console.log('[AMQP] connected');
    amqpConn = conn;

    cb(conn);
  });
};

module.exports = { startRabbit };
