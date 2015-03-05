using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.ServiceModel;
using System.Web;

namespace SDG.Componentes;

public class Logs
{
	public static string DumpPage(HttpServerUtility Server, HttpRequest Request)
	{
		string text = "";
		Exception ex = null;
		try
		{
			ex = Server.GetLastError().GetBaseException();
		}
		catch
		{
		}
		try
		{
			text = DateTime.Now.ToString() + " Error[app] : ";
			if (ex is HttpException)
			{
				object obj2 = text;
				text = string.Concat(obj2, "(", ((HttpException)ex).GetHttpCode(), ") ");
			}
			string text2 = text;
			text = text2 + Request.Url.ToString() + " - '" + ex.Message.ToString() + "'";
			text += "\r\n";
		}
		catch
		{
		}
		try
		{
			text += "Headers";
			text += "\r\n";
			foreach (string header in Request.Headers)
			{
				text = text + header + "=" + Request.Headers[header];
				text += "\r\n";
			}
		}
		catch
		{
		}
		try
		{
			text += "Contenido";
			text += "\r\n";
			Request.InputStream.Seek(0L, SeekOrigin.Begin);
			StreamReader streamReader = new StreamReader(Request.InputStream);
			string text4 = streamReader.ReadToEnd();
			if (!string.IsNullOrEmpty(text4))
			{
				text += text4;
				text += "\r\n";
				text += HttpUtility.UrlDecode(text4);
				text += "\r\n";
			}
		}
		catch
		{
		}
		try
		{
			text += "Form";
			text += "\r\n";
			foreach (string item in Request.Form)
			{
				switch (item)
				{
				case "__EVENTTARGET":
				case "__EVENTARGUMENT":
				case "__VIEWSTATE":
				case "__VIEWSTATEENCRYPTED":
				case "__EVENTVALIDATION":
				case "__VC":
					continue;
				}
				text = text + item + "=" + Request.Form[item];
				text += "\r\n";
			}
		}
		catch
		{
		}
		try
		{
			text += ex.StackTrace.ToString();
			text += "\r\n";
		}
		catch
		{
		}
		return text + "\r\n";
	}

	[MethodImpl(MethodImplOptions.NoInlining)]
	public static string GetCurrentMethod(int stack)
	{
		StackTrace stackTrace = new StackTrace();
		StackFrame frame = stackTrace.GetFrame(stack);
		return frame.GetMethod().Name;
	}

	[MethodImpl(MethodImplOptions.NoInlining)]
	public static string GetCurrentClass(int stack = 1)
	{
		StackTrace stackTrace = new StackTrace();
		StackFrame frame = stackTrace.GetFrame(stack);
		return frame.GetMethod().DeclaringType.ToString();
	}

	public static bool WriteClassLog(string log, string ClassName = null, string functionName = null)
	{
		if (ClassName == null)
		{
			ClassName = GetCurrentClass(2);
		}
		if (functionName == null)
		{
			functionName = GetCurrentMethod(2);
		}
		string text = $"{DateTime.Now} [{ClassName}:{functionName}] ";
		try
		{
			string text2 = "";
			text2 = ((HttpContext.Current != null) ? HttpContext.Current.Request.Url.ToString() : ((OperationContext.Current != null) ? OperationContext.Current.IncomingMessageHeaders.To.ToString() : Path.GetFileName(Assembly.GetEntryAssembly().Location)));
			text += $"({text2}) ";
		}
		catch
		{
		}
		return WriteLog(text + log);
	}

	public static bool WriteLog(string logs)
	{
		string archivo = "";
		if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["filelogs"]))
		{
			archivo = ConfigurationManager.AppSettings["filelogs"].ToString();
		}
		return WriteLog(logs, archivo);
	}

	public static bool Write(string log, params object[] args)
	{
		if (args.Length > 0)
		{
			log = string.Format(log, args);
		}
		return WriteLog(log);
	}

	public static bool WriteLog(string logs, string archivo)
	{
		try
		{
			string text = ((HttpContext.Current != null) ? HttpContext.Current.Request.Url.Segments[1].Replace("/", "") : ((OperationContext.Current != null) ? OperationContext.Current.IncomingMessageHeaders.To.ToString() : Path.GetFileName(Assembly.GetEntryAssembly().Location)));
			EventLog.WriteEntry("Application", text + ": " + logs);
		}
		catch
		{
		}
		try
		{
			if (!string.IsNullOrEmpty(archivo))
			{
				if (!File.Exists(archivo))
				{
					using StreamWriter streamWriter = File.CreateText(archivo);
					streamWriter.WriteLine(logs);
				}
				else
				{
					using StreamWriter streamWriter2 = File.AppendText(archivo);
					streamWriter2.WriteLine(logs);
				}
				return true;
			}
		}
		catch
		{
		}
		return false;
	}
}
