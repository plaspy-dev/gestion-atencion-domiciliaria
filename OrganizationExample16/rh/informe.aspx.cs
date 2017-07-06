using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class rh_informe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            BActualizar_Click(sender, e);
        }
    }

    protected void BActualizar_Click(object sender, EventArgs e)
    {
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0) {
            ((MasterPageI)Master).Excel(GResultados);
        }
    }

    public object _rhid = null;
    public List<string> _CurrentDocument = new List<string>();
    List<Varios> documentos = null;

    public List<string> GetDocuments(object id) {

        if (_rhid == id)
            return _CurrentDocument;
        _rhid = id;
        _CurrentDocument = new List<string>();

        using (CConector conector = new CConector()) {

            Query query = new Query("rh_documento");

            query += "documento";

            MySqlDataReader reader= conector.Query(query.GetSelect("funcionario={0} AND archivo IS NOT NULL", null, Query.GetValor(id)));
            if (reader != null) {
                while (reader.Read()) {
                    _CurrentDocument.Add(reader["documento"].ToString());
                }
            }
        }

        return _CurrentDocument;
    }

    protected bool HasDocument(object id, string documento) {

        documentos= documentos ?? Varios.Get(Varios.Tipos.DocumentosRRHH);
        Varios vdocumento= documentos.Find(x => x.Nombre == documento);
        if (vdocumento == null)
            return false;
        return GetDocuments(id).Contains(vdocumento.Id);
    }
}