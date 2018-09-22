using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class rutasanitaria_gestionambiental : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            TFecha.Text = DateTime.Now.ToShortDateString();
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                    BAceptar.Enabled = usuario.CanInsert();
                    PDatos.Visible = true;
                }
            }
            if (!string.IsNullOrEmpty(Request.QueryString["gaid"])) { 

                using(CConector conector= new CConector()) {
                    
                    Query query = new Query("ruta_sanitaria");

                    query += "rtsId";
                    query += "pacId";
                    query += "rtsFecha";
                    query += "vehPlaca";
                    query += "rtsPeso";
                    query += "rtsObservaciones";

                    MySqlDataReader reader = conector.Query(query.GetSelect("rtsId=" + Query.GetValor(Request.QueryString["gaid"])));
                    if (reader != null && reader.Read()) {

                        PDatos.Visible = true;
                        BAceptar.Enabled = usuario.CanUpdate();
                        ViewState["id"] = reader["rtsId"].ToString();
                        ((MasterPageI)Master).SetModificacion(reader["rtsId"].ToString());
                        
                        CCDetallePaciente.IdPaciente = reader["pacId"].ToString();
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);

                        TFecha.Text = Query.GetFromMySQLDate(reader["rtsFecha"]);
                        Utilidades.SelectInDropDown(DVehiculo, reader["vehPlaca"]);
                        TPeso.Text = reader["rtsPeso"].ToString();
                        TObservaciones.Text = reader["rtsObservaciones"].ToString();
                    }
                }
            }
        }
    }

    public void BAceptar_Clicked(object sender, EventArgs e) {
        if (!IsValid)
            return;
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            Query query = new Query("ruta_sanitaria");

            string id = (string)ViewState["id"];

            query["pacId"] = CCDetallePaciente.IdPaciente;
            query["rtsFecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["vehPlaca"] = DVehiculo.SelectedValue;
            query["rtsPeso"] = TPeso.Text;
            query["rtsObservaciones"] = TObservaciones.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                id = res.ToString();
            }
            else { 
                if(conector.QueryMod(query.GetUpdate("rtsId=" +Query.GetValor(id)))==-1)
                    return;
            }

            if (conector.InsertModificacion(id) == -1)
                return;

            conector.Commit();
            ((MasterPageI)Master).SetResultado("Gestión de " + CCDetallePaciente.Nombres + " editado.");
        }
    }

    public void BCancelar_Clicked(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?gaid=" + GResultados.SelectedDataKey["rtsId"].ToString());
    }
}
