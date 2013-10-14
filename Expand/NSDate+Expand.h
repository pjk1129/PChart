//
//  NSDate+Expand.h
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import <Foundation/Foundation.h>


struct DateInformation {
	NSInteger day;
	NSInteger month;
	NSInteger year;
	
	NSInteger weekday;
	
	NSInteger minute;
	NSInteger hour;
	NSInteger second;
	
};
typedef struct DateInformation DateInformation;

typedef enum {
    
    NSDateSecondsType = 0,
    NSDateMinutesType = 1,
    NSDateHoursType   = 2,
    NSDateDaysType    = 3,
    NSDateWeekType    = 4,
    NSDateMonthsType  = 5,
    NSDateYearType    = 6
    
} NSDateTimeType;

@interface NSDate (Expand)

+(int) unixTimestampFromDate:(NSDate *)aDate;
+(int) unixTimestampNow;
+ (NSDate *)date:(NSDate *)aDate add:(NSUInteger)increment of:(NSDateTimeType)type;

+ (NSDate *) yesterday;
+ (NSDate *) month;

- (NSDate *) monthDate;

- (BOOL) isSameDay:(NSDate*)anotherDate;
- (NSInteger) monthsBetweenDate:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)d;
- (BOOL) isToday;


- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;

- (NSString *) monthString;
- (NSString *) yearString;


- (DateInformation) dateInformation;
- (DateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(DateInformation)info;
+ (NSDate*) dateFromDateInformation:(DateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(DateInformation)info;

@end
