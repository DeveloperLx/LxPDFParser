//
//  PDFTableViewController.m
//  PDFCategory
//

#import "PDFTableViewController.h"
#import "PDFNodeDisplayCell.h"

#define CELL_REUSE_ID @"cellReuseId"

@interface PDFTableViewController ()

@property (nonatomic, strong) NSMutableArray * contentArray;

@end

@implementation PDFTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.contentArray removeAllObjects];
    
    id content = [self.pdfParser valueForPDFKeyPath:self.keyPathArray];
    
    if ([content isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary * dictionary = (NSDictionary *)content;
        for (id key in dictionary.allKeys) {
            [self.contentArray addObject:[NSString stringWithFormat:@"%@ : %@", key, dictionary[key]]];
        }
    }
    else if ([content isKindOfClass:[NSArray class]]) {
        
        NSArray * array = (NSArray *)content;
        for (int i = 0; i < array.count; i++) {
            id obj = array[i];
            [self.contentArray addObject:[NSString stringWithFormat:@"%i、 %@", i, [obj description]]];
        }
    }
    else {
        
        [self.contentArray addObject:[content description]];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [[NSMutableArray alloc]init];
    }
    return _contentArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDFNodeDisplayCell * cell = [[PDFNodeDisplayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_ID];
    NSString * displayContent = self.contentArray[indexPath.row];
    cell.displayLabel.text = displayContent;
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDFNodeDisplayCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
    if (cell == nil) {
        cell = [[PDFNodeDisplayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_ID];
    }
    
    NSString * displayContent = self.contentArray[indexPath.row];
    cell.displayLabel.text = displayContent;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * newKeyPathArray = [NSMutableArray arrayWithArray:self.keyPathArray];
    
    id content = [self.pdfParser valueForPDFKeyPath:self.keyPathArray];
    if ([content isKindOfClass:[NSDictionary class]]) {
        
        NSString * displayContent = self.contentArray[indexPath.row];
        NSString * displayKey = [displayContent componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]].firstObject;
        
        [newKeyPathArray addObject:displayKey];
    }
    else if ([content isKindOfClass:[NSArray class]]) {
        
        [newKeyPathArray addObject:@(indexPath.row)];
    }
    else {
        return;
    }
    
    typeof(self) ptvc = [[PDFTableViewController alloc]init];
    ptvc.pdfParser = self.pdfParser;
    ptvc.keyPathArray = newKeyPathArray;
    ptvc.title = [newKeyPathArray.lastObject description];
    [self.navigationController pushViewController:ptvc animated:YES];
}

@end
