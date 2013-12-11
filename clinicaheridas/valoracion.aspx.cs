using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Globalization;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class clinicaheridas_valoracion : System.Web.UI.Page
{
    public class Fotos
    {
        public string Archivo { get; set; }
        public string Ruta { get; set; }
        public bool Temporal { get; set; }
    };
    protected void Page_Load(object sender, EventArgs e)
    {
        // ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            // BAceptar.Enabled = false;

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Text = Conector.GetFromMySQLDate(DateTime.Now, true);
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
                        query += "localizacion";
                        query += "localizacion2";
                        query += "localizacion3";
                        query += "mi";
                        query += "pies";
                        query += "ubicacion_especifica";
                        query += "etiologia";
                        query += "tiempo_evolucion_ulcera";
                        query += "lugar_origen_ulcera";
                        query += "tejido_profundo";
                        query += "clasificacion";
                        query += "longitud";
                        query += "anchura";
                        query += "profundidad";
                        query += "tunelizacion";
                        query += "cavidad";
                        query += "tracto_sinusal";
                        query += "tipo_tejido";
                        query += "compacto";
                        query += "fibrina";
                        query += "seleccion_tejido";
                        query += "exudado";
                        query += "tipo_exudado";
                        query += "piel_circundante";
                        query += "bordes_herida";
                        query += "olor";
                        query += "olor_descripcion";
                        query += "signos_sintomas";
                        query += "manejo";
                        query += "epitelizacion";
                        query += "escara";
                        query += "granulacion";
                        query += "hipergranulacion";
                        query += "limpio";
                        query += "necrosis";
                        query += "costomias";
                        query += "cdispositivos_medicos";
                        query += "etiologia_otro";
                        query += "hogar_geriatrico";
                        query += "exudado_complicacion";
                        query += "exudado_definicion";
                        query += "consentimiento";
                        query += "periodicidad";
                        query += "fistula";
                        query += "localizacion_fistula";
                        query += "signos_infeccion";
                        query += "cantidad_afluente";
                        query += "observacion_pulso";
                        query += "factores_riesgo";

                        MySqlDataReader reader= conector.Query(query.GetSelect("paciente=" + Query.GetValor(Request.QueryString["pid"])));
                        if (reader != null && reader.Read()) {

                            BAceptar.Enabled = usuario.CanUpdate();

                            ViewState["id"] =
                                SVarios.SelectParameters["valoracion"].DefaultValue =
                                SRiesgos.SelectParameters["valoracion"].DefaultValue =
                                SAntecendentes.SelectParameters["valoracion"].DefaultValue =
                                SEducativo.SelectParameters["valoracion"].DefaultValue =
                                reader["id"].ToString();

                            TFecha.Text = CConector.GetFromMySQLDate(reader["fecha"]);
                            TTA.Text = reader["ta"].ToString();
                            TFC.Text = reader["fc"].ToString();
                            TFR.Text = reader["fr"].ToString();
                            TT.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["t"]);
                            try { RPDistales.DataBind(); RPDistales.SelectedValue = reader["pulsosdistales"].ToString(); } catch { }
                            try { RTipo.DataBind(); RTipo.SelectedValue = reader["ostomias"].ToString(); } catch { }
                            TUbicacion.Text = reader["ubicacion"].ToString();
                            CConector.SelectInDropDown(DColor, reader["color"]);
                            CConector.SelectInDropDown(DEstoma,reader["estoma"]);
                            CConector.SelectInDropDown(DComplicacion,reader["complicaciones"]);
                            CConector.SelectInDropDown(DEstadoPiel,reader["estado_piel"]);
                            CConector.SelectInDropDown(DTipoDispositivo,reader["tipo_dispositivo"]);
                            CConector.SelectInDropDown(DFuncional,reader["funcional"]);
                            TFuncionalDescripcion.Text = reader["funcional_descripcion"].ToString();
                            CConector.SelectInDropDown(DEscalaDolor,reader["dolor"]);
                            CConector.SelectInDropDown(DLocalizacion, reader["localizacion"]);
                            try { RLocalizacion2.DataBind(); RLocalizacion2.SelectedValue = reader["localizacion2"].ToString(); } catch { }
                            try { RLocalizacion3.DataBind(); RLocalizacion3.SelectedValue = reader["localizacion3"].ToString(); } catch { }
                            try { RMI.DataBind(); RMI.SelectedValue = reader["mi"].ToString(); } catch { }
                            try { RPies.DataBind(); RMI.SelectedValue = reader["pies"].ToString(); } catch { }
                            TUbicacionEspecifica.Text = reader["ubicacion_especifica"].ToString();
                            CConector.SelectInDropDown(DEtiologia,reader["etiologia"]);
                            TTiempoEvolucion.Text = reader["tiempo_evolucion_ulcera"].ToString();
                            CConector.SelectInDropDown(DLugarOrigen,reader["lugar_origen_ulcera"]);
                            CConector.SelectInDropDown(DTejidoSospechoso,reader["tejido_profundo"]);
                            CConector.SelectInDropDown(DClasificacion,reader["clasificacion"]);
                            TLongitud.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["longitud"]);
                            TAnchura.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["anchura"]);
                            TProfunidad.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["profundidad"]);
                            CTunelizacion.Checked = reader["tunelizacion"].ToString() == "" ? false : true;
                            TTunelizacion.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["tunelizacion"]);
                            TCavidad.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["cavidad"]);
                            TTracto.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["tracto_sinusal"]);
                            try { RTipoTejido.DataBind(); RTipoTejido.SelectedValue = reader["tipo_tejido"].ToString(); } catch { }
                            TCompacto.Text = reader["compacto"].ToString();
                            TDeFibrina.Text = reader["fibrina"].ToString();
                            CConector.SelectInDropDown(DSeleccione,reader["seleccion_tejido"]);
                            CConector.SelectInDropDown(DExudado,reader["exudado"]);
                            CConector.SelectInDropDown(DTipoExudado,reader["tipo_exudado"]);
                            CConector.SelectInDropDown(DPielCircundante,reader["piel_circundante"]);
                            CConector.SelectInDropDown(DBordesHerida,reader["bordes_herida"]);
                            CConector.SelectInDropDown(DOlor,reader["olor"]);
                            TOlorDescripcion.Text = reader["olor_descripcion"].ToString();
                            CConector.SelectInDropDown(DSignosSintomas, reader["signos_sintomas"]);
                            Conector.SelectInDropDown(DDefina, reader["exudado_definicion"]);
                            LTipo.Text = DEtiologia.SelectedItem.Text;
                            LClasificacion.Text = DDefina.SelectedItem.Text;
                            TManejo.Text = reader["manejo"].ToString();
                            TEpitelizacion.Text = reader["epitelizacion"].ToString();
                            TEscara.Text = reader["escara"].ToString();
                            TGranulacion.Text = reader["granulacion"].ToString();
                            THiperGranulacion.Text = reader["hipergranulacion"].ToString();
                            TLimpio.Text = reader["limpio"].ToString();
                            TNecrosis.Text = reader["necrosis"].ToString();
                            COstomias.Checked = reader["costomias"].ToString() == "1";
                            CDispositivosMedicos.Checked = reader["cdispositivos_medicos"].ToString() == "1";
                            TOtroEtiologia.Text = reader["etiologia_otro"].ToString();
                            THogarGeriatrico.Text = reader["hogar_geriatrico"].ToString();
                            TComplicaciones.Text = reader["exudado_complicacion"].ToString();
                            CComplicaciones.Checked = TComplicaciones.Text.Length > 0;
                            CConsentimiento.Checked = reader["consentimiento"].ToString() == "1";
                            TPeriodicidad.Text = reader["periodicidad"].ToString();
                            CFistulas.Checked= reader["fistula"].ToString()=="1";
                            TLocalizacionFistula.Text = reader["localizacion_fistula"].ToString();
                            CSignosInfeccion.Checked= reader["signos_infeccion"].ToString()=="1";
                            TCAfluente.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["cantidad_afluente"]);
                            TObservacionPulso.Text = reader["observacion_pulso"].ToString();
                            TFactoresRiesgo.Text = reader["factores_riesgo"].ToString();

                            ((MasterPageI)Master).SetModificacion(reader["id"].ToString());
                        }
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

        int total = 0;
        try { total += Convert.ToInt32(TCompacto.Text); } catch { }
        try { total += Convert.ToInt32(TDeFibrina.Text); } catch { }
        try { total += Convert.ToInt32(TEpitelizacion.Text); } catch { }
        try { total += Convert.ToInt32(TEscara.Text); } catch { }
        try { total += Convert.ToInt32(TGranulacion.Text); } catch { }
        try { total += Convert.ToInt32(THiperGranulacion.Text); } catch { }
        try { total += Convert.ToInt32(TLimpio.Text); } catch { }
        try { total += Convert.ToInt32(TNecrosis.Text); } catch { }
        
        if (total > 100) {
            TCompacto.Focus();
            LMensaje.Text = "La suma de los porcentajes no puede exceder el 100%";
            return;
        }

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id= (string)ViewState["id"];
            Query query = new Query("valoracion_herida");

            query["fecha"] = Conector.GetMySQLDateFormat(TFecha.Text);
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
            query["funcional"] = DFuncional.SelectedValue;
            query["funcional_descripcion"] = TFuncionalDescripcion.Text;
            query["dolor"] = DEscalaDolor.SelectedValue;
            query["localizacion"] = DLocalizacion.SelectedValue;
            query["localizacion2"] = RLocalizacion2.SelectedValue;
            query["localizacion3"] = RLocalizacion3.SelectedValue;
            query["mi"] = RMI.SelectedValue;
            query["pies"] = RPies.SelectedValue;
            query["ubicacion_especifica"] = TUbicacionEspecifica.Text;
            query["etiologia"] = DEtiologia.SelectedValue;
            query["tiempo_evolucion_ulcera"] = TTiempoEvolucion.Text;
            query["lugar_origen_ulcera"] = DLugarOrigen.SelectedValue;
            query["tejido_profundo"] = DTejidoSospechoso.SelectedValue;
            query["clasificacion"] = DClasificacion.SelectedValue;
            query["longitud"] = TLongitud.Text.Replace(" cm", "");
            query["anchura"] = TAnchura.Text.Replace(" cm", "");
            query["profundidad"] = TProfunidad.Text.Replace(" cm", "");
            query["tunelizacion"] = CTunelizacion.Checked ? TTunelizacion.Text.Replace(" cm", "") : "";
            query["cavidad"] = TCavidad.Text.Replace(" cm", "");
            query["tracto_sinusal"] = TTracto.Text.Replace(" cm", "");
            query["tipo_tejido"] = RTipoTejido.SelectedValue;
            query["compacto"] = TCompacto.Text.Replace(" %", "");
            query["fibrina"] = TDeFibrina.Text.Replace(" %", "");
            query["seleccion_tejido"] = DSeleccione.SelectedValue;
            query["exudado"] = DExudado.SelectedValue;
            query["tipo_exudado"] = DTipoExudado.SelectedValue;
            query["piel_circundante"] = DPielCircundante.SelectedValue;
            query["bordes_herida"] = DBordesHerida.SelectedValue;
            query["olor"] = DOlor.SelectedValue;
            query["olor_descripcion"] = TOlorDescripcion.Text;
            query["signos_sintomas"] = DSignosSintomas.SelectedValue;
            query["manejo"] = TManejo.Text;
            query["epitelizacion"] = TEpitelizacion.Text.Replace(" %", "");
            query["escara"] = TEscara.Text.Replace(" %", "");
            query["granulacion"] = TGranulacion.Text.Replace(" %", "");
            query["hipergranulacion"] = THiperGranulacion.Text.Replace(" %", "");
            query["limpio"] = TLimpio.Text.Replace(" %", "");
            query["necrosis"] = TNecrosis.Text.Replace(" %", "");
            query["costomias"]= COstomias.Checked ? "1":  "";
            query["cdispositivos_medicos"] = CDispositivosMedicos.Checked ? "1" : "";
            query["etiologia_otro"] = TOtroEtiologia.Text;
            query["hogar_geriatrico"] = THogarGeriatrico.Text;
            query["exudado_complicacion"] = CComplicaciones.Checked ? TComplicaciones.Text : "";
            query["exudado_definicion"] = DDefina.SelectedValue;
            query["consentimiento"] = CConsentimiento.Checked ? "1" : "";
            query["periodicidad"] = TPeriodicidad.Text;
            query["fistula"]= CFistulas.Checked ?"1" : "";
            query["localizacion_fistula"] = TLocalizacionFistula.Text;
            query["signos_infeccion"]= CSignosInfeccion.Checked ? "1" : "";
            query["cantidad_afluente"] = TCAfluente.Text.Replace(" cm", "");
            query["observacion_pulso"] = TObservacionPulso.Text;
            query["factores_riesgo"] = TFactoresRiesgo.Text;

            if(string.IsNullOrEmpty(id)) {

                query["paciente"] = CCDetallePaciente.IdPaciente;

                int res= conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                {
                    LMensaje.Text= conector.GetLastError();
                    return;
                }
            }

            Query educativo = new Query("valoracion_herida_educativo");
            if (conector.QueryMod(educativo.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.GetLastError();
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
                        LMensaje.Text = conector.GetLastError();
                        return;
                    }
                }
            }

            Query antecendentes = new Query("valoracion_herida_antecedentes");
            if (conector.QueryMod(antecendentes.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.GetLastError();
                return;
            }
            antecendentes["valoracion"] = id;

            for (int i = 0; i < GAntecedentes.Rows.Count; i++)
            {
                antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values["id"].ToString();
                antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                antecendentes["observaciones"] = ((TextBox)GAntecedentes.Rows[i].Cells[1].FindControl("TObservaciones")).Text;

                if (conector.QueryMod(antecendentes.GetInsert()) == -1) {
                    
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
            }

            Query riesgos = new Query("valoracion_herida_riesgos");
            if (conector.QueryMod(riesgos.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.GetLastError();
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
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
            }

            Query varios = new Query("valoracion_herida_varios");
            if (conector.QueryMod(varios.GetDelete("valoracion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.GetLastError();
                return;
            }
            varios["valoracion"] = id;

            for (int i = 0; i < GVarios.Rows.Count; i++)
            {
                varios["estado"] = ((CheckBox)GVarios.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
                varios["observaciones"] = ((TextBox)GVarios.Rows[i].Cells[1].FindControl("TObservaciones")).Text;
                varios["motivo"] = GVarios.DataKeys[i].Values["id"].ToString();

                if (conector.QueryMod(varios.GetInsert()) == -1)
                {
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1) {
                LMensaje.Text = conector.GetLastError();
                return;
            }
            conector.Commit();


            // ahora guardamos las fotos
            string rutafinal = GetFinalPath(id);
            foreach (string archivo in Directory.GetFiles(GetTemporalPath()))
            {
                File.Move(archivo, Path.Combine(rutafinal, Path.GetFileName(archivo)));
            }

            ((MasterPageI)Master).SetResultado( CCDetallePaciente.Nombres + " Editado.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public List<Fotos> RebuildGalery()
    {
        List<Fotos> fotos = new List<Fotos>();
        foreach (string archivo in Directory.GetFiles(GetTemporalPath())) {
            Fotos info = new Fotos();
            info.Archivo = Path.GetFileName(archivo);
            info.Temporal = true;
            fotos.Add(info);
        }
        foreach (string archivo in Directory.GetFiles(GetFinalPath((string)ViewState["id"])))
        {
            Fotos info = new Fotos();
            info.Archivo = Path.GetFileName(archivo);
            info.Temporal = false;
            fotos.Add(info);
        }
        DFotos.DataSource = fotos;
        DFotos.DataBind();
        return fotos;
    }

    public string GetTemporalPath() {

        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "valoracion");
        System.IO.Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, "temp");
        System.IO.Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, CCDetallePaciente.IdPaciente);
        System.IO.Directory.CreateDirectory(archivo);

        return archivo;
    }

    public string GetFinalPath(string id)
    {
        if (id == null)
            id = "";
        string archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "valoracion");
        System.IO.Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, id);
        System.IO.Directory.CreateDirectory(archivo);

        return archivo;
    }

    protected void BSubir_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        if (!FFoto.HasFile) 
            return;

        string archivo = Path.Combine(GetTemporalPath(), FFoto.FileName);
        FFoto.SaveAs(archivo);

        RebuildGalery();

        ScriptManager.RegisterStartupScript(FFoto, typeof(string), "registro", "$('html, body').animate({scrollTop: $('#registrofotografico').offset().top}, 0);", true);
    }
    protected void DFotos_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        string archivo = DFotos.DataKeys[e.Item.ItemIndex].ToString();
        File.Delete(Path.Combine(GetTemporalPath(), archivo));
        File.Delete(Path.Combine(GetFinalPath((string)ViewState["id"]), archivo));

        RebuildGalery();
    }
}
