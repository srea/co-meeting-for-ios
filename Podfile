pod 'NXOAuth2Client', '~>1.2.6'
pod 'PBWebViewController', '~>0.2'
pod 'JSONModel', '~>0.13.0'
pod 'AFNetworking', '~>2.3.1'
pod 'BlocksKit', '~> 2.2.3'
pod 'NSDate+TimeAgo', '~> 1.0.3'
pod 'NSDateMinimalTimeAgo', '~> 0.1.0'
pod 'CWStatusBarNotification', '~> 2.1.1'
pod 'CrittercismSDK', '~> 4.3.3'
pod 'GoogleAnalytics-iOS-SDK', '~> 3.0.7'
pod 'FontAwesomeKit', '~> 2.1.6'
pod 'CTFeedback', '~> 1.0.10'
pod 'StaticDataTableViewController', '~> 2.0.3'
pod 'Parse', '~> 1.2.19'
pod 'NJKWebViewProgress', '~> 0.2.3'
pod 'WSCoachMarksView'

#pod 'SuProgress'
#pod 'AZSocketIO', '~> 0.0.5'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-acknowledgements.plist', 'co-meeting/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
