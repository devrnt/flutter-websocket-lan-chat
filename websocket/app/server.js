const WebSocket = require('ws')

const wss = new WebSocket.Server({ port: 8080 });
console.log('[WebSocket] Starting WebSocket server...');

wss.on('connection', (ws, request) => {
  const clientIp = request.connection.remoteAddress;
  console.log(`[WebSocket] Client with IP ${clientIp} has connected`);

  // Broadcast to all connected clients 
  ws.on('message', message => {
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
    console.log(`[WebSocket] Message ${message} was received`)
  });
});