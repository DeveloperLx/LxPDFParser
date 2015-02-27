//
//  CatalogueTableViewController.m
//  LxPDFParser
//

#import "CatalogueTableViewController.h"
#import "CatalogueNodeCell.h"

static NSString * CatalogueNodeCellIdentifier = @"CatalogueNodeCellIdentifier";

@interface CatalogueTableViewController ()

@property (nonatomic,strong) NSMutableArray * catalogueNodeArray;

@end

@implementation CatalogueTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Catalogue";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerClass:[CatalogueNodeCell class] forCellReuseIdentifier:CatalogueNodeCellIdentifier];
}

- (void)setPdfParser:(LxPDFParser *)pdfParser
{
    if (_pdfParser != pdfParser) {
        
        [self.catalogueNodeArray removeAllObjects];
        [self.catalogueNodeArray addObject:pdfParser.rootCatalogueNode];
        
        _pdfParser = pdfParser;
    }
}

- (NSMutableArray *)catalogueNodeArray
{
    if (_catalogueNodeArray == nil) {
        _catalogueNodeArray = [[NSMutableArray alloc]init];
    }
    return _catalogueNodeArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.catalogueNodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CatalogueNodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CatalogueNodeCellIdentifier forIndexPath:indexPath];
    
    CatalogueNodeModel * catagueNodeModel = self.catalogueNodeArray[indexPath.row];
    
    cell.depth = catagueNodeModel.depth;
    cell.nameLabel.text = catagueNodeModel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CatalogueNodeModel * catagueNodeModel = self.catalogueNodeArray[indexPath.row];
    
    BOOL childNodeArrayIsOpened = NO;
    
    if (indexPath.row == self.catalogueNodeArray.count - 1) {
        
        childNodeArrayIsOpened = NO;
    }
    else {
        CatalogueNodeModel * nextCatagueNodeModel = self.catalogueNodeArray[indexPath.row + 1];
        childNodeArrayIsOpened = nextCatagueNodeModel.depth > catagueNodeModel.depth;
    }
    
    if (childNodeArrayIsOpened) {
        
        NSMutableArray * deleteIndexPathArray = [NSMutableArray array];
        NSMutableIndexSet * deleteIndexSet = [NSMutableIndexSet indexSet];
        
        for (NSInteger i = indexPath.row + 1; i < self.catalogueNodeArray.count; i++) {
            
            CatalogueNodeModel * nextCatalogueNodeModel = self.catalogueNodeArray[i];
            
            if (nextCatalogueNodeModel.depth > catagueNodeModel.depth) {
                
                [deleteIndexSet addIndex:i];
                
                [deleteIndexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        
        [self.catalogueNodeArray removeObjectsAtIndexes:deleteIndexSet];
    
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:deleteIndexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
    }
    else {
        
        NSMutableArray * insertIndexPathArray = [NSMutableArray array];
        NSMutableIndexSet * insertIndexSet = [NSMutableIndexSet indexSet];
        
        for (NSInteger i = 0; i < catagueNodeModel.childNodeArray.count; i++) {
            NSIndexPath * insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:0];
            [insertIndexPathArray addObject:insertIndexPath];
            [insertIndexSet addIndex:indexPath.row + i + 1];
        }
        
        [self.catalogueNodeArray insertObjects:catagueNodeModel.childNodeArray atIndexes:insertIndexSet];
        
        [tableView beginUpdates];
        
        [tableView insertRowsAtIndexPaths:insertIndexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
    }
}
@end
