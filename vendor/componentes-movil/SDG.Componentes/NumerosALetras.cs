using System;

namespace SDG.Componentes;

public class NumerosALetras
{
	private static string[] m_saCeroAVeinte = new string[20]
	{
		"cero", "un", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve",
		"diez", "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve"
	};

	private static string[] m_saCientos = new string[10] { "", "ciento", "docientos", "trecientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos" };

	private static string[] m_saDeca = new string[8] { "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa" };

	private static string[] m_saMasDeMil = new string[5] { "", "mil", "millon", "mil millones", "billon" };

	protected static string convert_nn(int val)
	{
		if (val < 20)
		{
			return m_saCeroAVeinte[val];
		}
		for (int i = 0; i < 10; i++)
		{
			string text = m_saDeca[i];
			if (20 + 10 * i + 10 > val)
			{
				if (val % 10 != 0)
				{
					return text + " y " + m_saCeroAVeinte[val % 10];
				}
				return text;
			}
		}
		return "";
	}

	protected static string convert_nnn(int val)
	{
		string text = "";
		int num = val / 100;
		int num2 = val % 100;
		if (num > 0)
		{
			text = m_saCientos[num];
			if (num2 > 0)
			{
				text += " ";
			}
		}
		if (num2 > 0)
		{
			text += convert_nn(num2);
		}
		else if (num < 2)
		{
			string text2 = text;
			text2.Remove(text2.Length - 1);
			string text3 = text;
			text3.Remove(text3.Length - 1);
		}
		return text;
	}

	public static string ToLetras(double valor)
	{
		string text = ToLetras(valor, comas: false);
		if (text.Length > 0)
		{
			text = text.Substring(0, 1).ToUpper() + text.Substring(1);
		}
		return text;
	}

	public static string ToLetras(double valor, bool comas)
	{
		valor = Math.Floor(valor);
		if (valor < 100.0)
		{
			return convert_nn(Convert.ToInt32(valor));
		}
		if (valor < 1000.0)
		{
			return convert_nnn(Convert.ToInt32(valor));
		}
		for (int i = 1; i < 5; i++)
		{
			if (Math.Pow(1000.0, i) > valor)
			{
				int num = i - 1;
				double num2 = Math.Pow(1000.0, num);
				double num3 = Math.Floor(valor / num2);
				double num4 = valor - num3 * num2;
				string text = ((num > 1 && num3 != 1.0) ? (convert_nnn(Convert.ToInt32(num3)) + " " + m_saMasDeMil[num] + "es") : ((num3 != 1.0) ? (convert_nnn(Convert.ToInt32(num3)) + " " + m_saMasDeMil[num]) : ((num != 1 && num != 3) ? (convert_nnn(Convert.ToInt32(num3)) + " " + m_saMasDeMil[num]) : m_saMasDeMil[num])));
				if (num4 > 0.0)
				{
					text = ((!comas) ? (text + " " + ToLetras(num4)) : (text + ", " + ToLetras(num4)));
				}
				return text;
			}
		}
		return "";
	}
}
