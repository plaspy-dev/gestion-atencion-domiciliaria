using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Collections.Specialized;

public partial class paciente_ingreso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();

        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = false;
            BMasCDiagnostico.Enabled = false;

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

                    PMujer.Visible = CCDetallePaciente.Sexo!= "M";

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasCDiagnostico.Enabled = usuario.CanInsert();

                    DMedico.Focus();

                    Query qIngreso = new Query("ingreso_paciente");

                    qIngreso += "id";
                    qIngreso += "medico";
                    qIngreso += "hora";
                    qIngreso += "motivo";
                    qIngreso += "segun";
                    qIngreso += "enfermedad_actual";
                    qIngreso += "ta";
                    qIngreso += "fc";
                    qIngreso += "fr";
                    qIngreso += "t";
                    qIngreso += "peso";
                    qIngreso += "observacionesa";
                    qIngreso += "amplacion";
                    qIngreso += "observacionesef";
                    qIngreso += "cdi";
                    qIngreso += "cde";
                    qIngreso += "ddi";
                    qIngreso += "dde";
                    qIngreso += "conducta";

                    CConector conectormysql = CConector.GetConector();
                    MySqlDataReader readermysql = conectormysql.Query(qIngreso.GetSelect("paciente=" + CCDetallePaciente.IdPaciente));
                    if (readermysql != null && readermysql.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasCDiagnostico.Enabled = usuario.CanUpdate();
                        ((MasterPageI)Master).Imprimir();

                        GCDiagnostico.Columns[0].Visible = usuario.CanUpdate();
                        GCDiagnostico.Columns[1].Visible = usuario.CanDelete();

                        HIdIngreso.Value = readermysql["id"].ToString();
                        DMedico.SelectedValue = readermysql["medico"].ToString();
                        THora.Text = readermysql["hora"].ToString();
                        TMotivo.Text = readermysql["motivo"].ToString();
                        DMotivo.SelectedValue = readermysql["segun"].ToString();
                        TEnfermedadActual.Text = readermysql["enfermedad_actual"].ToString();
                        TTA.Text = readermysql["ta"].ToString();
                        TFC.Text = readermysql["fc"].ToString();
                        TFR.Text = readermysql["fr"].ToString();
                        TT.Text = readermysql["t"].ToString();
                        TPeso.Text = readermysql["peso"].ToString();
                        // TObservacionesAntecedentes.Text = readermysql["observacionesa"].ToString();
                        // TAmpliacion.Text = readermysql["amplacion"].ToString();
                        // TObservacionesFisico.Text = readermysql["observacionesef"].ToString();
                        // TDIngreso.Text = readermysql["cdi"].ToString();
                        // TDEgreso.Text = readermysql["cde"].ToString();
                        // TDescripcionIngreso.Text = readermysql["ddi"].ToString();
                        // TDescripcionEgreso.Text = readermysql["dde"].ToString();
                        TConductaInicial.Text = readermysql["conducta"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdIngreso.Value);
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        CConector conector = CConector.GetConector();
        Query qIngreso = new Query("ingreso_paciente");

        qIngreso["medico"]= DMedico.SelectedValue;
        qIngreso["hora"]= THora.Text;
        qIngreso["motivo"]= TMotivo.Text;
        qIngreso["segun"]= DMotivo.SelectedValue;
        qIngreso["enfermedad_actual"]= TEnfermedadActual.Text;
        qIngreso["ta"]= TTA.Text;
        qIngreso["fc"]= TFC.Text;
        qIngreso["fr"]= TFR.Text;
        qIngreso["t"]= TT.Text;
        qIngreso["peso"]= TPeso.Text;
        // qIngreso["observacionesa"]= TObservacionesAntecedentes.Text;
        // qIngreso["amplacion"]= TAmpliacion.Text;
        // qIngreso["observacionesef"]= TObservacionesFisico.Text;
        // qIngreso["cdi"]= TDIngreso.Text;
        // qIngreso["cde"]= TDEgreso.Text;
        // qIngreso["ddi"]= TDescripcionIngreso.Text;
        // qIngreso["dde"]= TDescripcionEgreso.Text;
        qIngreso["conducta"]= TConductaInicial.Text;

        string szQuery;
        string mensaje;

        if (HIdIngreso.Value.Length == 0)
        {
            qIngreso["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = qIngreso.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdIngreso.Value = resultado.ToString();
        }
        else
        {
            szQuery = qIngreso.GetUpdate("id='" + HIdIngreso.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIngreso.Value) == -1)
            return;

        for(int i=0; i<GAntecedentes.Rows.Count; i++) {

            Query antecendentes = new Query("antecedentes_ingreso");
            string id= GAntecedentes.DataKeys[i].Values[1].ToString();

            antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
            if(id.Length>0) {
                id = antecendentes.GetUpdate("id='" + id + "'");
            } else {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

        for (int i = 0; i < GRevision.Rows.Count; i++)
        {

            Query antecendentes = new Query("revision_ingreso");
            string id = GRevision.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GRevision.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GRevision.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GRevision.Rows[i].Cells[3].FindControl("TObservaciones")).Text;

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GRevision.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

         for (int i = 0; i < GExamenFisico.Rows.Count; i++)
        {

            Query antecendentes = new Query("examen_ingreso");
            string id = GExamenFisico.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GExamenFisico.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GExamenFisico.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";
            antecendentes["observaciones"] = ((TextBox)GExamenFisico.Rows[i].Cells[3].FindControl("TObservaciones")).Text;

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GExamenFisico.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

         if (PMujer.Visible)
         {
             for (int i = 0; i < GGinecologico.Rows.Count; i++)
             {

                 Query antecendentes = new Query("varios_ingreso");
                 string id = GGinecologico.DataKeys[i].Values[1].ToString();

                 antecendentes["estado"] = ((CheckBox)GGinecologico.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                 antecendentes["observaciones"] = ((TextBox)GGinecologico.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                 if (id.Length > 0)
                 {
                     id = antecendentes.GetUpdate("id='" + id + "'");
                 }
                 else
                 {
                     antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                     antecendentes["motivo"] = GGinecologico.DataKeys[i].Values[0].ToString();
                     id = antecendentes.GetInsert();
                 }
                 conector.QueryMod(id);
             }
         }

        string[] querys = SCDiagnostico.GetQuerys();
        if (querys != null)
        {
            for (int i = 0; i < querys.Length; i++)
            {
                szQuery = querys[i].Replace("@ingreso", Query.GetValor(HIdIngreso.Value));
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected string GetCodigoCIE(string text)
    {
        int pos = text.IndexOf('-');
        if (pos != -1)
        {
            string resultado = text.Substring(0, pos);
            return text.Substring(0, pos).Trim();
        }
        return "";
    }

    protected void BMasCDiagnostico_Click(object sender, EventArgs e)
    {
        string codigo = GetCodigoCIE(TCIE10.Text);

        CConectorMS conector = new CConectorMS();

        string descripcion = conector.QueryString("SELECT cirDescripcion FROM phdCIE10 WHERE cieCodDx='" + codigo + "'");
        if (descripcion.Length > 0) {  // si existe el codigo

            IOrderedDictionary data = new OrderedDictionary();
            data.Add("codigo", codigo);
            data.Add("descripcion", descripcion);

            if (GCDiagnostico.SelectedIndex == -1)
            {
                SCDiagnostico.GetView().Insert(data, OnDataSourceOperationComplete);
            }
            else
            {
                data.Add("id", GCDiagnostico.DataKeys[GCDiagnostico.SelectedIndex].Value);

                IOrderedDictionary dataold = new OrderedDictionary();
                dataold.Add("codigo", HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[2].Text).Trim());
                dataold.Add("descripcion", HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim());
                dataold.Add("id", GCDiagnostico.DataKeys[GCDiagnostico.SelectedIndex].Value);

                SCDiagnostico.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
            }
            GCDiagnostico.SelectedIndex = -1;
            GCDiagnostico.DataBind();

            TCIE10.Text = "";
        }
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }

    protected void GCDiagnostico_SelectedIndexChanged(object sender, EventArgs e)
    {
        TCIE10.Text = HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[2].Text).Trim();
        TCIE10.Text+= " - " + HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim();
    }
}
