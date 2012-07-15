using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Collections;
using SDG.Componentes;

public partial class rh_funcionario : System.Web.UI.Page
{
    class Empresas {

        public string ilabEmpresa { get; set; }
        public string ilabTelefono { get; set; }
        public string ilabJefeInmediato { get; set; }
        public string ilabAño { get; set; }

        public Empresas() {

        }

        public Empresas(string empresa, string telefono, string jefe, string ano) {

            ilabAño = ano;
            ilabEmpresa = empresa;
            ilabJefeInmediato = jefe;
            ilabTelefono = telefono;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Session["foto_tabla"] = "admPersonalHS";
        Session["foto_id"] = "perId";

        if (!IsPostBack)
        {
            Response.Cookies["tabpersonal"].Value = null;
            string ruta = "";
            for (int i = 0; i < Request.Url.Segments.Length-1; i++)
                ruta += Request.Url.Segments[i];
            Response.Cookies["tabpersonal"].Path = ruta;

            Session[Request.Url.AbsolutePath] = new ArrayList();
            // solo compatibilidad
            if (Request.QueryString["ip"] != null && Request.QueryString["ip"].Length>0)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?id=" + crypt.Desencriptar(Request.QueryString["ip"]));
                Response.End();
                return;
            }
            TApellidos.Focus();

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            lnkAgInfoLab.Visible = usuario.CanInsert();
            IEliminar.Visible = false;

            if (Request.QueryString["fid"]!=null && Request.QueryString["fid"].Length>0)
            {
                Query query = new Query("admPersonalHS");

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
                query += "nombre";

                CConectorMS conector = new CConectorMS();

                SqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(Request.QueryString["fid"]) + ""));

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
                    TFIngreso.Text = ConectorMS.GetDate(reader["perFechaIngreso"]);
                    TDocumento.Text = reader["perDocumento"].ToString();
                    TLExpedicion.Text = reader["perLugarExpedicion"].ToString();
                    TLMilitar.Text = reader["perNumLibretaMil"].ToString();
                    TDMilitar.Text = reader["perDistritoMil"].ToString();
                    TPasadoJudicial.Text = reader["perNumPasadoJudicial"].ToString();
                    TFPasadoJudicial.Text = ConectorMS.GetDate(reader["perFechaPasadoJudicial"]);
                    CTarjetaProfesional.Checked = reader["perTarjetaProfesional"].ToString() == "1" ? true : false;
                    TTarjetaNumero.Text = reader["perNumeroTP"].ToString();
                    TGrupoSanguineo.Text = reader["perGrupoSanguineo"].ToString();
                    TRH.Text = reader["perRH"].ToString();
                    DSexo.SelectedValue = reader["sexoId"].ToString();
                    TFechaNacimiento.Text = ConectorMS.GetDate(reader["perFechaNac"]);
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
                    CPazySalvo.Checked = reader["perPazySalvo"].ToString()=="1" ? true : false;
                    DEstado.SelectedValue = reader["eEstId"].ToString();
                    DCargo.SelectedValue = reader["carId"].ToString();
                    TFechaContrato.Text = ConectorMS.GetDate(reader["perFechaContrato"]);
                    DArea.SelectedValue = reader["areaId"].ToString();
                    DNivelComplejidad.SelectedValue = reader["nivCompId"].ToString();
                    DDisponibilidad.SelectedValue = reader["dispId"].ToString();
                    TCuenta.Text = reader["perNroCuenta"].ToString();
                    DBanco.SelectedValue = reader["banId"].ToString();
                    DTerminacion.Text = reader["mteId"].ToString();
                    TFechaTerminacion.Text = ConectorMS.GetDate(reader["perFechaTermContrato"]);
                    TParentesco.Text = reader["perParentescoContacto"].ToString();
                    DLocalidadVivienda.SelectedValue = reader["residencialocId"].ToString();
                    if (reader["nombre"].ToString().Length != 0)
                    {
                        IFoto.ImageUrl = "~/archivo/foto.ashx?w=120&i=" + HId.Value;
                        IFoto.PostBackUrl = "~/archivo/foto.ashx?i=" + HId.Value;
                        IEliminar.Visible = usuario.CanDelete();
                    }

                    conector.SelectInDropDown(DTipoContrato, reader["tipContId"], "SELECT tipContDesc FROM admTipoContrato WHERE tipContId='" + reader["tipContId"].ToString() + "'");
                    conector.SelectInDropDown(DProfesion, reader["profId"], "SELECT profNombre FROM admProfesion WHERE profId='" + reader["profId"].ToString() + "'");

                    ArrayList lista = (ArrayList)Session[Request.Url.AbsolutePath];
                    Query empresa= new Query("admInfoLaboral");

                    empresa+="ilabEmpresa";
                    empresa+="ilabTelefono";
                    empresa+="ilabAño";
                    empresa+="ilabJefeInmediato";

                    reader= conector.Query(empresa.GetSelect("perId = " + HId.Value ));
                    if(reader!=null) {
                        while(reader.Read()) {

                            lista.Add(new Empresas(reader["ilabEmpresa"].ToString(),
                            reader["ilabTelefono"].ToString(),
                            reader["ilabJefeInmediato"].ToString(),
                            reader["ilabAño"].ToString()));
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

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("admPersonalHS");

        query["perApellidos"] = TApellidos.Text;
        query["perNombres"] = TNombres.Text;
        query["perObservaciones"] = TObservaciones.Text;
        query["perFechaIngreso"] = TFIngreso.Text;
        query["perDocumento"] = TDocumento.Text;
        query["perLugarExpedicion"] = TLExpedicion.Text;
        query["perNumLibretaMil"] = TLMilitar.Text;
        query["perDistritoMil"] = TDMilitar.Text;
        query["perNumPasadoJudicial"] = TPasadoJudicial.Text;
        query["perFechaPasadoJudicial"] = TFPasadoJudicial.Text;
        query["perTarjetaProfesional"] = CTarjetaProfesional.Checked ? "1" : "0";
        query["perNumeroTP"] = TTarjetaNumero.Text;
        query["perGrupoSanguineo"] = TGrupoSanguineo.Text;
        query["perRH"] = TRH.Text;
        query["sexoId"] = DSexo.SelectedValue;
        query["perFechaNac"] = TFechaNacimiento.Text;
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
        query["perFechaContrato"] = TFechaContrato.Text;
        query["areaId"] = DArea.SelectedValue;
        query["nivCompId"] = DNivelComplejidad.SelectedValue;
        query["dispId"] = DDisponibilidad.SelectedValue;
        query["perNroCuenta"] = TCuenta.Text;
        query["banId"] = DBanco.SelectedValue;
        query["mteId"] = DTerminacion.SelectedValue;
        query["perFechaTermContrato"] = TFechaTerminacion.Text;
        query["profId"] = DProfesion.SelectedValue;
        query["perParentescoContacto"] = TParentesco.Text;
        query["residencialocId"] = DLocalidadVivienda.SelectedValue;
        if (HId.Value.Length != 0 && IFoto.PostBackUrl.Length == 0)
        {
            query["nombre"] = "";
            query["tipo"] = "";
            query["archivo"] = "";
        }

        CConectorMS conectorms = new CConectorMS();

        if (HId.Value.Length>0) {

            if (conectorms.QueryMod(query.GetUpdate("perId='" + HId.Value + "'")) == -1)
                return;
        } else {

            int res= conectorms.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            HId.Value = res.ToString();
        }
        CConector conector = new CConector();
        conector.InsertModificacion(HId.Value);

        if (FFoto.HasFile)
        {
            Archivos archivo = new Archivos(FFoto.PostedFile, Convert.ToInt32(HId.Value));
            archivo.SaveFile(new Query("admPersonalHS"));
        }
        else if (WebCam.GetFoto() != null) {
            Archivos archivo = new Archivos(WebCam.GetFoto(), Convert.ToInt32(HId.Value));
            archivo.SaveFile(new Query("admPersonalHS"));
        }

        if(conectorms.QueryMod("DELETE FROM admDocsPersonalHS WHERE perId=" + HId.Value )==-1)
            return;

        Query documentos = new Query("admDocsPersonalHS");
        documentos["perId"] = HId.Value;

        for (int i = 0; i < DDocumentos.Items.Count; i++ ) {

            CheckBox check = (CheckBox)DDocumentos.Items[i].FindControl("CDocumentos");
            if (check.Checked)
            {
                documentos["docId"] = DDocumentos.DataKeys[i].ToString();
                if (conectorms.QueryMod(documentos.GetInsert()) == -1)
                    return;
            }
        }

        for (int i = 0; i < DDocumentosContratista.Items.Count; i++)
        {
            CheckBox check = (CheckBox)DDocumentosContratista.Items[i].FindControl("CDocumentos");
            if (check.Checked)
            {
                documentos["docId"] = DDocumentosContratista.DataKeys[i].ToString();
                if (conectorms.QueryMod(documentos.GetInsert()) == -1)
                    return;
            }
        }

        if (conectorms.QueryMod("DELETE FROM admPersonalInfoProf WHERE perId=" + HId.Value) == -1)
            return;

        Query informacion = new Query("admPersonalInfoProf");
        informacion["perId"] = HId.Value;

        for (int i = 0; i < GInformacionProfesional.Rows.Count; i++ ) {

            CheckBox check = (CheckBox)GInformacionProfesional.Rows[i].FindControl("CEntregado");

            if (check.Checked)
            {
                informacion["ipId"] = GInformacionProfesional.DataKeys[i].Value.ToString();
                TextBox text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TAno");
                informacion["infAño"] = text.Text;
                text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TInstitucion");
                informacion["infInstitucion"] = text.Text;
                text = (TextBox)GInformacionProfesional.Rows[i].FindControl("TActa");
                informacion["infNroActa"] = text.Text;

                if (conectorms.QueryMod(informacion.GetInsert()) == -1)
                    return;
            }
        }

        if (conectorms.QueryMod("DELETE FROM admInfoLaboral WHERE perId=" + HId.Value) == -1)
            return;

        Query empresa = new Query("admInfoLaboral");
        empresa["perId"] = HId.Value;

        for (int i = 0; i < GEmpresas.Rows.Count; i++ ) {

            TextBox text= (TextBox) GEmpresas.Rows[i].FindControl("TEmpresa");
            empresa["ilabEmpresa"]= text.Text;
            text = (TextBox)GEmpresas.Rows[i].FindControl("TTelefono");
            empresa["ilabTelefono"]= text.Text;
            text = (TextBox)GEmpresas.Rows[i].FindControl("TAno");
            empresa["ilabAño"]= text.Text;
            text = (TextBox)GEmpresas.Rows[i].FindControl("TJefe");
            empresa["ilabJefeInmediato"] = text.Text;

            if (conectorms.QueryMod(empresa.GetInsert()) == -1)
                return;
        }

        ((MasterPageI)Master).SetResultado("Usuario " + TNombres.Text + " Editado.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void lnkAgInfoLab_Click(object sender, EventArgs e)
    {
        ArrayList lista = (ArrayList)Session[Request.Url.AbsolutePath];
        lista.Add(new Empresas());
        GEmpresas.DataSource = lista;
        GEmpresas.DataBind();
    }

    protected void GEmpresas_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        ArrayList lista = (ArrayList)Session[Request.Url.AbsolutePath];
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
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if (HttpUtility.HtmlDecode(e.Row.Cells[2].Text).Trim().Length == 0)
            {
                e.Row.Cells[2].Text = HttpUtility.HtmlEncode(Procedimientos.GetProcedimiento(HttpUtility.HtmlDecode(e.Row.Cells[3].Text).Trim()));
            }
        }
    }
}
