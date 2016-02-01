using System;
using System.Reflection;
using System.Text;

namespace SDG.Web.UI.WebControls
{
	internal class MethodItem
	{
		#region Fields

		private MethodInfo _methodInfo;

		#endregion

		#region Properties

		public MethodInfo MethodInfo
		{
			get { return _methodInfo; }
		}

		#endregion

		#region Methods

		public MethodItem(MethodInfo methodInfo)
		{
			_methodInfo = methodInfo;
		}

		public override string ToString()
		{
			if (_methodInfo == null) {
				return "(none)";
			} else {
				return GetMethodSignature(_methodInfo);
			}
		}

		private string GetMethodSignature(MethodInfo method)
		{
			StringBuilder sb = new StringBuilder();
			sb.Append(method.Name);
			
			// add the parameters
			sb.Append("(");
			ParameterInfo[] parameters = method.GetParameters();
			foreach (ParameterInfo param in parameters) {
				sb.Append(param.ParameterType.Name);
				sb.Append(" ");
				sb.Append(param.Name);
				sb.Append(", ");
			}

			if (parameters.Length > 0){
				sb.Length -= 2;
			}
			sb.Append(")");

			// add the return type
			if (method.ReturnType != typeof(void)) {
				sb.Append(", returns ");
				sb.Append(method.ReturnType.Name);
			}

			return sb.ToString();
		}

		#endregion
	}
}
