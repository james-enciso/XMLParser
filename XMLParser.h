//
//  XMLParser.h
//  XMLTest
//
//  Created by James Enciso on 10/13/14.
//  Copyright (c) 2014  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>

//------XML PARSING OBJECTS--------
//downloads and parses the XML file
@property (nonatomic, retain) NSXMLParser *parser;
//temporarily holds element currently parsing
@property (nonatomic, retain) NSString *element;

//-------DATA STORAGE SYSTEMS-------
//contains list of feeds downloaded (for returning to user)
@property (nonatomic, retain) NSMutableArray *feeds;
//contains data parsed from XML per mainTag
@property (nonatomic, retain) NSMutableDictionary *item;
//array that holds temporary information parsed between XML tags
@property (nonatomic, retain) NSMutableArray *foundInformationArray;

//---------USER INPUTS---------
//array containing XML tags to parse through
@property (nonatomic, retain) NSMutableArray *tagArray;
//string containing mainTag to search for
@property (nonatomic, retain) NSString *mainTagString;
//link to download XML file (assigned by user)
@property (nonatomic, retain) NSURL *url;



-(NSMutableArray *)readDataFromURL:(NSURL *)inputURL usingTagsFromArray:(NSMutableArray *)inputMutableArray andMainTagAs:(NSString *)mainTag;


-(NSMutableArray *)readDataFromData:(NSData *)inputData usingTagsFromArray:(NSMutableArray *)inputMutableArray andMainTagAs:(NSString *)mainTag;


/*
 This Class reads the input of an XML file via URL, parses it, and returns an array of the data
	with dictionaries as elements

 To use it, create and allocate an object
 Assign the URL (In NSURL format)
 create an NSString for the mainTag (heirarchially)
 create an NSMutableArray and populate it with NSString objects containing the other XML sub-tags
 
 
 when calling the function, use an NSMutableArray to hold the value of the output
 -(NSMutableArray *)readDataFromURL:(NSURL *)inputURL usingTagsFromArray:(NSMutableArray *)inputMutableArray andMainTagAs:(NSString *)mainTag;

 
 
 Example Code
 
	//create parser object
     XMLParser *parser = [[XMLParser alloc] init];
	//set url
     NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
	//set individual tag objects as strings
			NSString *tag1 = "tag1";
	//create array for tags and populate array with tag objects
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	[tags addObject:tag1];
	//set main tag
		NSString *mainTag = @"main";

	//call function
	[parser readDataFromURL:url usingTagsFromArray:tags andMainTagAs:mainTag];
  
*/
  
 

@end
