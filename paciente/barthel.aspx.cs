using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.IO;

public partial class paciente_barthel : System.Web.UI.Page
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
                    TFecha.Focus();
                    BAceptar.Enabled = usuario.CanInsert();
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

                    CQuery indice= new CQuery("indice_barthel");
                    
                    indice+="id";
                    indice+="fecha";
                    indice+="diagnostico";

                    MySqlDataReader readermysql = conectormy.Query(indice.GetSelect("tipo='" + DDocumento.SelectedValue + "' AND documento='" + TDocumento.Text + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();

                        HIdIndice.Value = readermysql["id"].ToString();
                        TFecha.Text = CConector.GetDate(readermysql["fecha"]);
                        THora.Text = CConector.GetHora(readermysql["fecha"]);
                        TDiagnostico.Text = readermysql["diagnostico"].ToString();

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
        CQuery indice = new CQuery("indice_barthel");
        CConector conector = CConector.GetConector();

        indice["fecha"]= TFecha.Text + " " + THora.Text + ":00";
        indice["diagnostico"]= TDiagnostico.Text;

        string szQuery;
        string mensaje;

        if (HIdIndice.Value.Length == 0)
        {
            indice["tipo"] = DDocumento.SelectedValue;
            indice["documento"] = TDocumento.Text;

            szQuery = indice.GetInsert();
            mensaje = LNombres.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery);
            if (resultado == -1)
                return;
            HIdIndice.Value = resultado.ToString();
        }
        else
        {
            szQuery = indice.GetUpdate("id='" + HIdIndice.Value + "'");
            mensaje = LNombres.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIndice.Value) == -1)
            return;

        for (int i = 0; i < RGrupos.Items.Count; i++)
        {
            CQuery analisis = new CQuery("analisis_barthel");

            RadioButtonList lista = (RadioButtonList)RGrupos.Items[i].FindControl("RConceptos");
            HiddenField grupo = (HiddenField)RGrupos.Items[i].FindControl("HIdGrupo");
            HiddenField idanalisis = (HiddenField)RGrupos.Items[i].FindControl("HIdAnalisis");

            analisis["grupo"] = grupo.Value;
            
            string valor= lista.SelectedValue;
            valor = valor.Substring(valor.IndexOf("#", 0)+1);

            analisis["resultado"] = valor;

            if(idanalisis.Value.Length>0) {
                conector.QueryMod(analisis.GetUpdate("id='" + idanalisis.Value.ToString() + "'"));
            } else {
                analisis["indice_barthel"] = HIdIndice.Value.ToString();
                conector.QueryMod(analisis.GetInsert());
            }
        }
        Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"];
        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void RGrupos_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex != -1)
        {
            RadioButtonList lista = (RadioButtonList)e.Item.FindControl("RConceptos");
            HiddenField idanalisis = (HiddenField)e.Item.FindControl("HIdAnalisis");
            HiddenField resultado = (HiddenField)e.Item.FindControl("HIdResultado");

            for (int i = 0; i < lista.Items.Count; i++)
            {
                string valor = lista.Items[i].Value;
                valor = valor.Substring(valor.IndexOf("#", 0) + 1);
                if(valor == resultado.Value) {
                    lista.Items[i].Selected = true;
                    break;
                }
            }
        }
    }
}
