using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Data;
using System.Drawing;
using System.Reflection;
using System.Text;
using System.Windows.Forms;

namespace SDG.Web.UI.WebControls
{
	public partial class ConfigureDataSource : Form
	{
		#region Fields

		private IServiceProvider _serviceProvider;
		private CustomDataSource _component;
		private CustomDataSourceDesigner _designer;

		#endregion

		#region Properties

		internal string TypeName
		{
			get {
				// gets the selected type
				TypeItem selectedType = ddlTypes.SelectedItem as TypeItem;

				// return the selected type
				if (selectedType != null){
					return selectedType.Name;
				} else {
					return String.Empty;
				}
			}
			set {
				// iterate through all the types searching for the requested type
				foreach (TypeItem item in ddlTypes.Items){
					// if we have found it, select it
					if (String.Compare(item.Name, value, true) == 0) {
						ddlTypes.SelectedItem = item;
						break;
					}
				}
			}
		}

		internal string SelectMethod
		{
			get {
				// gets the select method
				string methodName = String.Empty;

				if (MethodInfo != null) {
					methodName = MethodInfo.Name;
				}

				return methodName;
			}
			set	{
				// iterate through all the types searching for the requested type
				foreach (MethodItem item in ddlMethods.Items) {
					// if we have found it, select it
					if (String.Compare(item.MethodInfo.Name, value, true) == 0) {
						ddlMethods.SelectedItem = item;
						break;
					}
				}
			}
		}

		internal MethodInfo MethodInfo
		{
			get {
				MethodItem item = ddlMethods.SelectedItem as MethodItem;

				if (item == null) {
					return null;
				}

				return item.MethodInfo;
			}
		}

		#endregion

		#region Methods

		public ConfigureDataSource()
		{
			InitializeComponent();
		}

		public ConfigureDataSource(IServiceProvider provider, CustomDataSourceDesigner designer)
		{
			InitializeComponent();

			_serviceProvider = provider;
			_component = designer.Component as CustomDataSource;
			_designer = designer;

			// fills the dropdownlist with the available types
			DiscoverTypes();

			// configure the form with the properties of the component
			TypeName = _component.TypeName;
			SelectMethod = _component.SelectMethod;
		}

		private void DiscoverTypes()
		{
			// try to get a reference to the type discovery service
			ITypeDiscoveryService discovery = null;
			if (_component.Site != null) {
				discovery = (ITypeDiscoveryService)_component.Site.GetService(typeof(ITypeDiscoveryService));
			}

			// if the type discovery service is available
			if (discovery != null) {
				// saves the cursor and sets the wait cursor
				Cursor previousCursor = Cursor.Current;
				Cursor.Current = Cursors.WaitCursor;

				try {
					// gets all types using the type discovery service
					ICollection types = discovery.GetTypes(typeof(object), true);
					ddlTypes.BeginUpdate();

					ddlTypes.Items.Clear();

					// adds the types to the list
					foreach (Type type in types) {
						TypeItem typeItem = new TypeItem(type);
						ddlTypes.Items.Add(typeItem);
					}
				} finally {
					Cursor.Current = previousCursor;
					ddlTypes.EndUpdate();
				}
			}
		}

		private void ddlTypes_SelectedIndexChanged(object sender, EventArgs e)
		{
			ddlMethods.Enabled = true;

			FillMethods();
		}

		private void ddlMethods_SelectedIndexChanged(object sender, EventArgs e)
		{
			bOK.Enabled = true;
		}

		private void FillMethods()
		{
			// saves the cursor and sets the wait cursor
			Cursor previousCursor = Cursor.Current;
			Cursor.Current = Cursors.WaitCursor;

			try {
			// gets all public methods (instance + static)
 				MethodInfo[] methods = CustomDataSourceDesigner.GetType(_component.Site, TypeName).GetMethods(BindingFlags.Public | BindingFlags.Static | BindingFlags.Instance | BindingFlags.FlattenHierarchy);
				ddlMethods.BeginUpdate();

				ddlMethods.Items.Clear();

				// adds the methods to the dropdownlist
				foreach (MethodInfo method in methods) {
					MethodItem methodItem = new MethodItem(method);
					ddlMethods.Items.Add(methodItem);
				}
			} finally {
				Cursor.Current = previousCursor;
				ddlMethods.EndUpdate();
			}
		}

		private void bOK_Click(object sender, EventArgs e)
		{
			// if the type has changed, save it
			if (String.Compare(TypeName, _component.TypeName, false) != 0) {
				TypeDescriptor.GetProperties(_component)["TypeName"].SetValue(_component, TypeName);
			}

			// if the select method has changed, save it
			if (String.Compare(SelectMethod, _component.SelectMethod, false) != 0) {
				TypeDescriptor.GetProperties(_component)["SelectMethod"].SetValue(_component, SelectMethod);
			}

			// if there is method selected, refresh the schema
			if (MethodInfo != null) {
				_designer.RefreshSchemaInternal(MethodInfo.ReflectedType, MethodInfo.Name, MethodInfo.ReturnType, true);
			}
		}

		#endregion
	}
}