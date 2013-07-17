using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class cliente_quejas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            if (Request.QueryString["qid"] != null)
            {
                Query query = new Query("serQuejasReclamos");

                query += "qrId";
                query += "qrFecha";
                query += "tqrIdTipo";
                query += "qrPersonaLlama";
                query += "qrParentesco";
                query += "qrEmail";
                query += "qrTelefono";
                query += "qrDetalle";
                query += "qrObsHS";
                query += "pacId";
                query += "perId";
                query += "clasificacion";

                using (CConectorMS conector = new CConectorMS())
                {
                    SqlDataReader reader = conector.Query(query.GetSelect("qrId=" + Query.GetValor(Request.QueryString["qid"])));

                    if (reader != null && reader.Read())
                    {

                        PSeguimiento.Visible = PDatos.Visible = true;
                        BAceptar.Enabled = usuario.CanUpdate();
                        HIdQuejas.Value = reader["qrId"].ToString();
                        try
                        {
                            DateTime fecha = (DateTime)reader["qrFecha"];
                            TFecha.Text = fecha.ToShortDateString();
                            THora.Text = fecha.Hour.ToString().PadLeft(2, '0') + ":" + fecha.Minute.ToString().PadLeft(2, '0');
                        }
                        catch { }
                        CConector.SelectInDropDown(DTipo, reader["tqrIdTipo"]);
                        TPLlama.Text = reader["qrPersonaLlama"].ToString();
                        TParentesco.Text = reader["qrParentesco"].ToString();
                        TEmail.Text = reader["qrEmail"].ToString();
                        TTelefono.Text = reader["qrTelefono"].ToString();
                        TDetalle.Text = reader["qrDetalle"].ToString();
                        TObservaciones.Text = reader["qrObsHS"].ToString();
                        CCDetallePaciente.IdPaciente = reader["pacId"].ToString();
                        FuncionarioC.IdFuncionario = reader["perId"].ToString();
                        CConector.SelectInDropDown(DClasificacion, reader["clasificacion"]);

                        if (CCDetallePaciente.IdPaciente.Length != 0)
                        {
                            RPaciente.Checked = true;
                            SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                            SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                        }
                        else
                        {
                            CCDetallePaciente.Visible = false;
                            REmpleado.Checked = true;
                        }

                        reader = conector.Query("SELECT admPersonalHS.perId AS id,admPersonalHS.pernombre AS nombre FROM serQuejaRecPersonal LEFT JOIN admPersonalHS ON (admPersonalHS.perId=serQuejaRecPersonal.perId) WHERE serQuejaRecPersonal.qrId=" + HIdQuejas.Value + " ORDER BY nombre;");
                        if (reader != null)
                        {

                            ArrayList personas = new ArrayList();
                            ViewState["cliente_quejas"] = personas;
                            while (reader.Read())
                            {
                                personas.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                            }
                            GPersonal.DataSource = personas;
                            GPersonal.DataBind();
                        }
                        DTipo_SelectedIndexChanged(sender, e);
                        if (!PConductaAbusiva.Visible)
                        {
                            ((MasterPageI)Master).Imprimir("quejas.html");
                        }
                        else
                        {

                            ((MasterPageI)Master).Imprimir("quejasa.html");
                            query = new Query("conducta_abusiva");

                            query += "id";
                            query += "lugar";
                            query += "circunstancias";
                            query += "antecedentes";
                            query += "presentadano";
                            query += "otro";
                            query += "fecha";
                            query += "riesgo";

                            reader = conector.Query(query.GetSelect("queja=" + Query.GetValor(HIdQuejas.Value)));
                            if (reader != null && reader.Read())
                            {

                                ViewState["idconducta"] = reader["id"].ToString();
                                TLugar.Text = reader["lugar"].ToString();
                                TCircunstanacias.Text = reader["circunstancias"].ToString();
                                TAntecedentes.Text = reader["antecedentes"].ToString();
                                CPresentaDano.Checked = reader["presentadano"].ToString() == "1";
                                TTipoDano.Text = reader["otro"].ToString();
                                TFechaEvento.Text = CConector.GetFromMySQLDate(reader["fecha"]);
                                CConector.SelectInDropDown(DTipoRiesgo, reader["riesgo"]);

                                string consecuencia = "";
                                reader = conector.Query("SELECT consecuencia FROM conducta_abusiva_consecuencias WHERE conducta_abusiva=" + ViewState["idconducta"].ToString());
                                if (reader != null)
                                {
                                    while (reader.Read())
                                    {
                                        if (consecuencia.Length > 0)
                                            consecuencia += ";";
                                        consecuencia += reader["consecuencia"].ToString();
                                    }
                                }
                                ViewState["consecuencia"] = consecuencia;

                                consecuencia = "";
                                reader = conector.Query("SELECT medida,fecha FROM conducta_abusiva_medidas WHERE conducta_abusiva=" + ViewState["idconducta"].ToString());
                                if (reader != null)
                                {
                                    while (reader.Read())
                                    {
                                        if (consecuencia.Length > 0)
                                            consecuencia += ";";
                                        consecuencia += reader["medida"].ToString()
                                            + ","
                                            + CConector.GetFromMySQLDate(reader["fecha"])
                                            ;
                                    }
                                }
                                ViewState["medidas"] = consecuencia;
                            }
                        }
                        ((MasterPageI)Master).SetModificacion(HIdQuejas.Value);
                    }
                    else if (Request.QueryString["pid"] != null)
                    {
                        CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                        if (CCDetallePaciente.IdPaciente.Length == 0)
                        {
                            Response.Redirect(Request.Url.AbsolutePath);
                        }
                        else
                        {
                            BAceptar.Enabled = usuario.CanInsert();

                            RPaciente.Checked = true;
                            SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                            SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                            PDatos.Visible = true;
                        }
                        TFecha.Focus();
                    }
                    else if (Request.QueryString["fid"] != null)
                    {

                        FuncionarioC.IdFuncionario = Request.QueryString["fid"];
                        if (FuncionarioC.IdFuncionario.Length == 0)
                        {
                            Response.Redirect(Request.Url.AbsolutePath);
                        }
                        else
                        {

                            CCDetallePaciente.Visible = false;
                            REmpleado.Checked = true;
                            BAceptar.Enabled = usuario.CanInsert();
                            PDatos.Visible = true;
                        }
                    }
                }
                if (DTipo.Items.Count == 0)
                    DTipo.DataBind();
                DTipo_SelectedIndexChanged(sender, e);
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConectorMS conector = new CConectorMS())
        {

            Query query = new Query("serQuejasReclamos");
            conector.StartTransaction();

            query["qrFecha"] = TFecha.Text + " " + THora.Text;
            query["tqrIdTipo"] = DTipo.SelectedValue;
            query["qrPersonaLlama"] = TPLlama.Text;
            query["qrParentesco"] = TParentesco.Text;
            query["qrEmail"] = TEmail.Text;
            query["qrTelefono"] = TTelefono.Text;
            query["qrDetalle"] = TDetalle.Text;
            query["qrObsHS"] = TObservaciones.Text;
            query["pacId"] = CCDetallePaciente.IdPaciente;
            query["perId"] = FuncionarioC.IdFuncionario;
            query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
            query["segFechaIngreso"] = "GETDATE()";
            query["qrTipoCliente"] = RPaciente.Checked ? "1" : "2";
            query["entId"] = CCDetallePaciente.AsegurdadorID;
            query["clasificacion"] = DClasificacion.SelectedValue;

            if (HIdQuejas.Value.Length == 0)
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HIdQuejas.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("qrId=" + HIdQuejas.Value)) == -1)
                    return;
            }
            using(CConector conectorm= new CConector()) 
                if (conectorm.InsertModificacion(HIdQuejas.Value) == -1)
                    return;

            if (PConductaAbusiva.Visible)
            {

                query = new Query("conducta_abusiva");

                query["lugar"] = TLugar.Text;
                query["circunstancias"] = TCircunstanacias.Text;
                query["antecedentes"] = TAntecedentes.Text;
                query["presentadano"] = CPresentaDano.Checked ? "1" : "0";
                query["otro"] = TTipoDano.Text;
                query["fecha"] = TFechaEvento.Text;
                query["riesgo"] = DTipoRiesgo.SelectedValue;
                string id = (string)ViewState["idconducta"];

                if (string.IsNullOrEmpty((string)id))
                {

                    query["queja"] = HIdQuejas.Value;
                    int res = conector.QueryMod(query.GetInsert(), true);
                    if (res == -1)
                        return;
                    id = res.ToString();
                }
                else
                {
                    if (conector.QueryMod(query.GetUpdate("id=" + id)) == -1)
                        return;
                }

                if (conector.QueryMod("DELETE FROM conducta_abusiva_medidas WHERE conducta_abusiva=" + Query.GetValor(id)) == -1)
                    return;
                if (conector.QueryMod("DELETE FROM conducta_abusiva_consecuencias WHERE conducta_abusiva=" + Query.GetValor(id)) == -1)
                    return;

                query = new Query("conducta_abusiva_consecuencias");
                query["conducta_abusiva"] = id;

                for (int i = 0; i < CTipoDano.Items.Count; i++)
                {
                    if (CTipoDano.Items[i].Selected)
                    {
                        query["consecuencia"] = CTipoDano.Items[i].Value;
                        if (conector.QueryMod(query.GetInsert()) == -1)
                            return;
                    }
                }

                query = new Query("conducta_abusiva_medidas");
                query["conducta_abusiva"] = id;

                for (int i = 0; i < GMedidas.Rows.Count; i++)
                {

                    TextBox fecha = (TextBox)GMedidas.Rows[i].FindControl("TFecha");
                    if (fecha.Text.Length != 0)
                    {
                        query["medida"] = GMedidas.DataKeys[i].Value.ToString();
                        query["fecha"] = fecha.Text;
                        if (conector.QueryMod(query.GetInsert()) == -1)
                            return;
                    }
                }
            }
            else if (!string.IsNullOrEmpty((string)ViewState["idconducta"]))
            { // limpiamos las tablas
                string id = (string)ViewState["idconducta"];
                if (conector.QueryMod("DELETE FROM conducta_abusiva_medidas WHERE conducta_abusiva=" + Query.GetValor(id)) == -1)
                    return;
                if (conector.QueryMod("DELETE FROM conducta_abusiva_consecuencias WHERE conducta_abusiva=" + Query.GetValor(id)) == -1)
                    return;
                if (conector.QueryMod("DELETE FROM conducta_abusiva WHERE id=" + Query.GetValor(id)) == -1)
                    return;
            }

            BAgregar_Click(sender, e);

            ArrayList personas = (ArrayList)ViewState["cliente_quejas"];
            if (personas != null)
            {

                Query qpersonas = new Query("serQuejaRecPersonal");
                qpersonas["qrId"] = HIdQuejas.Value;

                if (conector.QueryMod(qpersonas.GetDelete("qrId=" + HIdQuejas.Value)) == -1)
                    return;

                for (int i = 0; i < personas.Count; i++)
                {
                    Miscelaneos info = (Miscelaneos)personas[i];
                    qpersonas["perId"] = info.Id;
                    if (conector.QueryMod(qpersonas.GetInsert()) == -1)
                        return;
                }
            }
            conector.Commit();
        }

        ((MasterPageI)Master).SetResultado("Queja de " + (RPaciente.Checked ? CCDetallePaciente.Nombres : FuncionarioC.Nombre) + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GPersonal_SelectedIndexChanged(object sender, EventArgs e)
    {
        string id = GPersonal.DataKeys[GPersonal.SelectedIndex].Value.ToString();
        ArrayList personas = (ArrayList)ViewState["cliente_quejas"];
        if (personas!= null)
        {
            for (int i = 0; i < personas.Count; i++)
            {
                Miscelaneos info = (Miscelaneos)personas[i];
                if(info.Id==id) {
                    personas.RemoveAt(i);
                    break;
                }
            }
        }
        GPersonal.DataSource = personas;
        GPersonal.DataBind();
    }

    protected void BAgregar_Click(object sender, EventArgs e)
    {
        if (TFuncionarioID.Text.Length == 0 || TFuncionario.Text.Length == 0)
            return;
        ArrayList personas = (ArrayList)ViewState["cliente_quejas"];
        if (personas == null)
        {
            personas= new ArrayList();
            ViewState["cliente_quejas"] = personas;
        }
        for (int i = 0; i < personas.Count; i++)
        {
            Miscelaneos info = (Miscelaneos)personas[i];
            if (info.Id == TFuncionarioID.Text)
            {
                personas.RemoveAt(i);
                break;
            }
        }
        personas.Add(new Miscelaneos(TFuncionarioID.Text,TFuncionario.Text));

        TFuncionarioID.Text= TFuncionario.Text="";
        TFuncionario.Focus();
        GPersonal.DataSource = personas;
        GPersonal.DataBind();
    }

    protected void BAceptarSeguimiento_Click(object sender, EventArgs e)
    {
        if (!CVSeguimiento.IsValid)
            return;

        using (CConectorMS conector = new CConectorMS())
        {
            Query query = new Query("serSeguimiento");
            Query queja = new Query("serQuejasReclamos");

            query["sqrDetalles"] = TSDetalles.Text;
            if (TAcciones.Text.Length == 0)
                query.AddCampo("sqrPendiente", "''", false);
            else query["sqrPendiente"] = TAcciones.Text;
            query["sqrCerrar"] = CCerrar.Checked ? "1" : "0";

            if (CCerrar.Checked)
            {
                query["sqrRespuestaUsuario"] = CRUsuario.Checked ? "1" : "";
                query["sqrRespuestaAsegurador"] = CRAsegurador.Checked ? "1" : "";
                query["sqrRespuestaTelefonica"] = CRTelefonica.Checked ? "1" : "";
                query["sqrRespuestaEnteVig"] = CRVigilancia.Checked ? "1" : "";
                query["que"] = TQue.Text;
                query["quien"] = TQuien.Text;
                query["como"] = TComo.Text;
                query["porque"] = TPorque.Text;

                queja["qrCerrado"] = "1";
                if (!FArchivo.HasFile)
                    return;
            }

            query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
            query["segFechaIngreso"] = "GETDATE()";

            if (string.IsNullOrEmpty((string)ViewState["sqrId"]))
            {

                query["qrId"] = HIdQuejas.Value;
                query["sqrId"] = conector.QueryString("(SELECT ISNULL(MAX(sqrId)+1,1) FROM serSeguimiento WHERE qrId=" + HIdQuejas.Value + ")");
                if (FArchivo.HasFile)
                {
                    Archivos archivo = new Archivos(FArchivo.PostedFile, 0);
                    if (!archivo.SaveFile(query))
                        return;
                }
                else
                {
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate(string.Format("qrId={0} AND sqrId={1}"
                    , HIdQuejas.Value
                    , ViewState["sqrId"]))) == -1)
                    return;
            }

            queja["qrAtendido"] = "1";

            if (conector.QueryMod(queja.GetUpdate("qrId=" + HIdQuejas.Value)) == -1)
                return;
        }
        GSeguimiento.DataBind();

        BCancelarSeguimiento_Click(sender, e);
    }

    protected void BCancelarSeguimiento_Click(object sender, EventArgs e)
    {
        TSDetalles.Text = "";
        TAcciones.Text = "";
        TPorque.Text = "";
        TComo.Text = "";
        TQue.Text = "";
        TQuien.Text = "";
        CCerrar.Checked = false;
        CRUsuario.Checked = false;
        CRAsegurador.Checked = false;
        CRTelefonica.Checked = false;
        CRVigilancia.Checked = false;
        ViewState["sqrId"] = null;

        PISeguimiento.Visible = false;
    }

    protected void LASeguimiento_Click(object sender, EventArgs e)
    {
        ViewState["sqrId"] = null;
        PISeguimiento.Visible = true;
    }

    protected void OnValidateSeguimiento(object sender, ServerValidateEventArgs e)
    {
        e.IsValid = TSDetalles.Text.Length>0;
        if (CCerrar.Checked) {

            e.IsValid =
            CRUsuario.Checked &&
            CRTelefonica.Checked &&
            FArchivo.HasFile &&
            (CRAsegurador.Checked || CRVigilancia.Checked)
            ;
        }
    }
    protected void GSeguimiento_SelectedIndexChanged(object sender, EventArgs e) {

        if(GSeguimiento.SelectedIndex==-1)
            return;

        Query query = new Query("serSeguimiento");
        Query qarchivo = new Query("serSeguimiento");

        query["nombre"]="nombre";
        query["id"]="1";
        query["tipo"]="nombre";

        qarchivo+="archivo";

        Archivos archivo = new Archivos(
            query.GetSelect(string.Format("qrId={0} AND sqrId={1}", GSeguimiento.DataKeys[GSeguimiento.SelectedIndex].Values[0].ToString(), GSeguimiento.DataKeys[GSeguimiento.SelectedIndex].Values[1].ToString())), 
            qarchivo.GetSelect(string.Format("qrId={0} AND sqrId={1}", GSeguimiento.DataKeys[GSeguimiento.SelectedIndex].Values[0].ToString(), GSeguimiento.DataKeys[GSeguimiento.SelectedIndex].Values[1].ToString()))
            );

        archivo.ShowFile(Response);
        GSeguimiento.SelectedIndex=-1;
    }

    protected void GSeguimiento_Editing(object sender, GridViewEditEventArgs e)
    {
        if(e.NewEditIndex!=-1) {
            
            BAceptarSeguimiento.Enabled = CUsuario.GetUsuario().CanUpdate();

            Query query = new Query("serSeguimiento");
            using (CConectorMS conector = new CConectorMS())
            {

                query += "sqrDetalles";
                query += "sqrPendiente";
                query += "sqrCerrar";

                query += "sqrRespuestaUsuario";
                query += "sqrRespuestaAsegurador";
                query += "sqrRespuestaTelefonica";
                query += "sqrRespuestaEnteVig";
                query += "que";
                query += "quien";
                query += "como";
                query += "porque";

                SqlDataReader reader = conector.Query(query.GetSelect(string.Format("qrId={0} AND sqrId={1}"
                    , GSeguimiento.DataKeys[e.NewEditIndex].Values[0]
                    , GSeguimiento.DataKeys[e.NewEditIndex].Values[1])));
                if (reader != null && reader.Read())
                {

                    ViewState["sqrId"] = GSeguimiento.DataKeys[e.NewEditIndex].Values[1];
                    TSDetalles.Text = reader["sqrDetalles"].ToString();
                    TAcciones.Text = reader["sqrPendiente"].ToString();
                    CCerrar.Checked = reader["sqrCerrar"].ToString() == "True";
                    if (CCerrar.Checked)
                    {

                        CRUsuario.Checked = reader["sqrRespuestaUsuario"].ToString() == "True";
                        CRAsegurador.Checked = reader["sqrRespuestaAsegurador"].ToString() == "True";
                        CRTelefonica.Checked = reader["sqrRespuestaTelefonica"].ToString() == "True";
                        CRVigilancia.Checked = reader["sqrRespuestaEnteVig"].ToString() == "True";
                        TQue.Text = reader["que"].ToString();
                        TQuien.Text = reader["quien"].ToString();
                        TComo.Text = reader["como"].ToString();
                        TPorque.Text = reader["porque"].ToString();
                    }
                    PISeguimiento.Visible = true;
                }
            }
        }
        e.Cancel = true;
    }
    protected void DTipo_SelectedIndexChanged(object sender, EventArgs e)
    {
        PConductaAbusiva.Visible = DTipo.SelectedItem.Text.ToLower().IndexOf("abusiva") != -1;
    }
    protected void CTipoDano_DataBound(object sender, EventArgs e)
    {
        string consecuencia = (string)ViewState["consecuencia"];
        if(!string.IsNullOrEmpty(consecuencia)) {
            string[] cons= consecuencia.Split(';');
            for (int i = 0; i < CTipoDano.Items.Count; i++)
            {
                for(int j=0; j<cons.Length; j++) {
                    if(cons[j]== CTipoDano.Items[i].Value.ToString()) {
                        CTipoDano.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }
    }

    protected void GMedidas_DataBound(object sender, EventArgs e)
    {
        string medidas = (string)ViewState["medidas"];

        if(!string.IsNullOrEmpty(medidas)) {

            string[] meds = medidas.Split(';');
            string[] fechas= new string[meds.Length];
            for(int j=0; j<meds.Length; j++) {
                string []temp= meds[j].Split(',');
                meds[j]= temp[0];
                fechas[j]= temp[1];
            }

            for (int i = 0; i < GMedidas.Rows.Count; i++)
            {
                for(int j=0; j<meds.Length; j++) {

                    if (meds[j] == GMedidas.DataKeys[i].Value.ToString())
                    {
                        TextBox fecha = (TextBox)GMedidas.Rows[i].FindControl("TFecha");
                        fecha.Text = fechas[j];
                    }
                }
            }
        }
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido
        // evento.Contenido = evento.Contenido.Replace("$GPersonal$", RenderGrid(GPersonal));
        // evento.Contenido = evento.Contenido.Replace("$GExamenFisico$", RenderGrid(GExamenFisico));

        // evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + TPlanManejo.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());


        Paciente paciente= Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        /*query = new Query("admPersonalHS");

        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szCargo"] = "admCargo.carDescripcion";

        reader = conectorms.Query(query.GetSelect("perId=" + Query.GetValor(TIdFuncionario.Text), " LEFT JOIN admCargo ON (admCargo.carId=admPersonalHS.carId)"));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }*/
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }
}