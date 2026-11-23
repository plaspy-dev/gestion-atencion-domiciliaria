using System;
using System.IO;
using System.IO.Compression;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Serialization;

namespace SDG.Componentes;

public class Serializar
{
	public static byte[] Compress(byte[] bytes)
	{
		using MemoryStream memoryStream = new MemoryStream();
		using (DeflateStream deflateStream = new DeflateStream(memoryStream, CompressionMode.Compress, leaveOpen: false))
		{
			deflateStream.Write(bytes, 0, bytes.Length);
		}
		memoryStream.Close();
		return memoryStream.ToArray();
	}

	public static byte[] Decompress(byte[] bytes)
	{
		using MemoryStream stream = new MemoryStream(bytes, writable: false);
		using DeflateStream deflateStream = new DeflateStream(stream, CompressionMode.Decompress, leaveOpen: false);
		using MemoryStream memoryStream = new MemoryStream();
		byte[] array = new byte[bytes.Length];
		int count;
		while ((count = deflateStream.Read(array, 0, array.Length)) != 0)
		{
			memoryStream.Write(array, 0, count);
		}
		memoryStream.Close();
		return memoryStream.ToArray();
	}

	public static string SerializeBinary(object objeto)
	{
		return SerializeBinary(objeto, compress: true);
	}

	public static string SerializeBinary(object objeto, bool compress)
	{
		MemoryStream memoryStream = new MemoryStream();
		new BinaryFormatter().Serialize(memoryStream, objeto);
		memoryStream.Flush();
		memoryStream.Position = 0L;
		return Convert.ToBase64String(compress ? Compress(memoryStream.ToArray()) : memoryStream.ToArray());
	}

	public static T DesSerializeBinary<T>(string variable)
	{
		return DesSerializeBinary<T>(variable, compressed: true);
	}

	public static T DesSerializeBinary<T>(string variable, bool compressed)
	{
		if (!string.IsNullOrEmpty(variable))
		{
			using (MemoryStream memoryStream = new MemoryStream(compressed ? Decompress(Convert.FromBase64String(variable)) : Convert.FromBase64String(variable)))
			{
				object obj = new BinaryFormatter().Deserialize(memoryStream);
				memoryStream.Close();
				return (T)obj;
			}
		}
		return (T)Activator.CreateInstance(typeof(T));
	}

	public static string SerializeXML(object objeto, bool compress = true, bool base64 = true)
	{
		if (objeto == null)
		{
			return null;
		}
		StringBuilder stringBuilder = new StringBuilder();
		XmlSerializer xmlSerializer = new XmlSerializer(objeto.GetType());
		using (StringWriter textWriter = new StringWriter(stringBuilder))
		{
			xmlSerializer.Serialize(textWriter, objeto);
		}
		string input = stringBuilder.ToString();
		input = new Regex(">\\s*<").Replace(input, "><");
		if (base64)
		{
			return Convert.ToBase64String(compress ? Compress(Encoding.UTF8.GetBytes(input)) : Encoding.UTF8.GetBytes(input));
		}
		return input;
	}

	public static T DesSerializeXML<T>(string variable, bool compressed = true, bool base64 = true)
	{
		if (!string.IsNullOrEmpty(variable))
		{
			try
			{
				if (base64)
				{
					variable = Encoding.UTF8.GetString(compressed ? Decompress(Convert.FromBase64String(variable)) : Convert.FromBase64String(variable));
				}
				StringReader textReader = new StringReader(variable);
				return (T)new XmlSerializer(typeof(T)).Deserialize(textReader);
			}
			catch
			{
			}
		}
		return (T)Activator.CreateInstance(typeof(T));
	}

	public static T DeepClone<T>(T obj)
	{
		using MemoryStream memoryStream = new MemoryStream();
		BinaryFormatter binaryFormatter = new BinaryFormatter();
		binaryFormatter.Serialize(memoryStream, obj);
		memoryStream.Position = 0L;
		return (T)binaryFormatter.Deserialize(memoryStream);
	}
}
