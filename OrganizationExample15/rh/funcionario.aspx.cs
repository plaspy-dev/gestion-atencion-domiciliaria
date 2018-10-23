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
using System.Drawing;
using OrganizationExample15;

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

    [Serializable]
    public class DescuentosOtros {
        public int Index { get; set; }
        public string Id { get; set; }
        public bool Deleted { get; set; }
        public DateTime Fecha { get; set; }
        public string Archivo { get; set; }
        public string Observaciones { get; set; }
        public DescuentosOtros() {
            Fecha = DateTime.Now;
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
            GDocumentos.Columns[0].Visible = usuario.CanDelete();
            GDO.Columns[0].Visible = usuario.CanDelete();

            List<DescuentosOtros> descuentos = new List<DescuentosOtros>();

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
                query += "laboraActualmente";
                query += "origen_tp";
                query += "cargos";
                query += "alerta";
                query += "descuentos";

                using (CConector conector = new CConector())
                {

                    MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(Request.QueryString["fid"]) + ""));

                    if (reader != null && reader.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        lnkAgInfoLab.Visible = usuario.CanUpdate();
                        GEmpresas.Columns[4].Visible = usuario.CanDelete();
                        HSello.Visible =
                        HFirma.Visible = true;

                        HId.Value = reader["perId"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);

                        HFirma.NavigateUrl = ResolveClientUrl(HFirma.NavigateUrl + HId.Value) + ".jpg?d=" + Query.GetMySQLDateFormat(DateTime.Now, true);
                        HSello.NavigateUrl = ResolveClientUrl(HSello.NavigateUrl + HId.Value) + ".jpg?d=" + Query.GetMySQLDateFormat(DateTime.Now, true);

                        HFirma.ImageUrl = ResolveClientUrl(HFirma.ImageUrl + HId.Value) + ".jpg?d=" + Query.GetMySQLDateFormat(DateTime.Now, true);
                        HSello.ImageUrl = ResolveClientUrl(HSello.ImageUrl + HId.Value) + ".jpg?d=" + Query.GetMySQLDateFormat(DateTime.Now, true);

                        TApellidos.Text = reader["perApellidos"].ToString();
                        TNombres.Text = reader["perNombres"].ToString();
                        TObservaciones.Text = reader["perObservaciones"].ToString();
                        TFIngreso.Text = Query.GetFromMySQLDate(reader["perFechaIngreso"]);
                        TDocumento.Text = reader["perDocumento"].ToString();
                        TLExpedicion.Text = reader["perLugarExpedicion"].ToString();
                        TLMilitar.Text = reader["perNumLibretaMil"].ToString();
                        TDMilitar.Text = reader["perDistritoMil"].ToString();
                        // TPasadoJudicial.Text = reader["perNumPasadoJudicial"].ToString();
                        TFPasadoJudicial.Text = Query.GetFromMySQLDate(reader["perFechaPasadoJudicial"]);
                        CTarjetaProfesional.Checked = reader["perTarjetaProfesional"].ToString() == "True" ? true : false;
                        TTarjetaNumero.Text = reader["perNumeroTP"].ToString();
                        TGrupoSanguineo.Text = reader["perGrupoSanguineo"].ToString();
                        TRH.Text = reader["perRH"].ToString();
                        Utilidades.SelectInDropDown(DSexo, reader["sexoId"]);
                        TFechaNacimiento.Text = Query.GetFromMySQLDate(reader["perFechaNac"]);
                        TDireccion.Text = reader["perDireccion"].ToString();
                        TBarrio.Text = reader["perBarrio"].ToString();
                        TTelefono.Text = reader["perTelefono"].ToString();
                        TTelefono2.Text = reader["perTelefono1"].ToString();
                        TMovil.Text = reader["perCelular"].ToString();
                        TEMail.Text = reader["perCorreoElectronico"].ToString();
                        Utilidades.SelectInDropDown(DEstadoCivil, reader["estCivilId"]);
                        THijos.Text = reader["perNumHijos"].ToString();
                        TConyuge.Text = reader["perNomConyugue"].ToString();
                        TContacto.Text = reader["perContacto"].ToString();
                        TTelefonoContacto.Text = reader["perTelContacto"].ToString();
                        Utilidades.SelectInDropDown(DEPS, reader["entIdEPS"]);
                        Utilidades.SelectInDropDown(DFOP, reader["entIdAFP"]);
                        Utilidades.SelectInDropDown(DARP, reader["entIdARP"]);
                        Utilidades.SelectInDropDown(DLocalidad, reader["locId"]);
                        CPazySalvo.Checked = reader["perPazySalvo"].ToString() == "True";
                        TAlerta.Text = reader["alerta"].ToString();
                        PAlerta.Visible = CAlerta.Checked = TAlerta.Text.Length > 0;
                        if (CAlerta.Checked)
                            TObservaciones.Text += " " + TAlerta.Text;

                        Utilidades.SelectInDropDown(DEstado, reader["eEstId"]);
                        Utilidades.SelectInDropDown(DCargo, reader["carId"]);
                        LCargo.DataBind();
                        string[] cargos = reader["cargos"].ToString().Split(',');
                        foreach (ListItem item in LCargo.Items) {
                            item.Selected = cargos.Contains(item.Value);
                        }
                        TFechaContrato.Text = Query.GetFromMySQLDate(reader["perFechaContrato"]);
                        Utilidades.SelectInDropDown(DArea, reader["areaId"]);
                        // DNivelComplejidad.SelectedValue = reader["nivCompId"].ToString();
                        Utilidades.SelectInDropDown(DDisponibilidad, reader["dispId"]);
                        TCuenta.Text = reader["perNroCuenta"].ToString();
                        Utilidades.SelectInDropDown(DBanco, reader["banId"]);
                        DTerminacion.Text = reader["mteId"].ToString();
                        TFechaTerminacion.Text = Query.GetFromMySQLDate(reader["perFechaTermContrato"]);
                        TParentesco.Text = reader["perParentescoContacto"].ToString();
                        Utilidades.SelectInDropDown(DLocalidadVivienda, reader["residencialocId"]);
                        TInicioDescanso.Text = Query.GetFromMySQLDate(reader["inicio_descanso"]);
                        TFinDescanso.Text = Query.GetFromMySQLDate(reader["fin_descanso"]);
                        TVerificacionTitulos.Text = Query.GetFromMySQLDate(reader["verificacionTitulos"]);
                        Utilidades.SelectInDropDown(DOrigenTarjeta, reader["origen_tp"]);

                        string[] actualmente = reader["laboraActualmente"].ToString().Split(',');

                        CLaboraActualmente.DataBind();
                        foreach (ListItem item in CLaboraActualmente.Items) {
                            foreach (string emp in actualmente)
                            {
                                item.Selected = item.Value == emp;
                            }
                        }

                        IFoto.ImageUrl = "~/archivo/imagen.ashx?w=120&t=r&n=" + HId.Value + ".jpg";
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

                        query = new Query("recurso_humano_descuentos");

                        query += "id";
                        query += "fecha";
                        query += "archivo";
                        query += "observaciones";

                        reader = conector.Query(query.GetSelect("paciente={0}", null, Query.GetValor(HId.Value)));
                        if (reader != null) {
                            while (reader.Read()) {

                                DescuentosOtros info = new DescuentosOtros();

                                info.Fecha = (DateTime)reader["fecha"];
                                info.Archivo = reader["archivo"].ToString();
                                info.Observaciones = reader["observaciones"].ToString();
                                info.Id = reader["id"].ToString();

                                descuentos.Add(info);
                            }
                        }

                        GResultados.AllowPaging = false;
                        GResultados.DataBind();
                        LTotal.Text = GResultados.Rows.Count + " Sesiones";
                        GResultados.AllowPaging = true;
                        GResultados.DataBind();
                    }
                }
            }

            descuentos.Add(new DescuentosOtros());

            int index = 0;
            descuentos.ForEach(x => x.Index = index++);

            GDO.DataSource = descuentos;
            GDO.DataBind();
            ViewState["descuentos"] = descuentos;
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

    /*public Bitmap CropImage(Bitmap source, Rectangle section)
    {
        // An empty bitmap which will hold the cropped image
        Bitmap bmp = new Bitmap(section.Width, section.Height);
        using (Graphics g = Graphics.FromImage(bmp))
        {
            // Draw the given area (section) of the source image
            // at location 0,0 on the empty bitmap (bmp)
            g.DrawImage(source, 0, 0, section, GraphicsUnit.Pixel);
            return bmp;
        }
    }*/

    public bool CheckFirmas(Bitmap firmaysello, bool rotate=true) {

        int ystart = 420;
        int xstart = 250;
        int width = 550;
        int height = 260;

        if (firmaysello.Width < xstart + width || firmaysello.Height<ystart+height) // El archivo es mas pequeño de lo pensado
            return false;

        using (Bitmap firma2 = firmaysello.Clone(new Rectangle(xstart, ystart, width, height), firmaysello.PixelFormat))
        {
            using (Bitmap firma = FileStorage.CropSign(firma2)) 
            {
                if (firma == null)
                {
                    if (rotate)
                    {
                        firmaysello.RotateFlip(RotateFlipType.Rotate180FlipNone);
                        return CheckFirmas(firmaysello, false);
                    }
                    return false;
                }
                string archivo = Path.Combine(HomeCareVersion.FilesPath, "firmas");
                Directory.CreateDirectory(archivo);
                archivo = Path.Combine(archivo, HId.Value + ".jpg");
                firma.Save(archivo);
            }
        }
        xstart = 900;
        using (Bitmap sello2 = firmaysello.Clone(new Rectangle(xstart, ystart, width, height), firmaysello.PixelFormat))
        {
            using (Bitmap sello = FileStorage.CropSign(sello2))
            {
                if (sello == null)
                    return false;

                string archivo = Path.Combine(HomeCareVersion.FilesPath, "sellos");
                Directory.CreateDirectory(archivo);
                archivo = Path.Combine(archivo, HId.Value + ".jpg");
                sello.Save(archivo);
            }
        }

        return true;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        if (DEstado.SelectedItem.Text == "VACACIONES" || DEstado.SelectedItem.Text == "LICENCIA TEMPORAL") {
            if (TInicioDescanso.Text.Length == 0 || TFinDescanso.Text.Length == 0) {
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
        // query["perNumPasadoJudicial"] = TPasadoJudicial.Text;
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
        query["alerta"] = CAlerta.Checked ? TAlerta.Text : "";
        query["eEstId"] = DEstado.SelectedValue;
        query["carId"] = DCargo.SelectedValue;
        query["cargos"]= string.Join(",", LCargo.Items.Cast<ListItem>().Where(x => x.Selected).Select(x => x.Value));
        query["tipContId"] = DTipoContrato.SelectedValue;
        query["perFechaContrato"] = Query.GetMySQLDateFormat(TFechaContrato.Text);
        query["areaId"] = DArea.SelectedValue;
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
        query["origen_tp"] = DOrigenTarjeta.SelectedValue;

        string actualmente="";

        foreach (ListItem item in CLaboraActualmente.Items)
        {
            if (item.Selected)
            {
                actualmente = string.Format("{0}{1}{2}", actualmente, actualmente.Length>0 ? "," : "", item.Value);
            }
        }
        query["laboraActualmente"] = actualmente;

        if (DEstado.SelectedItem.Text == "VACACIONES" || DEstado.SelectedItem.Text == "LICENCIA TEMPORAL")
        {
            query["inicio_descanso"] = Query.GetMySQLDateFormat(TInicioDescanso.Text);
            query["fin_descanso"] = Query.GetMySQLDateFormat(TFinDescanso.Text);
        } else {
            query["inicio_descanso"] = "";
            query["fin_descanso"] = "";
        }

        int digitalizacion = 0;
        if (FFirma.HasFile) {
            digitalizacion = 3;
        }
        if (FFirmaO.HasFile) {
            digitalizacion |= 1;
        }
        if (FSelloO.HasFile) {
            digitalizacion |= 2;
        }

        if(digitalizacion>0)
            query["digitalizacion"] = digitalizacion;

        string id = HId.Value;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            if (!string.IsNullOrEmpty(id))
            {
                if (conector.QueryMod(query.GetUpdate("perId='" + HId.Value + "'")) == -1)
                    return;
            }
            else
            {

                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                id = res.ToString();
            }
            
            conector.InsertModificacion(id);

            Directory.CreateDirectory(Path.Combine(HomeCareVersion.FilesPath, "rh"));
            string foto = Path.Combine(Path.Combine(HomeCareVersion.FilesPath, "rh"), id + ".jpg");
            
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

            // Tratamos de cortar la firma
            if (FFirma.HasFile)
            {
                using (Bitmap firmaysello = new Bitmap(FFirma.FileContent))
                {
                    if (!CheckFirmas(firmaysello)) {
                        LMensaje.Text = "El archivo " + FFirma.FileName + " parece no contener un archivo con firmas y sello valido.";
                        return;
                    }
                }
            }

            if (FFirmaO.HasFile) {
                string archivo = Path.Combine(HomeCareVersion.FilesPath, "firmas");
                Directory.CreateDirectory(archivo);
                archivo = Path.Combine(archivo, id + ".jpg");
                if (File.Exists(archivo))
                    File.Delete(archivo);
                FFirmaO.SaveAs(archivo);
            }

            if (FSelloO.HasFile) {
                string archivo = Path.Combine(HomeCareVersion.FilesPath, "sellos");
                Directory.CreateDirectory(archivo);
                archivo = Path.Combine(archivo, id + ".jpg");
                if (File.Exists(archivo))
                    File.Delete(archivo);
                FSelloO.SaveAs(archivo);
            }

            if (conector.QueryMod("DELETE FROM recurso_humano_documento WHERE perId=" + id) == -1)
                return;

            Query documentos = new Query("recurso_humano_documento");
            documentos["perId"] = id;

            foreach (GridViewRow row in GDocumentos.Rows)
            {
                string extension = GDocumentos.DataKeys[row.RowIndex].Values["archivo"] as string;
                // bool _checked= ((CheckBox)row.FindControl("E")).Checked;
                bool _checked = false;
                string vencimiento = Query.GetMySQLDateFormat(((TextBox)row.FindControl("T")).Text);

                string idDocumento = GDocumentos.DataKeys[row.RowIndex].Values["id"].ToString();
                documentos["docId"] = idDocumento;
                documentos["vencimiento"] = vencimiento;
                
                FileUpload file = (FileUpload)row.FindControl("F");
                if (file.HasFile)
                {
                    _checked = true;
                    extension = Path.GetExtension(file.FileName).ToLower();
                    file.SaveAs(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, idDocumento + extension));
                }

                if (!_checked && string.IsNullOrEmpty(extension) && string.IsNullOrEmpty(vencimiento))
                    continue;

                documentos["archivo"] = extension;
                if (conector.QueryMod(documentos.GetInsertUpdate()) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                documentos.RemoveCampo("archivo");
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


            List<DescuentosOtros> descuentos = ViewState["descuentos"] as List<DescuentosOtros>;
            if (descuentos == null)
                descuentos = new List<DescuentosOtros>();

            foreach (DescuentosOtros info in descuentos.Where(x => x.Deleted))
            {
                if (conector.QueryMod(documentos.GetDelete("id={0}", Query.GetValor(info.Id))) == -1)
                    return;
            }

            foreach (GridViewRow row in GDO.Rows)
            {
                documentos = new Query("recurso_humano_descuentos");

                string Id = GDO.DataKeys[row.RowIndex].Values["Id"] as string;
                string obsevaciones = ((TextBox)row.FindControl("T")).Text;

                documentos["observaciones"] = obsevaciones;

                FileUpload file = (FileUpload)row.FindControl("F");
                if (file.HasFile)
                {
                    documentos["archivo"] = file.FileName;
                }
                else if (string.IsNullOrEmpty(Id))
                { // Omitimos los que no tienen archivo
                    continue;
                }

                if (string.IsNullOrEmpty(Id))
                {
                    documentos["fecha"] = "NOW()";
                    documentos["paciente"] = id;

                    int res = conector.QueryMod(documentos.GetInsert());
                    if (res == -1)
                        return;
                    Id = res.ToString();
                }
                else
                {
                    if (conector.QueryMod(documentos.GetUpdate("id={0}", Query.GetValor(Id))) == -1)
                        return;
                }

                if (file.HasFile)
                {
                    file.SaveAs(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, "descuentos", Id, file.FileName));
                }
            }

            if (conector.QueryMod("DELETE FROM recurso_humano_formacion WHERE perId=" + id) == -1)
                return;

            Query informacion = new Query("recurso_humano_formacion");
            informacion["perId"] = id;

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

            if (conector.QueryMod("DELETE FROM recurso_humano_info_laboral WHERE perId=" + id) == -1)
                return;

            Query empresa = new Query("recurso_humano_info_laboral");
            empresa["perId"] = id;

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

            if (conector.QueryMod("DELETE FROM recurso_humano_curso WHERE funcionario=" + id) == -1)
                return;

            Query curso= new Query("recurso_humano_curso");
            curso["funcionario"] = id;

            for (int i = 0; i < GCursos.Rows.Count; i++) {

                TextBox text = (TextBox)GCursos.Rows[i].FindControl("F");
                if (text.Text.Length > 0) {
                    curso["vencimiento"] = Query.GetMySQLDateFormat(text.Text);
                    curso["curso"] = GCursos.DataKeys[i].Values["id"].ToString();

                    if (conector.QueryMod(curso.GetInsert()) == -1)
                        return;
                }
            }

            // actualizamos la informacion del paciente
            if (conector.QueryMod("UPDATE usuario SET estado={0} WHERE personal={1} AND (estado IS NULL OR estado!=-1)"
                , false
                , DEstado.SelectedValue=="1" ? "NULL" : "0"
                , id ) == -1)
                return;

            conector.Commit();
            Funcionario.RemoveFuncionario(id);
        }

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

    protected void IEliminar_Click(object sender, EventArgs e)
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

    protected void GDocumentos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        string id = HId.Value;
        string idDocumento = e.Keys["id"].ToString();
        if (string.IsNullOrEmpty(id))
            return;

        Query query = new Query("recurso_humano_documento");

        using (CConector conector = new CConector())
        {
            if (conector.QueryMod(query.GetDelete("perId={0} AND docId={1}", id, idDocumento)) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
        }
        try { File.Delete(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, idDocumento + ".jpg")); } catch { }
        try { File.Delete(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, idDocumento + ".pdf")); } catch { }

        GDocumentos.DataBind();
    }

    public void OnValidaFileJPGPDF(object sender, ServerValidateEventArgs e)
    {

        Files.OnValidaFileJPGPDF(sender, e);
    }

    protected void GDO_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<DescuentosOtros> descuentos = ViewState["descuentos"] as List<DescuentosOtros>;
        if (descuentos == null)
            descuentos = new List<DescuentosOtros>();

        DescuentosOtros info= descuentos.Find(x=>x.Index== (int)e.Keys["Index"]);
        if (string.IsNullOrEmpty(info.Id)) {
            descuentos.Remove(info);
            int index = 0;
            descuentos.ForEach(x => x.Index = index++);
        } else info.Deleted = true;

        GDO.DataSource = descuentos.Where(x=>!x.Deleted);
        GDO.DataBind();
        ViewState["descuentos"] = descuentos;
    }

    protected void BADO_Click(object sender, EventArgs e)
    {
        List<DescuentosOtros> descuentos = ViewState["descuentos"] as List<DescuentosOtros>;
        if (descuentos == null)
            descuentos = new List<DescuentosOtros>();

        descuentos.Add(new DescuentosOtros() { Index = descuentos.Count });

        GDO.DataSource = descuentos.Where(x => !x.Deleted);
        GDO.DataBind();
        ViewState["descuentos"] = descuentos;
    }
}
