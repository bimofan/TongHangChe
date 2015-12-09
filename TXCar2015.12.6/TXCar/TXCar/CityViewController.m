//
//  CityViewController.m
//  TXCar
//
//  Created by jack on 15/10/20.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "CityViewController.h"
#import "RKDropdownAlert.h"
#import "ZhaoCheViewController.h"
#import "CityDetailSelectViewController.h"
#import "CarInputViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "sousuocheViewController.h"
@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview_city_select;
@property(nonatomic,copy)NSArray*state;
@property(nonatomic,copy)NSArray * city;

@property (nonatomic,strong) CLLocationManager *manager;

@property(nonatomic,copy)NSString *located_city;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_city_select_type);
    _located_city=@"正在定位...";
    _state=@[@"全国",@"大区",@"北京",@"天津",@"上海",@"重庆",@"河北",@"山西",@"辽宁",@"吉林",@"内蒙古",@"黑龙江",@"江苏",@"安徽",@"福建",@"江西",@"浙江",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"广西",@"海南",@"四川",@"贵州",@"云南",@"西藏",@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",@"台湾",@"香港",@"澳门"];
    _city= @[@[@"不限"],@[@"京津冀",@"晋鲁豫",@"黑吉辽",@"江浙沪",@"广深",@"云贵川"],@[@"不限",@"东城",@"西城",@"崇文",@"宣武",@"朝阳",@"丰台",@"石景山",@"海淀",@"门头沟",@"房山",@"通州",@"顺义",@"昌平",@"大兴",@"平谷",@"怀柔",@"密云",@"延庆"],@[@"不限",@"和平",@"河东",@"河西",@"南开",@"河北",@"红桥",@"塘沽",@"汉沽",@"大港",@"东丽",@"西青",@"津南",@"北辰",@"宁河",@"武清",@"静海",@"宝坻",@"蓟县"],@[@"不限",@"黄浦",@"卢湾",@"徐汇",@"长宁",@"静安",@"普陀",@"闸北",@"虹口",@"杨浦",@"闵行",@"宝山",@"嘉定",@"浦东",@"金山",@"松江",@"青浦",@"南汇",@"奉贤",@"崇明"],@[@"不限",@"万州",@"涪陵",@"渝中",@"大渡口",@"江北",@"沙坪坝",@"九龙坡",@"南岸",@"北碚",@"万盛",@"双挢",@"渝北",@"巴南",@"黔江",@"长寿",@"綦江",@"潼南",@"铜梁",@"大足",@"荣昌",@"壁山",@"梁平",@"城口",@"丰都",@"垫江",@"武隆",@"忠县",@"开县",@"云阳",@"奉节",@"巫山",@"巫溪",@"石柱",@"秀山",@"酉阳",@"彭水",@"江津",@"合川",@"永川",@"南川"],@[@"不限",@"石家庄",@"邯郸",@"邢台",@"保定",@"张家口",@"承德",@"廊坊",@"唐山",@"秦皇岛",@"沧州",@"衡水"],@[@"不限",@"太原",@"大同",@"阳泉",@"长治",@"晋城",@"朔州",@"吕梁",@"忻州",@"晋中",@"临汾",@"运城"],@[@"不限",@"沈阳",@"大连",@"鞍山",@"抚顺",@"本溪",@"丹东",@"锦州",@"营口",@"阜新",@"辽阳",@"盘锦",@"铁岭",@"朝阳",@"葫芦岛"],@[@"不限",@"长春",@"吉林",@"四平",@"辽源",@"通化",@"白山",@"松原",@"白城",@"延边"],@[@"不限",@"呼和浩特",@"包头",@"乌海",@"赤峰",@"呼伦贝尔盟",@"阿拉善盟",@"哲里木盟",@"兴安盟",@"乌兰察布盟",@"锡林郭勒盟",@"巴彦淖尔盟",@"伊克昭盟"],@[@"不限",@"哈尔滨",@"齐齐哈尔",@"牡丹江",@"佳木斯",@"大庆",@"绥化",@"鹤岗",@"鸡西",@"黑河",@"双鸭山",@"伊春",@"七台河",@"大兴安岭"],@[@"不限",@"南京",@"镇江",@"苏州",@"南通",@"扬州",@"盐城",@"徐州",@"连云港",@"常州",@"无锡",@"宿迁",@"泰州",@"淮安"],@[@"不限",@"合肥",@"芜湖",@"蚌埠",@"马鞍山",@"淮北",@"铜陵",@"安庆",@"黄山",@"滁州",@"宿州",@"池州",@"淮南",@"巢湖",@"阜阳",@"六安",@"宣城",@"亳州"],@[@"不限",@"福州",@"厦门",@"莆田",@"三明",@"泉州",@"漳州",@"南平",@"龙岩",@"宁德"],@[@"不限",@"南昌",@"景德镇",@"九江",@"鹰潭",@"萍乡",@"新馀",@"赣州",@"吉安",@"宜春",@"抚州",@"上饶"],@[@"不限",@"杭州",@"宁波",@"温州",@"嘉兴",@"湖州",@"绍兴",@"金华",@"衢州",@"台州",@"丽水",@"舟山"],@[@"不限",@"济南",@"青岛",@"淄博",@"枣庄",@"东营",@"烟台",@"潍坊",@"济宁",@"泰安",@"威海",@"日照"],@[@"不限",@"郑州",@"开封",@"洛阳",@"平顶山",@"安阳",@"鹤壁",@"新乡",@"焦作",@"濮阳",@"许昌",@"漯河",@"三门峡",@"南阳",@"商丘",@"周口",@"信阳",@"驻马店",@"潢川",@"济源"],@[@"不限",@"武昌",@"宜昌",@"荆州",@"襄樊",@"黄石",@"荆门",@"黄冈",@"十堰",@"恩施",@"潜江"],@[@"不限",@"长沙",@"常德",@"株洲",@"湘潭",@"衡阳",@"岳阳",@"邵阳",@"益阳",@"娄底",@"怀化",@"郴州",@"永州",@"湘西",@"张家界"],@[@"不限",@"广州",@"深圳",@"珠海",@"汕头",@"东莞",@"中山",@"佛山",@"韶关",@"江门",@"湛江",@"茂名",@"肇庆",@"惠州",@"梅州",@"汕尾",@"河源",@"阳江",@"清远",@"潮州",@"揭阳",@"云浮"],@[@"不限",@"南宁",@"柳州",@"桂林",@"梧州",@"北海",@"防城港",@"钦州",@"贵港",@"玉林",@"南宁地区",@"柳州地区",@"贺州",@"百色",@"河池"],@[@"不限",@"海口",@"三亚"],@[@"不限",@"成都",@"绵阳",@"德阳",@"自贡",@"内江",@"乐山",@"南充",@"雅安",@"眉山",@"甘孜",@"凉山",@"泸州"],@[@"不限",@"贵阳",@"六盘水",@"遵义",@"安顺",@"铜仁",@"黔西南",@"毕节",@"黔东南",@"黔南"],@[@"不限",@"昆明",@"大理",@"曲靖",@"玉溪",@"昭通",@"楚雄",@"红河",@"文山",@"思茅",@"西双版纳",@"保山",@"德宏",@"丽江",@"怒江",@"迪庆",@"临沧"],@[@"不限",@"拉萨",@"日喀则",@"山南",@"林芝",@"昌都",@"阿里",@"那曲"],@[@"不限",@"西安",@"宝鸡",@"咸阳",@"铜川",@"渭南",@"延安",@"榆林",@"汉中",@"安康",@"商洛"],@[@"不限",@"兰州",@"嘉峪关",@"金昌",@"白银",@"天水",@"酒泉",@"张掖",@"武威",@"定西",@"陇南",@"平凉",@"庆阳",@"临夏",@"甘南"],@[@"不限",@"西宁",@"海东",@"海南",@"海北",@"黄南",@"玉树",@"果洛",@"海西"],@[@"不限",@"银川",@"石嘴山",@"吴忠",@"固原"],@[@"不限",@"乌鲁木齐",@"石河子",@"克拉玛依",@"伊犁",@"巴音郭勒",@"昌吉",@"克孜勒苏柯尔克孜",@"博尔塔拉",@"吐鲁番",@"哈密",@"喀什",@"和田",@"阿克苏"],@[@"不限",@"台北",@"高雄",@"台中",@"台南",@"屏东",@"南投",@"云林",@"新竹",@"彰化",@"苗栗",@"嘉义",@"花莲",@"桃园",@"宜兰",@"基隆",@"台东",@"金门",@"马祖",@"澎湖"],@[@"香港"],@[@"不限",@"澳门"]];
    self.title=@"地区";
    _tableview_city_select.delegate=self;
    _tableview_city_select.dataSource=self;
    
    
    // 定位
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate =self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [_manager requestWhenInUseAuthorization];
        
    }
    else
    {
        
        [_manager startUpdatingLocation];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return _state.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString * cell_id = @"located_city_cell";
        
        UITableViewCell *cell = [self.tableview_city_select dequeueReusableCellWithIdentifier:cell_id];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        UILabel*image1 = (UILabel*)[cell viewWithTag:1];
        image1.text=_located_city;
        return cell;
    }else{
        static NSString * cell_id = @"city_cell";
        
        UITableViewCell *cell = [self.tableview_city_select dequeueReusableCellWithIdentifier:cell_id];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        UILabel*image1 = (UILabel*)[cell viewWithTag:1];
        image1.text=_state[indexPath.row];
        return cell;


    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"定位到城市";
    }else{
        return @"全部";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 45;
    }else{
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        NSLog(@"www");
        if ([_located_city isEqual:@"正在定位"]) {
            [RKDropdownAlert title:@"正在定位中..." backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
            return;
        }
        else
        {
            
        }
    }
    
    if ([_city_select_type isEqual:@"找车-城市选择"]) {
        
        if (indexPath.section==0) {
            
            NSInteger view_count=self.navigationController.viewControllers.count;
            ZhaoCheViewController * view=self.navigationController.viewControllers[view_count-2];
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"省" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
       
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"市" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            view.selecte_city=[NSString stringWithFormat:@" %@",_located_city];
            view.car_city_search=_located_city;
            [view setupRefresh];
            [self.navigationController popViewControllerAnimated:YES];
        }
   
        if(indexPath.section==1){
            
            CityDetailSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_detail_view"];
            view.city_state=_state[indexPath.row];
            view.city_detail=_city[indexPath.row];
            view.city_select_type=_city_select_type;
             view.city_select_type = @"找车-城市选择";
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    
    
    if ([_city_select_type isEqual:@"找车-城市选择1"]) {
        
        if (indexPath.section==0) {
            
            NSInteger view_count=self.navigationController.viewControllers.count;
            sousuocheViewController * view=self.navigationController.viewControllers[view_count-2];
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"省" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"市" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            view.selecte_city=[NSString stringWithFormat:@" %@",_located_city];
            view.car_city_search=_located_city;
            [view setupRefresh];
            [self.navigationController popViewControllerAnimated:YES];
        }
            if(indexPath.section==1){
                NSLog(@"123");
                CityDetailSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_detail_view"];
                view.city_state=_state[indexPath.row];
                view.city_detail=_city[indexPath.row];
                view.city_select_type=_city_select_type;
                view.city_select_type = @"找车-城市选择1";
                [self.navigationController pushViewController:view animated:YES];
            }

    }
    
    
    
    if ([_city_select_type isEqual:@"转车—所在地"]) {
        if (indexPath.section==0) {
            NSInteger view_count=self.navigationController.viewControllers.count;
            CarInputViewController * view=self.navigationController.viewControllers[view_count-2];
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"省" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"市" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            view.model.carLocation=_located_city;
            [view.tableview_input reloadData];
                
                [self.navigationController popViewControllerAnimated:YES];
        }
        if(indexPath.section==1){
            
            CityDetailSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_detail_view"];
            view.city_state=_state[indexPath.row];
            view.city_detail=_city[indexPath.row];
            view.city_select_type=@"转车-所在地";
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    if([_city_select_type isEqual:@"转车—车辆原籍"]){
        if (indexPath.section==0) {
            NSInteger view_count=self.navigationController.viewControllers.count;
            CarInputViewController * view=self.navigationController.viewControllers[view_count-2];
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"省" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            _located_city=[_located_city stringByReplacingOccurrencesOfString:@"市" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_located_city.length)];
            
            view.model.carLocation=_located_city;
            [view.tableview_input reloadData];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        if(indexPath.section==1){
            
            CityDetailSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_detail_view"];
            view.city_state=_state[indexPath.row];
            view.city_detail=_city[indexPath.row];
            view.city_select_type=@"转车-车辆原籍";
            [self.navigationController pushViewController:view animated:YES];
        }

    }

}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_manager startUpdatingLocation];
        
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    if (lastLocation) {
        
        [_manager stopUpdatingLocation];
        
        [self geocodeCity:lastLocation];
        
    }
}

#pragma mark - 
-(void)geocodeCity:(CLLocation*)location
{
    CLGeocoder *_geoCoder = [[CLGeocoder alloc]init];
    
    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        CLPlacemark * placemark = [placemarks firstObject];
        
//        NSLog(@"个数：%lu",(unsigned long)placemarks.count);
//        
//        NSLog(@"地理位置：%@",placemark.addressDictionary);
//        
//        NSLog(@"街道1：%@",[placemark.addressDictionary objectForKey:@"Street"]);
//        NSLog(@"详细地址：%@",[placemark.addressDictionary objectForKey:@"Name"]);
//        NSLog(@"市：%@",[placemark.addressDictionary objectForKey:@"City"]);
//        NSLog(@"街道2：%@",[placemark.addressDictionary objectForKey:@"Thoroughfare"]);
//        NSLog(@"省：%@",[placemark.addressDictionary objectForKey:@"State"]);
//        NSLog(@"format：%@",[placemark.addressDictionary objectForKey:@"FormattedAddressLines"]);
//        NSLog(@"SubLocality：%@",[placemark.addressDictionary objectForKey:@"SubLocality"]);
        
        
//        provinceName= [placemark.addressDictionary objectForKey:@"State"];
        _located_city = [placemark.addressDictionary objectForKey:@"City"];
        
        [_tableview_city_select reloadData];
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
