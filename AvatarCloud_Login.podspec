

Pod::Spec.new do |s|
    
  s.name             = 'AvatarCloud_Login'
  s.version          = '1.0.0'
  s.summary          = '云头像SDK的基础上，增加一键登录功能'
  s.homepage         = 'https://github.com/bj-jrxj/AvatarCloud-Login_iOS'

  s.description      = <<-DESC
                       头像云+一键登录
                       DESC

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bj-jrxj' => 'denghua@msn.com' }
  s.source           = { :git => 'https://github.com/bj-jrxj/AvatarCloud-Login_iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  

  s.source_files = 'AvatarCloud_Login/AvatarCloudSDK.framework/Headers/*'
  s.vendored_frameworks = [
                            "AvatarCloud_Login/AvatarCloudSDK.framework",
                          ]
  s.resources = 'AvatarCloud_Login/AvatarCloudSDK.framework/AvatarCloudSDK.bundle'
  s.framework = 'Network'
end
