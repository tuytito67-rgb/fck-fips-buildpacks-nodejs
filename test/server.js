const http = require('http');
const crypto = require('crypto');

const server = http.createServer((req, res) => {
  const fipsStatus = crypto.getFips() ? "ACTIVE (FIPS 140-3)" : "INACTIVE";
  const opensslVer = process.versions.openssl;
  
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`
    --- Wolfi FIPS Node.js Test ---
    Status: RUNNING
    FIPS Mode: ${fipsStatus}
    OpenSSL: ${opensslVer}
    Memory Limit: ${process.env.MEMORY_AVAILABLE} MB
  `);
});

server.listen(8080, () => {
  console.log('Server running at http://localhost:8080/');
  console.log('FIPS Mode:', crypto.getFips() ? 'ON' : 'OFF');
});
