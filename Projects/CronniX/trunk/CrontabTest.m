//
//  CrontabTest.m
//  CronniX
//
//  Created by Sven A. Schmidt on Sat Mar 23 2002.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "CrontabTest.h"

NSString *testString =
@"ENV1= value\n"
@"ENV2= value +more\n"
@"ENV3=value\n"
@"ENV4=value +more\n"
@"ENV5 = value\n"
@"ENV6 = value +more\n"
@"ENV7 =value\n"
@"ENV8 =value +more\n"
@"#CrInfo another test...\n"
@" 1      2       3       4       *       echo \"Happy New Year!\"\n"
@"# plain comment line\n"
@" 1      2       3       4       *       second Task\n"
@"#CrInfo third Task\n"
@" 30\t5\t \t6       4       *       third Task\n";


@implementation CrontabTest


- (void)testInsertEnvVariable {
	id env = [ EnvVariable envVariableWithString: @"newKey=testvalue" ];
	[ crontab insertEnvVariable: env atIndex: 3 ];
	[ self assertInt: [ crontab envVariableCount ] equals: 9 message: @"wrong env variable count" ];
    [ self assert: [[ crontab envVariableAtIndex: 2 ] key ] equals: @"ENV3" message: @"wrong env at index 2" ];
    [ self assert: [[ crontab envVariableAtIndex: 3 ] key ] equals: @"newKey" message: @"wrong env at index 3" ];
    [ self assert: [[ crontab envVariableAtIndex: 4 ] key ] equals: @"ENV4" message: @"wrong env at index 4" ];
}


- (void)testRemoveAllEnvVariables {
	[ crontab removeAllEnvVariables ];
	[ self assertInt: [ crontab envVariableCount ] equals: 0 ];
}

- (void)testRemoveEnvVariableAtIndex {
    [ crontab removeEnvVariableAtIndex: 2 ];
    [ self assertInt: [ crontab envVariableCount ] equals: 7 message: @"wrong env variable count" ];
    [ self assert: [[ crontab envVariableAtIndex: 0 ] key ] equals: @"ENV1" message: @"wrong env at index 0" ];
    [ self assert: [[ crontab envVariableAtIndex: 1 ] key ] equals: @"ENV2" message: @"wrong env at index 1" ];
    [ self assert: [[ crontab envVariableAtIndex: 2 ] key ] equals: @"ENV4" message: @"wrong env at index 2" ];
}



- (void)testRemoveEnvVariable {
    id env = [ crontab envVariableAtIndex: 1 ];
    [ crontab removeEnvVariable: env ];
    [ self assertInt: [ crontab envVariableCount ] equals: 7 message: @"wrong env variable count" ];
    [ self assert: [[ crontab envVariableAtIndex: 0 ] key ] equals: @"ENV1" message: @"wrong env at index 0" ];
    [ self assert: [[ crontab envVariableAtIndex: 1 ] key ] equals: @"ENV3" message: @"wrong env at index 1" ];
    [ self assert: [[ crontab envVariableAtIndex: 2 ] key ] equals: @"ENV4" message: @"wrong env at index 2" ];
}


- (void)testRemoveEnvVariableWithKey {
    [ crontab removeEnvVariableWithKey: @"ENV6" ];
    [ self assertInt: [ crontab envVariableCount ] equals: 7 message: @"wrong env variable count" ];
    [ self assert: [[ crontab envVariableAtIndex: 4 ] key ] equals: @"ENV5" message: @"wrong env at index 4" ];
    [ self assert: [[ crontab envVariableAtIndex: 5 ] key ] equals: @"ENV7" message: @"wrong env at index 5" ];
    [ self assert: [[ crontab envVariableAtIndex: 6 ] key ] equals: @"ENV8" message: @"wrong env at index 6" ];
}

- (void)testRemoveEnvVariableWithNonexistingKey {
    [ crontab removeEnvVariableWithKey: @"ENV10" ];
    [ self assertInt: [ crontab envVariableCount ] equals: 8 message: @"wrong env variable count" ];
}

- (void)testReplaceTaskAtIndex {
	id aTask = [ TaskObject taskWithString: @"1 2 3 4 * new task" ];
	[ crontab replaceTaskAtIndex: 1 withTask: aTask ];
	[ self assertInt: [ crontab taskCount ] equals: 3 message: @"wrong task count" ];
	[ self assert: [[ crontab taskAtIndex: 0 ] command ] equals: @"echo \"Happy New Year!\""
		  message: @"wrong task at index 0" ];
	[ self assert: [[ crontab taskAtIndex: 1 ] command ] equals: @"new task"
		  message: @"wrong task at index 1" ];
	[ self assert: [[ crontab taskAtIndex: 2 ] command ] equals: @"third Task"
		  message: @"wrong task at index 2" ];
}



- (void)testInsertTaskAtIndex {
	id aTask = [ TaskObject taskWithString: @"1 2 3 4 * new task" ];
	[ crontab insertTask: aTask atIndex: 1 ];
	[ self assertInt: [ crontab taskCount ] equals: 4 message: @"wrong task count" ];
	[ self assert: [[ crontab taskAtIndex: 0 ] command ] equals: @"echo \"Happy New Year!\""
		  message: @"wrong task at index 0" ];
	[ self assert: [[ crontab taskAtIndex: 1 ] command ] equals: @"new task"
		  message: @"wrong task at index 1" ];
	[ self assert: [[ crontab taskAtIndex: 2 ] command ] equals: @"second Task"
		  message: @"wrong task at index 2" ];
	[ self assert: [[ crontab taskAtIndex: 3 ] command ] equals: @"third Task"
		  message: @"wrong task at index 3" ];
}


- (void)testRemoveTaskAtIndex {
	[ crontab removeTaskAtIndex: 1 ];
	[ self assertInt: [ crontab taskCount ] equals: 2 message: @"wrong task count" ];
	[ self assert: [[ crontab taskAtIndex: 0 ] command ] equals: @"echo \"Happy New Year!\""
		  message: @"wrong task at index 0" ];
	[ self assert: [[ crontab taskAtIndex: 1 ] command ] equals: @"third Task"
		  message: @"wrong task at index 1" ];
}


- (void)testWhiteSpaceTask {
	id task = [ crontab taskAtIndex: 2 ];
	[ self assert: [ task minute ] equals: @"30" ];
	[ self assert: [ task hour ] equals: @"5" ];
	[ self assert: [ task mday ] equals: @"6" ];
	[ self assert: [ task command ] equals: @"third Task" ];
}


- (void)testLineCount {
	[ self assertInt: [[ crontab lines ] count ] equals: 15 ];
}


- (void)testSetLines {
	NSArray *a1 = [ NSArray arrayWithObjects: @"A", @"B", nil ];
	[ crontab setLines: a1 ];
	[ self assert: [[ crontab lines ] objectAtIndex: 0] equals: @"A" message: @"content" ];
	[ self assertInt: [[ crontab lines ] count ] equals: 2 message: @"length" ];
}

- (void)testTaskCount {
	[ self assertInt: [ crontab taskCount ] equals: 3 ];
}

- (void)testTask {
	[ self assertNotNil: [ crontab taskAtIndex: 0 ] ];
}

- (void)testTaskMinute {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task minute ] equals: @"1" ];
}

- (void)testTaskHour {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task hour ] equals: @"2" ];
}

- (void)testTaskMonth {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task month ] equals: @"4" ];
}

- (void)testTaskMday {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task mday ] equals: @"3" ];
}

- (void)testTaskWday {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task wday ] equals: @"*" ];
}

- (void)testTaskCommand {
	id task = [ crontab taskAtIndex: 0 ];
	[ self assert: [ task command ] equals: @"echo \"Happy New Year!\"" ];
}

- (void)testEnvironmentVariablesCount {
	[ self assertInt: [ crontab envVariableCount ] equals: 8 ];
}

- (void)testEnvironmentVariableContent {
	id env = [ crontab envVariableAtIndex: 0 ];
	[ self assert: [ env key ] equals: @"ENV1" ];
	[ self assert: [ env value ] equals: @"value" ];
}

- (void)testTaskAtIndex {
	[ self assertNotNil: [ crontab taskAtIndex: 0 ]];
}


- (void)setUp {
    crontab = [[ Crontab alloc ] 
				initWithData: [ testString dataUsingEncoding: [ NSString defaultCStringEncoding ]]
					 forUser: nil ];
}

- (void)tearDown {
	[ crontab release ];
}



@end
