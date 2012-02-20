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
using System.Collections.Specialized;

public partial class paciente_formulacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled=false;
            BFecha.Enabled = false;

            Usuario usuario = Usuario.GetUsuario();
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

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasFormulacion.Enabled= usuario.CanInsert();
                    TFecha.Focus();
                    BFecha.Enabled = true;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;

                    CConectorMS conector = CConectorMS.GetConector();
                    CConector conectormy = CConector.GetConector();

                    TFecha.Text = Request.QueryString["f"];
                    if (TFecha.Text.Length == 0)
                        TFecha.Text = DateTime.Now.ToShortDateString();

                    Query formulacion = new Query("formulacion");

                    formulacion += "id";
                    formulacion += "fecha";
                    formulacion += "codigo";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        ((MasterPageI)Master).Imprimir();
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasFormulacion.Enabled= usuario.CanUpdate();

                        GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                        GFormulacion.Columns[1].Visible = usuario.CanDelete();

                        HIdFormulacion.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();

                        ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                    }
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        Page.Validate("medicamento");
        if (!RMedicamento.IsValid || !RPosologia.IsValid || !RCantidad.IsValid)
            return;

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("medicamento", TMedicamento.Text);
        data.Add("formulada", TCantidad.Text);
        data.Add("posologia", TPosologia.Text);
        data.Add("medicamen_id", TMedicamentoID.Text);

        if (GFormulacion.SelectedIndex == -1)
        {
            SFormulacion.GetView().Insert(data, OnDataSourceOperationComplete);
        } 
        else
        {
            data.Add("id", GFormulacion.DataKeys[GFormulacion.SelectedIndex].Value);

            IOrderedDictionary dataold = new OrderedDictionary();
            dataold.Add("medicamento", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[3].Text).Trim());
            dataold.Add("formulada", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[4].Text).Trim());
            dataold.Add("posologia", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[5].Text).Trim());
            dataold.Add("medicamen_id", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[2].Text).Trim());
            dataold.Add("id", GFormulacion.DataKeys[GFormulacion.SelectedIndex].Value);

            SFormulacion.GetView().Update(data, data, dataold,OnDataSourceOperationComplete);
        }
        GFormulacion.SelectedIndex = -1;
        GFormulacion.DataBind();

        TMedicamentoID.Text = TMedicamento.Text = TPosologia.Text = TCantidad.Text = "";
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
            
        BMasFormulacion_Click(sender, e);

        if (!RMedicamento.IsValid || !RPosologia.IsValid || !RCantidad.IsValid)
        {
            if (TMedicamentoID.Text.Length != 0 || TCantidad.Text.Length != 0 || TPosologia.Text.Length != 0)
                return;
        }

        Query formulacion = new Query("formulacion");
        CConector conector = CConector.GetConector();

        formulacion["fecha"]= CConector.GetDate(Convert.ToDateTime( TFecha.Text));

        string szQuery;
        string mensaje;

        if (HIdFormulacion.Value.Length == 0)
        {
            formulacion["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = formulacion.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdFormulacion.Value = resultado.ToString();
        }
        else
        {
            szQuery = formulacion.GetUpdate("id='" + HIdFormulacion.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
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
        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        TMedicamentoID.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[2].Text).Trim();
        TMedicamento.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[3].Text).Trim();
        TCantidad.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[4].Text).Trim();
        TPosologia.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[5].Text).Trim();
    }
}
