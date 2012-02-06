using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using SDG.Componentes;

public partial class paciente_formulacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DDocumento.Focus();
        //Create the connection and DataAdapter for the Authors table.
        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = false;
            BMasFormulacion.Enabled=false;
            BFecha.Enabled = false;

            CConectorMS conector = CConectorMS.GetConector();
            CConector conectormy = CConector.GetConector();

            TDocumento.Text = Request.QueryString["pid"];
            DDocumento.DataBind();
            DDocumento.SelectedValue = Request.QueryString["td"];
            TFecha.Text = Request.QueryString["f"];
            if (TFecha.Text.Length == 0)
                TFecha.Text = DateTime.Now.ToShortDateString();

            if (TDocumento.Text.Length > 0 && DDocumento.SelectedIndex > -1)
            {
                Query query = new Query("phdPaciente");

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
                    BMasFormulacion.Enabled= usuario.CanInsert();
                    TFecha.Focus();
                    BFecha.Enabled = true;
                    Session["parametros"] = "?pid=" + Request.QueryString["pid"] + "&td=" + Request.QueryString["td"] + "&f=" + CConector.GetDate(DateTime.Now);

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

                    Query formulacion = new Query("formulacion");

                    formulacion += "id";
                    formulacion += "fecha";
                    formulacion += "codigo";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("tipo='" + DDocumento.SelectedValue + "' AND documento='" + TDocumento.Text + "' AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasFormulacion.Enabled= usuario.CanUpdate();

                        GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                        GFormulacion.Columns[1].Visible = usuario.CanDelete();

                        TCodigo.Focus();
                        HIdFormulacion.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        TCodigo.Text= readermysql["codigo"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
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
            Query query = new Query("phdPaciente");
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

    protected void DFormulacion_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GFormulacion.DataBind();
    }
    protected void DFormulacion_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GFormulacion.DataBind();
        GFormulacion.SelectedIndex = -1;
        DFormulacion.DataBind();
    }
    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        DFormulacion.ChangeMode(DetailsViewMode.Insert);
    }
    protected void DFormulacion_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GFormulacion.SelectedIndex = -1;
            DFormulacion.DataBind();
        }
    }
    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + DDocumento.SelectedValue + "&f=" + TFecha.Text);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query formulacion = new Query("formulacion");
        CConector conector = CConector.GetConector();

        formulacion["fecha"]= CConector.GetDate(Convert.ToDateTime( TFecha.Text));
        formulacion["codigo"]= TCodigo.Text;

        string szQuery;
        string mensaje;

        if (HIdFormulacion.Value.Length == 0)
        {
            formulacion["tipo"] = DDocumento.SelectedValue;
            formulacion["documento"] = TDocumento.Text;

            szQuery = formulacion.GetInsert();
            mensaje = LNombres.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdFormulacion.Value = resultado.ToString();
        }
        else
        {
            szQuery = formulacion.GetUpdate("id='" + HIdFormulacion.Value + "'");
            mensaje = LNombres.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdFormulacion.Value) == -1)
            return;

        string []querys= SFormulacion.GetQuerys();
        if (querys != null)
        {
            for (int i = 0; i < querys.Length; i++)
            {
                szQuery = querys[i].Replace("@formulacion", Query.GetValor(HIdFormulacion.Value));
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
        }

        Session["parametros"] = "?pid=" + Request.QueryString["pid"] + "&td=" + Request.QueryString["td"] + "&f=" + CConector.GetDate(DateTime.Now);
        ((MasterPageI)Master).SetResultado(mensaje);
    }
}
