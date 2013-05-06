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
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = false;
            PHistorial.Visible = false;

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


                    TFuncionario.Enabled = usuario.CanAdmin();
                    if (!usuario.CanAdmin())
                    {
                        if (usuario["personal"].Length == 0)
                            BAceptar.Enabled = false;
                        else
                        {
                            TIdFuncionario.Text = usuario["personal"];
                            TFuncionario.Text = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId='" + TIdFuncionario.Text + "'");
                        }
                    }

                    TFecha.Focus();
                    BAceptar.Enabled = usuario.CanInsert();

                    TFecha.Text = Request.QueryString["f"];
                    if (TFecha.Text.Length == 0)
                        TFecha.Text = DateTime.Now.ToShortDateString();
                    else THora.Focus();

                    Query indice= new Query("indice_barthel");
                    
                    indice+="id";
                    indice+="fecha";
                    indice += "medico";

                    MySqlDataReader readermysql = conectormy.Query(indice.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND DATE(fecha)='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        ((MasterPageI)Master).Imprimir("barthel.html");
                        BAceptar.Enabled = usuario.CanUpdate();

                        HIdIndice.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime) readermysql["fecha"]).ToShortDateString();
                        THora.Text = CConector.GetHora(readermysql["fecha"]);
                        
                        TIdFuncionario.Text = readermysql["medico"].ToString();
                        TFuncionario.Text = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId='" + TIdFuncionario.Text + "'");

                        TTotal.Text = conectormy.QueryString("SELECT SUM(varios.descripcion) FROM analisis_barthel LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE analisis_barthel.indice_barthel='" + HIdIndice.Value + "'");

                        ((MasterPageI)Master).SetModificacion(HIdIndice.Value);
                    }
                    
                    GHistorial.DataBind();
                    LHistorial.Text = GHistorial.Rows.Count + " Índice";
                    LHistorial.Text += GHistorial.Rows.Count == 1 ? "" : "s";
                    PHistorial.Visible = GHistorial.Rows.Count > 0;
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
        indice["medico"] = TIdFuncionario.Text;

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
        Usuario.GetUsuario().SetForceURL("", conector);
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
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)));
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text);
    }
    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        string incapacidad="";
        try
        {
            int puntaje = Convert.ToInt32(TTotal.Text);
            if (puntaje < 45)
                incapacidad = "Severa";
            else if (puntaje < 60)
                incapacidad = "Grave";
            else if (puntaje < 80)
                incapacidad = "Moderada";
            else if (puntaje < 100)
                incapacidad = "Ligera";
        } catch {

        }
        evento.Contenido = evento.Contenido.Replace("$szPuntaje$", incapacidad);

        string repeater = "<table width=100% border=1>";
        RGrupos.DataBind();

        for (int i = 0; i < RGrupos.Items.Count; i++)
        {
            repeater+="<tr><td><b>" + 
                        ((Label)RGrupos.Items[i].FindControl("LN")).Text +
                        "</b></td>";

            RadioButtonList lista = (RadioButtonList)RGrupos.Items[i].FindControl("RConceptos");
            repeater += "<td>";
            for (int j = 0; j < lista.Items.Count; j++) {
                if (j > 0)
                    repeater += "<br/>";
                if (lista.Items[j].Selected)
                    repeater += "<b>";
                repeater += lista.Items[j].Text;
                if (lista.Items[j].Selected)
                    repeater += "</b>";
            }
            repeater += "</td></tr>";
        }
        repeater += "</table>";
        evento.Contenido = evento.Contenido.Replace("$GDetalle$", repeater);

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        Query query = new Query("phdPaciente");

        query["szMedico"] = "admPersonalHS.perDocumento";
        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szCargo"] = "admCargo.carDescripcion";

        CConectorMS conectorms = new CConectorMS();

        SqlDataReader reader = conectorms.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente
            , "LEFT JOIN admPersonalHS ON (admPersonalHS.perId=phdPaciente.megId)"
            + " LEFT JOIN admCargo ON (admCargo.carId=admPersonalHS.carId)"
            ));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }
    }
}
