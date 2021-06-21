# sqlite3初体验

创建数据库的路径时，不能有太多级的目录

比如，"Documents/mydb.sqlite"就能创建成功，"Documents/usera/mydb.sqlite"就会创建失败，报错：

```
SQLite error 14: unable to open database file
```

