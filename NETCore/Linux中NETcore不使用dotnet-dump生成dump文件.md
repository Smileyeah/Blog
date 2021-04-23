## Linux中NETcore不使用dotnet-dump生成dump文件

在微软的官方文档中，dotnet-dump是被推荐来生成coredump文件，分析dump文件的。但是特定的环境下，这种方式会有很多前置条件需要满足。

1、ICU包问题。   
2、DOTNET_ROOT环境变量。  
    ① 编辑环境变量，CentOS文件为`~/.bash_profile`。添加行 `export DOTNET_ROOT=[dotnetinstalllocation]` 来解决。注意：在等号两边不能有空格。不然识别不了。  
    ② `source ~/.bash_profile`。让变量立即生效。  

### 推荐一种不使用dotnet-dump来生成dump文件的方法

其实`NETCore Runtime`就已经自带了创建dump的程序。文件位于`$dotnet/shared/Microsoft.NETCore.App/{install version}/createdump`。

1、查看NETCore版本，获取安装目录。
![image](https://user-images.githubusercontent.com/26318122/115856388-0228aa80-a45f-11eb-8b36-4da1a4ac31ec.png)

2、找到createdump并运行。`./createdump`
![image](https://user-images.githubusercontent.com/26318122/115860944-c85aa280-a464-11eb-84c4-0f669eba7779.png)

![image](https://user-images.githubusercontent.com/26318122/115861090-f344f680-a464-11eb-8bba-7eb685d0f98d.png)

3、创建dump文件。`./createdump -n -f /tmp/coredump.1 {dotnet pid}`
![image](https://user-images.githubusercontent.com/26318122/115861388-4fa81600-a465-11eb-99d8-5689603d2e3c.png)

至此dump文件已被创建。接下来就是分析。笔者对此也是不太熟悉，有时间写一些经验。
