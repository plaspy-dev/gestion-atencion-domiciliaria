using System;
using System.Collections;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Drawing.Design;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.Design;
using System.Web.UI.WebControls;
using System.Windows.Forms.Design;
using System.Windows.Forms;

namespace SDG.Web.UI.WebControls
{
	public class CustomDataSourceDesigner : DataSourceDesigner
	{
		#region Fields

		private static readonly string[] _views = { "DefaultView" };

		private CustomDesignerDataSourceView _view;
		private bool _inWizard;

		#endregion

		#region Properties

		public override bool CanConfigure
		{
			get { return true; }
		}

		public override bool CanRefreshSchema
		{
			get	{
				// if a type and the select method have been specified, the schema can be refreshed
				if (!String.IsNullOrEmpty(TypeName) && !String.IsNullOrEmpty(SelectMethod)) {
					return true;
				} else {
					return false;
				}
			}
		}

		public string TypeName
		{
			get { return DataSourceComponent.TypeName; }
			set	{
				// if the type has changed
				if (String.Compare(DataSourceComponent.TypeName, value, false) != 0){
					DataSourceComponent.TypeName = value;

					// notify to the associated designers that this component has changed
					if (CanRefreshSchema){
						RefreshSchema(true);
					} else {
						OnDataSourceChanged(EventArgs.Empty);
					}

					UpdateDesignTimeHtml();
				}
			}
		}

		public string SelectMethod
		{
			get { return DataSourceComponent.SelectMethod; }
			set	{
				// if the select method has changed
				if (String.Compare(DataSourceComponent.SelectMethod, value, false) != 0){
					DataSourceComponent.SelectMethod = value;

					// notify to the associated designers that this component has changed
					if (CanRefreshSchema && !_inWizard){
						RefreshSchema(true);
					} else {
						OnDataSourceChanged(EventArgs.Empty);
					}

					UpdateDesignTimeHtml();
				}
			}
		}

		internal CustomDataSource DataSourceComponent
		{
			get { return Component as CustomDataSource; }
		}

		internal IDataSourceViewSchema DataSourceSchema
		{
			get { return DesignerState["DataSourceSchema"] as IDataSourceViewSchema; }
			set { DesignerState["DataSourceSchema"] = value; }
		}

		protected CustomDesignerDataSourceView View
		{
			get {
				if (_view == null){
					_view = new CustomDesignerDataSourceView(this, _views[0]);
				}
				return _view;
			}
		}

		#endregion

		#region Methods

		public override DesignerDataSourceView GetView(string viewName)
		{
			if ((viewName == null) || ((viewName.Length != 0) && (String.Compare(viewName, "DefaultView", StringComparison.OrdinalIgnoreCase) != 0))){
				throw new ArgumentException("An invalid view was requested", "viewName");
			}

			return View;
		}

		public override string[] GetViewNames()
		{
			return _views;
		}

		public override void Configure()
		{
			_inWizard = true;

			// generate a transaction to undo changes
			InvokeTransactedChange(Component, new TransactedChangeCallback(ConfigureDataSourceCallback), null, "ConfigureDataSource");

			_inWizard = false;
		}

		protected virtual bool ConfigureDataSourceCallback(object context)
		{
			try {
				SuppressDataSourceEvents();

				IServiceProvider provider = Component.Site;
				if (provider == null){
					return false;
				}

				// get the service needed to show a form
				IUIService UIService = (IUIService) provider.GetService(typeof(IUIService));
				if (UIService == null){
					return false;
				}

				// shows the form
				ConfigureDataSource configureForm = new ConfigureDataSource(provider, this);
				if (UIService.ShowDialog(configureForm) == DialogResult.OK){
					OnDataSourceChanged(EventArgs.Empty);
					return true;
				}
 
			} finally {
				ResumeDataSourceEvents();
			}

			return false;
		}

		public override void RefreshSchema(bool preferSilent)
		{
			// saves the old cursor
			Cursor oldCursor = Cursor.Current;

			try {
				// ignore data source events while refreshing the schema
				SuppressDataSourceEvents();

				try {
					Cursor.Current = Cursors.WaitCursor;

					// gets the Type used in the DataSourceControl
					Type type = GetType(Component.Site, TypeName);

					// if we can't find the type, return
					if (type == null) {
						return;
					}

					// get all the methods that can be used as the select method
					MethodInfo[] methods = type.GetMethods(BindingFlags.FlattenHierarchy | BindingFlags.Static | BindingFlags.Instance | BindingFlags.Public);

					MethodInfo selectedMethod = null;

					// iterates through the methods searching for the select method
					foreach (MethodInfo method in methods) {
						// if the method is named as the selected method, select it
						if (IsMatchingMethod(method, SelectMethod)) {
							selectedMethod = method;
							break;
						}
					}

					// if the SelectMethod was found, save the type information
					if (selectedMethod != null) {
						RefreshSchemaInternal(type, selectedMethod.Name, selectedMethod.ReturnType, preferSilent);
					}
				} finally {
					// restores the cursor
					Cursor.Current = oldCursor;
				}
			} finally {
				// resume data source events
				ResumeDataSourceEvents();
			}
		}

		internal void RefreshSchemaInternal(Type typeName, string method, Type returnType, bool preferSilent)
		{
			// if all parameters are filled
			if ((typeName != null) && (!String.IsNullOrEmpty(method)) && (returnType != null)) {
				try {
					// gets the old schema
					IDataSourceViewSchema oldSchema = DataSourceSchema;

					// gets the schema of the return type
					IDataSourceViewSchema[] typeSchemas = new TypeSchema(returnType).GetViews();

					// if we can't get schema information from the type, exit
					if ((typeSchemas == null) || (typeSchemas.Length == 0)){
						DataSourceSchema = null;

						return;
					}

					// get a view of the schema
					IDataSourceViewSchema newSchema = typeSchemas[0];

					// if the schema has changed, raise the schema refreshed event
					if (!DataSourceDesigner.ViewSchemasEquivalent(oldSchema, newSchema)){
						DataSourceSchema = newSchema;

						OnSchemaRefreshed(EventArgs.Empty);
					}
				} catch (Exception e){
					if (!preferSilent){
						ShowError(DataSourceComponent.Site, "Cannot retrieve type schema for " + returnType.FullName + ". " + e.Message);
					}
				}
			}
		}

		protected override void PreFilterProperties(IDictionary properties)
		{
			base.PreFilterProperties(properties);

			// filters the TypeName property
			PropertyDescriptor typeNameProp = (PropertyDescriptor)properties["TypeName"];
			properties["TypeName"] = TypeDescriptor.CreateProperty(base.GetType(), typeNameProp, new Attribute[0]);

			// filters the SelectMethod property
			PropertyDescriptor selectMethodProp = (PropertyDescriptor)properties["SelectMethod"];
			properties["SelectMethod"] = TypeDescriptor.CreateProperty(base.GetType(), selectMethodProp, new Attribute[0]);
		}

		private void ShowError(ISite serviceProvider, string message)
		{
			// gets a reference to the UI service and shows the error message box
			IUIService UIService = (IUIService)serviceProvider.GetService(typeof(IUIService));
			if (UIService != null){
				UIService.ShowError(message);
			}
		}

		private bool IsMatchingMethod(MethodInfo method, string selectMethod)
		{
			// we only check the name of the method
			return String.Compare(method.Name, selectMethod, true) == 0;
		}

		internal static Type GetType(IServiceProvider serviceProvider, string typeName)
		{
			// try to get a reference to the resolution service
			ITypeResolutionService resolution = (ITypeResolutionService)serviceProvider.GetService(typeof(ITypeResolutionService));
			if (resolution == null) {
				return null;
			}

			// try to get the type
			return resolution.GetType(typeName, false, true);
		}

		#endregion
	}
}
