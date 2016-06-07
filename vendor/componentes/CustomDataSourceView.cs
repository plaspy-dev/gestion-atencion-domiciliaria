using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Reflection;
using System.Web.Compilation;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;

namespace SDG.Web.UI.WebControls
{
	public class CustomDataSourceView : DataSourceView, IStateManager
	{
		#region Fields

		bool _tracking;
		protected CustomDataSource _owner;
		protected string _typeName;
		protected string _selectMethod;
		protected ParameterCollection _selectParameters;
        protected ParameterCollection _UpdateParameters;
        protected ParameterCollection _InsertParameters;
        protected bool _init=false;

		#endregion

		#region Properties

		#region DataSourceView's CanXXX Properties

		public override bool CanInsert
		{
			get	{ return false; }
		}

		public override bool CanUpdate
		{
			get	{ return false; }
		}

		public override bool CanDelete
		{
			get { return false; }
		}

		public override bool CanRetrieveTotalRowCount
		{
			get	{ return false; }
		}

		public override bool CanSort
		{
			get	{ return false;	}
		}

		public override bool CanPage
		{
			get	{ return false; }
		}

		#endregion

		#region Other Properties

		public string TypeName
		{
			get	{
				if (_typeName == null) {
					return String.Empty;
				}
				return _typeName;
			}
			set	{
				if (TypeName != value) {
					_typeName = value;
					OnDataSourceViewChanged(EventArgs.Empty);
				}
			}
		}

		public string SelectMethod
		{
			get	{
				if (_selectMethod == null) {
					return String.Empty;
				}
				return _selectMethod;
			}
			set	{
				if (SelectMethod != value) {
					_selectMethod = value;
					OnDataSourceViewChanged(EventArgs.Empty);
				}
			}
		}

        public ParameterCollection UpdateParameters {
            get {
                if (_UpdateParameters == null)
                {
                    _UpdateParameters = new ParameterCollection();
                    _UpdateParameters.ParametersChanged += new EventHandler(ParametersChangedEventHandler);
                    if (_tracking)
                    {
                        ((IStateManager)_UpdateParameters).TrackViewState();
                    }
                }
                return _UpdateParameters;
            }
        }
        public ParameterCollection InsertParameters
        {
            get
            {
                if (_InsertParameters == null)
                {
                    _InsertParameters = new ParameterCollection();
                    _InsertParameters.ParametersChanged += new EventHandler(ParametersChangedEventHandler);
                    if (_tracking)
                    {
                        ((IStateManager)_InsertParameters).TrackViewState();
                    }
                }
                return _InsertParameters;
            }
        }
		public ParameterCollection SelectParameters
		{
			get	{
				if (_selectParameters == null) {
					_selectParameters = new ParameterCollection();
					_selectParameters.ParametersChanged += new EventHandler(ParametersChangedEventHandler);
					if (_tracking) {
						((IStateManager)_selectParameters).TrackViewState();
					}
				}
				return _selectParameters;
			}
		}

		#endregion

		#endregion

		#region Methods

		#region Constructors

		public CustomDataSourceView(CustomDataSource owner, string name) : base(owner, name)
		{
			_owner = owner;
		}

		#endregion

		#region IStateManager Methods

		bool IStateManager.IsTrackingViewState
		{
			get	{ return _tracking; }
		}

		void IStateManager.LoadViewState(object savedState)
		{
			LoadViewState(savedState);
		}

		object IStateManager.SaveViewState()
		{
			return SaveViewState();
		}

		void IStateManager.TrackViewState()
		{
			TrackViewState();
		}

		protected virtual void LoadViewState(object savedState)
		{
			if (savedState != null) {
				if (savedState != null){
					((IStateManager)SelectParameters).LoadViewState(savedState);
                    ((IStateManager)InsertParameters).LoadViewState(savedState);
                    ((IStateManager)UpdateParameters).LoadViewState(savedState);
				}
			}
		}

		protected virtual object SaveViewState()
		{
            if(_UpdateParameters!=null)
                ((IStateManager)_UpdateParameters).SaveViewState();
            if(_InsertParameters!=null)
                ((IStateManager)_InsertParameters).SaveViewState();
			if (_selectParameters != null){
				return ((IStateManager)_selectParameters).SaveViewState();
			} else {
				return null;
			}
		}

		protected virtual void TrackViewState()
		{
			_tracking = true;

            if (_selectParameters != null)
            {
                ((IStateManager)_selectParameters).TrackViewState();
            }
            if (_InsertParameters != null)
            {
                ((IStateManager)_InsertParameters).TrackViewState();
            }
            if (_UpdateParameters != null)
            {
                ((IStateManager)_UpdateParameters).TrackViewState();
            }
		}

		#endregion

		#region ExecuteXXX Methods

		protected override IEnumerable ExecuteSelect(DataSourceSelectArguments arguments)
		{
			// if there isn't a select method, error
			if (_owner.SelectCommand.Length==0)	{
                throw new InvalidOperationException(_owner.ID + ": There isn't a SelectCommand defined");
			}
            // check if we support the capabilities the data bound control expects
            arguments.RaiseUnsupportedCapabilitiesError(this);

            // gets the select parameters and their values
            IOrderedDictionary selParams = null;
            try {
                selParams = SelectParameters.GetValues(System.Web.HttpContext.Current, _owner);
            }
            catch // (System.ArgumentException e)
            {

            }
            SessionState tabla;
            string queryselect = _owner.SelectCommand;

            if (_owner.ParentDataSource.Length > 0) // tiene un padre
            {
                SessionState tablap = SessionState.Get(_owner.ModifyTable);
                for (int i = 0; i < tablap.dataTable.Rows.Count; i++)
                {
                    bool found = true;
                    DataRow row = tablap.dataTable.Rows[i];
                    if (selParams != null)
                    {
                        foreach (DictionaryEntry parametro in selParams)
                        {
                            if (tablap.dataTable.Columns.IndexOf(parametro.Key.ToString()) > -1)
                            {
                                if (row[parametro.Key.ToString()].ToString() != parametro.Value.ToString())
                                {
                                    found = false;
                                    break;
                                }
                            }
                        }
                        if (found) // encontrado
                        {
                            tabla = new SessionState(_owner.ID, queryselect);
                            for (int j = 0; j < tablap.dataTable.Columns.Count; j++) // agregamos los titulos
                            {
                                tabla.dataTable.Columns.Add(tablap.dataTable.Columns[j].Caption, tablap.dataTable.Columns[j].DataType);
                            }
                            tabla.dataTable.Rows.Add(row.ItemArray); // agregamos la fila
                            if (tabla.dataTable.Rows.Count == 0)
                                return null;
                            return tabla.dataTable.AsDataView();
                        }
                    }
                }
            }

            if (selParams!=null)
            {
                foreach (object paramName in selParams.Keys)
                {
                    object paramValue = selParams[paramName];
                    queryselect = queryselect.Replace("@" + paramName.ToString(), SessionState.GetValor(selParams[paramName]));
                }
            }

            Page pagina = (Page)System.Web.HttpContext.Current.Handler;

            if (pagina.IsPostBack || _init)
            {
                tabla = SessionState.Get(_owner.ID, queryselect);
                if (tabla != null)
                {
                    if (tabla.dataTable.Rows.Count == 0)
                        return null;
                    return tabla.dataTable.AsDataView();
                }
            }
            _init = true;
            tabla = new SessionState(_owner.ID, queryselect);

            MySqlConnection pSQLConector;
            try
            {
                pSQLConector = new MySqlConnection(_owner.ConnectionString);
                pSQLConector.Open();
            }
            catch (MySqlException ex)
            {
                throw new InvalidOperationException(_owner.ID + ": Error en la consulta", ex);
            }

            MySqlDataReader reader = null;
            try
            {
                MySqlCommand command = pSQLConector.CreateCommand();
                command.CommandText = queryselect;
                command.CommandTimeout = 0;
                reader = command.ExecuteReader();
            }
            catch (MySqlException ex)
            {
                throw new InvalidOperationException(_owner.ID + ": Error en la consulta", ex);
            }

            if (reader != null)
            {
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    tabla.dataTable.Columns.Add(reader.GetName(i), reader.GetFieldType(i));
                }
                tabla.dataTable.Columns.Add("sqlexists");
                object[] todos = new object[reader.FieldCount+1];
                while (reader.Read())
                {
                    reader.GetValues(todos);
                    DataRow row = tabla.dataTable.Rows.Add(todos);
                    row["sqlexists"] = true;
                }
            }
            reader.Close();
            pSQLConector.Close();
            pSQLConector.Dispose();
            if (tabla.dataTable.Rows.Count == 0)
                return null;
            return tabla.dataTable.AsDataView();
		}

		protected override int ExecuteInsert(IDictionary values)
		{
            if (_owner.InsertCommand.Length == 0)
            {
                throw new InvalidOperationException(_owner.ID + ": There isn't a InsertCommand defined");
            }

            string query = _owner.InsertCommand;
            SessionState tabla = SessionState.Get(_owner.ModifyTable);
            DataRow row = tabla.dataTable.Rows.Add(new object[tabla.dataTable.Columns.Count]);
            
            foreach (DictionaryEntry parametro in values)
            {
                row[parametro.Key.ToString()] = parametro.Value==null ? DBNull.Value : parametro.Value;
                query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
            }
            try
            {
                IOrderedDictionary Params = InsertParameters.GetValues(System.Web.HttpContext.Current, _owner);
                foreach (DictionaryEntry parametro in Params)
                {
                    if (tabla.dataTable.Columns.IndexOf(parametro.Key.ToString()) > -1)
                        row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                    query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
                }
            } catch // (System.ArgumentException e) 
            { }

            // nos toca agregarle un indice unico
            try
            {
                IOrderedDictionary selParams = SelectParameters.GetValues(System.Web.HttpContext.Current, _owner);
                foreach (DictionaryEntry parametro in selParams)
                {
                    if (tabla.dataTable.Columns.IndexOf(parametro.Key.ToString()) > -1)
                    {
                        if (row[parametro.Key.ToString()].ToString().Length == 0)
                        {
                            string random = new Random(DateTime.Now.Millisecond).Next().ToString();
                            for (int i = 0; i < tabla.dataTable.Rows.Count; i++)
                            {
                                if (row[parametro.Key.ToString()].ToString() == random)
                                {
                                    random = new Random(DateTime.Now.Millisecond).Next().ToString(); // volvemos a comenzar
                                    i = -1;
                                }
                            }
                            row[parametro.Key.ToString()] = random;
                        }
                    }
                }
            }
            catch // (System.ArgumentException e)
            {

            }

            tabla.AddQuery(query, tabla.dataTable.Rows.Count-1);
            return 1;
		}

		protected override int ExecuteUpdate(IDictionary keys, IDictionary values, IDictionary oldValues)
		{
            if (_owner.UpdateCommand.Length == 0)
            {
                throw new InvalidOperationException(_owner.ID + ": There isn't a UpdateCommand defined");
            }

            string query = _owner.UpdateCommand;
            SessionState tabla = SessionState.Get(_owner.ModifyTable);
            DataRow row=null;
            int pos = -1;

            for (int i = 0; i < tabla.dataTable.Rows.Count; i++)
            {
                bool found = true;
                foreach (DictionaryEntry old in oldValues)
                {
                    string valor= tabla.dataTable.Rows[i][old.Key.ToString()].ToString();
                    string sold = old.Value==null ? "" : old.Value.ToString();
                    if (valor != sold)
                    {
                        bool numeros = false;
                        try
                        {
                            numeros = Convert.ToDouble(valor) == Convert.ToDouble(sold);
                        }
                        catch { }
                        if (!numeros)
                        {
                            try
                            {
                                numeros = Convert.ToDateTime(valor) == Convert.ToDateTime(sold);
                            }
                            catch { }
                            if (!numeros)
                            {
                                found = false;
                                break;
                            }
                        }
                    }
                }
                if (found)
                {
                    row= tabla.dataTable.Rows[i];
                    pos = i;
                    break;
                }
            }
            if (pos == -1)
                return 0;
            if (tabla.CleanQuerys(pos)) // no existe en la base de datos
            {
                query = _owner.InsertCommand;
                try
                {
                    IOrderedDictionary ParamsI = InsertParameters.GetValues(System.Web.HttpContext.Current, _owner);
                    foreach (DictionaryEntry parametro in ParamsI)
                    {
                        if (tabla.dataTable.Columns.IndexOf(parametro.Key.ToString()) > -1)
                            row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                        query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
                    }
                }
                catch // (System.ArgumentException e)
                {

                }
            }
            foreach (DictionaryEntry parametro in keys)
            {
                row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
            }
            foreach (DictionaryEntry parametro in values)
            {
                row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
            }
            try
            {
                IOrderedDictionary Params = UpdateParameters.GetValues(System.Web.HttpContext.Current, _owner);
                foreach (DictionaryEntry parametro in Params)
                {
                    row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                    query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
                }
            }
            catch // (System.ArgumentException e)
            {

            }
            tabla.AddQuery(query, pos);
            return 1;
		}

		protected override int ExecuteDelete(IDictionary keys, IDictionary oldValues)
		{
            if (_owner.DeleteCommand.Length == 0)
            {
                throw new InvalidOperationException(_owner.ID + ": There isn't a DeleteCommand defined");
            }
            string query = _owner.DeleteCommand;
            SessionState tabla = SessionState.Get(_owner.ModifyTable);
            DataRow row = null;
            int pos = -1;
            
            for (int i = 0; i < tabla.dataTable.Rows.Count; i++)
            {
                bool found = true;
                foreach (DictionaryEntry old in oldValues)
                {
                    string valor = tabla.dataTable.Rows[i][old.Key.ToString()].ToString();
                    string sold = old.Value == null ? "" : old.Value.ToString();
                    if (valor != sold)
                    {
                        bool numeros=false;
                        try {
                            numeros= Convert.ToDouble(valor)==Convert.ToDouble(sold);
                        }catch  { }
                        if(!numeros) {
                            try {
                                numeros = Convert.ToDateTime(valor) == Convert.ToDateTime(sold);
                            } catch {}
                            if(!numeros) {
                                found = false;
                                break;
                            }
                        }
                    }
                }
                if (found)
                {
                    pos = i;
                    row = tabla.dataTable.Rows[i];
                    break;
                }
            }
            if (pos == -1)
                return 0;
            if (tabla.CleanQuerys(pos)) // no existe en la base de datos
            {
                // se borro
                tabla.DeleteRow(pos);
                return 1;
            }
            foreach (DictionaryEntry parametro in keys)
            {
                row[parametro.Key.ToString()] = parametro.Value == null ? DBNull.Value : parametro.Value;
                query = query.Replace("@" + parametro.Key.ToString(), SessionState.GetValor(parametro.Value));
            }
            tabla.AddQuery(query, pos);
            tabla.DeleteRow(pos);
            return 1;
		}

		#endregion

		#region Helpers

		public IEnumerable Select(DataSourceSelectArguments args)
		{
			return ExecuteSelect(args);
		}

		protected void ParametersChangedEventHandler(object o, EventArgs e)
		{
			OnDataSourceViewChanged(EventArgs.Empty);
		}

		#endregion

		#endregion
	}
}
