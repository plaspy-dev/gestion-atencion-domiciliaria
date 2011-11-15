using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using SDG.Componentes;

public partial class seguimiento_paciente : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            PReactivar.Visible = false;
            if (Request.QueryString["ip"] != null && Request.QueryString["ip"].Length > 0)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?id=" + crypt.Desencriptar(Request.QueryString["ip"]));
                Response.End();
                return;
            }
            TDocumento.Focus();

            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();

            if (Request.QueryString["id"] != null && Request.QueryString["id"].Length > 0)
            {
                Query query = new Query("phdPaciente");

                query += "pacId";
                query += "tdocId";
                query += "pacDocumento";
                query += "pacPApellido";
                query += "pacObservaciones";
                query += "pacSApellido";
                query += "pacPNombre";
                query += "pacSNombre";
                query += "sexoId";
                query += "pacFechaNac";
                query += "pacDireccion";
                query += "pacBarrio";
                query += "pacTelefono";
                query += "pacTelefono1";
                query += "pacCelular";
                query += "pacCorreo";
                query += "pacEspecLlegada";
                query += "locId";
                query += "pacEstrato";
                query += "pacFamilarResponsable";
                query += "pacParentesco";
                query += "pdirId";
                query += "pacCarne";
                query += "pacZona";
                query += "pacEntregaSuministros";
                query += "entId";
                query += "megId";
                query += "pacFecIngAsegurador";
                query += "pacGrado";
                query += "pacTipoAfiliado";
                query += "tipECod";
                query += "pacFecIngPrograma";
                query += "estId";
                query += "pacNumeroETB";
                query += "pacIntensidadTerapias";
                query += "cieCodDx";
                query += "cieCodDx_1";
                query += "cieCodDx_2";

                CConectorMS conector = new CConectorMS();

                SqlDataReader reader = conector.Query(query.GetSelect("pacId=" + Query.GetValor(Request.QueryString["id"]) + ""));

                if (reader != null && reader.Read())
                {
                    BAceptar.Enabled = usuario.CanUpdate();
                    ((MasterPageI)Master).Imprimir();

                    UCAutorizaciones.Value= HId.Value = reader["pacId"].ToString();
                    ((MasterPageI)Master).SetModificacion(HId.Value);

                    DDocumento.SelectedValue = reader["tdocId"].ToString();
                    TDocumento.Text = reader["pacDocumento"].ToString();
                    TPApellido.Text = reader["pacPApellido"].ToString();
                    TObservaciones.Text = reader["pacObservaciones"].ToString();
                    TSApellido.Text = reader["pacSApellido"].ToString();
                    TPNombre.Text = reader["pacPNombre"].ToString();
                    TSNombre.Text = reader["pacSNombre"].ToString();
                    DSexo.SelectedValue = reader["sexoId"].ToString();
                    TNacimiento.Text = ConectorMS.GetDate(reader["pacFechaNac"]);
                    TDireccion.Text = reader["pacDireccion"].ToString();
                    TBarrio.Text = reader["pacBarrio"].ToString();
                    TTelefono.Text = reader["pacTelefono"].ToString();
                    TTelefono1.Text = reader["pacTelefono1"].ToString();
                    TMovil.Text = reader["pacCelular"].ToString();
                    TEMail.Text = reader["pacCorreo"].ToString();
                    TLlegada.Text = reader["pacEspecLlegada"].ToString();
                    conector.SelectInDropDown(DLocalidad, reader["locId"], "SELECT locDescripcion FROM admLocalidad WHERE locId={0}");
                    TEstrato.Text = reader["pacEstrato"].ToString();
                    TFResponsable.Text = reader["pacFamilarResponsable"].ToString();
                    TParentesco.Text = reader["pacParentesco"].ToString();
                    conector.SelectInDropDown(DPago, reader["pdirId"], "SELECT pdirDescripcion FROM phdPagoDirecto WHERE pdirId={0}");
                    TCarnet.Text = reader["pacCarne"].ToString();
                    TZona.Text = reader["pacZona"].ToString();
                    CSuministros.Checked = reader["pacEntregaSuministros"].ToString() == "1" ? true : false;
                    conector.SelectInDropDown(DAsegurador, reader["entId"], "SELECT entNombre FROM admEntidad WHERE entId={0}");
                    conector.SelectInDropDown(DMedico, reader["megId"], "SELECT megNombre FROM phdMegas WHERE megId={0}");
                    TFechaIngresoAsegurador.Text = ConectorMS.GetDate(reader["pacFecIngAsegurador"]);
                    TGrado.Text = reader["pacGrado"].ToString();
                    DTipoAfiliado.SelectedValue = reader["pacTipoAfiliado"].ToString();
                    conector.SelectInDropDown(DTipoEvento, reader["tipECod"], "SELECT tipEDescripcion FROM phdTipoEvento WHERE tipECod={0}");
                    TFechaIngreso.Text = ConectorMS.GetDate(reader["pacFecIngPrograma"]);
                    conector.SelectInDropDown(DEstado, reader["estId"], "SELECT estDesc FROM phdEstado WHERE estId={0}");
                    TNumeroETB.Text = reader["pacNumeroETB"].ToString();
                    TIntensidadTerapias.Text = reader["pacIntensidadTerapias"].ToString();
                    TCIE1.Text = reader["cieCodDx"].ToString();
                    TCIE2.Text = reader["cieCodDx_1"].ToString();
                    TCIE3.Text = reader["cieCodDx_2"].ToString();

                    GetCodigoCIE(TCIE1, conector);
                    GetCodigoCIE(TCIE2, conector);
                    GetCodigoCIE(TCIE3, conector);

                    PReactivar.Visible = true;

                    if (DEstado.SelectedValue=="1")
                    {
                        SMotivo.SelectCommand = "SELECT cegId id,cegDescripcion nombre FROM dbo.phdCausaEgreso ORDER BY 2";
                        LReactivar.Text = "Inactivar";
                        BRetiro.Text = "Inactivar";
                    }
                }
            }
        }
    }

    protected void GetCodigoCIE(TextBox text, CConectorMS conector) {

        if (text.Text.Length > 0)
        {
            string codigo = conector.QueryString("SELECT [cieCodDx]+' - '+ [cirDescripcion] FROM phdCIE10 WHERE cieCodDx='" + text.Text + "'");
            if (codigo.Length>0)
                text.Text = codigo;
        }
    }
    protected string GetCodigoCIE(string text) {
        int pos= text.IndexOf('-');
        if(pos!=-1) {
            string resultado = text.Substring(0, pos);
            return text.Substring(0, pos);
        }
        return "";
    }

    protected string GetCleanDoc(string texto) {

        for (int i = 0; i < texto.Length; i++)
        {
            if (char.IsNumber(texto[i]) && !char.IsLetter(texto[i]))
            {
                texto= texto.Replace(texto[i].ToString(), "");
                i--;
            }
        }
        return texto;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("phdPaciente");

        query["tdocId"] = DDocumento.SelectedValue;
        query["pacDocumento"] = GetCleanDoc(TDocumento.Text);
        query["pacPApellido"] = TPApellido.Text;
        query["pacObservaciones"] = TObservaciones.Text;
        query["pacSApellido"] = TSApellido.Text;
        query["pacPNombre"] = TPNombre.Text;
        query["pacSNombre"] = TSNombre.Text;
        query["sexoId"] = DSexo.SelectedValue;
        query["pacFechaNac"] = TNacimiento.Text;
        query["pacDireccion"] = TDireccion.Text;
        query["pacBarrio"] = TBarrio.Text;
        query["pacTelefono"] = TTelefono.Text;
        query["pacTelefono1"] = TTelefono1.Text;
        query["pacCelular"] = TMovil.Text;
        query["pacCorreo"] = TEMail.Text;
        query["pacEspecLlegada"] = TLlegada.Text;
        query["locId"] = DLocalidad.SelectedValue;
        query["pacEstrato"] = TEstrato.Text;
        query["pacFamilarResponsable"] = TFResponsable.Text;
        query["pacParentesco"] = TParentesco.Text;
        query["pdirId"] = DPago.SelectedValue;
        query["pacCarne"] = TCarnet.Text;
        query["pacZona"] = TZona.Text;
        query["pacEntregaSuministros"] = CSuministros.Checked ? "1" : "0";
        query["entId"] = DAsegurador.SelectedValue;
        query["megId"] = DMedico.SelectedValue;
        query["pacFecIngAsegurador"] = TFechaIngresoAsegurador.Text;
        query["pacGrado"] = TGrado.Text;
        query["pacTipoAfiliado"] = DTipoAfiliado.SelectedValue;
        query["tipECod"] = DTipoEvento.Text;
        query["pacFecIngPrograma"] = TFechaIngreso.Text;
        query["estId"] = DEstado.SelectedValue;
        query["pacNumeroETB"] = TNumeroETB.Text;
        query["pacIntensidadTerapias"] = TIntensidadTerapias.Text;
        query["cieCodDx"] = GetCodigoCIE(TCIE1.Text);
        query["cieCodDx_1"] = GetCodigoCIE(TCIE2.Text);
        query["cieCodDx_2"] = GetCodigoCIE(TCIE3.Text);
        query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();

        CConectorMS conectorms = new CConectorMS();

        if (HId.Value.Length > 0)
        {
            if (conectorms.QueryMod(query.GetUpdate("pacId='" + HId.Value + "'")) == -1)
                return;
        }
        else
        {
            string id = conectorms.QueryString("SELECT pacId FROM phdPaciente WHERE tdocId=" + DDocumento.SelectedValue + " AND pacDocumento='"+ TDocumento.Text+"'");
            if(id.Length>0) {

                ((MasterPageI)Master).SetMensaje("Ya existe un paciente con este documento.");
                return;
            }

            int res = conectorms.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            HId.Value = res.ToString();
        }

        CConector conectormysql = new CConector();
        conectormysql.InsertModificacion(HId.Value);

        ((MasterPageI)Master).SetResultado("Usuario " + TPNombre.Text + " " + TPApellido.Text + " Editado.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BRetiro_Click(object sender, EventArgs e)
    {
        CConectorMS conector = new CConectorMS();

        if(LReactivar.Text == "Reactivar") {

            // reingreso paciente
            if (conector.QueryMod("UPDATE dbo.phdPaciente set estId=1 WHERE pacId=" + HId.Value)==-1)
                return;
            if (conector.QueryMod("INSERT INTO dbo.phdReingresos(pacId,cingId,rinFecha,rinObs,segUsuarioIngreso) VALUES(" + HId.Value + "," + DMotivo.SelectedValue + ",'" + TFechaRetiro.Text + "','" + TObservacionesRetiro.Text + "','" + Usuario.GetUsuario().GetLogin() + "')") == -1)
                return;
            if (conector.QueryMod("insert into dbo.phdAuditServicios(pacId,audIngreso,audUsuario,audFecha,audObs,segFechaIngreso) values(" + HId.Value + ",1,'" + Usuario.GetUsuario().GetLogin() + "','" + TFechaRetiro.Text + "','" + TObservacionesRetiro.Text + "',getdate())") == -1)
                return;
            if (conector.QueryMod("DELETE phdNovedad WHERE EXISTS(SELECT 1 FROM vwphd_ProgramacionTotal pr WHERE pacId=" + HId.Value + " and prgFechaProg>='" + TFechaRetiro.Text + "' and prgActivo=0 and pr.prgId=phdNovedad.prgId and pr.prgTipo=phdNovedad.prgTipo)") == -1)
                return;
            if (conector.QueryMod("update PhdProgramacion set prgActivo=1 where pacId=" + HId.Value + " and prgFechaProg>='" + TFechaRetiro.Text + "' and prgActivo=0") == -1)
                return;
            if (conector.QueryMod("update PhdProgramacionMD set prgActivo=1 where pacId=" + HId.Value + " and prgFechaProg>='" + TFechaRetiro.Text + "' and prgActivo=0") == -1)
                return;
            if (conector.QueryMod("update AtxProgramacion set prgActivo=1 where pacId=" + HId.Value + " and prgFechaProg>='" + TFechaRetiro.Text + "' and prgActivo=0") == -1)
                return;
            if (conector.QueryMod("UPDATE phdAutorizacion set autActivo=1 WHERE pacId=" + HId.Value + " and autFechaVenc>='" + TFechaRetiro.Text + "' and autActivo=0") == -1)
                return;
        } else { // retiro paciente

            if (conector.QueryMod("UPDATE dbo.phdPaciente set estId=2,pacCuraciones = 0,pacAdmPuntual = 0,pacTerapiaFisica = 0,pacTerapiaResp = 0,pacTerapiaOcup = 0,pacTerapiaLenguaje = 0,pacValNutricional = 0,pacValMedica = 0,pacEnfermeria_12 = 0,pacEnfermeria_24 = 0,pacEntregaSuministros = 0 WHERE pacId=" + HId.Value) == -1)
                return;
            if (conector.QueryMod("INSERT INTO dbo.phdEgresos(pacId,cegId,egrObs,egrFecha,segUsuarioIngreso) VALUES(" + HId.Value + "," + DMotivo.SelectedValue + ",'" + TObservacionesRetiro.Text + "','" + TFechaRetiro.Text + "','" + Usuario.GetUsuario().GetLogin() + "')") == -1)
                return;
            if (conector.QueryMod("INSERT INTO dbo.phdAuditServicios(pacId,audEgreso,audUsuario,audFecha,cegId,audObs,segFechaIngreso) VALUES(" + HId.Value + ",1,'" + Usuario.GetUsuario().GetLogin() + "','" + TFechaRetiro.Text + "'," + DMotivo.SelectedValue + ",'" + TObservacionesRetiro.Text + "',getdate())") == -1)
                return;
            string cnoId = conector.QueryString("SELECT cnoId FROM phdCausaEgreso WHERE cegId=" + DMotivo.SelectedValue);
            if (cnoId.Length == 0)
                cnoId = "NULL";
            if (conector.QueryMod("DELETE phdNovedad WHERE EXISTS(SELECT 1 FROM vwphd_ProgramacionTotal pr where pacId=" + HId.Value + " and prgFechaProg>'" + TFechaRetiro.Text + "' and prgActivo=1 and pr.prgId=phdNovedad.prgId and pr.prgTipo=phdNovedad.prgTipo)") == -1)
                return;
            if (conector.QueryMod("INSERT INTO phdNovedad(prgId,prgTipo,novId,novTipo,cnoId,perIdAnt,perId,novObs,segUsuarioRegistro,segFechaRegistro) SELECT prgId,prgTipo,1,1," + cnoId + ",perId,null,'GENERADA AUTOMATICAMENTE POR INACTIVACION DEL PACIENTE: " + TObservacionesRetiro.Text + "','" + Usuario.GetUsuario().GetLogin() + "',getdate() FROM dbo.vwphd_ProgramacionTotal WHERE pacId=" + HId.Value + " and prgFechaProg>'" + TFechaRetiro.Text + "' and prgActivo=1") == -1)
                return;
            if (conector.QueryMod("UPDATE PhdProgramacion set prgActivo=0 WHERE pacId=" + HId.Value + " and prgFechaProg>'" + TFechaRetiro.Text + "' and prgActivo=1") == -1)
                return;
            if (conector.QueryMod("UPDATE PhdProgramacionMD set prgActivo=0 WHERE pacId=" + HId.Value + " and prgFechaProg>'" + TFechaRetiro.Text + "' and prgActivo=1") == -1)
                return;
            if (conector.QueryMod("UPDATE AtxProgramacion set prgActivo=0 WHERE pacId=" + HId.Value + " and prgFechaProg>'" + TFechaRetiro.Text + "' and prgActivo=1") == -1)
                return;
            if (conector.QueryMod("UPDATE phdAutorizacion set autActivo=0 WHERE pacId=" + HId.Value + " and autFechaVenc>='" + TFechaRetiro.Text + "' and autActivo=1") == -1)
                return;
        }
        CConector conectormysql = new CConector();
        conectormysql.InsertModificacion(HId.Value);

        ((MasterPageI)Master).SetResultado("Usuario " + TPNombre.Text + " " + TPApellido.Text + " Editado.");
    }
}
