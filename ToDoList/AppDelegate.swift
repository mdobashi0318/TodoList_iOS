//
//  AppDelegate.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import UserNotifications
import Toast_Swift
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        requestAuthorization()

        let toDoListViewController: ToDoListViewController = ToDoListViewController()
        let navigation: UINavigationController = UINavigationController(rootViewController: toDoListViewController)

        //        navigation.navigationBar.barTintColor = .white
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()

        NotificationCenter.default.addObserver(self, selector: #selector(showToast(notification:)), name: NSNotification.Name(rawValue: R.string.notification.toast()), object: nil)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: - Toast_Swift

extension AppDelegate {

    @objc func showToast(notification: Notification) {
        if notification.object as! Bool == false {
            self.window?.makeToast("期限の登録に失敗しました", duration: 5.0, position: .bottom)
        }
    }

}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// 通知の許可
    fileprivate func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in
            center.delegate = self
        }
    }

    /// フォアグラウンドでローカル通知を出す
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.sound])

        let banner = FloatingNotificationBanner(title: notification.request.content.title,
                                                subtitle: notification.request.content.body,
                                                style: .success
        )
        banner.autoDismiss = false
        banner.onSwipeUp = {
            banner.dismiss()
            NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
        }

        banner.show(queuePosition: .front,
                    bannerPosition: .top,
                    cornerRadius: 10)
    }

}
