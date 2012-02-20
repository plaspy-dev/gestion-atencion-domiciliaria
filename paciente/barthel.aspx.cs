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

public partial class paciente_barthel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = false;

            CConectorMS conector = CConectorMS.GetConector();
            CConector conectormy = CConector.GetConector();

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

                    TFecha.Focus();
                    BAceptar.Enabled = usuario.CanInsert();
                    
                    Query indice= new Query("indice_barthel");
                    
                    indice+="id";
                    indice+="fecha";
                    indice+="diagnostico";

                    MySqlDataReader readermysql = conectormy.Query(indice.GetSelect("paciente=" + CCDetallePaciente.IdPaciente));
                    if (readermysql != null && readermysql.Read())
                    {
                        ((MasterPageI)Master).Imprimir();
                        BAceptar.Enabled = usuario.CanUpdate();

                        HIdIndice.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime) readermysql["fecha"]).ToShortDateString();
                        THora.Text = CConector.GetHora(readermysql["fecha"]);
                        TDiagnostico.Text = readermysql["diagnostico"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdIndice.Value);
                    }
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query indice = new Query("indice_barthel");
        CConector conector = CConector.GetConector();

        indice["fecha"] = CConector.GetMySQLDateFormat(TFecha.Text)  + " " + THora.Text + ":00";
        indice["diagnostico"]= TDiagnostico.Text;

        string szQuery;
        string mensaje;

        if (HIdIndice.Value.Length == 0)
        {
            indice["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = indice.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdIndice.Value = resultado.ToString();
        }
        else
        {
            szQuery = indice.GetUpdate("id='" + HIdIndice.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIndice.Value) == -1)
            return;

        for (int i = 0; i < RGrupos.Items.Count; i++)
        {
            Query analisis = new Query("analisis_barthel");

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
        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
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
