#!/usr/bin/env node

import { TestRunner } from './test-utils.js';

const runner = new TestRunner();

runner.describe('init.sh Tests', () => {
  runner.beforeEach(() => {
    runner.cleanupLogs();
  });

  runner.test('shows help when --help flag is used', () => {
    const output = runner.exec('./init.sh --help');
    runner.expect(output).toContain('Agents System Daily Initialization');
    runner.expect(output).toContain('--daily-check');
    runner.expect(output).toContain('--setup-logging');
  });

  runner.test('creates logging directories with --setup-logging', () => {
    runner.exec('./init.sh --setup-logging');
    runner.expect(runner.fileExists('./logs')).toBeTruthy();
    runner.expect(runner.fileExists('./logs/ai')).toBeTruthy();
    runner.expect(runner.fileExists('./logs/.gitignore')).toBeTruthy();
  });

  runner.test('detects missing logs and provides guidance', () => {
    const output = runner.exec('./init.sh --daily-check');
    runner.expect(output).toContain('No AI logging detected');
    runner.expect(output).toContain('ai_log.sh --complete');
  });

  runner.test('detects existing logs and confirms status', () => {
    // First create some logs
    runner.exec('./init.sh --setup-logging');
    runner.exec('./tools/logging/ai_log.sh --task="Test" --status="COMPLETED" --deliverables="test"');
    
    // Then check daily status
    const output = runner.exec('./init.sh --daily-check');
    runner.expect(output).toContain('AI logging is up to date');
  });

  runner.test('creates AGENTS.md in parent directory', () => {
    runner.exec('./init.sh --update-agents-md');
    runner.expect(runner.fileExists('../AGENTS.md')).toBeTruthy();
    
    const content = runner.readFile('../AGENTS.md');
    runner.expect(content).toContain('AI Workflow Management');
    runner.expect(content).toContain('Daily Workflow');
  });

  runner.test('integration check validates system health', () => {
    // First ensure AGENTS.md exists
    runner.exec('./init.sh --update-agents-md');
    
    const output = runner.exec('./init.sh --check-integration');
    runner.expect(output).toContain('integration looks good');
  });

  runner.test('integration check detects missing files', () => {
    // Remove AGENTS.md if it exists
    try {
      runner.exec('rm ../AGENTS.md');
    } catch {}
    
    const result = runner.exec('./init.sh --check-integration', { allowFailure: true });
    runner.expect(result.stderr).toContain('Missing AGENTS.md');
  });

  runner.test('default behavior runs setup and daily check', () => {
    const output = runner.exec('./init.sh');
    runner.expect(output).toContain('Setting up logging directories');
    runner.expect(output).toContain('Checking daily logging status');
    runner.expect(output).toContain('daily check complete');
  });
});

runner.summary();