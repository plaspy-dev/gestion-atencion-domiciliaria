using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.IO;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Data;

public partial class cliente_escliente : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            PEncuestas.Visible = false;
            if (Request.QueryString["eid"] != null) {

                Query query = new Query("escliente");
                using (CConector conector = new CConector())
                {

                    query += "id";
                    query += "paciente";
                    query += "fecha";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["eid"])));
                    if (reader != null && reader.Read())
                    {
                        CUsuario usuario = (CUsuario)Usuario.GetUsuario();
                        BAceptar.Enabled = usuario.CanUpdate();

                        ((MasterPageI)Master).Imprimir("escliente.html");

                        CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                        PDatos.Visible = true;

                        HIdEncuesta.Value = reader["id"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);

                        ((MasterPageI)Master).SetModificacion(HIdEncuesta.Value);
                    }
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
                    CUsuario usuario = (CUsuario) Usuario.GetUsuario();
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
        using (CConector conector = new CConector())
        {

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["calificacion"] = HCalificacion.Value;

            if (HIdEncuesta.Value.Length == 0)
            {
                query["paciente"] = CCDetallePaciente.IdPaciente;

                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HIdEncuesta.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + HIdEncuesta.Value)) == -1)
                    return;
            }
            if (conector.InsertModificacion(HIdEncuesta.Value) == -1)
                return;

            Query cal = new Query("escliente_calificacion");

            for (int i = 0; i < RGrupos.Items.Count; i++)
            {

                Repeater rep = (Repeater)RGrupos.Items[i].FindControl("RPreguntas");
                for (int j = 0; j < rep.Items.Count; j++)
                {
                    string sharedid = ((HiddenField)rep.Items[j].FindControl("HId")).Value;
                    string resid = ((HiddenField)rep.Items[j].FindControl("HIdr")).Value;

                    string calificacion = ((TextBox)rep.Items[j].FindControl("TRespuesta")).Text;
                    if (calificacion == "-")
                        calificacion = "0";
                    cal["calificacion"] = calificacion;
                    if (resid.Length == 0)
                    {

                        cal["encuesta"] = HIdEncuesta.Value;
                        cal["concepto"] = sharedid;
                        if (conector.QueryMod(cal.GetInsert()) == -1)
                            return;
                    }
                    else
                    {
                        if (conector.QueryMod(cal.GetUpdate("id=" + resid)) == -1)
                            return;
                    }
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

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);

            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            //call RenderControl method to get the generated HTML

            string encuesta = "";
            encuesta += "<table border=1 style='width: 100%; border-collapse: collapse;'>";
            double calificacion = 0;
            int total = 0;
            RGrupos.DataBind();
            DataView resultados = (DataView)SGrupos.Select(DataSourceSelectArguments.Empty);
            DataTable tabla = resultados.Table;

            for (int i = 0; i < RGrupos.Items.Count; i++) {
                encuesta += string.Format("<tr><td rowspan={1}>{0}</td></tr>",
                    tabla.Rows[i]["nombre"]
                    , tabla.Rows[i]["rows"]
                    );
                SqlDataSource sql= (SqlDataSource) RGrupos.Items[i].FindControl("SPreguntas");
                DataView rowDataView= (DataView)sql.Select(DataSourceSelectArguments.Empty);
                DataTable rowDataTable = rowDataView.Table;
                for (int j = 0; j < rowDataTable.Rows.Count; j++) {
                    total++;
                    calificacion += Convert.ToInt32(rowDataTable.Rows[j]["calificacion"]);
                    encuesta += string.Format("<tr><td>{0}</td><td>{1}</td></tr>",
                        rowDataTable.Rows[j]["nombre"]
                        , rowDataTable.Rows[j]["calificacion"]);
                }
                // DataBinder.Eval(RGrupos.Items[i].DataItem, "nombre"));
            }
            encuesta += "</table>";
            
            evento.Contenido = evento.Contenido.Replace("$szEncuesta$", encuesta);
            if (total > 0)
                calificacion /= total;
            evento.Contenido = evento.Contenido.Replace("$szCalificacion$", calificacion.ToString("0.##"));
        }
    }
}
