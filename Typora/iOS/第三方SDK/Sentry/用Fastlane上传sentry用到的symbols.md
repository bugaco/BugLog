# 用Fastlane上传sentry用到的symbols

按着sentry的文档，上传时候，需要用到fastlane库

生成 Fastlane 文件：

```
lane :upload_symbols do
  download_dsyms # this is the important part
  sentry_upload_dsym(
    auth_token: '4e0f624ceb5f46339dc39ada0f899ae3b77fe64061494fd79ed62367464163e3',
    org_slug: 'li5249789',
    project_slug: 'news-ios',
  )
end
```

然后在命令行执行`fastlane`按照提示往下即可。

---

配置 Apple ID 和 Bundle ID，在`Appfile`文件中配置：

```
app_identifier("com.yingmifans.news") # The bundle identifier of your app
apple_id("9kuapp@xhgame.com") # Your Apple email address


# For more information about the Appfile, see:
#     https://docs.fastlane.tools/advanced/#appfile
```

完成之后，用以下命令，便可以一键上传：

`fastlane upload_symbols`