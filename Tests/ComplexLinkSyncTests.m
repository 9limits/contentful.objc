//
//  ComplexLinkSyncTests.m
//  ContentfulSDK
//
//  Created by Boris Bügling on 11/04/14.
//
//

#import "SyncBaseTestCase.h"

@interface ComplexLinkSyncTests : SyncBaseTestCase

@end

#pragma mark -

@implementation ComplexLinkSyncTests

-(void)setUp {
    [super setUp];
    
    /*
     Map URLs to JSON response files
     */
    NSDictionary* stubs = @{ @"https://cdn.contentful.com/spaces/emh6o2ireilu/sync?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac&initial=true": @"ComplexLinkTestInitial", @"https://cdn.contentful.com/spaces/emh6o2ireilu/?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac": @"space", @"https://cdn.contentful.com/spaces/emh6o2ireilu/sync?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac&sync_token=w5ZGw6JFwqZmVcKsE8Kow4grw45QdyZxwrTDssOKwr9SACovw47Ckn1vcwjDuEXCqV3DlMKiw6LDjxPCjDfDisONc8KtcHvDrsKsP8O2w5Azw6rCglcncRM7w7fDmyh3QzEpKcKiWsOOw5LDtsOlcgXCi8Omw7M": @"ComplexLinkTestUpdate1", @"https://cdn.contentful.com/spaces/emh6o2ireilu/sync?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac&sync_token=w5ZGw6JFwqZmVcKsE8Kow4grw45QdyY9wrEfW8KYwpROLH55G8O-U2rCq8OsQn3DvcOrw4cGwpkjIAvDgWxYwrITw4xUa8O4UCXDojMJDk8fw6RzSMK6J2vDqMOUJm_CiMKaw6lVF1jCg2vCosOFwpo": @"ComplexLinkTestUpdate2", @"https://cdn.contentful.com/spaces/emh6o2ireilu/content_types?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac&sys.id%5Bin%5D=4yCmJfmk1WeqACagaemOIs%2C5kLp8FbRwAG0kcOOYa6GMa": @"ComplexLinkTestContentTypes", @"https://cdn.contentful.com/spaces/emh6o2ireilu/entries?access_token=1bf1261e0225089be464c79fff1a0773ca8214f1e82dd521f3ecf9690ba888ac&sys.id%5Bin%5D=4upDPGUMMEkG8w8UUs2OiO%2C1gQ4P2tG7QaGkQwkC4a6Gg%2C1Wl5HnguK8CiaykiQAiGu6": @"ComplexLinkTestEntries", };
    
    [self stubHTTPRequestUsingFixtures:stubs inDirectory:@"ComplexSyncTests"];
}

-(void)syncedSpace:(CDASyncedSpace *)space didCreateEntry:(CDAEntry *)entry {
    [super syncedSpace:space didCreateEntry:entry];
    
    XCTAssertNotNil([entry.fields[@"link1"] fields], @"");
    XCTAssertNotNil([entry.fields[@"link3"] fields], @"");
}

-(void)syncedSpace:(CDASyncedSpace *)space didUpdateEntry:(CDAEntry *)entry {
    [super syncedSpace:space didUpdateEntry:entry];
    
    XCTAssertNotNil([entry.fields[@"link1"] fields], @"");
    XCTAssertNotNil([entry.fields[@"link3"] fields], @"");
}

-(void)testComplexLinkSync {
    StartBlock();
    
    CDARequest* request = [self.client initialSynchronizationWithSuccess:^(CDAResponse *response, CDASyncedSpace *space) {
        space.delegate = self;
        
        [space performSynchronizationWithSuccess:^{
            [space performSynchronizationWithSuccess:^{
                EndBlock();
            } failure:^(CDAResponse *response, NSError *error) {
                XCTFail(@"Error: %@", error);
                
                EndBlock();
            }];
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);
            
            EndBlock();
        }];
    } failure:^(CDAResponse *response, NSError *error) {
        XCTFail(@"Error: %@", error);
        
        EndBlock();
    }];
    XCTAssertNotNil(request, @"");
    
    WaitUntilBlockCompletes();
    
    XCTAssertEqual(1U, self.numberOfEntriesCreated, @"");
    XCTAssertEqual(0U, self.numberOfEntriesUpdated, @"");
    XCTAssertEqual(1U, self.numberOfEntriesDeleted, @"");
}

/*
 This test demonstrates that using a shallow synchronized space will differ in what it treats as a
 create vs. update operation when unpublished Resources will get published again. This case will be
 normally be a create, but a shallow synchronized space will treat it as an update.
 */
-(void)testComplexLinkSyncWithoutSyncSpaceInstance {
    StartBlock();
    
    CDARequest* request = [self.client initialSynchronizationWithSuccess:^(CDAResponse *response, CDASyncedSpace *space) {
        CDASyncedSpace* shallowSyncSpace = [CDASyncedSpace shallowSyncSpaceWithToken:space.syncToken
                                                                              client:self.client];
        shallowSyncSpace.delegate = self;
        shallowSyncSpace.lastSyncTimestamp = space.lastSyncTimestamp;
        
        [shallowSyncSpace performSynchronizationWithSuccess:^{
            [shallowSyncSpace performSynchronizationWithSuccess:^{
                EndBlock();
            } failure:^(CDAResponse *response, NSError *error) {
                XCTFail(@"Error: %@", error);
                
                EndBlock();
            }];
        } failure:^(CDAResponse *response, NSError *error) {
            XCTFail(@"Error: %@", error);
            
            EndBlock();
        }];
    } failure:^(CDAResponse *response, NSError *error) {
        XCTFail(@"Error: %@", error);
        
        EndBlock();
    }];
    XCTAssertNotNil(request, @"");
    
    WaitUntilBlockCompletes();
    
    XCTAssertEqual(0U, self.numberOfEntriesCreated, @"");
    XCTAssertEqual(1U, self.numberOfEntriesUpdated, @"");
    XCTAssertEqual(1U, self.numberOfEntriesDeleted, @"");
}

@end
