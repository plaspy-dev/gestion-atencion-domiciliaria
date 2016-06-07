using System;
using System.Collections.Generic;
using System.Text;

namespace SDG.Web.UI.WebControls
{
	internal class TypeItem
	{
		#region Fields

		private Type _type;

		#endregion

		#region Properties

		public Type Type
		{
			get { return _type; }
		}

		public string Name
		{
			get { return _type.FullName; }
		}

		#endregion

		#region Methods

		public TypeItem(Type type)
		{
			_type = type;
		}

		public override string ToString()
		{
			return Name;
		}

		#endregion
	}
}
