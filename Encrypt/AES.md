### AES-128、AES-192和AES-256
AES最常见的有3种方案，分别是AES-128、AES-192和AES-256，它们的区别在于密钥长度不同，AES-128的密钥长度为16bytes（128bit / 8），后两者分别为24bytes和32bytes。

```
        /// <summary>  
        /// AES加密
        /// </summary>  
        /// <param name="plainBytes">被加密的明文</param>  
        /// <param name="key">密钥</param>  
        /// <returns>密文</returns>  
        public static string AESEncrypt(string Data, string Key)
        {
            MemoryStream mStream = new MemoryStream();
            RijndaelManaged aes = new RijndaelManaged();

            byte[] plainBytes = Encoding.UTF8.GetBytes(Data);
            byte[] bKey = new byte[32];
            Array.Copy(Encoding.UTF8.GetBytes(Key.PadRight(bKey.Length)), bKey, bKey.Length);

            aes.Mode = CipherMode.ECB;
            aes.Padding = PaddingMode.PKCS7;
            aes.KeySize = 128;
            aes.Key = bKey;
            CryptoStream cryptoStream = new CryptoStream(mStream, aes.CreateEncryptor(), CryptoStreamMode.Write);
            try
            {
                cryptoStream.Write(plainBytes, 0, plainBytes.Length);
                cryptoStream.FlushFinalBlock();
                return Convert.ToBase64String(mStream.ToArray());
            }
            finally
            {
                cryptoStream.Close();
                mStream.Close();
                aes.Clear();
            }
        }


        /// <summary>  
        /// AES解密  
        /// </summary>  
        /// <param name="encryptedBytes">被加密的明文</param>  
        /// <param name="key">密钥</param>  
        /// <returns>明文</returns>  
        internal static string AESDecrypt(String Data, String Key)
        {
            byte[] encryptedBytes = Convert.FromBase64String(Data);
            byte[] bKey = new byte[32];
            Array.Copy(Encoding.UTF8.GetBytes(Key.PadRight(bKey.Length)), bKey, bKey.Length);

            MemoryStream mStream = new MemoryStream(encryptedBytes);
            RijndaelManaged aes = new RijndaelManaged();
            aes.Mode = CipherMode.ECB;
            aes.Padding = PaddingMode.PKCS7;
            aes.KeySize = 128;
            aes.Key = bKey;
            CryptoStream cryptoStream = new CryptoStream(mStream, aes.CreateDecryptor(), CryptoStreamMode.Read);
            try
            {
                byte[] tmp = new byte[encryptedBytes.Length + 32];
                int len = cryptoStream.Read(tmp, 0, encryptedBytes.Length + 32);
                byte[] ret = new byte[len];
                Array.Copy(tmp, 0, ret, 0, len);
                return Encoding.UTF8.GetString(ret);
            }
            finally
            {
                cryptoStream.Close();
                mStream.Close();
                aes.Clear();
            }
        }
```
上述算法采用ECB/PCKS7，也可使用CBC

### ECB和CBC模式的区别
ECB模式的全称是Electronic Codebook Book，即电码本模式。这种模式是将整个明文分成若干个长度相同的分组，然后对每一小组进行加密，并将加密结果拼接为最终结果，C = C1C2C3......Cn。它与ECB模式的DES算法加密流程基本一致。

CBC模式的全称是Cipher Block Chaining，这种模式是先将明文切分成若干个长度相同的分组（与ECB模式一样），此时先利用初始向量IV与第一组数据进行异或后再进行加密运算生成C1。将C1作为初始向量与第二组数据进行异或后再进行加密运算生成C2。以此类推，当最后一组数据加密完毕后，将加密结果拼接为最终结果，C = C1C2C3......Cn。



