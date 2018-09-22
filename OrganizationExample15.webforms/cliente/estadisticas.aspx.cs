using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class cliente_estadisticas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            TDesde.Text = Query.GetFromMySQLDate(DateTime.Now.AddMonths(-1));
            THasta.Text = Query.GetFromMySQLDate(DateTime.Now);
        }
        ((MasterPageI)Master).RestoreState();
        BBuscar_Click(sender, e);
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        /*if (!IsValid)
            return;*/

        GResultados.SelectedIndex = -1;
        GResultados.DataBind();
        int total = 0;
        LResultado.Text = "['Concepto','Encuestas']";
        for (int i = 0; i < GResultados.Rows.Count; i++)
        {
            int actual = Convert.ToInt32(GResultados.Rows[i].Cells[1].Text);
            total += actual;
            LResultado.Text += ",['" + ((LinkButton)GResultados.Rows[i].FindControl("LC")).Text + "', " + actual.ToString() + "]";
        }
        LTotal.Text = total + " Encuesta";
        if (total != 1)
            LTotal.Text += "s";

        PDetalle.Visible = false;
        GDetalle.Visible = false;
        if(sender==BBuscar)
            TCalificacion.Text = "";

        ((MasterPageI)Master).Imprimir("escliente.html", true);
    }

    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {
        TCalificacion.Text = GResultados.DataKeys[GResultados.SelectedIndex].Value.ToString();
        LCalificacion.Text = "Detalle " + ((LinkButton)GResultados.SelectedRow.FindControl("LC")).Text;
        PDetalle.Visible = true;
        GDetalle.Visible = true;
        ((MasterPageI)Master).Imprimir("escliente.html", true);
    }

    protected void GDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex == -1)
            return;
        ((LinkButton)e.Row.FindControl("LPaciente")).Text = Paciente.GetPaciente(((LinkButton)e.Row.FindControl("LPaciente")).Text).NombreCompleto; ;
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        StringBuilderEx plantilla = new StringBuilderEx();
        StringBuilderEx contenido = new StringBuilderEx();

        Regex regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
        Match match = regx.Match(evento.Contenido.ToString());
        if (match.Success)
        {
            evento.Contenido = evento.Contenido.Replace(match.Groups["theBody"].Value, "{body}");
            plantilla = match.Groups["theBody"].Value;
        }

        GDetalle.AllowPaging = false;
        PP.Visible=
        PDetalle.Visible=
        GDetalle.Visible = true;

        using (CConector conector2 = new CConector())
        using (CConector conector = new CConector())
        {
            for (int i = 0; i < GDetalle.Rows.Count; i++)
            {
                contenido += plantilla.ToString();

                CCDetallePaciente.IdPaciente = GDetalle.DataKeys[i].Values["paciente"].ToString();
                TPaciente.Text = CCDetallePaciente.Documento;
                LPaciente.Text = CCDetallePaciente.Nombres;

                Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);

                contenido = contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
                contenido = contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

                
                Query query = new Query("escliente");

                query += "fecha";

                MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(GDetalle.DataKeys[i].Values["id"])));
                if (reader != null && reader.Read()) {
                    contenido.Replace("$TFecha$", Query.GetFromMySQLDate(reader["fecha"]));
                }

                string encuesta = "";
                int total = 0;
                double calificacion = 0;

                reader = conector.Query("SELECT id,nombre,(SELECT COUNT(*)+1 FROM varios AS s WHERE s.tipo=16 AND s.parametro1=varios.id AND s.szReservado IS NULL ) AS rows FROM varios WHERE tipo=15 AND szReservado IS NULL");
                if (reader != null) {
                    encuesta += "<table border=1 style='width: 100%; border-collapse: collapse;'>";
                    while (reader.Read()) {
                        // reader["id"], 
                        encuesta += string.Format("<tr><td rowspan={1}>{0}</td></tr>",
                            reader["nombre"]
                            , reader["rows"]);

                        MySqlDataReader reader2 = conector2.Query(@"SELECT varios.id,varios.nombre,escliente_calificacion.id AS idr, CAST(IF(escliente_calificacion.calificacion=0, '-',escliente_calificacion.calificacion) AS char) AS calificacion
                                            FROM varios 
                                            LEFT JOIN escliente_calificacion ON (escliente_calificacion.encuesta={1} AND escliente_calificacion.concepto=varios.id)
                                            WHERE varios.tipo=16 AND varios.parametro1={0} AND varios.szReservado IS NULL", reader["id"], Query.GetValor(GDetalle.DataKeys[i].Values["id"]));
                        if (reader2 != null) {
                            while (reader2.Read()) {
                                total++;
                                try { calificacion += Convert.ToInt32(reader2["calificacion"]); } catch { }
                                encuesta += string.Format("<tr><td>{0}</td><td>{1}</td></tr>",
                                    reader2["nombre"]
                                    , reader2["calificacion"]);
                            }
                        }
                        
                    }
                    encuesta += "</table>";
                }
                if (total > 0)
                    calificacion /= total;
                contenido = contenido.Replace("$szEncuesta$", encuesta);
                contenido = contenido.Replace("$szCalificacion$", calificacion.ToString("0.##"));
                contenido = Utilidades.ReplaceContenido(PP.Controls, contenido);
            }
        }

        evento.Contenido = evento.Contenido.Replace("{body}", contenido.ToString());
    }
}
