/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "AppMetricaUtils.h"

@implementation AppMetricaUtils

+ (YMMYandexMetricaConfiguration *)configurationForDictionary:(NSDictionary *)configDict
{
    NSString *apiKey = configDict[@"apiKey"];
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:apiKey];

    if (configDict[@"appVersion"] != nil) {
        configuration.appVersion = configDict[@"appVersion"];
    }
    if (configDict[@"crashReporting"] != nil) {
        configuration.crashReporting = [configDict[@"crashReporting"] boolValue];
    }
    if (configDict[@"activationAsSessionStart"] != nil) {
        configuration.handleActivationAsSessionStart = [configDict[@"activationAsSessionStart"] boolValue];
    }
    if (configDict[@"firstActivationAsUpdate"] != nil) {
        configuration.handleFirstActivationAsUpdate = [configDict[@"firstActivationAsUpdate"] boolValue];
    }
    if (configDict[@"location"] != nil) {
        configuration.location = [self locationForDictionary:configDict[@"location"]];
    }
    if (configDict[@"locationTracking"] != nil) {
        configuration.locationTracking = [configDict[@"locationTracking"] boolValue];
    }
    if (configDict[@"logs"] != nil) {
        configuration.logs = [configDict[@"logs"] boolValue];
    }
    if (configDict[@"preloadInfo"] != nil) {
        configuration.preloadInfo = [[self class] preloadInfoForDictionary:configDict[@"preloadInfo"]];
    }
    if (configDict[@"sessionsAutoTracking"] != nil) {
        configuration.sessionsAutoTracking = [configDict[@"sessionsAutoTracking"] boolValue];
    }
    if (configDict[@"sessionTimeout"] != nil) {
        configuration.sessionTimeout = [configDict[@"sessionTimeout"] unsignedIntegerValue];
    }
    if (configDict[@"statisticsSending"] != nil) {
        configuration.statisticsSending = [configDict[@"statisticsSending"] boolValue];
    }
    if (configDict[@"revenueAutoTrackingEnabled"] != nil) {
        configuration.revenueAutoTrackingEnabled = [configDict[@"revenueAutoTrackingEnabled"] boolValue];
    }

    return configuration;
}


+ (YMMMutableUserProfile *)configurationForUserProfile:(NSDictionary *)configDict
{
    YMMMutableUserProfile *profile = [[YMMMutableUserProfile alloc] init];
    
    id<YMMCustomCounterAttribute> timeLeftAttribute = [YMMProfileAttribute customCounter:@"time_left"];
    [profile apply:[timeLeftAttribute withDelta:-4.42]];
    
    if (configDict[@"name"] != nil) {
        id<YMMNameAttribute> nameAttribute = [YMMProfileAttribute name];
        [profile apply:[nameAttribute withValue:configDict[@"name"]]];
    }
    if (configDict[@"gender"] != nil && [configDict[@"gender"] isEqualToString:@"male"]) {
        id<YMMGenderAttribute> genderAttribute = [YMMProfileAttribute gender];
        [profile apply:[genderAttribute withValue:YMMGenderTypeMale]];
    }
    if (configDict[@"gender"] != nil && [configDict[@"gender"] isEqualToString:@"female"]) {
        id<YMMGenderAttribute> genderAttribute = [YMMProfileAttribute gender];
        [profile apply:[genderAttribute withValue:YMMGenderTypeFemale]];
    }
    if (configDict[@"age"] != nil) {
        NSNumber *age = configDict[@"age"];
        id<YMMBirthDateAttribute> birthDateAttribute = [YMMProfileAttribute birthDate];
        [profile apply:[birthDateAttribute withAge:[age unsignedIntegerValue]]];
    }
    if (configDict[@"notificationEnabled"] != nil) {
        id<YMMNotificationsEnabledAttribute> isNotificationAttribute = [YMMProfileAttribute notificationsEnabled];
        [profile apply:[isNotificationAttribute withValue:configDict[@"notificationEnabled"]]];
    }
    if (configDict[@"customAttributes"] != nil) {
        NSDictionary *customAttributes = configDict[@"customAttributes"];
        if (customAttributes != nil) {
            for (NSString *key in customAttributes) {
                id<YMMCustomStringAttribute> customStringAttribute = [YMMProfileAttribute customString:key];
                [profile apply:[customStringAttribute withValue:customAttributes[key]]];
            }
        }
    }

    return profile;
}

+ (CLLocation *)locationForDictionary:(NSDictionary *)locationDict
{
    if (locationDict == nil) {
        return nil;
    }

    NSNumber *latitude = locationDict[@"latitude"];
    NSNumber *longitude = locationDict[@"longitude"];
    NSNumber *altitude = locationDict[@"altitude"];
    NSNumber *horizontalAccuracy = locationDict[@"accuracy"];
    NSNumber *verticalAccuracy = locationDict[@"verticalAccuracy"];
    NSNumber *course = locationDict[@"course"];
    NSNumber *speed = locationDict[@"speed"];
    NSNumber *timestamp = locationDict[@"timestamp"];

    NSDate *locationDate = timestamp != nil ? [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue] : [NSDate date];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                         altitude:altitude.doubleValue
                                               horizontalAccuracy:horizontalAccuracy.doubleValue
                                                 verticalAccuracy:verticalAccuracy.doubleValue
                                                           course:course.doubleValue
                                                            speed:speed.doubleValue
                                                        timestamp:locationDate];

    return location;
}

+ (YMMYandexMetricaPreloadInfo *)preloadInfoForDictionary:(NSDictionary *)preloadInfoDict
{
    if (preloadInfoDict == nil) {
        return nil;
    }

    NSString *trackingId = preloadInfoDict[@"trackingId"];
    YMMYandexMetricaPreloadInfo *preloadInfo = [[YMMYandexMetricaPreloadInfo alloc] initWithTrackingIdentifier:trackingId];

    NSDictionary *additionalInfo = preloadInfoDict[@"additionalInfo"];
    if (additionalInfo != nil) {
        for (NSString *key in additionalInfo) {
            [preloadInfo setAdditionalInfo:additionalInfo[key] forKey:key];
        }
    }

    return preloadInfo;
}

+ (NSString *)stringFromRequestDeviceIDError:(NSError *)error
{
    if (error == nil) {
        return nil;
    }
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        return @"NETWORK";
    }
    return @"UNKNOWN";
}

@end
