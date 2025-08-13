#!/usr/bin/env node
// test-harness.js - Simple HTTP testing harness
const http = require('http');
const https = require('https');
const url = require('url');

function parseArgs() {
  const args = process.argv.slice(2);
  const config = {
    method: 'GET',
    path: '/',
    body: null,
    headers: {},
    baseUrl: 'http://localhost:3000',
    timeout: 10000
  };

  for (let i = 0; i < args.length; i += 2) {
    const flag = args[i];
    const value = args[i + 1];
    
    switch (flag) {
      case '--method':
        config.method = value;
        break;
      case '--path':
        config.path = value;
        break;
      case '--body':
        config.body = value;
        break;
      case '--header':
        const [key, val] = value.split(':');
        config.headers[key.trim()] = val.trim();
        break;
      case '--base-url':
        config.baseUrl = value;
        break;
      case '--timeout':
        config.timeout = parseInt(value);
        break;
    }
  }

  return config;
}

function makeRequest(config) {
  return new Promise((resolve, reject) => {
    const targetUrl = new URL(config.path, config.baseUrl);
    const isHttps = targetUrl.protocol === 'https:';
    const client = isHttps ? https : http;

    const options = {
      hostname: targetUrl.hostname,
      port: targetUrl.port || (isHttps ? 443 : 80),
      path: targetUrl.pathname + targetUrl.search,
      method: config.method,
      headers: {
        'Content-Type': 'application/json',
        ...config.headers
      },
      timeout: config.timeout
    };

    if (config.body) {
      const bodyData = Buffer.from(config.body, 'utf8');
      options.headers['Content-Length'] = bodyData.length;
    }

    const req = client.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        const result = {
          status: res.statusCode,
          headers: res.headers,
          body: data
        };
        
        // Try to parse as JSON
        try {
          result.json = JSON.parse(data);
        } catch (e) {
          // Keep as string if not JSON
        }
        
        resolve(result);
      });
    });

    req.on('error', reject);
    req.on('timeout', () => {
      req.destroy();
      reject(new Error(`Request timeout after ${config.timeout}ms`));
    });

    if (config.body) {
      req.write(config.body);
    }
    
    req.end();
  });
}

async function main() {
  const config = parseArgs();
  
  try {
    const result = await makeRequest(config);
    
    // Output structured result for spec-check.js to parse
    console.log(JSON.stringify({
      status: result.status,
      headers: result.headers,
      body: result.json || result.body,
      timestamp: new Date().toISOString()
    }, null, 2));
    
    process.exit(0);
  } catch (error) {
    console.error(JSON.stringify({
      error: error.message,
      status: 0,
      timestamp: new Date().toISOString()
    }, null, 2));
    
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}