using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class auditoria_indicadores : System.Web.UI.Page
{
    public bool addfield = true;
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            THasta.Text= DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
        if (ViewState["consulta"] != null)
        {
            SDetalle.SelectCommand = ViewState["consulta"].ToString();
            SDetalle.ProviderName = ViewState["ProviderName"].ToString();
            SDetalle.ConnectionString = ViewState["ConnectionString"].ToString();
        }
    }

    protected void AddField(string titulo, string datafield) {

        if (!addfield)
            return;

        BoundField campo = new BoundField();
        campo.DataField = datafield;
        campo.HeaderText = titulo;
        campo.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
        campo.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        DResultados.Fields.Add(campo);
    }

    protected string AddCampo(string id, string nombre, string servicios) {

        AddField("Servicios " + nombre, "a" + id);
        AddField("Pacientes atendidos " + nombre, "b" + id);
        AddField("Servicios descubiertos " + nombre, "c" + id);

        string szProcedimiento = "";
        string procedimientos="";

        if (servicios == null) // es un servicio
        {
            using(CConector conector= new CConector()) 
                szProcedimiento= conector.QueryString("SELECT GROUP_CONCAT(id) FROM medicamentos WHERE grupo=" + id);
            if (szProcedimiento.Length == 0)
                procedimientos = "0=1"; // esto es para que no filtre ningun servicio
            else procedimientos = "programacion.actId IN (" + szProcedimiento + ")";
        } else { // es el resto
            if (servicios.Length == 0)
                procedimientos = "0=0"; // todos los servicios
            else procedimientos = "programacion.actId NOT IN (" + servicios + ")"; 
        }

        // agregamos la nueva consulta de servicios
        string query = ",(SELECT COUNT(*) FROM programacion LEFT JOIN paciente ON (paciente.pacId=programacion.pacId) WHERE " + procedimientos + " AND prgFechaProg BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (@eps=0 OR paciente.entId=@eps)) AS a" + id;
        SResultados.SelectCommand += query;

        // agregamos los pacientes atendidos
        query = ",(SELECT COUNT(DISTINCT programacion.pacId) FROM programacion LEFT JOIN paciente ON (paciente.pacId=programacion.pacId) WHERE " + procedimientos + " AND prgFechaProg BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND (@eps=0 OR paciente.entId=@eps)) AS b" + id;
        SResultados.SelectCommand += query;

        // agregamos los servicios descubiertos
        query = ",(SELECT COUNT(*) FROM programacion_novedad LEFT JOIN programacion ON (programacion.prgId=programacion_novedad.prgId) LEFT JOIN paciente ON (paciente.pacId=programacion.pacId) WHERE programacion_novedad.segFechaRegistro BETWEEN STR_TO_DATE(@desde, '%d/%m/%Y') AND STR_TO_DATE(@hasta, '%d/%m/%Y') AND programacion_novedad.novTipo=5 AND programacion_novedad.prgTipo=1 AND " + procedimientos + " AND (@eps=0 OR paciente.entId=@eps)) AS c" + id;
        SResultados.SelectCommand += query;

        return szProcedimiento;
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        PDetalle.Visible = false;
        string servicios = "";

        addfield = DResultados.Rows.Count==3;

        using (CConector conector = new CConector())
        {

            MySqlDataReader reader = conector.Query("SELECT id, nombre FROM varios WHERE tipo=22 AND szReservado IS NULL ORDER BY nombre");
            if (reader != null)
            {
                while (reader.Read())
                {

                    string procedimientos = AddCampo(reader["id"].ToString(), reader["nombre"].ToString(), null);
                    if (servicios.Length > 0 && procedimientos.Length > 0)
                        servicios += ",";
                    servicios += procedimientos;
                }
            }
        }
        // agregamos el resto de los servicios
        AddCampo("", "(Otros)", servicios);

        DResultados.DataBind();
        if (DResultados.Rows.Count == 0)
            return;

        LChart.Text = "";
        for (int i = 3; i < DResultados.Rows.Count; i+=3 ) {

            servicios= HttpUtility.HtmlDecode(DResultados.Rows[i].Cells[0].Text).Trim();
            servicios = servicios.Substring("Servicios ".Length);
            LChart.Text += "['" + servicios + "', " + DResultados.Rows[i].Cells[1].Text + ", " + DResultados.Rows[i+1].Cells[1].Text + ", " + DResultados.Rows[i+2].Cells[1].Text + "],";
        }

        DEventos.DataBind();

        // LResultado.Text += "['" + ((LinkButton)DResultados.Rows[i].Cells[0].Controls[1]).Text + "', " + ((DataBoundLiteralControl)DResultados.Rows[i].Cells[1].Controls[0]).Text + "]";

        LChart2.Text = "['Eventos'";
        for (int i = 0; i < DEventos.Rows.Count; i++)
        {
            foreach (Control info in DEventos.Rows[i].Cells[1].Controls)
            {
                if (info is Label)
                {
                    LChart2.Text += "," + ((Label)info).Text;
                }
            }
        }
        LChart2.Text += "]";
    }

    protected void LEventos_Click(object sender, EventArgs e)
    {
        ViewState["consulta"] = null;
        string[] consultas = SEventos.SelectCommand.Split('\r');
        string consulta = "";

        for (int i = 0; i < consultas.Length; i++)
        {
            if (consultas[i].IndexOf(((LinkButton)sender).CommandName) != -1)
            {
                consulta = consultas[i];
                break;
            }
        }
        if (consulta.Length == 0)
            return;

        consulta = consulta.Replace("COUNT(*)", "DISTINCT evento_adverso.id,fecha,paciente AS pacienteid,descripcion,paciente");
        consulta = consulta.Replace("COUNT(DISTINCT evento_adverso.id)", "DISTINCT evento_adverso.id,fecha,paciente AS pacienteid,descripcion,paciente");
        consulta = consulta.Replace("@desde", Query.GetValor(TDesde.Text));
        consulta = consulta.Replace("@hasta", Query.GetValor(THasta.Text));

        int pos = consulta.IndexOf("(");
        if (pos != -1)
        {
            consulta = consulta.Substring(pos + 1);
        }
        pos = consulta.IndexOf(") AS ");
        if (pos != -1)
        {
            consulta = consulta.Substring(0, pos);
        }

        ViewState["consulta"] = consulta;

        LDetalle.Text = ((LinkButton)sender).Text;
        SDetalle.SelectCommand = ViewState["consulta"].ToString();
        ViewState["ConnectionString"] = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;
        ViewState["ProviderName"] = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ProviderName;

        SDetalle.ProviderName = ViewState["ProviderName"].ToString();
        SDetalle.ConnectionString = ViewState["ConnectionString"].ToString();

        PDetalle.Visible = true;
        GDetalle.DataBind();
        ScriptManager.RegisterStartupScript(GDetalle, typeof(string), "scroll", "$('html:not(:animated),body:not(:animated)').animate({ scrollTop: $('#" + GDetalle.ClientID + "').offset().top+100 }, 1100);", true);
    }

    protected void GDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex == -1)
            return;
        ((LinkButton)e.Row.FindControl("LPaciente")).Text = Paciente.GetPaciente(((LinkButton)e.Row.FindControl("LPaciente")).Text).NombreCompleto;
    }
}
