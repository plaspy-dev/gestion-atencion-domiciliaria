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
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled=false;
            BFecha.Enabled = false;
            BFormula.Visible = false;
            PFormulaciones.Visible = false;

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
                    
                    DTipo.DataBind();
                    if (DTipo.Items.FindByValue(Request.QueryString["tf"]) != null)
                        DTipo.SelectedValue = Request.QueryString["tf"];

                    Query formulacion = new Query("formulacion");

                    formulacion += "id";
                    formulacion += "fecha";
                    formulacion += "codigo";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "' AND tipo='" + DTipo.SelectedValue + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        ((MasterPageI)Master).Imprimir("formulacion.html");
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasFormulacion.Enabled= usuario.CanUpdate();

                        GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                        GFormulacion.Columns[1].Visible = usuario.CanDelete();

                        HIdFormulacion.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();

                        ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                    } else {

                        BFormula.Visible= conectormy.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' LIMIT 1;").Length!=0;
                    }

                    GFormulaciones.DataBind();
                    LFormulaciones.Text = GFormulaciones.Rows.Count + " Formula";
                    LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "s";
                    PFormulaciones.Visible = GFormulaciones.Rows.Count > 0;
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

        if (GFormulacion.Rows.Count > 4) 
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
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text + "&tf=" + DTipo.SelectedValue);
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
        formulacion["tipo"] = DTipo.SelectedValue;

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

    protected string RenderPage()
    {
        string resultado="";
        GFormulacion.DataBind();

        for (int i = 0; i < GFormulacion.Rows.Count; i++) {

            resultado += "<tr><td>" + GFormulacion.Rows[i].Cells[3].Text + "</td>";
            resultado += "<td align='right'>" + GFormulacion.Rows[i].Cells[4].Text + "</td>";
            resultado += "<td>" + GFormulacion.Rows[i].Cells[5].Text + "</td></tr>";
        }
        for (int i = GFormulacion.Rows.Count; i < 5; i++) {
            resultado += "<tr><td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td></tr>";
        }
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el resultado
        evento.Contenido = evento.Contenido.Replace("$GFormulacion$", RenderPage());
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        Query query = new Query("phdPaciente");

        query["categoria"] = "categoria";
        query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";

        CConectorMS conectorms = new CConectorMS();

        SqlDataReader reader = conectorms.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente));
        if (reader != null)
        {
            bool l = reader.Read();
            if (l)
            {
                evento.Contenido = evento.Contenido.Replace("$szCategoria$", new CConector().QueryString("SELECT nombre FROM varios WHERE id='" + reader["categoria"].ToString() + "' AND tipo=13"));
            }
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }
    }
    protected void BFormula_Click(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        string id= conector.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' ORDER BY fecha DESC LIMIT 1;");
        if(id.Length!=0) {

            MySqlDataReader reader= conector.Query("SELECT formulada,posologia,medicamento AS medicamentoid,CONCAT(medicamentos.nombre,' [',medicamentos.principio,'], ',medicamentos.concentracion,'-',medicamentos.forma) AS medicamento FROM medicamento_formulacion LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento) WHERE formulacion=" + id);
            if(reader!=null) {
                while(reader.Read()) {
                    
                    TMedicamento.Text= reader["medicamento"].ToString();
                    TCantidad.Text = reader["formulada"].ToString();
                    TPosologia.Text = reader["posologia"].ToString();
                    TMedicamentoID.Text = reader["medicamentoid"].ToString();

                    BMasFormulacion_Click(sender, e);
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formulacion.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)) + "&tf=" + ((ImageButton)sender).CommandName);
    }
}

