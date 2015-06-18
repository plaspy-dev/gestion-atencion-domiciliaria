using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Text.RegularExpressions;

public partial class paciente_valoracionat : System.Web.UI.Page
{
    public const int nMinutosTerapia = 45;

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = false;
            // PHistorial.Visible = false;
            TInicio.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);
            UCFuncionario.IdFuncionario = usuario["personal"];

            // DTV.MinumunValue = DateTime.Now.AddDays(-2);
            DTV.MinumunValue = DateTime.Now.AddMonths(-1);
            DTV.MaximunValue = DateTime.Now.AddMinutes(1);
            DTV.Enabled = !usuario.CanUpdate();

            using (CConector conectormy = new CConector())
            {
                if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    } else {
                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                        PDatos.Visible = true;

                        BAceptar.Enabled = usuario.CanInsert();
                        UCFuncionario.ReadOnly = !usuario.CanAdmin();
                        if (usuario.CanUpdate())
                            STipo.SelectParameters["canUpdate"].DefaultValue = "1";

                        TInicio.Focus();
                        DTipo.DataBind();
                        // DTipo_SelectedIndexChanged(sender, e);

                        if (!string.IsNullOrEmpty(Request.QueryString["vatid"]))
                        {

                            Query valoracion = new Query("valoracionat");

                            valoracion += "id";
                            valoracion += "inicio";
                            // valoracion += "fin";
                            valoracion += "tipo";
                            valoracion += "autorizacion";
                            valoracion += "observaciones";
                            valoracion += "paciente";
                            valoracion += "funcionario";

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
                                ((MasterPageI)Master).Imprimir("valoracionat.html");
                                BAceptar.Enabled = usuario.CanUpdate();
                                BEliminar.Visible = usuario.CanDelete();
                                // verificamos que el paciente solicitado sea el mismo 
                                if (CCDetallePaciente.IdPaciente != readermysql["paciente"].ToString()) { // son diferetnes

                                    CCDetallePaciente.IdPaciente = readermysql["paciente"].ToString();
                                    ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
                                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                                }

                                TInicio.Text = Query.GetFromMySQLDate(readermysql["inicio"], true);
                                LFinal.Text = Query.GetFromMySQLDate(((DateTime)readermysql["inicio"]).AddMinutes(nMinutosTerapia), true);
                                // TFin.Text = Query.GetFromMySQLDate(readermysql["fin"]);
                                // TNumeroTerapias.Text = readermysql["numero_terapias"].ToString();
                                TObservaciones.Text = readermysql["observaciones"].ToString();
                                UCFuncionario.IdFuncionario = readermysql["funcionario"].ToString();
                                Utilidades.SelectInDropDown(DTipo, readermysql["autorizacion"].ToString() + ";" + readermysql["tipo"].ToString(), Procedimientos.GetNombreMedicamento(readermysql["tipo"].ToString()));

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

                                // if (DTipo.SelectedValue == "1")
                                {
                                    Query respiratoria = new Query("valoracionat_respiratoria");

                                    respiratoria += "eoxigeno";
                                    respiratoria += "szEOxigeno";
                                    respiratoria += "latrogenia";
                                    respiratoria += "szLatrogenia";

                                    readermysql = conectormy.Query(respiratoria.GetSelect("valoracion=" + HIdValoracion.Value));
                                    if (readermysql != null && readermysql.Read())
                                    {

                                        COxigeno.Checked = readermysql["eoxigeno"].ToString() == "1";
                                        TOxigeno.Text = readermysql["szEOxigeno"].ToString();
                                        CLatrogenia.Checked = readermysql["latrogenia"].ToString() == "1";
                                        TLatrogenia.Text = readermysql["szLatrogenia"].ToString();
                                    }
                                }
                                // else if (DTipo.SelectedValue == "2")
                                {

                                } 
                                // else if (DTipo.SelectedValue == "3") 
                                {
                                    Query apoyo = new Query("valoracionat_ocupacional");

                                    apoyo += "presentoEA";
                                    apoyo += "szPresentoEA";
                                    apoyo += "medidas";

                                    readermysql = conectormy.Query(apoyo.GetSelect("valoracion=" + HIdValoracion.Value));
                                    if (readermysql != null && readermysql.Read())
                                    {

                                        CPresentoEA.Checked = readermysql["presentoEA"].ToString() == "1";
                                        TPresentoEA.Text = readermysql["szPresentoEA"].ToString();
                                        TMedidas.Text = readermysql["medidas"].ToString();
                                    }
                                }
                            }
                        }

                        GHistorial.DataBind();
                        LHistorial.Text = GHistorial.Rows.Count + " Valoraci";
                        LHistorial.Text += GHistorial.Rows.Count == 1 ? "ón" : "ones";
                        PHistorial.Visible = GHistorial.Rows.Count > 0;
                        DTipo_SelectedIndexChanged(sender, e);
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

        string szQuery;
        string mensaje;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            Query valoracion = new Query("valoracionat");

            valoracion["inicio"] = Query.GetMySQLDateFormat(TInicio.Text, true);
            // valoracion["fin"] = Query.GetMySQLDateFormat(TFin.Text);
            string[] valores = DTipo.SelectedValue.Split(';');
            valoracion["autorizacion"] = valores[0];
            valoracion["tipo"] = valores[1];
            // valoracion["numero_terapias"] = TNumeroTerapias.Text;
            valoracion["observaciones"] = TObservaciones.Text;
            valoracion["TA"] = TTA.Text;
            valoracion["FR"] = TFR.Text;
            valoracion["FC"] = TFC.Text;
            valoracion["saturacion"] = TSaturacion.Text;
            valoracion["justificacion"] = TJustificacion.Text;
            valoracion["revision"] = TPatron.Text;
            valoracion["actividades"] = TActividades.Text;
            valoracion["resultado"] = TResultados.Text;
            valoracion["funcionario"] = UCFuncionario.IdFuncionario;

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

            // if (DTipo.SelectedValue == "1")
            { // terapia respiratoria

                Query oxigeno = new Query("valoracionat_oxigeno");
                oxigeno["valoracion"] = HIdValoracion.Value;

                for (int i = 0; i < GOxigeno.Rows.Count; i++)
                {

                    TextBox valor = (TextBox)GOxigeno.Rows[i].FindControl("TValor");

                    oxigeno["valor"] = valor.Text;
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
            }
            // else if (DTipo.SelectedValue == "2")
            { // terapia fisica

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
            }
            // else if (DTipo.SelectedValue == "3")
            { // apoyo terapeutico

                Query apoyo = new Query("valoracionat_ocupacional");
                apoyo["valoracion"] = HIdValoracion.Value;
                apoyo["presentoEA"] = CPresentoEA.Checked ? "1" : "";
                apoyo["szPresentoEA"] = TPresentoEA.Text;
                apoyo["medidas"] = TMedidas.Text;

                if (conector.QueryMod(apoyo.GetInsert()) == -1)
                    return;
            }
            conector.Commit();
        }
        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&vatid=" + ((ImageButton)sender).CommandArgument);
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(UCFuncionario.IdFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(UCFuncionario.IdFuncionario)));

            RemoveSection(PRespiratoria, evento);
            RemoveSection(PFisica, evento);
            RemoveSection(POcupacional, evento);
        }
    }

    public void RemoveSection(PlaceHolder control, PrintEventArgs evento) {

        if (control.Visible)
            return;

        Regex regx = new Regex(string.Format(".*<!--.*{0}.*-->(?<content>.*)<!--.*{0}End.*-->.*", control.ID)
            , RegexOptions.IgnoreCase | RegexOptions.Singleline);
        Match match = regx.Match(evento.Contenido.ToString());
        if (match.Success)
        {
            evento.Contenido = evento.Contenido.Replace(match.Groups["content"].Value, "");
        }
    }

    protected void DTipo_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(DTipo.SelectedValue)) {
            LNumeroTerapias.Text = "";
            return;
        }

        string []valores= DTipo.SelectedValue.Split(';');
        Procedimientos.TipoServicio tiposervicio= Procedimientos.TipoServicio.Ninguno;
        try {
            Producto producto= Producto.GetProducto(valores[1]);
            tiposervicio = (Procedimientos.TipoServicio) Convert.ToInt32(producto.TipoServicio);
        } catch {}
        PRespiratoria.Visible = tiposervicio == Procedimientos.TipoServicio.TerapiaRespiratoria;
        PFisica.Visible = tiposervicio == Procedimientos.TipoServicio.TerapiaFisica;
        POcupacional.Visible = tiposervicio == Procedimientos.TipoServicio.TerapiaOcupacional || tiposervicio == Procedimientos.TipoServicio.TerapiaLenguaje;
        LTerapiaOcupacional.Text = Procedimientos.GetNombreTipoServicio(tiposervicio).ToUpper();

        using (CConector conector = new CConector())
        {
            LNumeroTerapias.Text = conector.QueryString(@"SELECT autorizacion_detalle.autNumSesiones
                            FROM programacion 
                            LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                            WHERE programacion.pacId={0} 
                            AND programacion.prgFechaProg>SYSDATE()-INTERVAL 7 DAY 
                            AND ({1}=1 OR programacion.perId={2})
                            AND programacion.actId={3} 
                            AND programacion.autNumero={4}
                            LIMIT 1
                            ", Query.GetValor(CCDetallePaciente.IdPaciente), CUsuario.GetInstance().CanUpdate() ? 1 : 0
                             , Query.GetValor(UCFuncionario.IdFuncionario), Query.GetValor(valores[1]), Query.GetValor(valores[0]));
        }
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM valoracionat WHERE id=" + HIdValoracion.Value) == -1)
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
            conector.Commit();
            ((MasterPageI)Master).SetResultado("Valoración eliminada " + CCDetallePaciente.Nombres);
        }
    }
}
