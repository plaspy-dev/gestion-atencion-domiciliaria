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

public partial class paciente_gastos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = false;
            BMasSuministros.Enabled = false;
            BFecha.Enabled = false;

            using (CConector conectormy = new CConector())
            {

                if (Request.QueryString["pid"] != null)
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

                        PDatos.Visible = true;

                        TFecha.Text = Request.QueryString["f"];
                        if (TFecha.Text.Length == 0)
                            TFecha.Text = DateTime.Now.ToShortDateString();

                        BAceptar.Enabled = usuario.CanInsert();
                        BMasSuministros.Enabled = usuario.CanInsert();
                        BFecha.Enabled = usuario.CanInsert();
                        TFecha.Focus();

                        Query hoja = new Query("hoja_gastos");

                        hoja += "id";
                        hoja += "fecha";

                        MySqlDataReader readermysql = conectormy.Query(hoja.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Query.GetMySQLDateFormat(Convert.ToDateTime(TFecha.Text)) + "'"));
                        if (readermysql != null && readermysql.Read())
                        {
                            ((MasterPageI)Master).Imprimir();
                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasSuministros.Enabled = usuario.CanUpdate();
                            BFecha.Enabled = usuario.CanUpdate();
                            GSuministros.Columns[0].Visible = usuario.CanUpdate();
                            GSuministros.Columns[1].Visible = usuario.CanDelete();

                            HIdHoja.Value = readermysql["id"].ToString();
                            TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                            BMasSuministros.Focus();

                            ((MasterPageI)Master).SetModificacion(HIdHoja.Value);
                        }
                    }
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected bool UpdateCambios(CConector conector, string[] querys)
    {
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

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query hoja = new Query("hoja_gastos");
        using (CConector conector = new CConector())
        {
            string szQuery = "";
            string mensaje = "";

            hoja["fecha"] = Query.GetMySQLDateFormat(Convert.ToDateTime(TFecha.Text));

            if (HIdHoja.Value.Length == 0)
            {
                hoja["paciente"] = CCDetallePaciente.IdPaciente;

                szQuery = hoja.GetInsert();
                mensaje = CCDetallePaciente.Nombres + " ingresado";
                int resultado = conector.QueryMod(szQuery, true);
                if (resultado == -1)
                    return;
                HIdHoja.Value = resultado.ToString();
            }
            else
            {
                szQuery = hoja.GetUpdate("id='" + HIdHoja.Value + "'");
                mensaje = CCDetallePaciente.Nombres + " editado";
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
            if (conector.InsertModificacion(HIdHoja.Value) == -1)
                return;
            if (!UpdateCambios(conector, SSuministros.GetQuerys()))
                return;

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }
    protected void DSuministros_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GSuministros.SelectedIndex = -1;
            GSuministros.DataBind();
        }
    }
    protected void DSuministros_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GSuministros.DataBind();
    }
    protected void DSuministros_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GSuministros.DataBind();
        GSuministros.SelectedIndex = -1;
        DSuministros.DataBind();
    }
    protected void BMasSuministros_Click(object sender, EventArgs e)
    {
        DSuministros.ChangeMode(DetailsViewMode.Insert);
    }
    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text);
    }
}
