using System.Text;

namespace SDG.Componentes;

public class StringBuilderEx
{
	public StringBuilder StringBuilder { get; set; }

	public StringBuilderEx()
	{
		StringBuilder = new StringBuilder();
	}

	public StringBuilderEx(string value)
	{
		StringBuilder = new StringBuilder(value);
	}

	public StringBuilderEx(StringBuilder value)
	{
		StringBuilder = value;
	}

	public StringBuilderEx Append(object value)
	{
		StringBuilder.Append(value);
		return this;
	}

	public StringBuilderEx Replace(string oldValue, string newValue)
	{
		StringBuilder.Replace(oldValue, newValue);
		return this;
	}

	public static StringBuilderEx operator +(StringBuilderEx This, string stringB)
	{
		return This.Append(stringB);
	}

	public static implicit operator StringBuilderEx(string value)
	{
		return new StringBuilderEx(value);
	}

	public static implicit operator StringBuilderEx(StringBuilder value)
	{
		return new StringBuilderEx(value);
	}

	public static implicit operator StringBuilder(StringBuilderEx value)
	{
		return value.StringBuilder;
	}

	public override string ToString()
	{
		return StringBuilder.ToString();
	}

	public bool Contains(string value)
	{
		return StringBuilder.Contains(value);
	}

	public int IndexOf(string value)
	{
		return StringBuilder.IndexOf(value);
	}

	public int IndexOf(string value, int startPosition)
	{
		return StringBuilder.IndexOf(value, startPosition);
	}

	public string Substring(int startIndex)
	{
		return Substring(startIndex, StringBuilder.Length - startIndex);
	}

	public string Substring(int startIndex, int length)
	{
		return StringBuilder.ToString(startIndex, length);
	}

	public StringBuilderEx Insert(int index, string value)
	{
		StringBuilder = StringBuilder.Insert(index, value);
		return this;
	}
}
