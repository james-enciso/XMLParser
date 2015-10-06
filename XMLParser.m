//
//  XMLParser.m
//  XMLTest
//
//  Created by James Enciso on 10/13/14.
//  Copyright (c) 2014 All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize parser;
@synthesize  url;
@synthesize feeds, item, element;
@synthesize tagArray, mainTagString, foundInformationArray;


//This function takes in 3 parameters when called.
/*
 inputURL is the url from where XML metadata will be fetched
 inputMutableArray is a mutableArray that contains the tag names of the XML (in the form of NSStrings)
 mainTag is the main XML tag that groups smaller sub-components. It is in the form is NSString
 
 This function returns an NSArray with an NSDictionary of each component within
 */

-(NSMutableArray *)readDataFromURL:(NSURL *)inputURL usingTagsFromArray:(NSMutableArray *)inputMutableArray andMainTagAs:(NSString *)mainTag{

	//assign variables from global to input (for use later)
	tagArray = inputMutableArray;
	
	mainTagString = mainTag;
		
	url = inputURL;
	

	//create the array and load the parser with data from URL
    
    feeds = [[NSMutableArray alloc] init];
	//  NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
  //  parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    //added stuff here---
    
    NSString *stringData = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    NSString *contentString = [stringData stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];

    NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    parser = [[NSXMLParser alloc] initWithData:data];

    
    //END ADD---
    
	//set parser properties
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
	
	//start the parser
    [parser parse];
	
    NSLog(@"got contents");
	
//    NSLog(@"%@", item);
    
    NSLog(@"finished parsing");
//	NSLog(@"%@", feeds);
    
    return feeds;

}




-(NSMutableArray *)readDataFromData:(NSData *)inputData usingTagsFromArray:(NSMutableArray *)inputMutableArray andMainTagAs:(NSString *)mainTag{

    
        //assign variables from global to input (for use later)
        tagArray = inputMutableArray;
        
        mainTagString = mainTag;
		
      //  url = inputURL;
        NSData *userInputData = [[NSData alloc] initWithData:inputData];
    
        //create the array and load the parser with data from URL
        
        feeds = [[NSMutableArray alloc] init];
        //  NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
        //  parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        //added stuff here---
      /*
        NSString *stringData = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        NSString *contentString = [stringData stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        
        NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    
    */
        parser = [[NSXMLParser alloc] initWithData:userInputData];
        
        
        //END ADD---
        
        //set parser properties
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        
        //start the parser
        [parser parse];
        
        NSLog(@"got contents");
        
        //    NSLog(@"%@", item);
        
        NSLog(@"finished parsing");
        //	NSLog(@"%@", feeds);
        
        return feeds;

    
    

}







//code to insert into table view
//cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];


//called whenever parser encounters a lead element
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

 //alloc new dictionaries here and strings here
    //Dictionaries hold the main chunks, the strings hold the contents to store into the chunks
    
    //this makes the global variable for use later
    element = elementName;
    
    //checks if major block of entry code encountered (in this case, it's item)
    if ([element isEqualToString:mainTagString]) {
    //    NSLog(@"found entry tag: %@", mainTagString);
		
		//create a dictionary (creates for each time mainTag is encountered)
        item    = [[NSMutableDictionary alloc] init];
		
	
		//this array holds temporary data to be stored in dictionary after end tag encountered
		foundInformationArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < tagArray.count; i++) {
			
			//initialise the array with blank strings, with number of elements as XML sub-tags
			NSMutableString *blankString = [[NSMutableString alloc] init];
			//[foundInformationArray insertObject:blankString atIndex:i];
			[foundInformationArray addObject:blankString];
			
		}
		 
		NSLog(@"Initialised array");
        
    }

}

//called whenever finds new characters (between tags).
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

		//searches for each XML sub-tag
	for (int i = 0; i < tagArray.count; i++) {
		if ([element isEqualToString: [tagArray objectAtIndex:i] ]) {
			
		//	NSLog(@"encountered end tag: %@", [tagArray objectAtIndex:i]);
		//	NSLog(@"end tag at index %i", i);

			//get possibly "blank" string from array, fill it with XML metadata, save it back
			NSMutableString *savedString = [foundInformationArray objectAtIndex:i];
			[savedString appendString:string];
			NSLog(@"string char: %@", string);
			[foundInformationArray replaceObjectAtIndex:i withObject:savedString];
		//	NSLog(@"savedString:%@", savedString);
			
		}
				
	//	NSLog(@"informationArray is %@", foundInformationArray);

	}
	

}

//called whenever end tag is found
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//if encounters end mainTag
	if ([elementName isEqualToString: mainTagString]) {
		
		//fetches all temp data and saves it to dictionary created earlier
		for (int i = 0; i < tagArray.count; i++) {
			
			[item setObject:[foundInformationArray objectAtIndex:i] forKey:[tagArray objectAtIndex:i]];

			NSLog(@"Information Object: %@ , Key: %@", [foundInformationArray objectAtIndex:i], [tagArray objectAtIndex:i]);
			
		}
		
		//save the dictionary into array (for output)
		[feeds addObject:[item copy]];

		
	}
	NSLog(@"reached end");
//	NSLog(@"information feeds: %@", feeds);
	
}




@end
