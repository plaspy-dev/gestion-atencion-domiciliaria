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
using System.Globalization;

public partial class paciente_formulacion : System.Web.UI.Page
{
    public const string idprocedimientos = "173";
    public const string iddisan = "36";

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            // SeleccionarPaciente.Inactivos = false;
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled=false;
            BFecha.Enabled = false;
            BFormula.Visible = false;
            PFormulaciones.Visible = false;

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            if (!string.IsNullOrEmpty(Request.QueryString["fid"])) {

                CConector conectormy = CConector.GetConector();
                Query formulacion = new Query("formulacion");

                formulacion += "paciente";
                formulacion += "fecha";
                formulacion += "tipo";

                MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("id=" + Query.GetValor(Request.QueryString["fid"])));
                if (readermysql != null && readermysql.Read()) {
                    Response.Redirect("~/paciente/formulacion.aspx?pid=" + readermysql["paciente"].ToString() + "&f=" + string.Format("{0:d}", Convert.ToDateTime(readermysql["fecha"])) + "&tf=" + readermysql["tipo"].ToString());
                }
            }
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

                    DTipo.DataBind();
                    if (!usuario.CanAdmin())
                    {
                        for (int i = 0; i < DTipo.Items.Count; i++) {
                            if(CCDetallePaciente.AsegurdadorID == iddisan) {
                                if(DTipo.Items[i].Text == "Medicamentos") {
                                    DTipo.Items.RemoveAt(i);
                                    break;
                                }
                            } else {
                                if(DTipo.Items[i].Text == "Acuerdo 042 y 046") {
                                    DTipo.Items.RemoveAt(i);
                                    break;
                                }
                            }
                        }
                    }
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

                    if (DTipo.Items.FindByValue(Request.QueryString["tf"]) != null)
                        DTipo.SelectedValue = Request.QueryString["tf"];

                    trIntensidad.Visible = DTipo.SelectedValue == idprocedimientos;

                    if (DTipo.SelectedIndex != -1)
                    {
                        string singular = DTipo.SelectedItem.Text.ToLower();
                        if (singular[singular.Length - 1] == 's')
                        {
                            singular = DTipo.SelectedItem.Text.Substring(0, DTipo.SelectedItem.Text.Length - 1);
                        }
                        else singular = DTipo.SelectedItem.Text;
                        CConector conectormysql = new CConector();
                        GFormulacion.Columns[6].HeaderText = LPosologia.Text = conectormysql.QueryString("SELECT descripcion FROM varios WHERE id=" + DTipo.SelectedValue);
                        if (LPosologia.Text.ToLower() != "posología") {
                            GFormulacion.Columns[7].Visible = false;
                            GFormulacion.Columns[8].Visible = false;
                            trPosologia.Visible = false;
                        }

                        LFormulacion.Text = DTipo.SelectedItem.Text;
                        LMedicamento.Text = singular;
                        GFormulacion.Columns[3].HeaderText = singular;
                    }

                    Query formulacion = new Query("formulacion");

                    formulacion += "id";
                    formulacion += "fecha";
                    formulacion += "codigo";
                    formulacion += "profesional";
                    formulacion += "autorizacion";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "' AND tipo='" + DTipo.SelectedValue + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        string ruta = string.Format("formulacion{0}.html", CCDetallePaciente.AsegurdadorID);
                        ((MasterPageI)Master).Imprimir(File.Exists(Server.MapPath(ruta)) ? ruta : "formulacion.html");

                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasFormulacion.Enabled= usuario.CanInsert();

                        GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                        GFormulacion.Columns[1].Visible = usuario.CanDelete();

                        HIdFormulacion.Value = readermysql["id"].ToString();
                        if (readermysql["autorizacion"].ToString().Length > 0)
                        {
                            HAutorizacion.Text = "Autorización " + readermysql["autorizacion"].ToString();
                            HAutorizacion.NavigateUrl = "~/admisiones/autorizaciones.aspx?aut=" + readermysql["autorizacion"].ToString();
                            ViewState["autorizacion"] = readermysql["autorizacion"].ToString();
                        }
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        ViewState["profesional"] = readermysql["profesional"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                    } else {

                        BFormula.Visible = DTipo.SelectedValue != idprocedimientos && conectormy.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' LIMIT 1;").Length != 0;
                    }

                    GFormulaciones.DataBind();
                    LFormulaciones.Text = GFormulaciones.Rows.Count + " Orden";
                    LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "es";
                    LFormulaciones.Text += " médica";
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

    protected bool AddMedicamento() {

        LMensajeMedicamento.Text = "";
        if (TMedicamentoID.Text.Length == 0 && HIdFormulacion.Value.Length>0) // ya existe la formula y el medicamento esta en blanco
            return true;

        Page.Validate("medicamento");
        if (!Page.IsValid)
            return false;

        if (!Usuario.GetUsuario().CanAdmin())
        {
            // verificamos que la cantidad no exeda lo permitido por el servicio
            int maximo = Procedimientos.GetMaxServicios(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID);
            int cantidadactual = Convert.ToInt32(TCantidad.Text);
            if (DTipo.SelectedValue == idprocedimientos)
            {
                if (cantidadactual > 93)
                {
                    LMensajeMedicamento.Text = "Excede la cantidad máxima diaria permitida";
                    TCantidad.Focus();
                    return false;
                }
                CConector conector = new CConector();
                string cantidad = conector.QueryString(string.Format("SELECT medicamento_formulacion.formulada FROM formulacion"
                    + " LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)"
                    + " WHERE"
                    + " formulacion.paciente={0}"
                    + " AND medicamento_formulacion.medicamento={2}"
                    + " AND (({3}='' AND medicamento_formulacion.intensidad IS NULL) OR medicamento_formulacion.intensidad={3} )"
                    + " ORDER BY formulacion.fecha DESC"
                    + " LIMIT 1"
                    , Query.GetValor(CCDetallePaciente.IdPaciente)
                    , Query.GetValor(Conector.GetMySQLDateFormat(TFecha.Text))
                    , Query.GetValor(TMedicamentoID.Text)
                    , Query.GetValor(DIntensidad.SelectedValue)
                    ));
                try
                {
                    int nCantidad= Convert.ToInt32(cantidad);
                    nCantidad= Convert.ToInt32(nCantidad*1.1);
                    if (cantidadactual > nCantidad)
                    {  // excede la cantidad anterior
                        LMensajeMedicamento.Text = "Excede la cantidad máxima de sesiones de la orden médica anterior.";
                        TCantidad.Focus();
                        return false;
                    }
                }
                catch { }
            }
            if (maximo > 0) // esta restringido
            {
                int nuevacantidad = cantidadactual;
                // esto se guarda linea por linea en la base de datos no hay necesidad de sumar
                /*for (int i = 0; i < GFormulacion.Rows.Count; i++)
                {
                    if (HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[2].Text).Trim() == TMedicamentoID.Text)
                        nuevacantidad += Convert.ToInt32(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[4].Text).Trim());
                }*/

                if (maximo < nuevacantidad)
                {  // excede el maximo permitido
                    LMensajeMedicamento.Text = "Excede la cantidad máxima por servicio permitida (" + maximo.ToString() + ")";
                    TMedicamento.Focus();
                    return false;
                }

                // verificamos el acumulado de servicios formulados
                string formuladaanterior = new CConector().QueryString("SELECT SUM(medicamento_formulacion.formulada) FROM formulacion LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id) WHERE formulacion.paciente=" + CCDetallePaciente.AsegurdadorID + " AND medicamento_formulacion.medicamento=" + Query.GetValor(TMedicamentoID.Text) + " AND fecha>DATE_ADD(DATE(SYSDATE()), INTERVAL -30 DAY);");
                if (formuladaanterior.Length != 0)
                    nuevacantidad += Convert.ToInt32(formuladaanterior);
                if (maximo < nuevacantidad)
                {  // excede el maximo permitido
                    LMensajeMedicamento.Text = "Excede la cantidad máxima por servicio mensual permitida (" + maximo.ToString() + ")";
                    TMedicamento.Focus();
                    return false;
                }
            }

            // verificamos el valor maximo por paciente
            double costoprocedimiento = Procedimientos.GetCosto(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID);
            if ((CCDetallePaciente.TopePaciente > 0 || CCDetallePaciente.TopeAsegurador > 0) && costoprocedimiento > 0) // el tratamiento tiene costo
            {
                double total = cantidadactual * costoprocedimiento; // este es el actual
                // esto se guarda linea por linea en la base de datos no hay necesidad de sumar
                /*for (int i = 0; i < GFormulacion.Rows.Count; i++)
                {
                    total += Convert.ToInt32(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[4].Text).Trim()) *
                        Procedimientos.GetCosto(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[2].Text).Trim(), CCDetallePaciente.AsegurdadorID);
                }*/
                // verificamos el tope del paciente
                if (total > CCDetallePaciente.TopePaciente)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto del paciente";
                    TMedicamento.Focus();
                    return false;
                }
                total += CCDetallePaciente.GetCostoPacienteActual;
                if (total > CCDetallePaciente.TopePaciente)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto mensual del paciente";
                    TMedicamento.Focus();
                    return false;
                }
                // verificamos el tope del asegurador
                if (total > CCDetallePaciente.TopeAsegurador)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto mensual de la aseguradora";
                    TMedicamento.Focus();
                    return false;
                }
                // verificamos que el tope de todos los servicios del asegurador
                total -= CCDetallePaciente.GetCostoPacienteActual;
                total += CCDetallePaciente.GetCostoAseguradoraActual;

                // verificamos el tope del asegurador
                if (total > CCDetallePaciente.TopeAsegurador)
                {
                    LMensajeMedicamento.Text = "Los servicios exceden el tope de presupuesto mensual de la aseguradora";
                    TMedicamento.Focus();
                    return false;
                }
            }
        }

        // verificamos que no se halla formulado el mes anterior
        if (!CUsuario.GetUsuario().CanAdmin() && CCDetallePaciente.AsegurdadorID == iddisan)
        {
            CConector conector = new CConector();
            string ultimareceta = conector.QueryString(string.Format("SELECT formulacion.fecha FROM formulacion"
                + " LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)"
                + " WHERE"
                + " formulacion.paciente={0}"
                + " AND formulacion.fecha>DATE_ADD({1}, INTERVAL -60 DAY)"
                + " AND medicamento_formulacion.medicamento={2}"
                + " LIMIT 1"
                , Query.GetValor(CCDetallePaciente.IdPaciente)
                , Query.GetValor(Conector.GetMySQLDateFormat(TFecha.Text))
                , Query.GetValor(TMedicamentoID.Text)
                ));
            if (ultimareceta.Length > 0)
            {
                LMensajeMedicamento.Text = "Este medicamento fue recetado el " + CConector.GetDateFormat(ultimareceta);
                TMedicamento.Focus();
                return false;
            }
        }
        return true;
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        BAceptar_Click(sender, e);
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text + "&tf=" + DTipo.SelectedValue);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        } catch {}

        if (!AddMedicamento())
            return;

        if (DTipo.SelectedValue == idprocedimientos && Procedimientos.HasIntensidad(TMedicamentoID.Text) && DIntensidad.SelectedValue.Length == 0)
        { // es un procedimiento
            LMensajeMedicamento.Text = "Por favor ingrese una intensidad para el procedimiento.";
            DIntensidad.Focus();
            return;
        }

        Query formulacion = new Query("formulacion");
        Query query = new Query("phdAutorizacion");

        CConector conector = new CConector();
        CConectorMS conectorMS = new CConectorMS();

        conector.StartTransaction();
        conectorMS.StartTransaction();

        DateTime fecha = Convert.ToDateTime(TFecha.Text);

        formulacion["fecha"]= CConector.GetMySQLDateFormat(TFecha.Text);
        formulacion["tipo"] = DTipo.SelectedValue;
        formulacion["profesional"] = CUsuario.GetUsuario()["personal"];


        query["autFecha"] = fecha.ToShortDateString();
        query["autFechaVenc"] = fecha.AddDays(30).ToShortDateString();

        string szQuery;
        string mensaje;

        if (HIdFormulacion.Value.Length == 0)
        {
            formulacion["paciente"] = CCDetallePaciente.IdPaciente;
            if (DTipo.SelectedValue == idprocedimientos)
            { // agregamos la autorizacion

                string autorizacion= conectorMS.QueryString(
                String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(ISNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                        + " FROM phdAutorizacion"
                        + " WHERE autNumero LIKE 'AD{0}%'", fecha.ToString("yyMMdd")));

                query["autNumero"] = autorizacion;
                query["pacId"] = CCDetallePaciente.IdPaciente;
                query["entId"] = CCDetallePaciente.AsegurdadorID;
                query["autActivo"] = "0";
                query["autProvisional"] = "1";
                query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
                query["segFechaIngreso"] = "GETDATE()";

                if (conectorMS.QueryMod(query.GetInsert()) == -1)
                    return;

                formulacion["autorizacion"] = autorizacion;
                ViewState["autorizacion"] = autorizacion;
            }

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
            if (!string.IsNullOrEmpty((string)ViewState["autorizacion"])) {
                if (conectorMS.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString()))) == -1)
                    return;
            }
        }
        if (conector.InsertModificacion(HIdFormulacion.Value) == -1)
            return;
        if (!string.IsNullOrEmpty((string)ViewState["autorizacion"]))
        {
            /*if (new CConector().InsertModificacion(ViewState["autorizacion"].ToString(), null, "~/admisiones/autorizaciones.aspx") == -1)
                return;*/
        }

        if(TMedicamentoID.Text.Length>0) {

            Query medicamento = new Query("medicamento_formulacion");

            medicamento["medicamento"] = TMedicamentoID.Text;
            medicamento["formulada"] = TCantidad.Text;
            medicamento["posologia"] = TPosologia.Text;
            medicamento["via"] = TVia.Text;
            medicamento["tiempo"] = TTiempo.Text;
            medicamento["costo"] = Procedimientos.GetCosto(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID).ToString(CultureInfo.InvariantCulture);
            medicamento["intensidad"] = DIntensidad.SelectedValue;

            if (GFormulacion.SelectedIndex == -1)
            {
                medicamento["formulacion"] = HIdFormulacion.Value;
                if (conector.QueryMod(medicamento.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(medicamento.GetUpdate("id=" + GFormulacion.DataKeys[GFormulacion.SelectedIndex].Values["id"].ToString())) == -1)
                    return;
            }
        }

        if (!string.IsNullOrEmpty((string)ViewState["autorizacion"]))
        {
            if (conectorMS.QueryMod("DELETE FROM phdDetalleAutorizacion WHERE autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString())) == -1)
                return;

            Query detalle = new Query("phdDetalleAutorizacion");

            detalle["autNumero"] = ViewState["autorizacion"].ToString();

            MySqlDataReader reader = conector.Query("SELECT medicamento,formulada,intensidad FROM medicamento_formulacion WHERE formulacion=" + Query.GetValor(HIdFormulacion.Value));
            if(reader!=null) {
                while(reader.Read()) {
                    
                    detalle["actId"] = reader["medicamento"].ToString();
                    detalle["autNumSesiones"] = reader["formulada"].ToString();
                    detalle["intensidad"] = reader["intensidad"].ToString();

                    if (conectorMS.QueryMod(detalle.GetInsert()) == -1)
                        return;
                }
            }

            query = new Query("phdAutorizacion");

            query["formulacion"] = HIdFormulacion.Value;
            // query["autObservaciones"] = conector.QueryString("SELECT GROUP_CONCAT(CONCAT(nombre,': ',posologia) SEPARATOR '\n') FROM medicamento_formulacion LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento) WHERE formulacion=" + Query.GetValor(HIdFormulacion.Value) + " AND posologia IS NOT NULL");

            if (conectorMS.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString()))) == -1)
                return;

            HAutorizacion.Text = "Autorización " + ViewState["autorizacion"].ToString();
            HAutorizacion.NavigateUrl = "~/admisiones/autorizaciones.aspx?aut=" + ViewState["autorizacion"].ToString();
        }

        conector.Commit();
        conectorMS.Commit();

        if (sender != BAceptar)
        {
            GFormulacion.SelectedIndex = -1;
            GFormulacion.DataBind();
            TMedicamentoID.Text = TMedicamento.Text = TPosologia.Text = TCantidad.Text = "";
            TMedicamentoID_TextChanged(sender, e);
            TTiempo.Text = TVia.Text = "";
            CCDetallePaciente.GetCostoPacienteActual = 0;
            CCDetallePaciente.GetCostoAseguradoraActual = 0;
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        if(sender==BAceptar)
            ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        TMedicamentoID.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[2].Text).Trim();
        TMedicamento.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[3].Text).Trim();
        TCantidad.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[5].Text).Trim();
        TPosologia.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[6].Text).Trim();
        TTiempo.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[7].Text).Trim();
        TVia.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[8].Text).Trim();
        TMedicamentoID_TextChanged(sender, e);
        CConector.SelectInDropDown(DIntensidad, GFormulacion.DataKeys[GFormulacion.SelectedIndex].Values["intensidad"]);
    }

    protected string RenderPage(int inicio, int numero_medicamentos)
    {
        string resultado="";
        GFormulacion.DataBind();
        int i = inicio;

        for (; i < GFormulacion.Rows.Count && i < inicio + numero_medicamentos; i++)
        {
            resultado += "<tr><td>" + GFormulacion.Rows[i].Cells[3].Text + "</td>";
            resultado += "<td>" + NumerosALetras.ToLetras(Convert.ToInt32(GFormulacion.Rows[i].Cells[5].Text)).ToUpper() + " (" + GFormulacion.Rows[i].Cells[5].Text + ")</td>";
            resultado += "<td>" + GFormulacion.Rows[i].Cells[6].Text + "</td>";
            if(trPosologia.Visible) {
                resultado += "<td>" + GFormulacion.Rows[i].Cells[7].Text + "</td>";
                resultado += "<td>" + GFormulacion.Rows[i].Cells[8].Text + "</td>";
            }
            if(trIntensidad.Visible) {
                resultado += "<td>" + GFormulacion.Rows[i].Cells[Utilidades.GetGridColumnIndex(GFormulacion, "Intensidad")].Text + "</td>";
            }
            resultado += "</tr>";
        }
        for (; i < inicio + numero_medicamentos; i++)
        {
            resultado += "<tr><td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td>";
            if (trPosologia.Visible)
            {
                resultado += "<td>&nbsp;</td>";
                resultado += "<td>&nbsp;</td>";
            }
            if (trIntensidad.Visible)
            {
                resultado += "<td>&nbsp;</td>";
            }
            resultado += "</tr>";
        }
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());
        evento.Contenido = evento.Contenido.Replace("$szMedicamento$", LMedicamento.Text);
        evento.Contenido = evento.Contenido.Replace("$szPosologia$", LPosologia.Text);
        
        string encabezado = "";
        if (trPosologia.Visible)
        {
            encabezado += "<td align='center'><strong>Tiempo</strong></td>";
            encabezado += "<td align='center'><strong>Vía</strong></td>";
        }
        if (trIntensidad.Visible)
        {
            encabezado += "<td align='center'><strong>Intensidad</strong></td>";
        }
        evento.Contenido = evento.Contenido.Replace("$GFormulacionHeader$", encabezado);

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
        evento.Contenido = evento.Contenido.Replace("$szGrado$", paciente.Grado);
        evento.Contenido = evento.Contenido.Replace("$cCIE10$", paciente.cie10.Count>0 ? Procedimientos.GetCodigoCIE(paciente.cie10[0].ToString()) : "");

        // obtenemos el ID del usuario que lo modifico primero
        string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
        string idmedico = new CConector().QueryString("SELECT usuario.personal FROM modificaciones LEFT JOIN usuario ON (usuario.id=modificaciones.usuario) WHERE modificaciones.id='" + HIdFormulacion.Value + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha LIMIT 1");

        CConectorMS conectorms = new CConectorMS();
        Query query = new Query("admPersonalHS");

        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szMedico"] = "admPersonalHS.perNombre";

        SqlDataReader reader = conectorms.Query(query.GetSelect("perId=" + Query.GetValor(idmedico)));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }

        int numero_medicamentos = 5;
        if (CCDetallePaciente.AsegurdadorID == iddisan)
        { // disan
            numero_medicamentos = 3;
        }

        int paginas = (int)Math.Ceiling((double)GFormulacion.Rows.Count / numero_medicamentos);
        if (DTipo.SelectedValue == idprocedimientos) // procedimientos
        {
            paginas = 0;
            numero_medicamentos = 1;
            for(int i=0; i<GFormulacion.Rows.Count; i++) {
                paginas++;
                if(EsLaboratorio(i)) {
                    i += 4;
                    continue;
                }
            }
            numero_medicamentos = EsLaboratorio(0) ? 5 : 1;
        }

        if(paginas>1) {
            int pos = evento.Contenido.IndexOf("<div");
            int posf = evento.Contenido.IndexOf("</div>");

            string contenidoreal = evento.Contenido.Substring(pos, posf - pos + 6);
            string contenido = "";
            int inicial = numero_medicamentos;
            if (DTipo.SelectedValue == idprocedimientos)
                inicial = EsLaboratorio(0) ? 5 : 1;

            for(int i=1; i<paginas; i++) {

                if (DTipo.SelectedValue == idprocedimientos) // procedimientos
                    numero_medicamentos = EsLaboratorio(i * numero_medicamentos) ? 5 : 1;
                contenido += contenidoreal.Replace("$szFormulacion$", RenderPage(inicial, numero_medicamentos))
                    .Replace("$szConsecutivo$", HIdFormulacion.Value + "-" + (i+1));
                inicial += numero_medicamentos;
            }
            evento.Contenido= evento.Contenido.Insert(posf + 6, contenido);
        }
        if (DTipo.SelectedValue == idprocedimientos) // procedimientos
            numero_medicamentos = EsLaboratorio(0) ? 5 : 1;
        // aqui modificamos la primera pagina.
        evento.Contenido = evento.Contenido.Replace("$szFormulacion$", RenderPage(0, numero_medicamentos))
            .Replace("$szConsecutivo$", HIdFormulacion.Value + "-1");
    }

    protected bool EsLaboratorio(int posicion) {
        try
        {
            int codigo = Convert.ToInt32(GFormulacion.DataKeys[posicion].Values["codigo"]);
            if (codigo > 900000 && codigo < 921100)
            { // es un laboratorio
                return true;
            }
        }
        catch { }
        return false;
    }
    protected void BFormula_Click(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        string id= conector.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' ORDER BY fecha DESC LIMIT 1;");
        if(id.Length!=0) {

            Query medicamento = new Query("medicamento_formulacion");

            medicamento+="medicamento";
            medicamento+="formulada";
            medicamento+="posologia";
            medicamento+="via";
            medicamento+="tiempo";

            MySqlDataReader reader = conector.Query(medicamento.GetSelect("formulacion=" + id));
            if(reader!=null) {
                while(reader.Read()) {
                    
                    TMedicamentoID.Text= reader["medicamento"].ToString();
                    TCantidad.Text = reader["formulada"].ToString();
                    TPosologia.Text = reader["posologia"].ToString();
                    TVia.Text = reader["via"].ToString();
                    TTiempo.Text = reader["tiempo"].ToString();

                    BMasFormulacion_Click(sender, e);
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formulacion.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)) + "&tf=" + ((ImageButton)sender).CommandName);
    }

    protected void TMedicamentoID_TextChanged(object sender, EventArgs e)
    {
        DIntensidad.DataBind();
        RIntensidad.Visible = DIntensidad.Items.Count > 0;
        DIntensidad.Items.Insert(0, new ListItem("(Ninguna)", ""));
        DIntensidad.SelectedIndex = 0;
        if(sender==TMedicamentoID)
            DIntensidad.Focus();
    }
}

