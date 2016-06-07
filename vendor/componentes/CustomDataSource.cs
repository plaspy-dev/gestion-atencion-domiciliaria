using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing.Design;
using System.Web.UI;
using System.Web.UI.Design;
using System.Web.UI.WebControls;
using System.Web.UI.Design.WebControls;
using System.Data;

namespace SDG.Web.UI.WebControls
{
	[PersistChildren(false), ParseChildren(true)]
	[Designer(typeof(CustomDataSourceDesigner))]
	public class CustomDataSource : DataSourceControl
	{
		#region Fields

		protected static readonly string[] _views = { "DefaultView" };
        protected string _ConnectionString = "";
        protected string _SelectCommand = "";
        protected string _DeleteCommand = "";
        protected string _UpdateCommand = "";
        protected string _InsertCommand = "";
        protected string _ParentDataSource = "";
		protected CustomDataSourceView _view;

		#endregion

		#region Properties

        [Category("ParentDataSource"), DefaultValue("")]
        public string ParentDataSource
        {
            get { return _ParentDataSource; }
            set { _ParentDataSource = value; }
        }
        [Category("InsertCommand"), DefaultValue("")]
        public string InsertCommand
        {
            get { return _InsertCommand; }
            set { _InsertCommand = value; }
        }
        [Category("SelectCommand"), DefaultValue("")]
        public string SelectCommand
        {
            get { return _SelectCommand; }
            set { _SelectCommand = value; }
        }
        [Category("DeleteCommand"), DefaultValue("")]
        public string DeleteCommand
        {
            get { return _DeleteCommand; }
            set { _DeleteCommand = value; }
        }
        [Category("UpdateCommand"), DefaultValue("")]
        public string UpdateCommand
        {
            get { return _UpdateCommand; }
            set { _UpdateCommand = value; }
        }
        [Category("ConnectionString"), DefaultValue("")]
        public string ConnectionString
		{
            get { return _ConnectionString; }
            set { _ConnectionString = value; }
		}
        [Category("Data"), DefaultValue("")]
        public string TypeName
        {
            get { return View.TypeName; }
            set { View.TypeName = value; }
        }

		[Category("Data"), DefaultValue("")]
		public string SelectMethod
		{
			get { return View.SelectMethod; }
			set { View.SelectMethod = value; }
		}

		[PersistenceMode(PersistenceMode.InnerProperty), Category("Data"), DefaultValue((string) null), MergableProperty(false), Editor(typeof(ParameterCollectionEditor), typeof(UITypeEditor))]
		public ParameterCollection SelectParameters
		{
			get { return View.SelectParameters;	}
		}

        [PersistenceMode(PersistenceMode.InnerProperty), Category("Data"), DefaultValue((string)null), MergableProperty(false), Editor(typeof(ParameterCollectionEditor), typeof(UITypeEditor))]
        public ParameterCollection InsertParameters
        {
            get { return View.InsertParameters; }
        }

        [PersistenceMode(PersistenceMode.InnerProperty), Category("Data"), DefaultValue((string)null), MergableProperty(false), Editor(typeof(ParameterCollectionEditor), typeof(UITypeEditor))]
        public ParameterCollection UpdateParameters
        {
            get { return View.UpdateParameters; }
        }

		protected CustomDataSourceView View
		{
			get {
				if (_view == null){
					_view = new CustomDataSourceView(this, _views[0]);
					if (base.IsTrackingViewState) {
						((IStateManager)_view).TrackViewState();
					}
				}
				return _view;
			}
		}

		#endregion

		#region Methods

		#region Constructors

		public CustomDataSource()
		{
		}

		#endregion

		#region IDataSource Methods

		protected override DataSourceView GetView(string viewName)
		{
			if ((viewName == null) || ((viewName.Length != 0) && (String.Compare(viewName, "DefaultView", StringComparison.OrdinalIgnoreCase) != 0))){
				throw new ArgumentException("An invalid view was requested", "viewName");
			}

			return View;
		}

		protected override ICollection GetViewNames()
		{
			return _views;
		}

		#endregion

		#region ViewState Management

		// We use a pair to store the view state. The first element is used to store the parent's view state
		// The second element is used to store the view's view state

		protected override void LoadViewState(object savedState)
		{
			Pair previousState = (Pair) savedState;

			if (savedState == null) {
				base.LoadViewState(null);
			} else {
				base.LoadViewState(previousState.First);

				if (previousState.Second != null) {
					((IStateManager) View).LoadViewState(previousState.Second);
				}
			}
		}

		protected override object SaveViewState()
		{
			Pair currentState = new Pair();

			currentState.First = base.SaveViewState();

			if (_view != null) {
				currentState.Second = ((IStateManager) View).SaveViewState();
			}

			if ((currentState.First == null) && (currentState.Second == null)) {
				return null;
			}

			return currentState;
		}

		protected override void TrackViewState()
		{
			base.TrackViewState();

			if (_view != null) {
				((IStateManager) View).TrackViewState();
			}
		}

		#endregion

		#region Life Cycle Related Methods

		protected override void OnInit(EventArgs e)
		{
			base.OnInit(e);

			// handle the LoadComplete event to update select parameters
			if (Page != null) {
				Page.LoadComplete += new EventHandler(UpdateParameterValues);
			}
		}

		protected virtual void UpdateParameterValues(object sender, EventArgs e)
		{
			SelectParameters.UpdateValues(Context, this);
            /*InsertParameters.UpdateValues(Context, this);
            UpdateParameters.UpdateValues(Context, this);*/
		}

		#endregion

		#region Select Method

		public IEnumerable Select()
		{
			return View.Select(DataSourceSelectArguments.Empty);
		}

        public string ModifyTable
        {
            get
            {
                return ParentDataSource.Length == 0 ? this.ID : ParentDataSource;
            }
        }

        public CustomDataSourceView GetView()
        {
            return View;
        }

        public DataTable GetTable()
        {
            SessionState sesion = SessionState.Get(ID);
            if (sesion != null)
            {
                return sesion.dataTable;
            }
            return null;
        }

        public string[] GetQuerys() {

            SessionState sesion = SessionState.Get(ID);
            if (sesion != null)
            {
                string[] res= sesion.GetQuerys();
                SessionState.Clean(ID);
                return res;
            }
            return null;
        }

        public bool Apply()
        {
            SessionState sesion = SessionState.Get(ID);
            if (sesion!=null)
                return sesion.Aplicar(ConnectionString);
            return false;
        }
		#endregion

		#endregion
	}
}
