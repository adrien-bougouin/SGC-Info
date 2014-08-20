/*******************************************************************************
 * main.m
 *
 * Adrien Bougouin <adrien.bougouin@gmail.com>
 */

#import <Foundation/Foundation.h>
#import <AppKit/Appkit.h>

#import "AppController.h"

int main(int argc, char **argv) {
  [[NSAutoreleasePool alloc] init];
  [[NSApplication sharedApplication] setDelegate:[[AppController alloc] init]];

  return NSApplicationMain(argc, (const char **) argv);
}

