### TaskCompletionSource<T>的使用


## 用于原始的Windows API，socket。


~~~
public static Task<Socket> AcceptAsync(this Socket socket)
{
    if (socket == null)
        throw new ArgumentNullException("socket");

    var tcs = new TaskCompletionSource<Socket>();

    socket.BeginAccept(asyncResult =>
    {
        try
        {
            var s = asyncResult.AsyncState as Socket;
            var client = s.EndAccept(asyncResult);

            tcs.SetResult(client);
        }
        catch (Exception ex)
        {
            tcs.SetException(ex);
        }

    }, socket);

    return tcs.Task;
}
~~~

使用Task.Factory.StartNew会创建一个在线程池线程上运行的新任务，但是上面的代码利用了BeginAccept启动的I / O完成线程，ow：它不会启动新线程。

## 一般用法

与 async关键字一起使用

~~~
public Task<Args> SomeApiWrapper()
{
    TaskCompletionSource<Args> tcs = new TaskCompletionSource<Args>(); 

    var obj = new SomeApi();

    // will get raised, when the work is done
    obj.Done += (args) => 
    {
        // this will notify the caller 
        // of the SomeApiWrapper that 
        // the task just completed
        tcs.SetResult(args);
    }

    // start the work
    obj.Do();

    return tcs.Task;
}
~~~
