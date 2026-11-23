using System.Text;

namespace SDG.Componentes;

public static class StringBuilderExtension
{
	public static int IndexOf(this StringBuilder theStringBuilder, string value)
	{
		if (theStringBuilder == null)
		{
			return -1;
		}
		if (string.IsNullOrEmpty(value))
		{
			return -1;
		}
		int length = theStringBuilder.Length;
		int length2 = value.Length;
		if (length < length2)
		{
			return -1;
		}
		int num = length - length2 + 1;
		for (int i = 0; i < num; i++)
		{
			bool flag = true;
			for (int j = 0; j < length2; j++)
			{
				if (theStringBuilder[i + j] != value[j])
				{
					flag = false;
					break;
				}
			}
			if (flag)
			{
				return i;
			}
		}
		return -1;
	}

	public static int IndexOf(this StringBuilder theStringBuilder, string value, int startPosition)
	{
		if (theStringBuilder == null)
		{
			return -1;
		}
		if (string.IsNullOrEmpty(value))
		{
			return -1;
		}
		int length = theStringBuilder.Length;
		int length2 = value.Length;
		if (length < length2)
		{
			return -1;
		}
		int num = length - length2 + 1;
		if (startPosition >= num)
		{
			return -1;
		}
		for (int i = startPosition; i < num; i++)
		{
			bool flag = true;
			for (int j = 0; j < length2; j++)
			{
				if (theStringBuilder[i + j] != value[j])
				{
					flag = false;
					break;
				}
			}
			if (flag)
			{
				return i;
			}
		}
		return -1;
	}

	public static bool Contains(this StringBuilder theStringBuilder, string value)
	{
		if (theStringBuilder == null)
		{
			return false;
		}
		if (string.IsNullOrEmpty(value))
		{
			return false;
		}
		int length = theStringBuilder.Length;
		int length2 = value.Length;
		if (length < length2)
		{
			return false;
		}
		int num = length - length2 + 1;
		for (int i = 0; i < num; i++)
		{
			bool flag = true;
			for (int j = 0; j < length2; j++)
			{
				if (theStringBuilder[i + j] != value[j])
				{
					flag = false;
					break;
				}
			}
			if (flag)
			{
				return true;
			}
		}
		return false;
	}
}
