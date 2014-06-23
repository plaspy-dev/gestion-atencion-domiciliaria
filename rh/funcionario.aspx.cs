using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Collections;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.IO;

public partial class rh_funcionario : System.Web.UI.Page
{
    [Serializable] 
    class Empresas {

        public string ilabEmpresa { get; set; }
        public string ilabTelefono { get; set; }
        public string ilabJefeInmediato { get; set; }
        public string ilabAno { get; set; }

        public Empresas() {

        }

        public Empresas(string empresa, string telefono, string jefe, string ano) {

            ilabAno = ano;
            ilabEmpresa = empresa;
            ilabJefeInmediato = jefe;
            ilabTelefono = telefono;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Response.Cookies["tabpersonal"].Value = null;
            string ruta = "";
            for (int i = 0; i < Request.Url.Segments.Length-1; i++)
                ruta += Request.Url.Segments[i];
            Response.Cookies["tabpersonal"].Path = ruta;

            ViewState["infolaboral"] = new ArrayList();
            // Session[Request.Url.AbsolutePath] = new ArrayList();
            // solo compatibilidad
            if (Request.QueryString["ip"] != null && Request.QueryString["ip"].Length>0)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?id=" + Crypt.DesencriptarDES(Request.QueryString["ip"]));
                Response.End();
                return;
            }
            TApellidos.Focus();

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            lnkAgInfoLab.Visible = usuario.CanInsert();
            IEliminar.Visible = false;

            if (Request.QueryString["fid"] != null && Request.QueryString["fid"].Length > 0)
            {
                Query query = new Query("recurso_humano");

                query += "perId";
                query += "perApellidos";
                query += "perNombres";
                query += "perObservaciones";
                query += "perFechaIngreso";
                query += "perDocumento";
                query += "perLugarExpedicion";
                query += "perNumLibretaMil";
                query += "perDistritoMil";
                query += "perNumPasadoJudicial";
                query += "perFechaPasadoJudicial";
                query += "perTarjetaProfesional";
                query += "perNumeroTP";
                query += "perGrupoSanguineo";
                query += "perRH";
                query += "sexoId";
                query += "perFechaNac";
                query += "perDireccion";
                query += "perBarrio";
                query += "perTelefono";
                query += "perTelefono1";
                query += "perCelular";
                query += "perCorreoElectronico";
                query += "estCivilId";
                query += "perNumHijos";
                query += "perNomConyugue";
                query += "perContacto";
                query += "perTelContacto";
                query += "entIdEPS";
                query += "entIdAFP";
                query += "entIdARP";
                query += "locId";
                query += "perPazySalvo";
                query += "eEstId";
                query += "carId";
                query += "tipContId";
                query += "perFechaContrato";
                query += "areaId";
                query += "nivCompId";
                query += "dispId";
                query += "perNroCuenta";
                query += "banId";
                query += "mteId";
                query += "perFechaTermContrato";
                query += "profId";
                query += "perParentescoContacto";
                query += "residencialocId";
                query += "inicio_descanso";
                query += "fin_descanso";
                query += "verificacionTitulos";

                using (CConector conector = new CConector())
                {

                    MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(Request.QueryString["fid"]) + ""));

                    if (reader != null && reader.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        lnkAgInfoLab.Visible = usuario.CanUpdate();
                        GEmpresas.Columns[4].Visible = usuario.CanDelete();

                        HId.Value = reader["perId"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);

                        TApellidos.Text = reader["perApellidos"].ToString();
                        TNombres.Text = reader["perNombres"].ToString();
                        TObservaciones.Text = reader["perObservaciones"].ToString();
                        TFIngreso.Text = Query.GetFromMySQLDate(reader["perFechaIngreso"]);
                        TDocumento.Text = reader["perDocumento"].ToString();
                        TLExpedicion.Text = reader["perLugarExpedicion"].ToString();
                        TLMilitar.Text = reader["perNumLibretaMil"].ToString();
                        TDMilitar.Text = reader["perDistritoMil"].ToString();
                        TPasadoJudicial.Text = reader["perNumPasadoJudicial"].ToString();
                        TFPasadoJudicial.Text = Query.GetFromMySQLDate(reader["perFechaPasadoJudicial"]);
                        CTarjetaProfesional.Checked = reader["perTarjetaProfesional"].ToString() == "True" ? true : false;
                        TTarjetaNumero.Text = reader["perNumeroTP"].ToString();
                        TGrupoSanguineo.Text = reader["perGrupoSanguineo"].ToString();
                        TRH.Text = reader["perRH"].ToString();
                        DSexo.SelectedValue = reader["sexoId"].ToString();
                        TFechaNacimiento.Text = Query.GetFromMySQLDate(reader["perFechaNac"]);
                        TDireccion.Text = reader["perDireccion"].ToString();
                        TBarrio.Text = reader["perBarrio"].ToString();
                        TTelefono.Text = reader["perTelefono"].ToString();
                        TTelefono2.Text = reader["perTelefono1"].ToString();
                        TMovil.Text = reader["perCelular"].ToString();
                        TEMail.Text = reader["perCorreoElectronico"].ToString();
                        DEstadoCivil.SelectedValue = reader["estCivilId"].ToString();
                        THijos.Text = reader["perNumHijos"].ToString();
                        TConyuge.Text = reader["perNomConyugue"].ToString();
                        TContacto.Text = reader["perContacto"].ToString();
                        TTelefonoContacto.Text = reader["perTelContacto"].ToString();
                        DEPS.SelectedValue = reader["entIdEPS"].ToString();
                        DFOP.SelectedValue = reader["entIdAFP"].ToString();
                        DARP.SelectedValue = reader["entIdARP"].ToString();
                        DLocalidad.SelectedValue = reader["locId"].ToString();
                        CPazySalvo.Checked = reader["perPazySalvo"].ToString() == "True" ? true : false;
                        DEstado.SelectedValue = reader["eEstId"].ToString();
                        DCargo.SelectedValue = reader["carId"].ToString();
                        TFechaContrato.Text = Query.GetFromMySQLDate(reader["perFechaContrato"]);
                        DArea.SelectedValue = reader["areaId"].ToString();
                        DNivelComplejidad.SelectedValue = reader["nivCompId"].ToString();
                        DDisponibilidad.SelectedValue = reader["dispId"].ToString();
                        TCuenta.Text = reader["perNroCuenta"].ToString();
                        DBanco.SelectedValue = reader["banId"].ToString();
                        DTerminacion.Text = reader["mteId"].ToString();
                        TFechaTerminacion.Text = Query.GetFromMySQLDate(reader["perFechaTermContrato"]);
                        TParentesco.Text = reader["perParentescoContacto"].ToString();
                        DLocalidadVivienda.SelectedValue = reader["residencialocId"].ToString();
                        TInicioDescanso.Text = Query.GetFromMySQLDate(reader["inicio_descanso"]);
                        TFinDescanso.Text = Query.GetFromMySQLDate(reader["fin_descanso"]);
                        TVerificacionTitulos.Text = Query.GetFromMySQLDate(reader["verificacionTitulos"]);

                        IFoto.ImageUrl = "~/archivo/imagen.ashx?w=120&t=r&n=" + HId.Value +".jpg";
                        IFoto.PostBackUrl = "~/archivo/imagen.ashx?t=r&n=" + HId.Value + ".jpg";
                        IEliminar.Visible = usuario.CanDelete();

                        conector.SelectInDropDown(DTipoContrato, reader["tipContId"], "SELECT tipContDesc FROM tipo_contrato WHERE tipContId='" + reader["tipContId"].ToString() + "'");
                        conector.SelectInDropDown(DProfesion, reader["profId"], "SELECT profNombre FROM admProfesion WHERE profId='" + reader["profId"].ToString() + "'");

                        ArrayList lista = (ArrayList)ViewState["infolaboral"]; // Session[Request.Url.AbsolutePath];
                        Query empresa = new Query("recurso_humano_info_laboral");

                        empresa += "ilabEmpresa";
                        empresa += "ilabTelefono";
                        empresa += "ilabAno";
                        empresa += "ilabJefeInmediato";

                        reader = conector.Query(empresa.GetSelect("perId = " + HId.Value));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {

                                lista.Add(new Empresas(reader["ilabEmpresa"].ToString(),
                                reader["ilabTelefono"].ToString(),
                                reader["ilabJefeInmediato"].ToString(),
                                reader["ilabAno"].ToString()));
                            }
                        }
                        GEmpresas.DataSource = lista;
                        GEmpresas.DataBind();


                        GResultados.AllowPaging = false;
                        GResultados.DataBind();
                        LTotal.Text = GResultados.Rows.Count + " Sesiones";
                        GResultados.AllowPaging = true;
                        GResultados.DataBind();
                    }
                }
            }
        }
    }

    public string JoinNames(string[] nombres)
    {
        string resultado = "";
        foreach (string nombre in nombres)
        {
            resultado += " " + nombre.Trim();
            resultado.Trim();
        }
        return resultado;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        if(DEstado.SelectedItem.Text=="VACACIONES" || DEstado.SelectedItem.Text=="LICENCIA TEMPORAL") {
            if(TInicioDescanso.Text.Length==0 || TFinDescanso.Text.Length==0) {
                LMensaje.Text = "Por favor ingrese una fecha de inicio y fin del descanso";
                TInicioDescanso.Focus();
                return;
            }
        }

        Query query = new Query("recurso_humano");

        query["perApellidos"] = TApellidos.Text;
        query["perNombres"] = TNombres.Text;
        query["perObservaciones"] = TObservaciones.Text;
        query["perFechaIngreso"] = Query.GetMySQLDateFormat(TFIngreso.Text);
        query["perDocumento"] = TDocumento.Text;
        query["perLugarExpedicion"] = TLExpedicion.Text;
        query["perNumLibretaMil"] = TLMilitar.Text;
        query["perDistritoMil"] = TDMilitar.Text;
        query["perNumPasadoJudicial"] = TPasadoJudicial.Text;
        query["perFechaPasadoJudicial"] = Query.GetMySQLDateFormat(TFPasadoJudicial.Text);
        query["perTarjetaProfesional"] = CTarjetaProfesional.Checked ? "1" : "0";
        query["perNumeroTP"] = TTarjetaNumero.Text;
        query["perGrupoSanguineo"] = TGrupoSanguineo.Text;
        query["perRH"] = TRH.Text;
        query["sexoId"] = DSexo.SelectedValue;
        query["perFechaNac"] = Query.GetMySQLDateFormat(TFechaNacimiento.Text);
        query["perDireccion"] = TDireccion.Text;
        query["perBarrio"] = TBarrio.Text;
        query["perTelefono"] = TTelefono.Text;
        query["perTelefono1"] = TTelefono2.Text;
        query["perCelular"] = TMovil.Text;
        query["perCorreoElectronico"] = TEMail.Text;
        query["estCivilId"] = DEstadoCivil.SelectedValue;
        query["perNumHijos"] = THijos.Text;
        query["perNomConyugue"] = TConyuge.Text;
        query["perContacto"] = TContacto.Text;
        query["perTelContacto"] = TTelefonoContacto.Text;
        query["entIdEPS"] = DEPS.SelectedValue;
        query["entIdAFP"] = DFOP.SelectedValue;
        query["entIdARP"] = DARP.SelectedValue;
        query["locId"] = DLocalidad.SelectedValue;
        query["perPazySalvo"] = CPazySalvo.Checked ? "1" : "0";
        query["eEstId"] = DEstado.SelectedValue;
        query["carId"] = DCargo.SelectedValue;
        query["tipContId"] = DTipoContrato.SelectedValue;
        query["perFechaContrato"] = Query.GetMySQLDateFormat(TFechaContrato.Text);
        query["areaId"] = DArea.SelectedValue;
        query["nivCompId"] = DNivelComplejidad.SelectedValue;
        query["dispId"] = DDisponibilidad.SelectedValue;
        query["perNroCuenta"] = TCuenta.Text;
        query["banId"] = DBanco.SelectedValue;
        query["mteId"] = DTerminacion.SelectedValue;
        query["perFechaTermContrato"] = Query.GetMySQLDateFormat(TFechaTerminacion.Text);
        query["profId"] = DProfesion.SelectedValue;
        query["perParentescoContacto"] = TParentesco.Text;
        query["residencialocId"] = DLocalidadVivienda.SelectedValue;
        query["verificacionTitulos"] = Query.GetMySQLDateFormat(TVerificacionTitulos.Text);
        query["perNombre"] = JoinNames(new string[] { TApellidos.Text, TNombres.Text });

        if (DEstado.SelectedItem.Text == "VACACIONES" || DEstado.SelectedItem.Text == "LICENCIA TEMPORAL")
        {
            query["inicio_descanso"] = Query.GetMySQLDateFormat(TInicioDescanso.Text);
            query["fin_descanso"] = Query.GetMySQLDateFormat(TFinDescanso.Text);
        } else {
            query["inicio_descanso"] = "";
            query["fin_descanso"] = "";
        }

        using (CConector conector = new CConector())
        {
            // conector.StartTransaction();

            if (HId.Value.Length > 0)
            {
                if (conector.QueryMod(query.GetUpdate("perId='" + HId.Value + "'")) == -1)
                    return;
            }
            else
            {

                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HId.Value = res.ToString();
            }
            
            conector.InsertModificacion(HId.Value);

            Directory.CreateDirectory(Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "rh"));
            string foto = Path.Combine(Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "rh"), HId.Value + ".jpg");
            
            if (IFoto.PostBackUrl.Length == 0)
            {
                File.Delete(foto);
            }

            if (FFoto.HasFile)
            {
                File.Delete(foto);
                FFoto.SaveAs(foto);
            } else if (WebCam.GetFoto() != null) {
                File.Delete(foto);
                using (FileStream file = File.Open(foto, FileMode.CreateNew))
                {
                    byte[] contenido = WebCam.GetFoto();
                    file.Write(contenido, 0, contenido.Length);
                    file.Close();
                }
            }

            if (conector.QueryMod("DELETE FROM recurso_humano_documento WHERE perId=" + HId.Value) == -1)
                return;

            Query documentos = new Query("recurso_humano_documento");
            documentos["perId"] = HId.Value;

            for (int i = 0; i < DDocumentos.Items.Count; i++)
            {

                CheckBox check = (CheckBox)DDocumentos.Items[i].FindControl("CDocumentos");
                if (check.Checked)
                {
                    documentos["docId"] = DDocumentos.DataKeys[i].ToString();
                    if (conector.QueryMod(documentos.GetInsert()) == -1)
                        return;
                }
            }

            for (int i = 0; i < DDocumentosContratista.Items.Count; i++)
            {
                CheckBox check = (CheckBox)DDocumentosContratista.Items[i].FindControl("CDocumentos");
                if (check.Checked)
                {
                    documentos["docId"] = DDocumentosContratista.DataKeys[i].ToString();
                    if (conector.QueryMod(documentos.GetInsert()) == -1)
                        return;
                }
            }

            if (conector.QueryMod("DELETE FROM recurso_humano_formacion WHERE perId=" + HId.Value) == -1)
                return;

            Query informacion = new Query("recurso_humano_formacion");
            informacion["perId"] = HId.Value;

            for (int i = 0; i < GInformacionProfesional.Rows.Count; i++)
            {

                CheckBox check = (CheckBox)GInformacionProfesional.Rows[i].FindControl("CEntregado");

                if (check.Checked)
                {
                    informacion["ipId"] = GInformacionProfesional.DataKeys[i].Value.ToString();
                    TextBox text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TAno");
                    informacion["infAno"] = text.Text;
                    text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TInstitucion");
                    informacion["infInstitucion"] = text.Text;
                    text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TActa");
                    informacion["infNroActa"] = text.Text;

                    if (conector.QueryMod(informacion.GetInsert()) == -1)
                        return;
                }
            }

            if (conector.QueryMod("DELETE FROM recurso_humano_info_laboral WHERE perId=" + HId.Value) == -1)
                return;

            Query empresa = new Query("recurso_humano_info_laboral");
            empresa["perId"] = HId.Value;

            for (int i = 0; i < GEmpresas.Rows.Count; i++)
            {

                TextBox text = (TextBox)GEmpresas.Rows[i].FindControl("TEmpresa");
                empresa["ilabEmpresa"] = text.Text;
                text = (TextBox)GEmpresas.Rows[i].FindControl("TTelefono");
                empresa["ilabTelefono"] = text.Text;
                text = (TextBox)GEmpresas.Rows[i].FindControl("TAno");
                empresa["ilabAno"] = text.Text;
                text = (TextBox)GEmpresas.Rows[i].FindControl("TJefe");
                empresa["ilabJefeInmediato"] = text.Text;

                if (conector.QueryMod(empresa.GetInsert()) == -1)
                    return;
            }

            Funcionario.RemoveFuncionario(HId.Value);
        }

        // conector.Commit();
        ((MasterPageI)Master).SetResultado("Usuario " + TNombres.Text + " Editado.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void lnkAgInfoLab_Click(object sender, EventArgs e)
    {
        ArrayList lista = (ArrayList)ViewState["infolaboral"]; // Session[Request.Url.AbsolutePath];
        lista.Add(new Empresas());
        GEmpresas.DataSource = lista;
        GEmpresas.DataBind();
    }

    protected void GEmpresas_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        ArrayList lista = (ArrayList)ViewState["infolaboral"]; // Session[Request.Url.AbsolutePath];
        lista.RemoveAt(e.RowIndex);
        GEmpresas.DataSource = lista;
        GEmpresas.DataBind();
    }

    protected void IEliminar_Click(object sender, ImageClickEventArgs e)
    {
        IFoto.PostBackUrl = "";
        IFoto.ImageUrl = "";
        IEliminar.Visible = false;
    }
    protected void OnValidaFileJPG(object sender, ServerValidateEventArgs e)
    {
        e.IsValid = false;
        if(e.Value.Length!=0) {
            string Extension = e.Value.Substring(e.Value.LastIndexOf(".") + 1).ToLower();
            e.IsValid = Extension == "jpg" || Extension == "jpeg"; // Valid file type
        }
    }
}
