using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing.Design;
using System.Web.UI;
using System.Web.UI.Design;
using System.Web.UI.WebControls;
using System.Web.UI.Design.WebControls;

namespace SDG.Web.UI.WebControls
{
	public class CustomDesignerDataSourceView : DesignerDataSourceView
	{
		#region Fields

		protected CustomDataSourceDesigner _owner;

		#endregion

		#region Properties

		public override IDataSourceViewSchema Schema 
		{
			get { 
				// if a type and the select method have been specified, the schema information is available
				if (!String.IsNullOrEmpty(_owner.TypeName) && !String.IsNullOrEmpty(_owner.SelectMethod)) {
					return _owner.DataSourceSchema;
				} else {
					return null;
				}
			}
		}

		#endregion

		#region Methods

		public CustomDesignerDataSourceView(CustomDataSourceDesigner owner, string viewName) : base(owner, viewName) 
		{
			_owner = owner;
		}

		#endregion
	}
}
