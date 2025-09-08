// Simple testing utilities
import { execSync } from 'child_process';
import { existsSync, rmSync, readFileSync, mkdtempSync, mkdirSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';

export class TestRunner {
  constructor() {
    this.tests = [];
    this.passed = 0;
    this.failed = 0;
  }

  describe(name, fn) {
    console.log(`\n📋 ${name}`);
    fn();
  }

  test(name, fn) {
    try {
      fn();
      this.passed++;
      console.log(`  ✅ ${name}`);
    } catch (error) {
      this.failed++;
      console.log(`  ❌ ${name}`);
      console.log(`     Error: ${error.message}`);
    }
  }

  expect(actual) {
    return {
      toBe: (expected) => {
        if (actual !== expected) {
          throw new Error(`Expected ${expected}, got ${actual}`);
        }
      },
      toContain: (expected) => {
        if (!actual.includes(expected)) {
          throw new Error(`Expected "${actual}" to contain "${expected}"`);
        }
      },
      toMatch: (regex) => {
        if (!regex.test(actual)) {
          throw new Error(`Expected "${actual}" to match ${regex}`);
        }
      },
      toBeTruthy: () => {
        if (!actual) {
          throw new Error(`Expected ${actual} to be truthy`);
        }
      }
    };
  }

  beforeEach(fn) {
    fn();
  }

  afterEach(fn) {
    fn();
  }

  exec(command, options = {}) {
    try {
      return execSync(command, { 
        encoding: 'utf8',
        stdio: 'pipe',
        ...options 
      });
    } catch (error) {
      if (options.allowFailure) {
        return { stdout: error.stdout, stderr: error.stderr, status: error.status };
      }
      throw error;
    }
  }

  fileExists(path) {
    return existsSync(path);
  }

  readFile(path) {
    return readFileSync(path, 'utf8');
  }

  cleanupLogs() {
    try {
      rmSync('./logs', { recursive: true });
    } catch {}
  }

  createTempDir() {
    return mkdtempSync(join(tmpdir(), 'agents-test-'));
  }

  summary() {
    console.log(`\n📊 Test Summary:`);
    console.log(`  ✅ Passed: ${this.passed}`);
    console.log(`  ❌ Failed: ${this.failed}`);
    console.log(`  📋 Total: ${this.passed + this.failed}`);
    
    if (this.failed > 0) {
      process.exit(1);
    }
  }
}