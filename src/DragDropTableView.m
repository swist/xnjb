//
//  DragDropTableView.m
//  XNJB
//
//  Created by Richard Low on 13/12/2004.
//

#import "DragDropTableView.h"

@implementation DragDropTableView

- (void)dealloc
{
	[fsBrowser release];
	[super dealloc];
}

- (void)registerDragAndDrop
{
	// allow drag and drop
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeFileURL]];

	fsBrowser = [[FileSystemBrowser alloc] init];

	allowCopies = YES;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if (!allowCopies)
		return NSDragOperationNone;
	else
		return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	return [self draggingEntered:sender];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	if (!allowCopies)
		return NO;
	else
		return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	if (!allowCopies)
		return NO;
	NSMutableArray *filesToCopy = [[NSMutableArray alloc] init];
	NSPasteboard *pb = [sender draggingPasteboard];
	NSArray *fileURLs = [pb readObjectsForClasses:@[[NSURL class]] options:@{NSPasteboardURLReadingFileURLsOnlyKey: @YES}];
	if (fileURLs != nil)
	{
		NSURL *fileURL;
		NSEnumerator *fileEnumerator = [fileURLs objectEnumerator];
		while (fileURL = [fileEnumerator nextObject])
		{
			NSString *filename = [fileURL path];
			FileSystemBrowserNode *node = [FileSystemBrowserNode nodeWithParent:nil atRelativePath:filename];
			[fsBrowser addContentsOfNode:node toArray:filesToCopy];
		}
	}
	int count = (int)[filesToCopy count];
	
	NSString *filename;
	NSEnumerator *fileEnumerator = [filesToCopy objectEnumerator];
	while (filename = [fileEnumerator nextObject])
		[[self delegate] copyFileToNJB:filename];
	
	[filesToCopy release];
	return (count != 0);
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{}

- (void)allowCopies
{
	allowCopies = YES;
}

- (void)disallowCopies
{
	allowCopies = NO;
}

@end
