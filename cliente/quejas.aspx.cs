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
        if (!IsPostBack)
        {
            Session["cliente_quejas"] = null;
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

                CConectorMS conector = new CConectorMS();
                SqlDataReader reader = conector.Query(query.GetSelect("qrId=" + Query.GetValor(Request.QueryString["qid"])));

                if(reader!=null && reader.Read()) {

                    PSeguimiento.Visible= PDatos.Visible = true;
                    BAceptar.Enabled = usuario.CanUpdate();
                    HIdQuejas.Value = reader["qrId"].ToString();
                    string []fechas= reader["qrFecha"].ToString().Split(' ');
                    if (fechas.Length>1)
                    {
                        TFecha.Text = fechas[0];
                        THora.Text = fechas[1];
                    }
                    DTipo.SelectedValue = reader["tqrIdTipo"].ToString();
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
                    } else {
                        CCDetallePaciente.Visible = false;
                        REmpleado.Checked = true;
                    }

                    reader= conector.Query("SELECT admPersonalHS.perId AS id,admPersonalHS.pernombre AS nombre FROM serQuejaRecPersonal LEFT JOIN admPersonalHS ON (admPersonalHS.perId=serQuejaRecPersonal.perId) WHERE serQuejaRecPersonal.qrId=" + HIdQuejas.Value + " ORDER BY nombre;");
                    if(reader!=null) {

                        ArrayList personas= new ArrayList();
                        Session["cliente_quejas"] = personas;
                        while(reader.Read()) {
                            personas.Add(new Miscelaneos(reader["id"].ToString(), reader["nombre"].ToString()));
                        }
                        GPersonal.DataSource = personas;
                        GPersonal.DataBind();
                    }
                    ((MasterPageI)Master).SetModificacion(HIdQuejas.Value);
                }
            }
            else if (Request.QueryString["pid"]!=null)
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
            } else if(Request.QueryString["fid"]!=null) {

                FuncionarioC.IdFuncionario = Request.QueryString["fid"];
                if (FuncionarioC.IdFuncionario.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                } else {

                    CCDetallePaciente.Visible = false;
                    REmpleado.Checked = true;
                    BAceptar.Enabled = usuario.CanInsert();
                    PDatos.Visible = true;
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("serQuejasReclamos");
        CConectorMS conector= new CConectorMS();

        conector.StartTransaction();

        query["qrFecha"] = TFecha.Text + " " + THora.Text;
        query["tqrIdTipo"] = DTipo.SelectedValue;
        query["qrPersonaLlama"] = TPLlama.Text;
        query["qrParentesco"] = TParentesco.Text;
        query["qrEmail"] = TEmail.Text;
        query["qrTelefono"] = TTelefono.Text;
        query["qrDetalle"] = TDetalle.Text;
        query["qrObsHS"] = TObservaciones.Text;
        query["pacId"]= CCDetallePaciente.IdPaciente;
        query["perId"]= FuncionarioC.IdFuncionario;
        query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
        query["segFechaIngreso"] = "GETDATE()";
        query["qrTipoCliente"]= RPaciente.Checked ? "1" : "2";
        query["entId"] = CCDetallePaciente.AsegurdadorID;
        query["clasificacion"] = DClasificacion.SelectedValue;

        if(HIdQuejas.Value.Length==0) {

            int res= conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            HIdQuejas.Value= res.ToString();
        } else {
            if (conector.QueryMod(query.GetUpdate("qrId=" + HIdQuejas.Value)) == -1)
                return;
        }
        if (new CConector().InsertModificacion(HIdQuejas.Value) == -1)
            return;

        BAgregar_Click(sender, e);

        ArrayList personas = (ArrayList)Session["cliente_quejas"];
        if(personas!=null) {

            Query qpersonas = new Query("serQuejaRecPersonal");
            qpersonas["qrId"] = HIdQuejas.Value;

            if (conector.QueryMod(qpersonas.GetDelete("qrId=" + HIdQuejas.Value)) == -1)
                return;

            for(int i=0; i<personas.Count; i++) {
                Miscelaneos info = (Miscelaneos)personas[i];
                qpersonas["perId"] = info.Id;
                if (conector.QueryMod(qpersonas.GetInsert())==-1)
                    return;
            }
        }
        conector.Commit();


        ((MasterPageI)Master).SetResultado("Queja de " + (RPaciente.Checked ? CCDetallePaciente.Nombres : FuncionarioC.Nombre) + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GPersonal_SelectedIndexChanged(object sender, EventArgs e)
    {
        string id = GPersonal.DataKeys[GPersonal.SelectedIndex].Value.ToString();
        ArrayList personas = (ArrayList)Session["cliente_quejas"];
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
        ArrayList personas = (ArrayList)Session["cliente_quejas"];
        if (personas == null)
        {
            personas= new ArrayList();
            Session["cliente_quejas"] = personas;
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

        Query query = new Query("serSeguimiento");
        Query queja = new Query("serQuejasReclamos");
        CConectorMS conector= new CConectorMS();

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

        if (string.IsNullOrEmpty((string)ViewState["sqrId"])) {
            
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
        } else {
            if (conector.QueryMod(query.GetUpdate(string.Format("qrId={0} AND sqrId={1}"
                , HIdQuejas.Value
                , ViewState["sqrId"]))) == -1)
                return;
        }

        queja["qrAtendido"] = "1";

        if (conector.QueryMod(queja.GetUpdate("qrId=" + HIdQuejas.Value)) == -1)
            return;

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
            CConectorMS conector = new CConectorMS();

            query+= "sqrDetalles";
            query+= "sqrPendiente";
            query+= "sqrCerrar";

            query+= "sqrRespuestaUsuario";
            query+= "sqrRespuestaAsegurador";
            query+= "sqrRespuestaTelefonica";
            query+= "sqrRespuestaEnteVig";
            query+= "que";
            query+= "quien";
            query+= "como";
            query += "porque";

            SqlDataReader reader= conector.Query(query.GetSelect(string.Format("qrId={0} AND sqrId={1}"
                , GSeguimiento.DataKeys[e.NewEditIndex].Values[0]
                , GSeguimiento.DataKeys[e.NewEditIndex].Values[1])));
            if(reader!=null && reader.Read()) {

                ViewState["sqrId"] = GSeguimiento.DataKeys[e.NewEditIndex].Values[1];
                TSDetalles.Text= reader["sqrDetalles"].ToString();
                TAcciones.Text = reader["sqrPendiente"].ToString();
                CCerrar.Checked= reader["sqrCerrar"].ToString()=="True";
                if(CCerrar.Checked) {

                    CRUsuario.Checked = reader["sqrRespuestaUsuario"].ToString() == "True";
                    CRAsegurador.Checked = reader["sqrRespuestaAsegurador"].ToString() == "True";
                    CRTelefonica.Checked = reader["sqrRespuestaTelefonica"].ToString() == "True";
                    CRVigilancia.Checked = reader["sqrRespuestaEnteVig"].ToString() == "True";
                    TQue.Text= reader["que"].ToString();
                    TQuien.Text= reader["quien"].ToString();
                    TComo.Text= reader["como"].ToString();
                    TPorque.Text = reader["porque"].ToString();
                }
                PISeguimiento.Visible = true;
            }
        }
        e.Cancel = true;
    }
}