## Linux上Oracle数据库客户端安装与连接
### 下载安装
下载页面：https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html

我下载的是rpm包。在下载页面获取到下载地址，然后使用curl下载

首先下载基础包BasicClient
```Bash
curl-O https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm
```
然后下载工具包sqlplus
```Bash
curl-O https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-sqlplus-21.1.0.0.0-1.x86_64.rpm
```

下载完成后使用rpm命令安装包文件。

```Bash
rpm -ivh oracle-instantclient-sqlplus-21.1.0.0.0-1.x86_64.rpm
```
安装过程中弹出了ldconfig的警告，我没有管，之后查看安装文件发现安装成功了。
安装的文件默认放在两个位置：

头文件：/usr/include/oracle/21/client64/ 下，如果在使用时报错找不到头文件，记得看路径是否是这个。

包文件：/usr/lib/oracle/21/client64/ 下，包含{bin、lib}两个文件夹；

至此安装就结束了。  
此时运行命令sqlplus会让输入user name

### 登录

登录一般的命令是

```Bash
sqlplus {user}/{password}@//{ip}:{port}/{sid}
```

oracle默认端口是1521。所以省略端口的登录命令是
```Bash
sqlplus {user}/{password}@//{ip}/{sid}
```
