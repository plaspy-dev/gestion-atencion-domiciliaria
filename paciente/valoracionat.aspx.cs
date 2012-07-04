using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class paciente_valoracionat : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = CUsuario.GetUsuario();

            BAceptar.Enabled = false;
            // PHistorial.Visible = false;

            CConector conectormy = CConector.GetConector();

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
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
                    DTipo.Focus();

                    BAceptar.Enabled = usuario.CanInsert();

                    if(!string.IsNullOrEmpty(Request.QueryString["vatid"])) {

                        Query valoracion = new Query("valoracionat");

                        valoracion += "id";
                        valoracion += "inicio";
                        valoracion += "fin";
                        valoracion += "tipo";
                        valoracion += "numero_terapias";
                        valoracion += "observaciones";
                        valoracion += "paciente";

                        // panel comun
                        valoracion += "TA";
                        valoracion += "FR";
                        valoracion += "FC";
                        valoracion += "saturacion";
                        valoracion += "justificacion";
                        valoracion += "revision";
                        valoracion += "actividades";
                        valoracion += "resultado";

                        MySqlDataReader readermysql = conectormy.Query(valoracion.GetSelect("id=" + Request.QueryString["vatid"]));
                        if (readermysql != null && readermysql.Read())
                        {
                            BAceptar.Enabled = usuario.CanUpdate();
                            // verificamos que el paciente solicitado sea el mismo 
                            if(CCDetallePaciente.IdPaciente != readermysql["paciente"].ToString()) { // son diferetnes

                                CCDetallePaciente.IdPaciente = readermysql["paciente"].ToString();
                                ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
                                SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                                SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                            }

                            TInicio.Text = CConector.GetFromMySQLDate(readermysql["inicio"]);
                            TFin.Text = CConector.GetFromMySQLDate(readermysql["fin"]);
                            DTipo.SelectedValue = readermysql["tipo"].ToString();
                            TNumeroTerapias.Text = readermysql["numero_terapias"].ToString();
                            TObservaciones.Text= readermysql["observaciones"].ToString();

                            // panel comun
                            TTA.Text = readermysql["TA"].ToString();
                            TFR.Text = readermysql["FR"].ToString();
                            TFC.Text = readermysql["FC"].ToString();
                            TSaturacion.Text = readermysql["saturacion"].ToString();
                            TJustificacion.Text = readermysql["justificacion"].ToString();
                            TPatron.Text = readermysql["revision"].ToString();
                            TActividades.Text = readermysql["actividades"].ToString();
                            TResultados.Text = readermysql["resultado"].ToString();

                            HIdValoracion.Value = readermysql["id"].ToString();

                            ((MasterPageI)Master).SetModificacion(HIdValoracion.Value);

                            if (DTipo.SelectedValue == "1") {
                                
                                Query respiratoria = new Query("valoracionat_respiratoria");

                                respiratoria+="eoxigeno";
                                respiratoria+="szEOxigeno";
                                respiratoria += "latrogenia";
                                respiratoria += "szLatrogenia";
                                
                                readermysql = conectormy.Query(respiratoria.GetSelect("valoracion=" + HIdValoracion.Value));
                                if (readermysql != null && readermysql.Read()) {

                                    COxigeno.Checked= readermysql["eoxigeno"].ToString()=="1";
                                    TOxigeno.Text= readermysql["szEOxigeno"].ToString();
                                    CLatrogenia.Checked = readermysql["latrogenia"].ToString() == "1";
                                    TLatrogenia.Text = readermysql["szLatrogenia"].ToString();
                                }
                            } else if (DTipo.SelectedValue == "2") { 

                            }  else if (DTipo.SelectedValue == "3") {
                                
                                Query apoyo = new Query("valoracionat_ocupacional");
                                
                                apoyo+="presentoEA";
                                apoyo+="szPresentoEA";
                                apoyo+="medidas";

                                readermysql = conectormy.Query(apoyo.GetSelect("valoracion=" + HIdValoracion.Value));
                                if (readermysql != null && readermysql.Read()) {

                                    CPresentoEA.Checked= readermysql["presentoEA"].ToString() == "1";
                                    TPresentoEA.Text = readermysql["szPresentoEA"].ToString();
                                    TMedidas.Text= readermysql["medidas"].ToString();
                                }
                            }
                        }
                    }

                    GHistorial.DataBind();
                    LHistorial.Text = GHistorial.Rows.Count + " Evaluaci";
                    LHistorial.Text += GHistorial.Rows.Count == 1 ? "ón" : "ones";
                    PHistorial.Visible = GHistorial.Rows.Count > 0;
                    DTipo_SelectedIndexChanged(sender, e);
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

        string szQuery;
        string mensaje;
        
        CConector conector = new CConector();
        Query valoracion = new Query("valoracionat");

        valoracion["inicio"] = CConector.GetMySQLDateFormat(TInicio.Text);
        valoracion["fin"]= CConector.GetMySQLDateFormat(TFin.Text);
        valoracion["tipo"]= DTipo.SelectedValue;
        valoracion["numero_terapias"]= TNumeroTerapias.Text;
        valoracion["observaciones"]= TObservaciones.Text;
        valoracion["TA"] = TTA.Text;
        valoracion["FR"] = TFR.Text;
        valoracion["FC"] = TFC.Text;
        valoracion["saturacion"] = TSaturacion.Text;
        valoracion["justificacion"] = TJustificacion.Text;
        valoracion["revision"] = TPatron.Text;
        valoracion["actividades"] = TActividades.Text;
        valoracion["resultado"] = TResultados.Text;

        if (HIdValoracion.Value.Length == 0)
        {
            valoracion["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = valoracion.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdValoracion.Value = resultado.ToString();
        }
        else
        {
            szQuery = valoracion.GetUpdate("id='" + HIdValoracion.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdValoracion.Value) == -1)
            return;

        // eliminamos las otras tablas
        if (conector.QueryMod("DELETE FROM valoracionat_ocupacional WHERE valoracion=" + HIdValoracion.Value) == -1)
            return;
        if (conector.QueryMod("DELETE FROM valoracionat_oxigeno WHERE valoracion=" + HIdValoracion.Value) == -1)
            return;
        if (conector.QueryMod("DELETE FROM valoracionat_respiratoria WHERE valoracion=" + HIdValoracion.Value) == -1)
            return;
        if (conector.QueryMod("DELETE FROM valoracionat_fuerza_muscular WHERE valoracion=" + HIdValoracion.Value) == -1)
            return;

        if(DTipo.SelectedValue=="1") { // terapia respiratoria

            Query oxigeno = new Query("valoracionat_oxigeno");
            oxigeno["valoracion"] = HIdValoracion.Value;

            for(int i=0; i<GOxigeno.Rows.Count; i++) {

                TextBox valor=(TextBox)GOxigeno.Rows[i].FindControl("TValor");

                oxigeno["valor"]=valor.Text;
                oxigeno["tipo"] = GOxigeno.DataKeys[i].Value.ToString();

                if (conector.QueryMod(oxigeno.GetInsert()) == -1)
                    return;
            }
            Query respiratoria = new Query("valoracionat_respiratoria");

            respiratoria["valoracion"] = HIdValoracion.Value;
            respiratoria["eoxigeno"] = COxigeno.Checked ? "1" : "";
            respiratoria["szEOxigeno"] = TOxigeno.Text;
            respiratoria["latrogenia"] = CLatrogenia.Checked ? "1" : "";
            respiratoria["szLatrogenia"] = TLatrogenia.Text;

            if (conector.QueryMod(respiratoria.GetInsert()) == -1)
                return;
        } else if(DTipo.SelectedValue=="2") { // terapia fisica

            Query fuerza = new Query("valoracionat_fuerza_muscular");
            fuerza["valoracion"] = HIdValoracion.Value;

            for (int i = 0; i < GFuerza.Rows.Count; i++)
            {
                fuerza["izquierda"] = ((TextBox)GFuerza.Rows[i].FindControl("TIzquierda")).Text;
                fuerza["derecha"] = ((TextBox)GFuerza.Rows[i].FindControl("TDerecha")).Text;
                fuerza["puntuacion"] = ((TextBox)GFuerza.Rows[i].FindControl("TPuntaje")).Text;
                fuerza["tipo"] = GFuerza.DataKeys[i].Value.ToString();

                if (conector.QueryMod(fuerza.GetInsert()) == -1)
                    return;
            }
        } else if(DTipo.SelectedValue=="3") { // apoyo terapeutico

            Query apoyo = new Query("valoracionat_ocupacional");
            apoyo["valoracion"] = HIdValoracion.Value;
            apoyo["presentoEA"] = CPresentoEA.Checked ? "1" : "";
            apoyo["szPresentoEA"] = TPresentoEA.Text;
            apoyo["medidas"] = TMedidas.Text;

            if (conector.QueryMod(apoyo.GetInsert()) == -1)
                return;
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&vatid=" + ((ImageButton)sender).CommandArgument);
    }
    protected void DTipo_SelectedIndexChanged(object sender, EventArgs e)
    {
        PRespiratoria.Visible= DTipo.SelectedValue=="1";
        PFisica.Visible = DTipo.SelectedValue == "2";
        POcupacional.Visible = DTipo.SelectedValue == "3";
        PComun.Visible = PRespiratoria.Visible || PFisica.Visible;
    }
}
