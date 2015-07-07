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
    [Serializable]
    public class Medicamento {

        public int IdGrid { get; set; }
        public string Id { get; set; }
        public string IdMedicamento { get; set; }
        public string Formulada { get; set; }
        public string Posologia { get; set; }
        public string Tiempo { get; set; }
        public string Via { get; set; }
        public string Codigo { get; set; }

        public string Nombre { get; set; }

        public Medicamento(int idgrid) {
            IdGrid = idgrid;
        }

        
    }

    public const string idprocedimientos = "173";
    public const string iddisan = "36";
    public const string idecopetrol = "29";
    public const string idmedicamentosecopetrol = "269";

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

                using (CConector conectormy = new CConector())
                {
                    Query formulacion = new Query("formulacion");

                    formulacion += "paciente";
                    formulacion += "fecha";
                    formulacion += "tipo";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("id=" + Query.GetValor(Request.QueryString["fid"])));
                    if (readermysql != null && readermysql.Read())
                    {
                        Response.Redirect("~/paciente/formulacion.aspx?pid=" + readermysql["paciente"].ToString() + "&f=" + string.Format("{0:d}", Convert.ToDateTime(readermysql["fecha"])) + "&tf=" + readermysql["tipo"].ToString());
                    }
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
                            switch (DTipo.Items[i].Text) { 
                                case "Medicamentos":
                                    if(CCDetallePaciente.AsegurdadorID == iddisan || CCDetallePaciente.AsegurdadorID==idecopetrol) {
                                        DTipo.Items.RemoveAt(i);
                                        i--;
                                    }
                                    break;
                                case "Acuerdo 042 y 046":
                                    // ya no esta visible
                                    DTipo.Items.RemoveAt(i);
                                    i--;
                                    break;
                                case "Acuerdo 052":
                                    if(CCDetallePaciente.AsegurdadorID != iddisan){
                                        DTipo.Items.RemoveAt(i);
                                        i--;
                                    }
                                    break;
                                case "Medicamentos Ecopetrol":
                                    if(CCDetallePaciente.AsegurdadorID != idecopetrol){
                                        DTipo.Items.RemoveAt(i);
                                        i--;
                                    }
                                    break;
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

                    using (CConector conector = new CConector())
                    {
                        TFecha.Text = Request.QueryString["f"];
                        if (TFecha.Text.Length == 0)
                            TFecha.Text = DateTime.Now.ToShortDateString();

                        if (DTipo.Items.FindByValue(Request.QueryString["tf"]) != null)
                            DTipo.SelectedValue = Request.QueryString["tf"];

                        TMedicamentoID.AutoPostBack = DTipo.SelectedValue == idprocedimientos;

                        if (DTipo.SelectedIndex != -1)
                        {
                            string singular = DTipo.SelectedItem.Text.ToLower();
                            if (singular[singular.Length - 1] == 's')
                            {
                                singular = DTipo.SelectedItem.Text.Substring(0, DTipo.SelectedItem.Text.Length - 1);
                            }
                            else singular = DTipo.SelectedItem.Text;
                            GFormulacion.Columns[4].HeaderText = LPosologia.Text = conector.QueryString("SELECT descripcion FROM varios WHERE id=" + DTipo.SelectedValue);
                            if (LPosologia.Text.ToLower() != "posología")
                            {
                                GFormulacion.Columns[5].Visible = false;
                                GFormulacion.Columns[6].Visible = false;
                                trPosologia.Visible = false;
                            }

                            LFormulacion.Text = DTipo.SelectedItem.Text;
                            LMedicamento.Text = singular;
                            GFormulacion.Columns[2].HeaderText = singular;
                        }

                        Query formulacion = new Query("formulacion");

                        formulacion += "id";
                        formulacion += "fecha";
                        formulacion += "codigo";
                        formulacion += "profesional";
                        formulacion += "autorizacion";

                        MySqlDataReader readermysql = conector.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Query.GetMySQLDateFormat(Convert.ToDateTime(TFecha.Text)) + "' AND tipo='" + DTipo.SelectedValue + "'"));
                        if (readermysql != null && readermysql.Read())
                        {
                            string ruta = string.Format("formulacion{0}.html", CCDetallePaciente.AsegurdadorID);
                            ((MasterPageI)Master).Imprimir(File.Exists(Server.MapPath(ruta)) ? ruta : "formulacion.html");

                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasFormulacion.Enabled = usuario.CanInsert();

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

                            List<Medicamento> medicamentos = new List<Medicamento>();

                            Query qmedicamentos = new Query("medicamento_formulacion");

                            qmedicamentos["id"] = "medicamento_formulacion.id";
                            qmedicamentos["idmedicamento"] = "medicamento_formulacion.medicamento";
                            qmedicamentos["formulada"] = "medicamento_formulacion.formulada";
                            qmedicamentos["posologia"] = "medicamento_formulacion.posologia";
                            qmedicamentos["via"] = "medicamento_formulacion.via";
                            qmedicamentos["tiempo"] = "medicamento_formulacion.tiempo";
                            qmedicamentos["codigo"] = "IF(hoja_sola IS NULL, medicamentos.codigo, 'hoja_sola')";

                            readermysql = conector.Query(qmedicamentos.GetSelect("formulacion=" + HIdFormulacion.Value + " ORDER BY medicamentos.hoja_sola IS NULL OR (codigo>900000 AND codigo<921100)"
                                , "LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)"));
                            if (readermysql != null)
                            {
                                while (readermysql.Read())
                                {
                                    Medicamento info = new Medicamento(medicamentos.Count);
                                    info.Id = readermysql["id"].ToString();
                                    info.IdMedicamento = readermysql["idmedicamento"].ToString();
                                    info.Formulada = readermysql["formulada"].ToString();
                                    info.Posologia = readermysql["posologia"].ToString();
                                    info.Nombre = Procedimientos.GetNombreMedicamento(info.IdMedicamento);
                                    info.Via = readermysql["via"].ToString();
                                    info.Tiempo = readermysql["tiempo"].ToString();
                                    info.Codigo = readermysql["codigo"].ToString();
                                    medicamentos.Add(info);
                                }
                            }

                            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
                            GFormulacion.DataSource = medicamentos;
                            GFormulacion.DataBind();

                            ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                        }
                        else
                        {

                            BFormula.Visible = DTipo.SelectedValue != idprocedimientos && conector.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' LIMIT 1;").Length != 0;
                        }

                        BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";

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
                using (CConector conector = new CConector())
                {
                    string cantidad = conector.QueryString(string.Format("SELECT medicamento_formulacion.formulada FROM formulacion"
                        + " LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id)"
                        + " WHERE"
                        + " formulacion.paciente={0}"
                        + " AND medicamento_formulacion.medicamento={2}"
                        + " ORDER BY formulacion.fecha DESC"
                        + " LIMIT 1"
                        , Query.GetValor(CCDetallePaciente.IdPaciente)
                        , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text))
                        , Query.GetValor(TMedicamentoID.Text)
                        ));
                    try
                    {
                        int nCantidad = Convert.ToInt32(cantidad);
                        nCantidad = Convert.ToInt32(nCantidad * 1.1);
                        if (cantidadactual > nCantidad)
                        {  // excede la cantidad anterior
                            LMensajeMedicamento.Text = "Excede la cantidad máxima de sesiones de la orden médica anterior.";
                            TCantidad.Focus();
                            return false;
                        }
                    }
                    catch { }
                }
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
                using (CConector conector = new CConector())
                {
                    string formuladaanterior = conector.QueryString("SELECT SUM(medicamento_formulacion.formulada) FROM formulacion LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id) WHERE formulacion.paciente=" + CCDetallePaciente.AsegurdadorID + " AND medicamento_formulacion.medicamento=" + Query.GetValor(TMedicamentoID.Text) + " AND fecha>DATE_ADD(DATE(SYSDATE()), INTERVAL -30 DAY);");
                    if (formuladaanterior.Length != 0)
                        nuevacantidad += Convert.ToInt32(formuladaanterior);
                    if (maximo < nuevacantidad)
                    {  // excede el maximo permitido
                        LMensajeMedicamento.Text = "Excede la cantidad máxima por servicio mensual permitida (" + maximo.ToString() + ")";
                        TMedicamento.Focus();
                        return false;
                    }
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

        List<Medicamento> medicamentos = Serializar.DesSerializeBinary <List<Medicamento>>(HFormulacion.Value);

        Medicamento info = null;
        if (GFormulacion.SelectedIndex != -1)
        {
            List<Medicamento> resultado = (from t in medicamentos
                                                             where t.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                                             select t).ToList();
            if (resultado.Count != 0)
                info = resultado.First();
        }
        if (info == null) {
            info = new Medicamento(medicamentos.Count);
            medicamentos.Add(info);
        }

        info.IdMedicamento = TMedicamentoID.Text;
        info.Formulada = TCantidad.Text;
        info.Posologia = TPosologia.Text;
        info.Nombre = TMedicamento.Text;
        info.Via = TVia.Text;
        info.Tiempo = TTiempo.Text;

        HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
        GFormulacion.SelectedIndex = -1;
        GFormulacion.DataSource = medicamentos;
        GFormulacion.DataBind();

        BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";

        TMedicamentoID.Text= TCantidad.Text= TPosologia.Text = TMedicamento.Text = TVia.Text = TTiempo.Text= "";

        CCDetallePaciente.GetCostoPacienteActual = 0;
        CCDetallePaciente.GetCostoAseguradoraActual = 0;
        TMedicamento.Focus();

        // verificamos que no se halla formulado el mes anterior
        /*if (!CUsuario.GetUsuario().CanAdmin() && CCDetallePaciente.AsegurdadorID == iddisan && DTipo.SelectedValue != idprocedimientos)
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
                , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text))
                , Query.GetValor(TMedicamentoID.Text)
                ));
            if (ultimareceta.Length > 0)
            {
                LMensajeMedicamento.Text = "Este medicamento fue recetado el " + CConector.GetDateFormat(ultimareceta);
                TMedicamento.Focus();
                return false;
            }
        }*/
        return true;
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        } catch { }
        AddMedicamento();
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text + "&tf=" + DTipo.SelectedValue);
    }

    public bool UpdateFormulacion(Conector conector, string formulacion = null)
    {
        if (!string.IsNullOrEmpty(formulacion))
            formulacion = "WHERE formulacion=" + Query.GetValor(formulacion);
        conector.QueryMod("SET @c:=0,@i=0;");
        return conector.QueryMod("UPDATE medicamento_formulacion SET numero=IF(@i=formulacion, 1, CONCAT(@i:=formulacion, @c:=0)),numero=@c:=@c+1 " + formulacion + " ORDER BY formulacion,id;") != -1;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        } catch {}


        CUsuario usuario= (CUsuario) CUsuario.GetInstance();
        Query formulacion = new Query("formulacion");
        // Query query = new Query("autorizacion");

        if (!usuario.CanDelete() && GFormulacion.Rows.Count == 0) {

            LMensajeMedicamento.Text = "Por favor ingrese por lo menos un medicamento.";
            return;
        }

        string szQuery;
        string mensaje;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            DateTime fecha = Convert.ToDateTime(TFecha.Text);

            formulacion["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            formulacion["tipo"] = DTipo.SelectedValue;
            formulacion["profesional"] = usuario["personal"];
            formulacion["asegurador"] = CCDetallePaciente.AsegurdadorID;

            /*query["autFecha"] = fecha.ToShortDateString();
            query["autFechaVenc"] = fecha.AddDays(30).ToShortDateString();*/

            if (HIdFormulacion.Value.Length == 0)
            {
                formulacion["paciente"] = CCDetallePaciente.IdPaciente;
                /*if (DTipo.SelectedValue == idprocedimientos)
                { // agregamos la autorizacion

                    string autorizacion= conector.QueryString(
                    String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(IFNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                            + " FROM autorizacion"
                            + " WHERE autNumero LIKE 'AD{0}%'", fecha.ToString("yyMMdd")));

                    query["autNumero"] = autorizacion;
                    query["pacId"] = CCDetallePaciente.IdPaciente;
                    query["entId"] = CCDetallePaciente.AsegurdadorID;
                    query["autActivo"] = "0";
                    query["autProvisional"] = "1";
                    query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
                    query["segFechaIngreso"] = "SYSDATE()";

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;

                    formulacion["autorizacion"] = autorizacion;
                    ViewState["autorizacion"] = autorizacion;
                }*/

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
                /*if (!string.IsNullOrEmpty((string)ViewState["autorizacion"]))
                {
                    if (conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString()))) == -1)
                        return;
                }*/
            }
            if (conector.InsertModificacion(HIdFormulacion.Value) == -1)
                return;
            if (!string.IsNullOrEmpty((string)ViewState["autorizacion"]))
            {
                /*if (new CConector().InsertModificacion(ViewState["autorizacion"].ToString(), null, "~/admisiones/autorizaciones.aspx") == -1)
                    return;*/
            }

            Query medicamento = new Query("medicamento_formulacion");

            List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
            for (int i = 0; i < medicamentos.Count; i++) {
                

                Medicamento info = medicamentos[i];

                medicamento["medicamento"] = info.IdMedicamento;
                medicamento["formulada"] = info.Formulada;
                medicamento["posologia"] = info.Posologia;
                medicamento["via"] = info.Via;
                medicamento["tiempo"] = info.Tiempo;
                medicamento["costo"] = Procedimientos.GetCosto(info.IdMedicamento, CCDetallePaciente.AsegurdadorID).ToString(CultureInfo.InvariantCulture);

                if (string.IsNullOrEmpty(info.Id))
                {
                    medicamento["formulacion"] = HIdFormulacion.Value;
                    if (conector.QueryMod(medicamento.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(medicamento.GetUpdate("id=" + info.Id)) == -1)
                        return;
                }
            }

            UpdateFormulacion(conector, HIdFormulacion.Value);
            /*if (!string.IsNullOrEmpty((string)ViewState["autorizacion"]))
            {
                if (conector.QueryMod("DELETE FROM autorizacion_detalle WHERE autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString())) == -1)
                    return;

                Query detalle = new Query("autorizacion_detalle");

                detalle["autNumero"] = ViewState["autorizacion"].ToString();

                MySqlDataReader reader = conector.Query("SELECT medicamento,formulada,intensidad FROM medicamento_formulacion WHERE formulacion=" + Query.GetValor(HIdFormulacion.Value));
                if (reader != null)
                {
                    while (reader.Read())
                    {

                        detalle["actId"] = reader["medicamento"].ToString();
                        detalle["autNumSesiones"] = reader["formulada"].ToString();
                        detalle["intensidad"] = reader["intensidad"].ToString();

                        if (conector.QueryMod(detalle.GetInsert()) == -1)
                            return;
                    }
                }

                query = new Query("autorizacion");

                query["formulacion"] = HIdFormulacion.Value;
                // query["autObservaciones"] = conector.QueryString("SELECT GROUP_CONCAT(CONCAT(nombre,': ',posologia) SEPARATOR '\n') FROM medicamento_formulacion LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento) WHERE formulacion=" + Query.GetValor(HIdFormulacion.Value) + " AND posologia IS NOT NULL");

                if (conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(ViewState["autorizacion"].ToString()))) == -1)
                    return;

                HAutorizacion.Text = "Autorización " + ViewState["autorizacion"].ToString();
                HAutorizacion.NavigateUrl = "~/admisiones/autorizaciones.aspx?aut=" + ViewState["autorizacion"].ToString();
            }*/

            conector.Commit();
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from info in medicamentos
                                      where info.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                      select info).ToList();

        if (resultado.Count != 0) {
            
            Medicamento info= resultado.First();

            TMedicamentoID.Text = info.IdMedicamento;
            TMedicamento.Text = info.Nombre;
            TCantidad.Text = info.Formulada;
            TPosologia.Text = info.Posologia;
            TTiempo.Text = info.Tiempo;
            TVia.Text = info.Via;
        }
    }

    protected string RenderPage(int inicio, int numero_medicamentos)
    {
        string resultado="";
        // GFormulacion.DataBind();
        int i = inicio;

        for (; i < GFormulacion.Rows.Count && i < inicio + numero_medicamentos; i++)
        {
            resultado += "<tr><td>" + GFormulacion.Rows[i].Cells[2].Text + "</td>";
            resultado += "<td>" + NumerosALetras.ToLetras(Convert.ToInt32(GFormulacion.Rows[i].Cells[3].Text)).ToUpper() + " (" + GFormulacion.Rows[i].Cells[3].Text + ")</td>";
            resultado += "<td>" + GFormulacion.Rows[i].Cells[4].Text + "</td>";
            if(trPosologia.Visible) {
                resultado += "<td>" + GFormulacion.Rows[i].Cells[5].Text + "</td>";
                resultado += "<td>" + GFormulacion.Rows[i].Cells[6].Text + "</td>";
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
        
        evento.Contenido = evento.Contenido.Replace("$GFormulacionHeader$", encabezado);

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
        evento.Contenido = evento.Contenido.Replace("$szGrado$", paciente.Grado);
        evento.Contenido = evento.Contenido.Replace("$cCIE10$", paciente.cie10.Count>0 ? Procedimientos.GetCodigoCIE(paciente.cie10[0].ToString()) : "");

        // obtenemos el ID del usuario que lo modifico primero
        string idmedico = "";
        string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
        using (CConector conector = new CConector())
        {
            idmedico = conector.QueryString("SELECT usuario.personal FROM modificaciones LEFT JOIN usuario ON (usuario.id=modificaciones.usuario) WHERE modificaciones.id='" + HIdFormulacion.Value + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha LIMIT 1");

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szMedico"] = "recurso_humano.perNombre";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(idmedico)));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
        }

        using (CConector conector = new CConector())
        {
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(idmedico)));
        }

        int total_medicamentos = 5;
        int numero_medicamentos = 5;

        if (CCDetallePaciente.AsegurdadorID == iddisan)
        { // disan
            total_medicamentos = numero_medicamentos = 3;
        }

        int paginas = (int)Math.Ceiling((double)GFormulacion.Rows.Count / numero_medicamentos);
        if (DTipo.SelectedValue == idprocedimientos) // procedimientos
        {
            paginas = 0;
            numero_medicamentos = 1;
            for (int i = 0; i < GFormulacion.Rows.Count; i++)
            {
                paginas++;
                if (EsLaboratorio(i))
                {
                    i += total_medicamentos - 1;
                    continue;
                }
            }
            numero_medicamentos = EsLaboratorio(0) ? total_medicamentos : 1;
        } else { // para el resto
            paginas = 0;
            numero_medicamentos = 1;
            for (int i = 0; i < GFormulacion.Rows.Count; i++)
            {
                paginas++;
                if (!UnaSolaHoja(i))
                {
                    i += total_medicamentos - 1;
                    continue;
                }
            }
            numero_medicamentos = UnaSolaHoja(0) ? 1 : total_medicamentos;
        }

        if(paginas>1) {
            int pos = evento.Contenido.IndexOf("<div");
            int posf = evento.Contenido.IndexOf("</div>");

            string contenidoreal = evento.Contenido.Substring(pos, posf - pos + 6);
            string contenido = "";
            int inicial = numero_medicamentos;
            if (DTipo.SelectedValue == idprocedimientos)
                inicial = EsLaboratorio(0) ? total_medicamentos : 1;

            for(int i=1; i<paginas; i++) {

                if (DTipo.SelectedValue == idprocedimientos) // procedimientos
                    numero_medicamentos = EsLaboratorio(i * numero_medicamentos) ? total_medicamentos : 1;
                else numero_medicamentos = UnaSolaHoja(i * numero_medicamentos) ? 1 : total_medicamentos;

                contenido += contenidoreal.Replace("$szFormulacion$", RenderPage(inicial, numero_medicamentos))
                    .Replace("$szConsecutivo$", HIdFormulacion.Value + "-" + (i+1));
                inicial += numero_medicamentos;
            }
            evento.Contenido= evento.Contenido.Insert(posf + 6, contenido);
        }
        if (DTipo.SelectedValue == idprocedimientos) // procedimientos
            numero_medicamentos = EsLaboratorio(0) ? total_medicamentos : 1;
        else numero_medicamentos = UnaSolaHoja(0) ? 1 : total_medicamentos;
        // aqui modificamos la primera pagina.
        evento.Contenido = evento.Contenido.Replace("$szFormulacion$", RenderPage(0, numero_medicamentos))
            .Replace("$szConsecutivo$", HIdFormulacion.Value + "-1");
    }

    protected bool UnaSolaHoja(int posicion) {
        try
        {
            List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
            List<Medicamento> resultado = (from t in medicamentos
                                           where t.IdGrid.ToString() == GFormulacion.DataKeys[posicion].Value.ToString()
                                           select t).ToList();
            Medicamento info = resultado.First();

            return info.Codigo == "hoja_sola";
        }
        catch { }
        return false;
    }

    protected bool EsLaboratorio(int posicion) {
        try
        {
            List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
            List<Medicamento> resultado = (from t in medicamentos
                                           where t.IdGrid.ToString() == GFormulacion.DataKeys[posicion].Value.ToString()
                                           select t).ToList();
            Medicamento info = resultado.First();

            int codigo = Convert.ToInt32(info.Codigo);
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
        using (CConector conector = new CConector())
        {
            string id = conector.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' ORDER BY fecha DESC LIMIT 1;");
            if (id.Length != 0)
            {
                Query medicamento = new Query("medicamento_formulacion");

                medicamento += "medicamento";
                medicamento += "formulada";
                medicamento += "posologia";
                medicamento += "via";
                medicamento += "tiempo";

                MySqlDataReader reader = conector.Query(medicamento.GetSelect("formulacion=" + id));
                if (reader != null)
                {
                    while (reader.Read())
                    {

                        TMedicamentoID.Text = reader["medicamento"].ToString();
                        TMedicamento.Text = Procedimientos.GetNombreMedicamento(TMedicamentoID.Text);
                        TCantidad.Text = reader["formulada"].ToString();
                        TPosologia.Text = reader["posologia"].ToString();
                        TVia.Text = reader["via"].ToString();
                        TTiempo.Text = reader["tiempo"].ToString();

                        BMasFormulacion_Click(sender, e);
                    }
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formulacion.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)) + "&tf=" + ((ImageButton)sender).CommandName);
    }

    protected void GFormulacion_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from t in medicamentos
                                                         where t.IdGrid.ToString() == GFormulacion.DataKeys[e.RowIndex].Value.ToString()
                                                         select t).ToList();
        if (resultado.Count != 0) {

            Medicamento info = resultado.First();
            if (!string.IsNullOrEmpty(info.Id)) {
                using (CConector conector = new CConector()) {
                    if (conector.QueryMod("DELETE FROM medicamento_formulacion WHERE id=" + Query.GetValor(info.Id)) == -1) {
                        LMensajeMedicamento.Text = conector.LastError;
                        return;
                    }
                }
            }
            
            medicamentos.Remove(info);
            for (int i = 0; i < medicamentos.Count; i++)
                medicamentos[i].IdGrid = i;

            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
            GFormulacion.SelectedIndex = -1;
            GFormulacion.DataSource = medicamentos;
            GFormulacion.DataBind();

            BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";
        }
    }
}

