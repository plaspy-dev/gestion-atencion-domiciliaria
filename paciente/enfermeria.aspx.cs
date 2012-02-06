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
using SDG.Componentes;

public partial class paciente_enfermeria : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DDocumento.Focus();
        //Create the connection and DataAdapter for the Authors table.
        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = false;
            BMasControlLiquidosA.Enabled = false;
            BMaSControlLiquidosE.Enabled = false;
            BMasMedicamentos.Enabled = false;
            BMasSVital.Enabled = false;
            BMasBitacora.Enabled = false;


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
                    BMasControlLiquidosA.Enabled = usuario.CanInsert();
                    BMaSControlLiquidosE.Enabled = usuario.CanInsert();
                    BMasMedicamentos.Enabled = usuario.CanInsert();
                    BMasSVital.Enabled = usuario.CanInsert();
                    BMasBitacora.Enabled = usuario.CanInsert();
                    TFecha.Focus();

                    BFecha.Enabled = true;
                    Session["parametros"] = "?pid=" + Request.QueryString["pid"] + "&td=" + Request.QueryString["td"] + "&f=" + DateTime.Now.ToShortDateString();

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

                    Query hoja = new Query("hoja_enfermeria");

                    hoja += "id";
                    hoja += "fecha";
                    hoja += "diagnostico";
                    hoja += "dieta";

                    MySqlDataReader readermysql = conectormy.Query(hoja.GetSelect("tipo='" + DDocumento.SelectedValue + "' AND documento='" + TDocumento.Text + "' AND fecha='" + CConector.GetDate(Convert.ToDateTime(TFecha.Text)) + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        HIdHoja.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        TDiagnostico.Text = readermysql["diagnostico"].ToString();
                        DDieta.Text = readermysql["dieta"].ToString();
                        
                        TDiagnostico.Focus();
                    }
                    if (HIdHoja.Value.Length > 0)
                    {
                        Query valoracion = new Query("valoracion_hoja_enfermeria");
                        
                        valoracion += "id";
                        valoracion += "neurologico";
                        valoracion += "cabeza";
                        valoracion += "cuello";
                        valoracion += "torax";
                        valoracion += "abdomen";
                        valoracion += "msss";
                        valoracion += "msls";
                        valoracion += "genitourinario";
                        valoracion += "observaciones";

                        readermysql = conectormy.Query(valoracion.GetSelect("hoja_enfermeria='" + HIdHoja.Value + "'"));
                        if (readermysql != null && readermysql.Read())
                        {
                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasControlLiquidosA.Enabled = usuario.CanUpdate();
                            BMaSControlLiquidosE.Enabled = usuario.CanUpdate();
                            BMasMedicamentos.Enabled = usuario.CanUpdate();
                            BMasSVital.Enabled = usuario.CanUpdate();
                            BMasBitacora.Enabled = usuario.CanUpdate();

                            GSignoVital.Columns[0].Visible = GControlLiquidosA.Columns[0].Visible = GControlLiquidosE.Columns[0].Visible = GMedicamentos.Columns[0].Visible = GBitacora.Columns[0].Visible = usuario.CanUpdate();
                            GSignoVital.Columns[1].Visible = GControlLiquidosA.Columns[1].Visible = GControlLiquidosE.Columns[1].Visible = GMedicamentos.Columns[1].Visible = GBitacora.Columns[1].Visible = usuario.CanDelete();

                            HIdValoracion.Value = readermysql["id"].ToString();
                            TNeurologico.Text= readermysql["neurologico"].ToString();
                            TCabeza.Text = readermysql["cabeza"].ToString();
                            TCuello.Text = readermysql["cuello"].ToString();
                            TTorax.Text = readermysql["torax"].ToString();
                            TAbdomen.Text = readermysql["abdomen"].ToString();
                            TMsss.Text = readermysql["msss"].ToString();
                            TMsls.Text = readermysql["msls"].ToString();
                            TGenitourinario.Text = readermysql["genitourinario"].ToString();
                            TObservaciones.Text = readermysql["observaciones"].ToString();

                            ((MasterPageI)Master).SetModificacion(HIdValoracion.Value);
                        }
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
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString() + "&f=" + DateTime.Now.ToShortDateString();
                link.Text = reader["pacDocumento"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);

                cell = new TableCell();
                link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString() + "&f=" + DateTime.Now.ToShortDateString();
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
        if (!IsValid)
            return;
        Query hoja = new Query("hoja_enfermeria");
        CConector conector = CConector.GetConector();

        hoja["fecha"]= CConector.GetDate(Convert.ToDateTime( TFecha.Text));
        hoja["diagnostico"]= TDiagnostico.Text;
        hoja["dieta"] = DDieta.Text;
        
        string szQuery;
        string mensaje;

        if (HIdHoja.Value.Length == 0)
        {
            hoja["tipo"] = DDocumento.SelectedValue;
            hoja["documento"] = TDocumento.Text;

            szQuery = hoja.GetInsert();
            mensaje = LNombres.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdHoja.Value = resultado.ToString();
        }
        else
        {
            szQuery = hoja.GetUpdate("id='" + HIdHoja.Value + "'");
            mensaje = LNombres.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdHoja.Value) == -1)
            return;

        Query valoracion = new Query("valoracion_hoja_enfermeria");

        valoracion["neurologico"]= TNeurologico.Text;
        valoracion["cabeza"] = TCabeza.Text;
        valoracion["cuello"] =TCuello.Text;
        valoracion["torax"] = TTorax.Text;
        valoracion["abdomen"] = TAbdomen.Text;
        valoracion["msss"] =TMsss.Text;
        valoracion["msls"] =TMsls.Text;
        valoracion["genitourinario"] = TGenitourinario.Text;
        valoracion["observaciones"] = TObservaciones.Text;

        if (HIdValoracion.Value.Length == 0)
        {
            valoracion["hoja_enfermeria"] = HIdHoja.Value;
            szQuery = valoracion.GetInsert();
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        else
        {
            szQuery = valoracion.GetUpdate("id='" + HIdValoracion.Value + "'");
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (!UpdateCambios(conector, SSignoVital.GetQuerys()))
            return;
        if (!UpdateCambios(conector, SControlLiquidosA.GetQuerys()))
            return;
        if (!UpdateCambios(conector, SControlLiquidosE.GetQuerys()))
            return;
        if (!UpdateCambios(conector, SMedicamentos.GetQuerys()))
            return;
        if (!UpdateCambios(conector, SBitacora.GetQuerys()))
            return;

        Session["parametros"] = "?pid=" + Request.QueryString["pid"] + "&td=" + Request.QueryString["td"] + "&f=" + DateTime.Now.ToShortDateString();
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected bool UpdateCambios(CConector conector, string []querys) {

        if (querys != null)
        {
            string szQuery;
            for (int i = 0; i < querys.Length; i++)
            {
                szQuery = querys[i].Replace("@hoja", Query.GetValor(HIdHoja.Value));
                if (conector.QueryMod(szQuery) == -1)
                    return false;
            }
        }
        return true;
    }

    protected void BMasSVital_Click(object sender, EventArgs e)
    {
        DSignoVital.ChangeMode(DetailsViewMode.Insert);
    }
    protected void DSignoVital_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GSignoVital.DataBind();
    }
    protected void DSignoVital_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GSignoVital.DataBind();
        GSignoVital.SelectedIndex = -1;
        DSignoVital.DataBind();
    }
    protected void DSignoVital_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GSignoVital.SelectedIndex = -1;
            DSignoVital.DataBind();
        }
    }
    protected void BMasControlLiquidosA_Click(object sender, EventArgs e)
    {
        DControlLiquidosA.ChangeMode(DetailsViewMode.Insert);
    }
    protected void DControlLiquidosA_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GControlLiquidosA.SelectedIndex = -1;
            GControlLiquidosA.DataBind();
        }
    }
    protected void DControlLiquidosA_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GControlLiquidosA.DataBind();
    }
    protected void DControlLiquidosA_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GControlLiquidosA.DataBind();
        GControlLiquidosA.SelectedIndex = -1;
        DControlLiquidosA.DataBind();
    }
    protected void DControlLiquidosE_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GControlLiquidosE.SelectedIndex = -1;
            GControlLiquidosE.DataBind();
        }
    }
    protected void DControlLiquidosE_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GControlLiquidosE.DataBind();
    }
    protected void DControlLiquidosE_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GControlLiquidosE.DataBind();
        GControlLiquidosE.SelectedIndex = -1;
        DControlLiquidosE.DataBind();
    }
    protected void BMaSControlLiquidosE_Click(object sender, EventArgs e)
    {
        DControlLiquidosE.ChangeMode(DetailsViewMode.Insert);
    }
    protected void DMedicamentos_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GMedicamentos.SelectedIndex = -1;
            GMedicamentos.DataBind();
        }
    }
    protected void DMedicamentos_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GMedicamentos.DataBind();
    }
    protected void DMedicamentos_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GMedicamentos.DataBind();
        GMedicamentos.SelectedIndex = -1;
        DMedicamentos.DataBind();
    }
    protected void BMasMedicamentos_Click(object sender, EventArgs e)
    {
        DMedicamentos.ChangeMode(DetailsViewMode.Insert);
    }
    protected void DBitacora_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GBitacora.SelectedIndex = -1;
            GBitacora.DataBind();
        }
    }
    protected void DBitacora_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GBitacora.DataBind();
    }
    protected void DBitacora_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GBitacora.DataBind();
        GBitacora.SelectedIndex = -1;
        DBitacora.DataBind();
    }
    protected void BMasBitacora_Click(object sender, EventArgs e)
    {
        DBitacora.ChangeMode(DetailsViewMode.Insert);
    }
    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + DDocumento.SelectedValue + "&f=" + TFecha.Text);
    }
}
