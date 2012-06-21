using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class cliente_escliente : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PEncuestas.Visible = false;
            if (Request.QueryString["eid"] != null) {

                Query query = new Query("escliente");
                CConector conector = new CConector();

                query += "id";
                query += "paciente";
                query += "fecha";

                MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["eid"])));
                if (reader != null && reader.Read())
                {
                    CUsuario usuario = CUsuario.GetUsuario();
                    BAceptar.Enabled= usuario.CanUpdate();

                    CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                    PDatos.Visible = true;

                    HIdEncuesta.Value = reader["id"].ToString();
                    TFecha.Text = CConector.GetFromMySQLDate(reader["fecha"]);

                    ((MasterPageI)Master).SetModificacion(HIdEncuesta.Value);
                }
            } else if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    CUsuario usuario = CUsuario.GetUsuario();
                    BAceptar.Enabled = usuario.CanInsert();

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;
                }
                TFecha.Focus();
            }
            GEncuestas.DataBind();
            LEncuestas.Text = GEncuestas.Rows.Count + " Encuesta";
            LEncuestas.Text += GEncuestas.Rows.Count == 1 ? "" : "s";
            PEncuestas.Visible = GEncuestas.Rows.Count > 0;
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("escliente");
        CConector conector = new CConector();

        query["fecha"]= CConector.GetMySQLDateFormat(TFecha.Text);
        query["calificacion"] = HCalificacion.Value;

        if (HIdEncuesta.Value.Length == 0)
        {
            query["paciente"] = CCDetallePaciente.IdPaciente;

            int res = conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            HIdEncuesta.Value = res.ToString();
        } else {
            if (conector.QueryMod(query.GetUpdate("id=" + HIdEncuesta.Value)) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdEncuesta.Value) == -1)
            return;

        Query cal = new Query("escliente_calificacion");

        for(int i=0; i<RGrupos.Items.Count; i++) {

            Repeater rep= (Repeater)RGrupos.Items[i].FindControl("RPreguntas");
            for(int j=0; j<rep.Items.Count; j++) {
                string sharedid= ((HiddenField)rep.Items[j].FindControl("HId")).Value;
                string resid = ((HiddenField)rep.Items[j].FindControl("HIdr")).Value;

                string calificacion=((TextBox)rep.Items[j].FindControl("TRespuesta")).Text;
                if(calificacion=="-")
                    calificacion="0";
                cal["calificacion"] = calificacion;
                if(resid.Length==0) {

                    cal["encuesta"] = HIdEncuesta.Value;
                    cal["concepto"] = sharedid;
                    if (conector.QueryMod(cal.GetInsert()) == -1)
                        return;
                } else {
                    if (conector.QueryMod(cal.GetUpdate("id=" + resid)) == -1)
                        return;
                }                
            }
        }

        ((MasterPageI)Master).SetResultado("Encuesta de " + CCDetallePaciente.Nombres + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void IIr_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/cliente/escliente.aspx?eid=" + ((ImageButton)sender).CommandArgument);
    }
}
