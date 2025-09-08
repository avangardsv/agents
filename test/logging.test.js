#!/usr/bin/env node

import { TestRunner } from './test-utils.js';

const runner = new TestRunner();

runner.describe('ai_log.sh Tests', () => {
  runner.beforeEach(() => {
    runner.cleanupLogs();
    // Ensure logging directories exist
    runner.exec('./init.sh --setup-logging');
  });

  runner.test('shows help when --help flag is used', () => {
    const output = runner.exec('./tools/logging/ai_log.sh --help');
    runner.expect(output).toContain('AI Prompt Logging Tool');
    runner.expect(output).toContain('--complete');
    runner.expect(output).toContain('--daily-summary');
  });

  runner.test('creates valid JSONL entries via pipeline', () => {
    runner.exec('echo "test message" | ./tools/logging/ai_log.sh test action --files="test.txt"');
    
    runner.expect(runner.fileExists('./logs/ai/log.jsonl')).toBeTruthy();
    
    const content = runner.readFile('./logs/ai/log.jsonl');
    const entry = JSON.parse(content);
    
    runner.expect(entry.category).toBe('test');
    runner.expect(entry.action).toBe('action');
    runner.expect(entry.message).toBe('test message');
    runner.expect(entry.files).toContain('test.txt');
  });

  runner.test('creates text log entries with manual flags', () => {
    const today = new Date().toISOString().split('T')[0];
    const logFile = `./logs/ai_prompts_${today}.log`;
    
    runner.exec('./tools/logging/ai_log.sh --task="Test Task" --status="COMPLETED" --deliverables="test file"');
    
    runner.expect(runner.fileExists(logFile)).toBeTruthy();
    
    const content = runner.readFile(logFile);
    runner.expect(content).toContain('TASK_TYPE: Test Task');
    runner.expect(content).toContain('STATUS: COMPLETED');
    runner.expect(content).toContain('DELIVERABLES:');
    runner.expect(content).toContain('- test file');
  });

  runner.test('shows today summary when no arguments', () => {
    // First create a log entry
    runner.exec('./tools/logging/ai_log.sh --task="Test" --status="COMPLETED" --deliverables="test"');
    
    // Then check summary
    const output = runner.exec('./tools/logging/ai_log.sh');
    runner.expect(output).toContain("Today's AI Activity");
    runner.expect(output).toContain('TASK_TYPE: Test');
  });

  runner.test('handles multiple files in JSONL format', () => {
    // Clean up first
    runner.cleanupLogs();
    runner.exec('./init.sh --setup-logging');
    
    runner.exec('echo "test multiple files" | ./tools/logging/ai_log.sh test multifiles --files="file1.js, file2.css, file3.html"');
    
    const content = runner.readFile('./logs/ai/log.jsonl');
    const entry = JSON.parse(content.trim());
    
    runner.expect(entry.category).toBe('test');
    runner.expect(entry.action).toBe('multifiles');
    runner.expect(entry.files).toContain('file1.js');
    runner.expect(entry.files).toContain('file2.css');
    runner.expect(entry.files).toContain('file3.html');
  });

  runner.test('generates daily summary from JSONL', () => {
    // Create some JSONL entries
    runner.exec('echo "task 1" | ./tools/logging/ai_log.sh dev implement --files="file1.js"');
    runner.exec('echo "task 2" | ./tools/logging/ai_log.sh ops deploy --files="docker-compose.yml"');
    
    // Generate daily summary
    runner.exec('./tools/logging/ai_log.sh --daily-summary');
    
    const today = new Date().toISOString().split('T')[0];
    const summaryFile = `./logs/ai/${today}.md`;
    
    runner.expect(runner.fileExists(summaryFile)).toBeTruthy();
    
    const content = runner.readFile(summaryFile);
    runner.expect(content).toContain(`# AI Activity Summary - ${today}`);
    runner.expect(content).toContain('## Actions Taken');
  });

  runner.test('handles empty deliverables gracefully', () => {
    runner.exec('./tools/logging/ai_log.sh --task="Test Task" --status="PENDING"');
    
    const today = new Date().toISOString().split('T')[0];
    const content = runner.readFile(`./logs/ai_prompts_${today}.log`);
    
    runner.expect(content).toContain('TASK_TYPE: Test Task');
    runner.expect(content).toContain('STATUS: PENDING');
    runner.expect(content).toContain('ISSUES: None');
  });

  runner.test('shows weekly summary', () => {
    // Create a log entry first
    runner.exec('./tools/logging/ai_log.sh --task="Weekly Test" --status="COMPLETED" --deliverables="summary"');
    
    const output = runner.exec('./tools/logging/ai_log.sh --week');
    runner.expect(output).toContain('Weekly AI Activity Summary');
  });
});

runner.summary();