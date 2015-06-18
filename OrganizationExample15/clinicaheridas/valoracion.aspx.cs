using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Globalization;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.UI.HtmlControls;

public partial class clinicaheridas_valoracion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            UCFuncionario.ReadOnly = !usuario.CanAdmin();
            BAceptar.Enabled = false;

            if (!string.IsNullOrEmpty(Request.QueryString["hveid"]))
            {
                using (CConector conector = new CConector())
                    Response.Redirect(string.Format("~/clinicaheridas/valoracion.aspx?pid={0}"
                        , conector.QueryString("SELECT paciente FROM valoracion_herida WHERE id=" + Query.GetValor(Request.QueryString["hveid"]))
                        ));
            }

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    UCFuncionario.IdFuncionario = usuario["personal"];

                    BAceptar.Enabled = usuario.CanInsert();
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
                    PDatos.Visible = true;

                    using (CConector conector = new CConector()) {

                        Query query = new Query("valoracion_herida");

                        query += "id";
                        query += "paciente";
                        query += "fecha";
                        query += "ta";
                        query += "fc";
                        query += "fr";
                        query += "t";
                        query += "pulsosdistales";
                        query += "ostomias";
                        query += "ubicacion";
                        query += "color";
                        query += "estoma";
                        query += "complicaciones";
                        query += "estado_piel";
                        query += "tipo_dispositivo";
                        query += "funcional";
                        query += "funcional_descripcion";
                        query += "dolor";
                        query += "tiempo_evolucion_ulcera";
                        query += "lugar_origen_ulcera";
                        query += "tejido_profundo";
                        query += "manejo";
                        query += "costomias";
                        query += "cdispositivos_medicos";
                        query += "hogar_geriatrico";
                        query += "consentimiento";
                        query += "periodicidad";
                        query += "fistula";
                        query += "localizacion_fistula";
                        query += "signos_infeccion";
                        query += "cantidad_afluente";
                        query += "observacion_pulso";
                        query += "funcionario";

                        MySqlDataReader reader= conector.Query(query.GetSelect("paciente=" + Query.GetValor(Request.QueryString["pid"])));
                        if (reader != null && reader.Read()) {

                            BAceptar.Enabled = usuario.CanUpdate();
                            ((MasterPageI)Master).Imprimir("valoracion.html");

                            ViewState["id"] =
                                SRiesgos.SelectParameters["valoracion"].DefaultValue =
                                SAntecendentes.SelectParameters["valoracion"].DefaultValue =
                                SEducativo.SelectParameters["valoracion"].DefaultValue =
                                reader["id"].ToString();

                            TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                            UCFuncionario.IdFuncionario = reader["funcionario"].ToString();
                            TTA.Text = reader["ta"].ToString();
                            TFC.Text = reader["fc"].ToString();
                            TFR.Text = reader["fr"].ToString();
                            TT.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["t"]);
                            try { RPDistales.DataBind(); RPDistales.SelectedValue = reader["pulsosdistales"].ToString(); } catch { }
                            try { RTipo.DataBind(); RTipo.SelectedValue = reader["ostomias"].ToString(); } catch { }
                            TUbicacion.Text = reader["ubicacion"].ToString();
                            Utilidades.SelectInDropDown(DColor, reader["color"]);
                            Utilidades.SelectInDropDown(DEstoma, reader["estoma"]);
                            Utilidades.SelectInDropDown(DComplicacion, reader["complicaciones"]);
                            Utilidades.SelectInDropDown(DEstadoPiel, reader["estado_piel"]);
                            Utilidades.SelectInDropDown(DTipoDispositivo, reader["tipo_dispositivo"]);
                            Utilidades.SelectInDropDown(DFuncional, reader["funcional"]);
                            CFuncional.Checked = DFuncional.SelectedValue == "";
                            TFuncionalDescripcion.Text = reader["funcional_descripcion"].ToString();
                            Utilidades.SelectInDropDown(DEscalaDolor, reader["dolor"]);                            
                            TTiempoEvolucion.Text = reader["tiempo_evolucion_ulcera"].ToString();
                            Utilidades.SelectInDropDown(DLugarOrigen, reader["lugar_origen_ulcera"]);
                            Utilidades.SelectInDropDown(DTejidoSospechoso, reader["tejido_profundo"]);
                            LTipo.Text = DEtiologia.SelectedItem.Text;
                            LClasificacion.Text = "";// DDefina.SelectedItem.Text;
                            COstomias.Checked = reader["costomias"].ToString() == "1";
                            CDispositivosMedicos.Checked = reader["cdispositivos_medicos"].ToString() == "1";
                            THogarGeriatrico.Text = reader["hogar_geriatrico"].ToString();
                            CConsentimiento.Checked = reader["consentimiento"].ToString() == "1";
                            TPeriodicidad.Text = reader["periodicidad"].ToString();
                            CFistulas.Checked= reader["fistula"].ToString()=="1";
                            TLocalizacionFistula.Text = reader["localizacion_fistula"].ToString();
                            CSignosInfeccion.Checked= reader["signos_infeccion"].ToString()=="1";
                            TCAfluente.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["cantidad_afluente"]);
                            TObservacionPulso.Text = reader["observacion_pulso"].ToString();
                            
                            TPlanManejo.Text = reader["manejo"].ToString();

                            if (TPlanManejo.Text.Length == 0)
                            {
                                string procedimientos = Procedimientos.GetPlanDeManejo(conector, CCDetallePaciente.IdPaciente, TFecha.Text);
                                if (procedimientos.Length > 0)
                                {
                                    ViewState["procedimientos"] = procedimientos;
                                    TPlanManejo.Text = procedimientos;
                                }
                            }

                            query = new Query("valoracion_herida_herida");

                            query+="id";
                            query += "localizacion";
                            query += "localizacion2";
                            query += "localizacion3";
                            query += "mi";
                            query += "pies";
                            query += "ubicacion_especifica";
                            query += "etiologia";
                            query += "etiologia_otro";
                            query += "clasificacion";
                            query += "factores_riesgo";
                            query += "longitud";
                            query += "anchura";
                            query += "profundidad";
                            query += "tunelizacion";
                            query += "cavidad";
                            query += "bolsillo_tamano";
                            query += "bolsillo_ubicacion";
                            query += "tipo_tejido";
                            query += "compacto";
                            query += "fibrina";
                            query += "epitelizacion";
                            query += "escara";
                            query += "granulacion";
                            query += "hipergranulacion";
                            query += "limpio";
                            query += "necrosis";
                            query += "seleccion_tejido";
                            query += "exudado";
                            query += "tipo_exudado";
                            query += "piel_circundante";
                            query += "bordes_herida";
                            query += "olor";
                            query += "olor_descripcion";
                            query += "signos_sintomas";
                            query += "exudado_complicacion";
                            query += "exudado_definicion";

                            List<Heridas> heridas = new List<Heridas>();

                            reader= conector.Query(query.GetSelect("valoracion=" + Query.GetValor(ViewState["id"].ToString())));
                            if (reader != null) {
                                while (reader.Read()) {
                                    Heridas info = new Heridas(reader["id"].ToString(),reader["ubicacion_especifica"].ToString(), reader["id"].ToString());
                                    for (int i = 0; i < reader.FieldCount; i++) {
                                        if(reader[i]!= DBNull.Value && reader[i] is float)
                                            info.query[reader.GetName(i)] = ((float)reader[i]).ToString(CultureInfo.InvariantCulture);
                                        else info.query[reader.GetName(i)] = reader[i].ToString();
                                    }
                                    Utilidades.SelectInDropDown(DDefina, reader["exudado_definicion"]);
                                    LClasificacion.Text = DDefina.SelectedItem.Text;
                                    info.query.RemoveCampo("id");
                                    heridas.Add(info);
                                }
                            }
                            ViewState["querys"] = GHeridas.DataSource = heridas;
                            GHeridas.DataBind();

                            ((MasterPageI)Master).SetModificacion(ViewState["id"].ToString());
                        }
                        TPlanManejo.ReadOnly = !usuario.CanAdmin();
                    }
                    RebuildGalery();
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        BAgregar_Click(sender, e);

        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        if ((consultas == null || consultas.Count == 0) && string.IsNullOrEmpty((string)ViewState["id"]))
        {
            LMensaje.Text = "Por favor ingrese por lo menos una herida";
            TUbicacionEspecifica.Focus();
            return;
        }
        if (consultas == null)
            consultas = new List<Heridas>();

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id= (string)ViewState["id"];
            Query query = new Query("valoracion_herida");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["ta"] = TTA.Text;
            query["fc"] = TFC.Text.Replace(" Lat/min", "");
            query["fr"] = TFR.Text.Replace(" Min", "");
            query["t"] = TT.Text.Replace(" °", "");
            query["pulsosdistales"] = RPDistales.SelectedValue;
            query["ostomias"] = RTipo.SelectedValue;
            query["ubicacion"] = TUbicacion.Text;
            query["color"] = DColor.SelectedValue;
            query["estoma"] = DEstoma.SelectedValue;
            query["complicaciones"] = DComplicacion.SelectedValue;
            query["estado_piel"] = DEstadoPiel.SelectedValue;
            query["tipo_dispositivo"] = DTipoDispositivo.SelectedValue;
            query["funcional"] = CFuncional.Checked ? "" : DFuncional.SelectedValue;
            query["funcional_descripcion"] = TFuncionalDescripcion.Text;
            query["dolor"] = DEscalaDolor.SelectedValue;
            query["tiempo_evolucion_ulcera"] = TTiempoEvolucion.Text;
            query["lugar_origen_ulcera"] = DLugarOrigen.SelectedValue;
            query["tejido_profundo"] = DTejidoSospechoso.SelectedValue;
            query["costomias"] = COstomias.Checked ? "1" : "";
            query["cdispositivos_medicos"] = CDispositivosMedicos.Checked ? "1" : "";
            query["hogar_geriatrico"] = THogarGeriatrico.Text;
            query["consentimiento"] = CConsentimiento.Checked ? "1" : "";
            query["periodicidad"] = TPeriodicidad.Text;
            query["fistula"] = CFistulas.Checked ? "1" : "";
            query["localizacion_fistula"] = TLocalizacionFistula.Text;
            query["signos_infeccion"] = CSignosInfeccion.Checked ? "1" : "";
            query["cantidad_afluente"] = TCAfluente.Text.Replace(" cm", "");
            query["observacion_pulso"] = TObservacionPulso.Text;
            query["manejo"] =
                (string.IsNullOrEmpty((string)ViewState["procedimientos"]) || TPlanManejo.Text != ViewState["procedimientos"].ToString())
                ? TPlanManejo.Text
                : "";

            if(string.IsNullOrEmpty(id)) {

                query["paciente"] = CCDetallePaciente.IdPaciente;
                query["asegurador"] = CCDetallePaciente.AsegurdadorID;

                int res= conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            for (int i = 0; i < consultas.Count; i++) {
                if (consultas[i].eliminado) // eliminamos los que no necesitamos, // falta eliminar las fotos
                {
                    if (!string.IsNullOrEmpty(consultas[i].IdTabla)) {
                        if(conector.QueryMod(consultas[i].query.GetDelete("id=" + Query.GetValor(consultas[i].Id)))==-1) {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(consultas[i].IdTabla))
                    {
                        consultas[i].query["valoracion"] = id;
                        int res= conector.QueryMod(consultas[i].query.GetInsert(), true);
                        if ( res== -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                        consultas[i].IdTemp= res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(consultas[i].query.GetUpdate("id=" + Query.GetValor(consultas[i].IdTabla))) == -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                    }
                }
            }

            Query educativo = new Query("valoracion_herida_educativo");
            if (conector.QueryMod(educativo.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            educativo["valoracion"] = id;

            for (int i = 0; i < GEducativo.Rows.Count; i++)
            {
                CheckBox check= (CheckBox)GEducativo.Rows[i].FindControl("CSi");
                if (check.Checked)
                {
                    educativo["concepto"] = GEducativo.DataKeys[i].Value.ToString();
                    educativo["valor"] = "1";

                    if (conector.QueryMod(educativo.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
            }

            Query antecendentes = new Query("valoracion_herida_antecedentes");
            if (conector.QueryMod(antecendentes.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            antecendentes["valoracion"] = id;

            for (int i = 0; i < GAntecedentes.Rows.Count; i++)
            {
                antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values["id"].ToString();
                antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;

                if (conector.QueryMod(antecendentes.GetInsert()) == -1) {

                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            Query riesgos = new Query("valoracion_herida_riesgos");
            if (conector.QueryMod(riesgos.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            riesgos["valoracion"] = id;

            for (int i = 0; i < GRiesgos.Rows.Count; i++)
            {                
                riesgos["estado"] = ((CheckBox)GRiesgos.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                riesgos["observaciones"] = ((TextBox)GRiesgos.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                riesgos["motivo"] = GRiesgos.DataKeys[i].Values["id"].ToString();

                if (conector.QueryMod(riesgos.GetInsert()) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1) {
                LMensaje.Text = conector.LastError;
                return;
            }
            
            if (string.IsNullOrEmpty((string)ViewState["id"]))
                Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(TFecha.Text, true)), conector);

            conector.Commit();


            // ahora guardamos las fotos
            for (int i = 0; i < consultas.Count; i++) {

                try
                {
                    foreach (string archivo in Directory.GetFiles(GetTemporalPath(consultas[i].Id, false)))
                    {
                        string rutafinal = GetFinalPath(id, string.IsNullOrEmpty(consultas[i].IdTabla) ? consultas[i].IdTemp : consultas[i].IdTabla, true);
                        if (consultas[i].eliminado)
                            File.Delete(archivo);
                        else File.Move(archivo, Path.Combine(rutafinal, Path.GetFileName(archivo)));
                    }
                } catch {}
                CleanTemporalPath(consultas[i].Id);
                try
                {
                    if (consultas[i].eliminado)
                    {
                        string rutafinal = GetFinalPath(id, string.IsNullOrEmpty(consultas[i].IdTabla) ? consultas[i].IdTemp : consultas[i].IdTabla, false);
                        foreach (string archivo in Directory.GetFiles(rutafinal))
                            File.Delete(archivo);
                        Directory.Delete(rutafinal);
                    }
                } catch { }
            }
            CleanTemporalPath(GetHeridaID());

            
            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado( CCDetallePaciente.Nombres + " Editado.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public string GetHeridaID() { 
        string id = (string)ViewState["idherida"];
        if (string.IsNullOrEmpty(id)) {
            List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
            if (consultas == null)
                id = "-1";
            else id = ((consultas.Count+1)*-1).ToString();
        }
        return id;
    }

    public List<Heridas.Fotos> RebuildGalery()
    {
        List<Heridas.Fotos> fotos = new List<Heridas.Fotos>();
        string id= GetHeridaID();
        try
        {
            foreach (string archivo in Directory.GetFiles(GetTemporalPath(id, false)))
            {
                Heridas.Fotos info = new Heridas.Fotos();
                info.Archivo = Path.GetFileName(archivo);
                info.Temporal = true;
                info.Id = id;
                fotos.Add(info);
            }
        } catch { }
        try
        {
            foreach (string archivo in Directory.GetFiles(GetFinalPath((string)ViewState["id"], id, false)))
            {
                Heridas.Fotos info = new Heridas.Fotos();
                info.Archivo = Path.GetFileName(archivo);
                info.Temporal = false;
                info.Id = id;
                fotos.Add(info);
            }
        } catch {}

        DFotos.DataSource = fotos;
        DFotos.DataBind();
        return fotos;
    }

    public void CleanTemporalPath(string id) {

        List<string> archivos = new List<string>();
        archivos.Add("temp");
        archivos.Add(CCDetallePaciente.IdPaciente);
        archivos.Add(id);

        for (int j = 0; j < archivos.Count; j++)
        {
            string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "valoracion");
            for (int i = 0; i < archivos.Count-j; i++)
            {
                archivo = Path.Combine(archivo, archivos[i]);
            }
            try
            {
                Directory.Delete(archivo);
            } catch { }
        }
    }

    public string GetTemporalPath(string id, bool create) {

        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "valoracion");
        if(create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, "temp");
        if (create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, CCDetallePaciente.IdPaciente);
        if (create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, id);
        if (create)
            Directory.CreateDirectory(archivo);

        return archivo;
    }

    public string GetFinalPath(string id, string idHerida, bool create)
    {
        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "valoracion");

        if (string.IsNullOrEmpty(id))
        {
            archivo = Path.Combine(Path.GetTempPath(), "evolucion");
            if(create)
                Directory.CreateDirectory(archivo);
        }
        else
        {
            if (create)
                Directory.CreateDirectory(archivo);
            archivo = Path.Combine(archivo, id);
            if (create)
                Directory.CreateDirectory(archivo);
            archivo = Path.Combine(archivo, idHerida);
            if (create)
                Directory.CreateDirectory(archivo);
        }
        return archivo;
    }

    protected void BSubir_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        if (!FFoto.HasFile) 
            return;

        string archivo = Path.Combine(GetTemporalPath(GetHeridaID(), true), FFoto.FileName);
        FFoto.SaveAs(archivo);

        RebuildGalery();

        ScriptManager.RegisterStartupScript(FFoto, typeof(string), "registro", "$('html, body').animate({scrollTop: $('#registrofotografico').offset().top}, 0);", true);
    }

    protected void DFotos_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        string archivo = DFotos.DataKeys[e.Item.ItemIndex].ToString();
        try { File.Delete(Path.Combine(GetTemporalPath(GetHeridaID(), false), archivo)); } catch {}
        try { File.Delete(Path.Combine(GetFinalPath((string)ViewState["id"], GetHeridaID(), false), archivo)); } catch { }
        CleanTemporalPath(GetHeridaID());
        RebuildGalery();
    }
    
    protected void BAgregar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        if (TUbicacionEspecifica.Text.Length == 0)
            return;
        
        LMensajeHerida.Text = "";

        int total = 0;
        try { total += Convert.ToInt32(TCompacto.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TDeFibrina.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TEpitelizacion.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TEscara.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TGranulacion.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(THiperGranulacion.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TLimpio.Text.Replace(" %", "")); } catch { }
        try { total += Convert.ToInt32(TNecrosis.Text.Replace(" %", "")); } catch { }

        if (total > 100)
        {
            TCompacto.Focus();
            LMensajeHerida.Text = "La suma de los porcentajes no puede exceder el 100%";
            return;
        }

        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        if (consultas == null)
            consultas = new List<Heridas>();

        Heridas info = null;

        string id=(string)ViewState["idherida"];
        if (!string.IsNullOrEmpty(id)) {
            for (int i = 0; i < consultas.Count; i++) {
                if (consultas[i].Id == id) {
                    info = consultas[i];
                    info.Nombre = TUbicacionEspecifica.Text;
                    break;
                }
            }
        }
        if (info == null) {
            info= new Heridas(((consultas.Count+1)*-1).ToString(), TUbicacionEspecifica.Text);
            consultas.Add(info);
        }

        info.query["localizacion"] = DLocalizacion.SelectedValue;
        info.query["localizacion2"] = RLocalizacion2.SelectedValue;
        info.query["localizacion3"] = RLocalizacion3.SelectedValue;
        info.query["mi"] = RMI.SelectedValue;
        info.query["pies"] = RPies.SelectedValue;
        info.query["ubicacion_especifica"] = TUbicacionEspecifica.Text;
        info.query["etiologia"] = DEtiologia.SelectedValue;
        info.query["etiologia_otro"] = TOtroEtiologia.Text;
        info.query["clasificacion"] = DClasificacion.SelectedValue;
        info.query["factores_riesgo"] = TFactoresRiesgo.Text;
        info.query["longitud"] = TLongitud.Text.Replace(" cm", "");
        info.query["anchura"] = TAnchura.Text.Replace(" cm", "");
        info.query["profundidad"] = TProfunidad.Text.Replace(" cm", "");
        info.query["tunelizacion"] = CTunelizacion.Checked ? TTunelizacion.Text.Replace(" cm", "") : "";
        info.query["cavidad"] = TCavidad.Text.Replace(" cm", "");
        info.query["bolsillo_tamano"] = CBolsillo.Checked ? TBolsilloProfundidad.Text.Replace(" cm", "") : "";
        info.query["bolsillo_ubicacion"] = CBolsillo.Checked ? TBolsilloUbicacion.Text : "";
        info.query["tipo_tejido"] = RTipoTejido.SelectedValue;
        info.query["compacto"] = TCompacto.Text.Replace(" %", "");
        info.query["fibrina"] = TDeFibrina.Text.Replace(" %", "");
        info.query["epitelizacion"] = TEpitelizacion.Text.Replace(" %", "");
        info.query["escara"] = TEscara.Text.Replace(" %", "");
        info.query["granulacion"] = TGranulacion.Text.Replace(" %", "");
        info.query["hipergranulacion"] = THiperGranulacion.Text.Replace(" %", "");
        info.query["limpio"] = TLimpio.Text.Replace(" %", "");
        info.query["necrosis"] = TNecrosis.Text.Replace(" %", "");
        info.query["seleccion_tejido"] = DSeleccione.SelectedValue;
        info.query["exudado"] = DExudado.SelectedValue;
        info.query["tipo_exudado"] = DTipoExudado.SelectedValue;
        info.query["piel_circundante"] = DPielCircundante.SelectedValue;
        info.query["bordes_herida"] = DBordesHerida.SelectedValue;
        info.query["olor"] = DOlor.SelectedValue;
        info.query["olor_descripcion"] = TOlorDescripcion.Text;
        info.query["signos_sintomas"] = DSignosSintomas.SelectedValue;
        info.query["exudado_complicacion"] = CComplicaciones.Checked ? TComplicaciones.Text : "";
        info.query["exudado_definicion"] = DDefina.SelectedValue;

        ViewState["querys"] = GHeridas.DataSource = consultas;
        GHeridas.DataBind();
        BCancelarHerida_Click(sender, e);
    }

    protected void BCancelarHerida_Click(object sender, EventArgs e)
    {
        LMensajeHerida.Text = "";

        RLocalizacion2.SelectedIndex=
            RLocalizacion3.SelectedIndex= 
            RMI.SelectedIndex=
            RPies.SelectedIndex=
            DEtiologia.SelectedIndex=
            DClasificacion.SelectedIndex =
            RTipoTejido.SelectedIndex =
            DSeleccione.SelectedIndex=
            DExudado.SelectedIndex =
            DTipoExudado.SelectedIndex =
            DPielCircundante.SelectedIndex =
            DBordesHerida.SelectedIndex =
            DOlor.SelectedIndex =
            DSignosSintomas.SelectedIndex =
            DDefina.SelectedIndex=
            DLocalizacion.SelectedIndex = 0;
        
        TFactoresRiesgo.Text=
            TLongitud.Text=
            TAnchura.Text =
            TProfunidad.Text =
            TTunelizacion.Text =
            TCavidad.Text =
            TBolsilloProfundidad.Text =
            TBolsilloUbicacion.Text =
            TCompacto.Text =
            TDeFibrina.Text =
            TEpitelizacion.Text =
            TEscara.Text =
            TGranulacion.Text =
            THiperGranulacion.Text =
            TLimpio.Text =
            TNecrosis.Text =
            TOlorDescripcion.Text=
            TComplicaciones.Text=
            TOtroEtiologia.Text=
        TUbicacionEspecifica.Text= "";

        CBolsillo.Checked=
            CComplicaciones.Checked=
        CTunelizacion.Checked = false;

        GHeridas.SelectedIndex = -1;
        ViewState["idherida"] = null;
        RebuildGalery();

        BAgregar.Text = "Agregar";
        BAgregar.Enabled = Usuario.GetInstance().CanInsert();
        BEliminar.Visible=false;
    }

    protected void BEliminar_Click(object sender, EventArgs e) {

        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        Heridas info = GetHerida((string)ViewState["idherida"]);
        info.eliminado = true;
        ViewState["querys"] = GHeridas.DataSource = consultas;
        GHeridas.DataBind();
        BCancelarHerida_Click(sender, e);
    }

    protected void GHeridas_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) {
            
            Heridas info=GetHerida(GHeridas.DataKeys[e.Row.RowIndex].Value.ToString());
            if(info!=null && info.eliminado)
                e.Row.Cells[1].CssClass = "eliminado";
        }
    }

    public Heridas GetHerida(string id) {

        Heridas info = null;
        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        if (consultas == null)
            return null;
        for (int i = 0; i < consultas.Count; i++)
        {
            if (consultas[i].Id == id)
            {
                info = consultas[i];
                break;
            }
        }
        return info;
    }

    protected void GHeridas_SelectedIndexChanged(object sender, EventArgs e)
    {
        Heridas info = GetHerida(GHeridas.SelectedDataKey.Value.ToString());
        if (info == null)
            return;
        
        ViewState["idherida"] = info.Id;

        Utilidades.SelectInDropDown(DLocalizacion, info.query["localizacion"]);
        try { RLocalizacion2.SelectedValue = info.query["localizacion2"].ToString(); } catch { }
        try { RLocalizacion3.SelectedValue = info.query["localizacion3"].ToString(); } catch { }
        try { RMI.SelectedValue = info.query["mi"].ToString(); } catch { }
        try { RPies.SelectedValue = info.query["pies"].ToString(); } catch { }
        TUbicacionEspecifica.Text = info.query["ubicacion_especifica"].ToString();
        Utilidades.SelectInDropDown(DEtiologia, info.query["etiologia"]);
        TOtroEtiologia.Text = info.query["etiologia_otro"].ToString();
        Utilidades.SelectInDropDown(DClasificacion, info.query["clasificacion"]);
        TFactoresRiesgo.Text = info.query["factores_riesgo"].ToString();
        TLongitud.Text = info.query["longitud"].ToString();
        TAnchura.Text = info.query["anchura"].ToString();
        TProfunidad.Text = info.query["profundidad"].ToString();
        CTunelizacion.Checked = info.query["tunelizacion"].ToString() == "" ? false : true;
        TTunelizacion.Text = info.query["tunelizacion"].ToString();
        TCavidad.Text = info.query["cavidad"].ToString();
        TBolsilloProfundidad.Text = info.query["bolsillo_tamano"].ToString();
        TBolsilloUbicacion.Text = info.query["bolsillo_ubicacion"].ToString();
        CBolsillo.Checked = TBolsilloProfundidad.Text.Length > 0;
        try { RTipoTejido.SelectedValue = info.query["tipo_tejido"].ToString(); } catch { }
        TCompacto.Text = info.query["compacto"].ToString();
        TDeFibrina.Text = info.query["fibrina"].ToString();
        TEpitelizacion.Text = info.query["epitelizacion"].ToString();
        TEscara.Text = info.query["escara"].ToString();
        TGranulacion.Text = info.query["granulacion"].ToString();
        THiperGranulacion.Text = info.query["hipergranulacion"].ToString();
        TLimpio.Text = info.query["limpio"].ToString();
        TNecrosis.Text = info.query["necrosis"].ToString();
        Utilidades.SelectInDropDown(DSeleccione, info.query["seleccion_tejido"]);
        Utilidades.SelectInDropDown(DExudado, info.query["exudado"]);
        Utilidades.SelectInDropDown(DTipoExudado, info.query["tipo_exudado"]);
        Utilidades.SelectInDropDown(DPielCircundante, info.query["piel_circundante"]);
        Utilidades.SelectInDropDown(DBordesHerida, info.query["bordes_herida"]);
        Utilidades.SelectInDropDown(DOlor, info.query["olor"]);
        TOlorDescripcion.Text = info.query["olor_descripcion"].ToString();
        Utilidades.SelectInDropDown(DSignosSintomas, info.query["signos_sintomas"]);
        TComplicaciones.Text = info.query["exudado_complicacion"].ToString();
        CComplicaciones.Checked = TComplicaciones.Text.Length > 0;
        Utilidades.SelectInDropDown(DDefina, info.query["exudado_definicion"]);

        BAgregar.Enabled = Usuario.GetInstance().CanUpdate();
        BAgregar.Text = "Editar";
        BEliminar.Visible = Usuario.GetInstance().CanDelete();

        RebuildGalery();
    }

    protected static string ImprimirGridTipo1(GridView grid)
    {
        string resultado = "";
        for (int i = 0; i < grid.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)grid.Rows[i].FindControl("CSi");
            TextBox text = (TextBox)grid.Rows[i].FindControl("TObservaciones");
            if (text.Text.Length != 0)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += string.Format("<b>{0}: </b> {2}", check.Text, check.Checked ? "X" : "_", text.Text);
            }
        }
        if (resultado.Length == 0)
            resultado = grid.EmptyDataText;
        return resultado;
    }

    protected string ImprimirPlanEducativo()
    {
        string resultado = "";
        GEducativo.DataBind();
        for (int i = 0; i < GEducativo.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)GEducativo.Rows[i].FindControl("CSi");
            if (check.Checked)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += check.Text;
            }
        }
        if (resultado.Length == 0)
            resultado = "No se encontro plan educativo.";
        return resultado;
    }

    public string ImprimirFotos() {

        if (DFotos.Items.Count == 0) {
            return "No se encontro registro fotográfico.";
        }

        string resultado = "<table>";
        List<Heridas.Fotos> fotos = RebuildGalery();
        for (int i = 0; i < fotos.Count; i += 3) {
            resultado += "<tr>";
            for (int j = i; j < i + 3 && j < fotos.Count; j++)
            {
                resultado += "<td>";
                resultado += string.Format("<img border=0 src='{5}{6}?t=v&p={0}&i={1}&n={2}&hi={4}&d={3}&w=150&h=150'/>",
                                    CCDetallePaciente.IdPaciente, ViewState["id"], fotos[j].Archivo, fotos[j].Temporal, fotos[j].Id
                                    , ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/archivo/imagen.ashx"));
                resultado += "</td>";
            }
            resultado += "</tr>";
        }
        resultado += "</table>";
        return resultado;
    }

    protected string AddPorcentajeDeTejido(string nombre, TextBox textBox, bool coma) {

        if (string.IsNullOrEmpty(textBox.Text))
            return null;
        return (coma ? "," : "") + " <b>" + nombre + "</b> " + textBox.Text + "%";
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        string porcentajedepedido = "";
        PrintEventArgs evento = (PrintEventArgs)e;

        // aqui modificamos el evento.Contenido
        evento.Contenido = evento.Contenido.Replace("$szAntecedentes$", ImprimirGridTipo1(GAntecedentes));
        evento.Contenido = evento.Contenido.Replace("$szRiesgos$", ImprimirGridTipo1(GRiesgos));
        evento.Contenido = evento.Contenido.Replace("$szPlanEducativo$", ImprimirPlanEducativo());

        evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + TPlanManejo.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            evento.Contenido = evento.Contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, TFecha.Text, escala));
        }

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
        evento.Contenido = evento.Contenido.Replace("$szImagenEscala$", DEscalaDolor.SelectedItem.Text.Split(' ')[0]);

        if (GHeridas.Rows.Count > 0)
        {
            int inicio = evento.Contenido.IndexOf("<!-- inicioherida -->");
            int final = evento.Contenido.IndexOf("<!-- finherida -->");
            if (inicio != -1 && final != -1)
            {
                StringBuilder herida = new StringBuilder(evento.Contenido.Substring(inicio, final - inicio));
                for (int i = GHeridas.Rows.Count - 2; i >= 0; i--)
                {
                    GHeridas.SelectedIndex = i;
                    GHeridas_SelectedIndexChanged(sender, e);

                    porcentajedepedido = "";

                    porcentajedepedido += AddPorcentajeDeTejido("Compacto", TCompacto, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("De fibrina", TDeFibrina, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Epitelización", TEpitelizacion, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Esfacelo", TEscara, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Granulación", TGranulacion, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Hipergranulación", THiperGranulacion, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Limpio pero no granulado", TLimpio, porcentajedepedido.Length > 0);
                    porcentajedepedido += AddPorcentajeDeTejido("Necrosis profunda", TNecrosis, porcentajedepedido.Length > 0);

                    herida = herida.Replace("$szPorcentajedePedido$", porcentajedepedido);

                    evento.Contenido = evento.Contenido.Insert(inicio, Utilidades.ReplaceContenido(Controls, herida.Replace("$szFotos$", ImprimirFotos())).ToString());
                }
            }
            GHeridas.SelectedIndex = GHeridas.Rows.Count - 1;
            GHeridas_SelectedIndexChanged(sender, e);
        }

        porcentajedepedido = "";
        porcentajedepedido += AddPorcentajeDeTejido("Compacto", TCompacto, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("De fibrina", TDeFibrina, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Epitelización", TEpitelizacion, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Esfacelo", TEscara, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Granulación", TGranulacion, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Hipergranulación", THiperGranulacion, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Limpio pero no granulado", TLimpio, porcentajedepedido.Length > 0);
        porcentajedepedido += AddPorcentajeDeTejido("Necrosis profunda", TNecrosis, porcentajedepedido.Length > 0);

        evento.Contenido = evento.Contenido.Replace("$szPorcentajedePedido$", porcentajedepedido);

        evento.Contenido = evento.Contenido.Replace("$szFotos$", ImprimirFotos());
        
        using (CConector conector = new CConector())
        {
            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";
            query["szNombrePersonal"] = "recurso_humano.perNombre";

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
        }
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }
}
