using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Configuration;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class clinicaheridas_evolucion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack) {

            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            UCFuncionario.ReadOnly = !usuario.CanAdmin();
            BAceptar.Enabled = false;
            TPlanManejo.ReadOnly = !usuario.CanAdmin();

            RLocalizacion2.DataBind();
            RLocalizacion3.DataBind();
            RMI.DataBind();
            RPies.DataBind();
            // BAceptar.Enabled = false;

            if (!string.IsNullOrEmpty(Request.QueryString["hveid"]) && string.IsNullOrEmpty(Request.QueryString["ehid"])) {

                using(CConector conector=new CConector())
                    Response.Redirect(string.Format("~/clinicaheridas/valoracion.aspx?pid={0}&hveid={1}"
                        , Request.QueryString["pid"]
                        , Request.QueryString["hveid"]));
            }

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                } else {
                    UCFuncionario.IdFuncionario = usuario["personal"];

                    BAceptar.Enabled = usuario.CanInsert();
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
                    CCDetallePaciente.Visible=
                        PHistorial.Visible=
                    PDatos.Visible = true;

                    using (CConector conector = new CConector())
                    {
                        string id = "";
                        string condicion = "";
                        bool evolucion=false;
                        Query query = new Query("valoracion_herida");
                        DateTime fecha = DateTime.Parse(TFecha.Text);

                        query += "id";
                        query += "fecha";

                        MySqlDataReader reader= conector.Query(query.GetSelect("paciente=" + Query.GetValor(Request.QueryString["pid"])));
                        if (reader != null && reader.Read())
                        {
                            BAceptar.Enabled= usuario.CanUpdate();
                            LValoracionInicial.Text = Query.GetFromMySQLDate(reader["fecha"]);
                            id = reader["id"].ToString();
                            condicion = "valoracion=" + Query.GetValor(id);

                            try
                            {
                                TimeSpan ts = fecha - DateTime.Parse(LValoracionInicial.Text);
                                LDiasEvolucion.Text = ts.Days.ToString();
                            } catch { }
                        }

                        bool completa = !string.IsNullOrEmpty(Request.QueryString["ehid"]);

                        query = new Query("evolucion_herida");

                        query += "id";
                        query += "fecha";

                        if (completa) {

                            query+="funcionario";
                            query+="ta";
                            query+="fc";
                            query+="fr";
                            query+="t";
                            query+="pulsosdistales";
                            query+="observacion_pulso";
                            query+="manejo";
                            query+="insumos";
                            query+="otros";
                        }

                        if(completa)
                            reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["ehid"])));
                        else reader = conector.Query(query.GetSelect("paciente=" + Query.GetValor(Request.QueryString["pid"]) + " ORDER BY fecha DESC LIMIT 1"));

                        query = new Query("valoracion_herida_herida");

                        if (reader != null && reader.Read())
                        {
                            evolucion = true;
                            LUltimaEvolucion.Text = Query.GetFromMySQLDate(reader["fecha"]);
                            id = reader["id"].ToString();

                            try {
                                TimeSpan ts = fecha - DateTime.Parse(LUltimaEvolucion.Text);
                                LDiasEvolucion2.Text = ts.Days.ToString();
                            } catch { }

                            query = new Query("evolucion_herida_herida");
                            condicion = "evolucion=" + Query.GetValor(id);

                            if (completa) {
                                BAceptar.Enabled = usuario.CanUpdate();
                                ((MasterPageI)Master).Imprimir("evolucion.html");

                                ViewState["id"] =
                                    SClinica.SelectParameters["evolucion"].DefaultValue =
                                    SEducativo.SelectParameters["evolucion"].DefaultValue =
                                    reader["id"].ToString();

                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                UCFuncionario.IdFuncionario = reader["funcionario"].ToString();
                                TTA.Text = reader["ta"].ToString();
                                TFC.Text = reader["fc"].ToString();
                                TFR.Text = reader["fr"].ToString();
                                TT.Text = Utilidades.TryConverToDoubleInvariantCulture(reader["t"]);
                                try { RPDistales.DataBind(); RPDistales.SelectedValue = reader["pulsosdistales"].ToString(); } catch { }
                                TObservacionPulso.Text= reader["observacion_pulso"].ToString();
                                TOtros.Text = reader["otros"].ToString();
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

                                ((MasterPageI)Master).SetModificacion(ViewState["id"].ToString());
                            }
                        }

                        if (!string.IsNullOrEmpty(id))
                        {
                            query += "id";
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
                            if (evolucion) {
                                query += "cambio_herida";
                                query += "signo_infeccion";
                            }

                            List<Heridas> heridas = new List<Heridas>();

                            reader = conector.Query(query.GetSelect(condicion));
                            if (reader != null)
                            {
                                while (reader.Read())
                                {
                                    Heridas info = new Heridas(reader["id"].ToString(), reader["ubicacion_especifica"].ToString(), reader["id"].ToString(), "evolucion_herida_herida", completa);
                                    for (int i = 0; i < reader.FieldCount; i++)
                                    {
                                        if (reader[i] != DBNull.Value && reader[i] is float)
                                            info.query[reader.GetName(i)] = ((float)reader[i]).ToString(CultureInfo.InvariantCulture);
                                        else info.query[reader.GetName(i)] = reader[i].ToString();
                                    }
                                    info.query.RemoveCampo("id");
                                    heridas.Add(info);
                                }
                            }
                            ViewState["querys"] = GHeridas.DataSource = heridas;
                            GHeridas.DataBind();
                        }
                    }
                    GHistorial.DataBind();
                    LHistorial.Text = GHistorial.Rows.Count + " Evoluci";
                    LHistorial.Text += GHistorial.Rows.Count == 1 ? "ón" : "ones";
                    PHistorial.Visible = GHistorial.Rows.Count > 0;
                }
            }
        }
    }

    public bool UpdateHeridas(Conector conector, string evolucion=null) {
        
        if (!string.IsNullOrEmpty(evolucion))
            evolucion = "WHERE evolucion=" + Query.GetValor(evolucion);
        conector.QueryMod("SET @c:=0,@i=0;");
        return conector.QueryMod("UPDATE evolucion_herida_herida SET numero=IF(@i=evolucion, 1, CONCAT(@i:=evolucion, @c:=0)),numero=@c:=@c+1 " + evolucion + " ORDER BY evolucion,id;")!=-1;
    }
    
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        BAgregar_Click(sender, e);

        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        /*if ((consultas == null || consultas.Count == 0) && string.IsNullOrEmpty((string)ViewState["id"]))
        {
            LMensaje.Text = "Por favor ingrese por lo menos una herida";
            TUbicacionEspecifica.Focus();
            return;
        }*/
        if (consultas == null)
            consultas = new List<Heridas>();

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id = (string)ViewState["id"];

            Query query = new Query("evolucion_herida");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["ta"] = TTA.Text;
            query["fc"] = TFC.Text.Replace(" Lat/min", "");
            query["fr"] = TFR.Text.Replace(" Min", "");
            query["t"] = TT.Text.Replace(" °", "");
            query["pulsosdistales"] = RPDistales.SelectedValue;
            query["observacion_pulso"] = TObservacionPulso.Text;
            query["otros"] = TOtros.Text;
            query["manejo"] =
                (string.IsNullOrEmpty((string)ViewState["procedimientos"]) || TPlanManejo.Text != ViewState["procedimientos"].ToString())
                ? TPlanManejo.Text
                : "";

            if (string.IsNullOrEmpty(id))
            {
                query["paciente"] = CCDetallePaciente.IdPaciente;
                query["asegurador"] = CCDetallePaciente.AsegurdadorID;
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            for (int i = 0; i < consultas.Count; i++)
            {
                if (consultas[i].eliminado) // eliminamos los que no necesitamos, // falta eliminar las fotos
                {
                    if (consultas[i].Existe)
                    {
                        if (conector.QueryMod(consultas[i].query.GetDelete("id=" + Query.GetValor(consultas[i].Id) + " AND evolucion=" + Query.GetValor(id))) == -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                    }
                }
                else
                {
                    if (!consultas[i].Existe)
                    {
                        query = Serializar.DesSerializeBinary<Query>(Serializar.SerializeBinary(consultas[i].query, false), false);
                        query.TableName = "valoracion_herida_herida";

                        query -= "cambio_herida";
                        query -= "signo_infeccion";

                        query["valoracion"] = "0";

                        int res = conector.QueryMod(query.GetInsert(), true);
                        if (res == -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }

                        consultas[i].IdTabla = res.ToString();
                        consultas[i].query["id"] = consultas[i].IdTabla; //  establecemos el id de la herida
                        consultas[i].query["evolucion"] = id;
                        res = conector.QueryMod(consultas[i].query.GetInsert(), true);
                        if (res == -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                        consultas[i].IdTemp = res.ToString();
                    }
                    else
                    {
                        if (conector.QueryMod(consultas[i].query.GetUpdate("id=" + Query.GetValor(consultas[i].IdTabla) + " AND evolucion=" + Query.GetValor(id))) == -1)
                        {
                            LMensaje.Text = conector.LastError;
                            return;
                        }
                    }
                }
            }

            if (conector.InsertModificacion(id) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            
            Query clinica = new Query("evolucion_herida_clinica");
            if (conector.QueryMod(clinica.GetDelete("evolucion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            clinica["evolucion"] = id;

            for (int i = 0; i < GClinica.Rows.Count; i++)
            {
                CheckBox check = (CheckBox)GClinica.Rows[i].FindControl("CSi");
                if (check.Checked)
                {
                    clinica["concepto"] = GClinica.DataKeys[i].Value.ToString();
                    clinica["valor"] = "1";

                    if (conector.QueryMod(clinica.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
            }

            Query educativo = new Query("evolucion_herida_educativo");
            if (conector.QueryMod(educativo.GetDelete("evolucion=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            educativo["evolucion"] = id;

            for (int i = 0; i < GEducativo.Rows.Count; i++)
            {
                CheckBox check = (CheckBox)GEducativo.Rows[i].FindControl("CSi");
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

            UpdateHeridas(conector, id);

            if (string.IsNullOrEmpty((string)ViewState["id"]) && Usuario.GetInstance().GetPermisosRaiz("~/App_data/Escalas") ==0)
                Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(TFecha.Text, true)), conector);

            conector.Commit();

            // ahora guardamos las fotos
            for (int i = 0; i < consultas.Count; i++)
            {
                try
                {
                    foreach (string archivo in Directory.GetFiles(Heridas.GetTemporalPath(CCDetallePaciente.IdPaciente, consultas[i].Id, false, "e")))
                    {
                        string rutafinal = Heridas.GetFinalPath(id, string.IsNullOrEmpty(consultas[i].IdTabla) ? consultas[i].IdTemp : consultas[i].IdTabla, true, "e"); // nos aseguramos que exista un archivo
                        if (consultas[i].eliminado)
                            File.Delete(archivo);
                        else File.Move(archivo, Path.Combine(rutafinal, Path.GetFileName(archivo)));
                    }
                } catch { }
                CleanTemporalPath(consultas[i].Id);
                try
                {
                    if (consultas[i].eliminado)
                    {
                        string rutafinal = Heridas.GetFinalPath(id, string.IsNullOrEmpty(consultas[i].IdTabla) ? consultas[i].IdTemp : consultas[i].IdTabla, false, "e");
                        foreach (string archivo in Directory.GetFiles(rutafinal))
                            File.Delete(archivo);
                        Directory.Delete(rutafinal);
                    }
                } catch { }
            }
            CleanTemporalPath(GetHeridaID());

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado(CCDetallePaciente.Nombres + " Editado.");
        }

    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GHeridas_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            Heridas info = GetHerida(GHeridas.DataKeys[e.Row.RowIndex].Value.ToString());
            if (info != null && info.eliminado)
                e.Row.Cells[1].CssClass = "eliminado";
        }
    }

    public Heridas GetHerida(string id)
    {
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
        /*Utilidades.SelectInDropDown(DEtiologia, info.query["etiologia"]);
        TOtroEtiologia.Text = info.query["etiologia_otro"];*/
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
        // try { RTipoTejido.SelectedValue = info.query["tipo_tejido"]; } catch { }
        TCompacto.Text = info.query["compacto"].ToString();
        TDeFibrina.Text = info.query["fibrina"].ToString();
        TEpitelizacion.Text = info.query["epitelizacion"].ToString();
        TEscara.Text = info.query["escara"].ToString();
        TGranulacion.Text = info.query["granulacion"].ToString();
        THiperGranulacion.Text = info.query["hipergranulacion"].ToString();
        TLimpio.Text = info.query["limpio"].ToString();
        TNecrosis.Text = info.query["necrosis"].ToString();
        // Utilidades.SelectInDropDown(DSeleccione, info.query["seleccion_tejido"]);
        Utilidades.SelectInDropDown(DExudado, info.query["exudado"]);
        Utilidades.SelectInDropDown(DTipoExudado, info.query["tipo_exudado"]);
        Utilidades.SelectInDropDown(DPielCircundante, info.query["piel_circundante"]);
        Utilidades.SelectInDropDown(DBordesHerida, info.query["bordes_herida"]);
        // Utilidades.SelectInDropDown(DOlor, info.query["olor"]);
        // TOlorDescripcion.Text = info.query["olor_descripcion"];
        Utilidades.SelectInDropDown(DSignosSintomas, info.query["signos_sintomas"]);
        // TComplicaciones.Text = info.query["exudado_complicacion"];
        // CComplicaciones.Checked = TComplicaciones.Text.Length > 0;
        // Utilidades.SelectInDropDown(DDefina, info.query["exudado_definicion"]);
        Utilidades.SelectInDropDown(DTipoCambios, info.query["cambio_herida"]);
        TSignosInfeccion.Text = info.query["signo_infeccion"].ToString();

        BAgregar.Enabled = Usuario.GetInstance().CanUpdate();
        BAgregar.Text = "Editar";
        PHerida.Visible= 
        BAgregar.Visible = true;
        BEliminar.Visible = Usuario.GetInstance().CanDelete();
        BAgregarHerida.Visible = false;

        Heridas.RebuildGalery(CCDetallePaciente.IdPaciente, (string)ViewState["id"], (string)ViewState["idherida"], "e", DFotos);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
        Heridas info = GetHerida((string)ViewState["idherida"]);
        info.eliminado = true;
        ViewState["querys"] = GHeridas.DataSource = consultas;
        GHeridas.DataBind();
        BCancelarHerida_Click(sender, e);
    }

    protected void BCancelarHerida_Click(object sender, EventArgs e)
    {
        LMensajeHerida.Text = "";

        try
        {
            RLocalizacion2.SelectedIndex =
                RLocalizacion3.SelectedIndex =
                RMI.SelectedIndex =
                RPies.SelectedIndex =
                // DEtiologia.SelectedIndex =
                DClasificacion.SelectedIndex =
                // RTipoTejido.SelectedIndex =
                // DSeleccione.SelectedIndex =
                DExudado.SelectedIndex =
                DTipoExudado.SelectedIndex =
                DPielCircundante.SelectedIndex =
                DBordesHerida.SelectedIndex =
                // DOlor.SelectedIndex =
                DSignosSintomas.SelectedIndex =
                // DDefina.SelectedIndex =
                DTipoCambios.SelectedIndex =
                DLocalizacion.SelectedIndex = 0;
        } catch { }

        TFactoresRiesgo.Text =
            TLongitud.Text =
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
            TSignosInfeccion.Text= 
            // TOlorDescripcion.Text =
            // TComplicaciones.Text =
            // TOtroEtiologia.Text =
        TUbicacionEspecifica.Text = "";

        CBolsillo.Checked =
            // CComplicaciones.Checked =
        CTunelizacion.Checked = false;

        GHeridas.SelectedIndex = -1;
        ViewState["idherida"] = null;
        Heridas.RebuildGalery(CCDetallePaciente.IdPaciente, (string)ViewState["id"], (string)ViewState["idherida"], "e", DFotos);

        BAgregar.Text = "Agregar";
        PHerida.Visible= 
        BAgregar.Visible = false;
        BAgregar.Enabled = Usuario.GetInstance().CanInsert();
        BEliminar.Visible = false;
        BAgregarHerida.Visible = true;
    }

    protected void BAgregar_Click(object sender, EventArgs e)
    {
        /*if (string.IsNullOrEmpty((string)ViewState["idherida"])) // no se pueden agregar heridas, solo editar
            return;*/

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

        string id = (string)ViewState["idherida"];
        if (!string.IsNullOrEmpty(id))
        {
            for (int i = 0; i < consultas.Count; i++)
            {
                if (consultas[i].Id == id)
                {
                    info = consultas[i];
                    info.Nombre = TUbicacionEspecifica.Text;
                    break;
                }
            }
        }
        if (info == null)
        {
            info = new Heridas(((consultas.Count + 1) * -1).ToString(), TUbicacionEspecifica.Text, null, "evolucion_herida_herida", false);
            info.query["id"] = "";
            consultas.Add(info);
        }

        info.query["localizacion"] = DLocalizacion.SelectedValue;
        info.query["localizacion2"] = RLocalizacion2.SelectedValue;
        info.query["localizacion3"] = RLocalizacion3.SelectedValue;
        info.query["mi"] = RMI.SelectedValue;
        info.query["pies"] = RPies.SelectedValue;
        info.query["ubicacion_especifica"] = TUbicacionEspecifica.Text;
        // info.query["etiologia"] = DEtiologia.SelectedValue;
        // info.query["etiologia_otro"] = TOtroEtiologia.Text;
        info.query["clasificacion"] = DClasificacion.SelectedValue;
        info.query["factores_riesgo"] = TFactoresRiesgo.Text;
        info.query["longitud"] = TLongitud.Text.Replace(" cm", "");
        info.query["anchura"] = TAnchura.Text.Replace(" cm", "");
        info.query["profundidad"] = TProfunidad.Text.Replace(" cm", "");
        info.query["tunelizacion"] = CTunelizacion.Checked ? TTunelizacion.Text.Replace(" cm", "") : "";
        info.query["cavidad"] = TCavidad.Text.Replace(" cm", "");
        info.query["bolsillo_tamano"] = CBolsillo.Checked ? TBolsilloProfundidad.Text.Replace(" cm", "") : "";
        info.query["bolsillo_ubicacion"] = CBolsillo.Checked ? TBolsilloUbicacion.Text : "";
        // info.query["tipo_tejido"] = RTipoTejido.SelectedValue;
        info.query["compacto"] = TCompacto.Text.Replace(" %", "");
        info.query["fibrina"] = TDeFibrina.Text.Replace(" %", "");
        info.query["epitelizacion"] = TEpitelizacion.Text.Replace(" %", "");
        info.query["escara"] = TEscara.Text.Replace(" %", "");
        info.query["granulacion"] = TGranulacion.Text.Replace(" %", "");
        info.query["hipergranulacion"] = THiperGranulacion.Text.Replace(" %", "");
        info.query["limpio"] = TLimpio.Text.Replace(" %", "");
        info.query["necrosis"] = TNecrosis.Text.Replace(" %", "");
        // info.query["seleccion_tejido"] = DSeleccione.SelectedValue;
        info.query["exudado"] = DExudado.SelectedValue;
        info.query["tipo_exudado"] = DTipoExudado.SelectedValue;
        info.query["piel_circundante"] = DPielCircundante.SelectedValue;
        info.query["bordes_herida"] = DBordesHerida.SelectedValue;
        // info.query["olor"] = DOlor.SelectedValue;
        // info.query["olor_descripcion"] = TOlorDescripcion.Text;
        info.query["signos_sintomas"] = DSignosSintomas.SelectedValue;
        // info.query["exudado_complicacion"] = CComplicaciones.Checked ? TComplicaciones.Text : "";
        // info.query["exudado_definicion"] = DDefina.SelectedValue;
        info.query["cambio_herida"] = DTipoCambios.SelectedValue;
        info.query["signo_infeccion"] = TSignosInfeccion.Text;

        ViewState["querys"] = GHeridas.DataSource = consultas;
        GHeridas.DataBind();
        BCancelarHerida_Click(sender, e);
    }

    public string GetHeridaID()
    {
        string id = (string)ViewState["idherida"];
        if (string.IsNullOrEmpty(id))
        {
            List<Heridas> consultas = (List<Heridas>)ViewState["querys"];
            if (consultas == null)
                id = "-1";
            else id = ((consultas.Count + 1) * -1).ToString();
        }
        return id;
    }

    protected void DFotos_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        string archivo = DFotos.DataKeys[e.Item.ItemIndex].ToString();
        try { File.Delete(Path.Combine(Heridas.GetTemporalPath(CCDetallePaciente.IdPaciente, GetHeridaID(), false, "e"), archivo)); } catch { }
        try { File.Delete(Path.Combine(Heridas.GetFinalPath((string)ViewState["id"], GetHeridaID(), false, "e"), archivo)); } catch {}
        CleanTemporalPath(GetHeridaID());
        Heridas.RebuildGalery(CCDetallePaciente.IdPaciente, (string)ViewState["id"], (string)ViewState["idherida"], "e", DFotos);
    }

    public void CleanTemporalPath(string id)
    {
        List<string> archivos = new List<string>();
        archivos.Add("temp");
        archivos.Add(CCDetallePaciente.IdPaciente);
        archivos.Add(id);

        for (int j = 0; j < archivos.Count; j++)
        {
            string archivo = Path.Combine(HomeCareVersion.FilesPath, "evolucion");
            for (int i = 0; i < archivos.Count - j; i++)
            {
                archivo = Path.Combine(archivo, archivos[i]);
            }
            try
            {
                Directory.Delete(archivo);
            }
            catch { }
        }
    }

    protected void BSubir_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        if (!FFoto.HasFile)
            return;

        string archivo = Path.Combine(Heridas.GetTemporalPath(CCDetallePaciente.IdPaciente, GetHeridaID(), true, "e"), FFoto.FileName);
        FFoto.SaveAs(archivo);

        Heridas.RebuildGalery(CCDetallePaciente.IdPaciente, (string)ViewState["id"], (string)ViewState["idherida"], "e",DFotos);

        ScriptManager.RegisterStartupScript(FFoto, typeof(string), "registro", "$('html, body').animate({scrollTop: $('#registrofotografico').offset().top}, 0);", true);
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&ehid=" + ((ImageButton)sender).CommandArgument);
    }

    protected void GHistorial_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            int funcionario = GHistorial.GetGridColumnIndex("Funcionario");
            e.Row.Cells[funcionario].Text = Funcionario.GetFuncionario(e.Row.Cells[funcionario].Text).Nombres;
        }
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

    protected string ImprimirPlanEducativo(GridView grid)
    {
        string resultado = "";
        for (int i = 0; i < grid.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)grid.Rows[i].FindControl("CSi");
            if (check.Checked)
            {
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += check.Text;
            }
        }
        if (resultado.Length == 0)
            resultado = "No se encontro";
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido
        evento.Contenido = evento.Contenido.Replace("$szPlanEducativo$", ImprimirPlanEducativo(GEducativo));
        evento.Contenido = evento.Contenido.Replace("$szClinica$", ImprimirPlanEducativo(GClinica));

        evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + TPlanManejo.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            evento.Contenido = evento.Contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, TFecha.Text, escala));
        }

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        if (GHeridas.Rows.Count > 0)
        {
            int inicio = evento.Contenido.IndexOf("<!-- seccionherida -->");
            int final = evento.Contenido.IndexOf("<!-- seccionheridaEnd -->");
            if (inicio != -1 && final != -1)
            {
                StringBuilder heridaCompleta = new StringBuilder(evento.Contenido.Substring(inicio, final - inicio));
                for (int i = GHeridas.Rows.Count - 2; i >= 0; i--)
                {
                    StringBuilder herida = new StringBuilder(heridaCompleta.ToString());
                    GHeridas.SelectedIndex = i;
                    GHeridas_SelectedIndexChanged(sender, e);
                    evento.Contenido = evento.Contenido.Insert(inicio, Utilidades.ReplaceContenido(Controls, herida.Replace("$szFotos$", Heridas.ImprimirFotos(CCDetallePaciente.IdPaciente, ViewState["id"].ToString(), ViewState["idherida"].ToString(), "e"))).ToString());
                }
            }
            GHeridas.SelectedIndex = GHeridas.Rows.Count - 1;
            GHeridas_SelectedIndexChanged(sender, e);
        }
        evento.Contenido = evento.Contenido.Replace("$szFotos$", Heridas.ImprimirFotos(CCDetallePaciente.IdPaciente, ViewState["id"].ToString()
            , GHeridas.Rows.Count > 0 ? ViewState["idherida"].ToString() : "", "e"));

        using (CConector conector = new CConector())
        {
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
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", UCFuncionario.IdFuncionario);
        }
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }

    protected void BAgregarHerida_Click(object sender, EventArgs e)
    {
        BCancelarHerida_Click(sender, e); // limpiamos primero el texto

        BAgregar.Enabled = Usuario.GetInstance().CanUpdate();
        BAgregar.Text = "Editar";
        PHerida.Visible =
        BAgregar.Visible = true;
        BEliminar.Visible = Usuario.GetInstance().CanDelete();
        BAgregarHerida.Visible = false;

        Heridas.RebuildGalery(CCDetallePaciente.IdPaciente, (string)ViewState["id"], (string)ViewState["idherida"], "e", DFotos);
    }
}
