using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace componentes;

public class crypt
{
	private static byte[] IV = new byte[8] { 16, 17, 18, 19, 20, 21, 22, 23 };

	private crypt()
	{
	}

	public static string Desencriptar(string palabra)
	{
		string text = "";
		text = "DEMO" + DateTime.Now.Day.ToString().PadLeft(2, '0') + "K7";
		return Desencriptar(palabra, text);
	}

	public static string Desencriptar(string palabra, string key)
	{
		byte[] array = Convert.FromBase64String(palabra);
		byte[] bytes = Encoding.UTF8.GetBytes(key.Substring(0, 8));
		DESCryptoServiceProvider dESCryptoServiceProvider = new DESCryptoServiceProvider();
		MemoryStream memoryStream = new MemoryStream();
		CryptoStream cryptoStream = new CryptoStream(memoryStream, dESCryptoServiceProvider.CreateDecryptor(bytes, IV), CryptoStreamMode.Write);
		cryptoStream.Write(array, 0, array.Length);
		cryptoStream.FlushFinalBlock();
		return Encoding.UTF8.GetString(memoryStream.ToArray());
	}

	public static string Encriptar(string palabra)
	{
		string text = "";
		text = "DEMO" + DateTime.Now.Day.ToString().PadLeft(2, '0') + "K7";
		return Encriptar(palabra, text);
	}

	public static string Encriptar(string palabra, string key)
	{
		byte[] bytes = Encoding.UTF8.GetBytes(key.Substring(0, 8));
		byte[] bytes2 = Encoding.UTF8.GetBytes(palabra);
		DESCryptoServiceProvider dESCryptoServiceProvider = new DESCryptoServiceProvider();
		MemoryStream memoryStream = new MemoryStream();
		CryptoStream cryptoStream = new CryptoStream(memoryStream, dESCryptoServiceProvider.CreateEncryptor(bytes, IV), CryptoStreamMode.Write);
		cryptoStream.Write(bytes2, 0, bytes2.Length);
		cryptoStream.FlushFinalBlock();
		return Convert.ToBase64String(memoryStream.ToArray());
	}
}
