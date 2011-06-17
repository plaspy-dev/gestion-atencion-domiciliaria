using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Text;
using System.IO;

public partial class paciente_epicrisis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DDocumento.Focus();
        //Create the connection and DataAdapter for the Authors table.
        if (!IsPostBack)
        {
            CUsuario usuario = CUsuario.GetUsuario();

            BAceptar.Enabled = false;

            CConectorMS conector = CConectorMS.GetConector();
            CConector conectormy = CConector.GetConector();

            TDocumento.Text = Request.QueryString["id"];
            DDocumento.DataBind();
            DDocumento.SelectedValue = Request.QueryString["td"];

            if (TDocumento.Text.Length > 0 && DDocumento.SelectedIndex > -1)
            {
                CQuery query = new CQuery("phdPaciente");

                query["pacId"] = "phdPaciente.pacId";
                query["pacPNombre"] = "phdPaciente.pacPNombre";
                query["pacSNombre"] = "phdPaciente.pacSNombre";
                query["pacPApellido"] = "phdPaciente.pacPApellido";
                query["pacSApellido"] = "phdPaciente.pacSApellido";
                query["pacDireccion"] = "phdPaciente.pacDireccion";
                query["pacFechaNac"] = "phdPaciente.pacFechaNac";
                query["entNombre"] = "admEntidad.entNombre";

                SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacDocumento='" + TDocumento.Text + "' AND phdPaciente.tdocId='" + DDocumento.SelectedValue + "'", "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)"));
                if (reader != null && reader.Read())
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    TFecha.Focus();
                    Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"];

                    HId.Value = reader["pacId"].ToString();
                    LNombres.Text = reader["pacPNombre"].ToString() + " " + reader["pacSNombre"].ToString();
                    LApellidos.Text = reader["pacPApellido"].ToString() + " " + reader["pacSApellido"].ToString();
                    LDireccion.Text = reader["pacDireccion"].ToString();
                    LEntidad.Text = reader["entNombre"].ToString();

                    if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length != 0)
                    {
                        DateTime birthDate = (DateTime)reader["pacFechaNac"];
                        DateTime now = DateTime.Now;
                        int years = now.Year - birthDate.Year;

                        if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                            --years;

                        LEdad.Text = years + " años";
                    }

                    CQuery epicrisis = new CQuery("epicrisis");

                    epicrisis += "id";
                    epicrisis += "fecha";
                    epicrisis += "valoracion_inicial";
                    epicrisis += "valoracion_final";
                    epicrisis += "intervencion_propuesta";
                    epicrisis += "intervencion_realizada";
                    epicrisis += "logros";
                    epicrisis += "observaciones";

                    MySqlDataReader readermysql = conectormy.Query(epicrisis.GetSelect("tipo='" + DDocumento.SelectedValue + "' AND documento='" + TDocumento.Text + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();

                        HIdIndice.Value = readermysql["id"].ToString();
                        TFecha.Text = CConector.GetDate(readermysql["fecha"]);
                        TValoracionInicial.Text = readermysql["valoracion_inicial"].ToString();
                        TValoracionFinal.Text = readermysql["valoracion_final"].ToString();
                        TIntervencionPropuesta.Text = readermysql["intervencion_propuesta"].ToString();
                        TIntervencionRealizada.Text = readermysql["intervencion_realizada"].ToString();
                        TLogros.Text = readermysql["logros"].ToString();
                        TObservaciones.Text = readermysql["observaciones"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdIndice.Value);
                    }
                }
            }
        }
    }
    protected void IBuscar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        String documento = conector.QueryString("SELECT pacDocumento FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "' AND tdocId='" + DDocumento.SelectedValue + "'");
        if (documento.Length > 0)
        {
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + DDocumento.SelectedValue);
            return;
        }
        string texto = "No se encontraron resultados";
        String count = conector.QueryString("SELECT COUNT(*) FROM phdPaciente WHERE pacDocumento LIKE '%" + TDocumento.Text + "%'");
        int cuenta = 0;
        try
        {
            cuenta = Convert.ToInt32(count);
        }
        catch (System.FormatException ex)
        {
            texto = ex.ToString();
        }
        if (cuenta == 1)
        {
            string tipo = conector.QueryString("SELECT tdocId FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "'");
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + tipo);
            return;
        }

        if (cuenta > 1)
        {
            texto = "";
            CQuery query = new CQuery("phdPaciente");
            query += "tdocId";
            query += "pacDocumento";
            query += "pacPNombre";
            query += "pacSNombre";
            query += "pacPApellido";
            query += "pacSApellido";

            SqlDataReader reader = conector.Query(query.GetSelect("pacDocumento LIKE '%" + TDocumento.Text + "%' ORDER BY pacPApellido,pacPNombre"));
            Table tabla = new Table();
            tabla.BorderWidth = 1;

            while (reader.Read())
            {

                TableRow row = new TableRow();
                TableCell cell = new TableCell();
                HyperLink link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacDocumento"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);

                cell = new TableCell();
                link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacPApellido"].ToString() + " " + reader["pacSApellido"].ToString()
                    + " " + reader["pacPNombre"].ToString() + " " + reader["pacSNombre"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);
                tabla.Rows.Add(row);
            }
            StringBuilder sb = new StringBuilder();
            StringWriter tw = new StringWriter(sb);
            HtmlTextWriter hw = new HtmlTextWriter(tw);

            tabla.RenderControl(hw);
            texto = sb.ToString();
        }
        ((MasterPageI)Master).SetAuxDiag("Busqueda de " + TDocumento.Text, texto);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CQuery epicrisis = new CQuery("epicrisis");
        CConector conector = CConector.GetConector();
        string szQuery;
        string mensaje;

        epicrisis["fecha"]= TFecha.Text;
        epicrisis["valoracion_inicial"]= TValoracionInicial.Text;
        epicrisis["valoracion_final"]= TValoracionFinal.Text;
        epicrisis["intervencion_propuesta"]= TIntervencionPropuesta.Text;
        epicrisis["intervencion_realizada"]= TIntervencionRealizada.Text;
        epicrisis["logros"]= TLogros.Text;
        epicrisis["observaciones"]= TObservaciones.Text;
                
        if (HIdIndice.Value.Length == 0)
        {
            epicrisis["tipo"] = DDocumento.SelectedValue;
            epicrisis["documento"] = TDocumento.Text;

            szQuery = epicrisis.GetInsert();
            mensaje = LNombres.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery);
            if (resultado == -1)
                return;
            HIdIndice.Value = resultado.ToString();
        }
        else
        {
            szQuery = epicrisis.GetUpdate("id='" + HIdIndice.Value + "'");
            mensaje = LNombres.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIndice.Value) == -1)
            return;
        Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"];
        ((MasterPageI)Master).SetResultado(mensaje);
    }
}
