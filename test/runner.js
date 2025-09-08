#!/usr/bin/env node

import { spawn } from 'child_process';
import { readdirSync } from 'fs';

console.log('🧪 Running Agents System Test Suite\n');

const testFiles = readdirSync('./test')
  .filter(file => file.endsWith('.test.js'))
  .sort();

let totalPassed = 0;
let totalFailed = 0;

for (const testFile of testFiles) {
  console.log(`\n🔍 Running ${testFile}...\n`);
  
  try {
    const result = spawn('node', [`./test/${testFile}`], { 
      stdio: 'inherit' 
    });
    
    await new Promise((resolve, reject) => {
      result.on('close', (code) => {
        if (code === 0) {
          resolve();
        } else {
          reject(new Error(`${testFile} failed with exit code ${code}`));
        }
      });
      
      result.on('error', reject);
    });
    
    console.log(`✅ ${testFile} completed successfully`);
    
  } catch (error) {
    console.log(`❌ ${testFile} failed: ${error.message}`);
    totalFailed++;
  }
}

console.log('\n' + '='.repeat(50));
console.log('🏁 Test Suite Summary');
console.log('='.repeat(50));

if (totalFailed === 0) {
  console.log('🎉 All test files completed successfully!');
  process.exit(0);
} else {
  console.log(`❌ ${totalFailed} test file(s) failed`);
  process.exit(1);
}