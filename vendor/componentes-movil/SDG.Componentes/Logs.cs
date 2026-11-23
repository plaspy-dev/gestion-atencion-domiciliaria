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
		return DumpPage(Server, Request, new Query(""));
	}

	public static bool DumpPage(HttpServerUtility Server, HttpRequest Request, Conector conector)
	{
		Query query = new Query("pageError");
		DumpPage(Server, Request, query);
		return conector.QueryMod(query.GetInsert(), false) != -1;
	}

	public static string DumpPage(HttpServerUtility Server, HttpRequest Request, Query query)
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
			query["fecha"] = "SYSDATE()";
			query["url"] = Request.Url.ToString();
			query["error"] = ex.Message.ToString();
			text = DateTime.Now.ToString() + " Error[app] : ";
			if (ex is HttpException)
			{
				text = text + "(" + ((HttpException)ex).GetHttpCode() + ") ";
				query["httpexception"] = ((HttpException)ex).GetHttpCode();
			}
			text = text + Request.Url.ToString() + " - '" + ex.Message.ToString() + "'";
			text += "\r\n";
		}
		catch
		{
		}
		try
		{
			text += "Headers";
			text += "\r\n";
			string text2 = "";
			foreach (string header in Request.Headers)
			{
				text2 = text2 + header + "=" + Request.Headers[header];
				text2 += "\r\n";
			}
			query["headers"] = text2;
			text += text2;
		}
		catch
		{
		}
		try
		{
			text += "Contenido";
			text += "\r\n";
			Request.InputStream.Seek(0L, SeekOrigin.Begin);
			string text4 = new StreamReader(Request.InputStream).ReadToEnd();
			if (!string.IsNullOrEmpty(text4))
			{
				text += text4;
				text += "\r\n";
				text += HttpUtility.UrlDecode(text4);
				text += "\r\n";
				query["contenido"] = HttpUtility.UrlDecode(text4);
			}
		}
		catch
		{
		}
		try
		{
			text += "Form";
			text += "\r\n";
			string text5 = "";
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
				text5 = text5 + item + "=" + Request.Form[item];
				text5 += "\r\n";
			}
			query["form"] = text5;
			text += text5;
		}
		catch
		{
		}
		try
		{
			query["stacktrace"] = ex.StackTrace.ToString();
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
		return new StackTrace().GetFrame(stack).GetMethod().Name;
	}

	[MethodImpl(MethodImplOptions.NoInlining)]
	public static string GetCurrentClass(int stack = 1)
	{
		return new StackTrace().GetFrame(stack).GetMethod().DeclaringType.ToString();
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
		if (args.Length != 0)
		{
			log = string.Format(log, args);
		}
		return WriteLog(log);
	}

	public static bool WriteLog(string logs, string archivo)
	{
		try
		{
			if (HttpContext.Current == null)
			{
				if (OperationContext.Current == null)
				{
					Path.GetFileName(Assembly.GetEntryAssembly().Location);
				}
				else
				{
					OperationContext.Current.IncomingMessageHeaders.To.ToString();
				}
			}
			else
			{
				HttpContext.Current.Request.Url.Segments[1].Replace("/", "");
			}
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
