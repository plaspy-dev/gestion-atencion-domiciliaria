using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using componentes;

public partial class phd_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            HId.Value = Request.QueryString["id"];
            TPaciente.Focus();
            if(HId.Value.Length>0) {
                Query query = new Query("phdPaciente");

                query["pacId"] = "phdPaciente.pacId";
                query["tdocId"] = "phdPaciente.tdocId";
                query["pacDocumento"] = "phdPaciente.pacDocumento";
                query["pacPApellido"] = "phdPaciente.pacPApellido";
                query["pacSApellido"] = "phdPaciente.pacSApellido";
                query["pacPNombre"] = "phdPaciente.pacPNombre";
                query["pacSNombre"] = "phdPaciente.pacSNombre";
                query["sexoId"] = "phdPaciente.sexoId";
                query["pacFechaNac"] = "phdPaciente.pacFechaNac";
                query["pacDireccion"] = "phdPaciente.pacDireccion";
                query["pacTelefono"] = "phdPaciente.pacTelefono";
                query["pacCelular"] = "phdPaciente.pacCelular";
                query["pacCarne"] = "phdPaciente.pacCarne";
                query["pacBarrio"] = "phdPaciente.pacBarrio";
                query["pacFamilarResponsable"] = "phdPaciente.pacFamilarResponsable";
                query["pacParentesco"] = "phdPaciente.pacParentesco";
                query["cieCodDx"] = "phdPaciente.cieCodDx";
                query["cieCodDx_1"] = "phdPaciente.cieCodDx_1";
                query["cieCodDx_2"] = "phdPaciente.cieCodDx_2";
                query["entidad"]= "admEntidad.entNombre";
                query["tipopago"] = "phdPagoDirecto.pdirDescripcion";
                query["estId"] = "phdPaciente.estId";

                CConectorMS conector = new CConectorMS();

                SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacId=" + Query.GetValor(Request.QueryString["id"]) + "", 
                    "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)" +
                    " LEFT JOIN phdPagoDirecto ON (phdPagoDirecto.pdirId=phdPaciente.pdirId)"));

                if (reader != null && reader.Read())
                {
                    Usuario usuario= Usuario.GetUsuario();
                    LNuevo.Visible= usuario.CanInsert();
                    GProgramacion.Columns[2].Visible = lnkelimMasivo.Visible = usuario.CanDelete();
                    GProgramacion.Columns[1].Visible= lnkNovedad.Visible = usuario.CanUpdate();

                    PDatos.Visible = true;
                    UCProgramacion.IdPaciente= UCAutorizaciones.Value= HId.Value = reader["pacId"].ToString();
                    
                    ((MasterPageI)Master).SetModificacion(HId.Value);

                    TPaciente.Text = reader["pacDocumento"].ToString();
                    LPaciente.Text = reader["pacPApellido"].ToString() + 
                        " " + reader["pacSApellido"].ToString() +
                        " " + reader["pacPNombre"].ToString() +
                        " " + reader["pacSNombre"].ToString();
                    if (reader["estId"].ToString() == "2")
                        LPaciente.Text += " (Inactivo)";
                    LFechaNacimiento.Text = ConectorMS.GetDate(reader["pacFechaNac"]) + " ";
                    if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length != 0)
                    {
                        DateTime birthDate = (DateTime)reader["pacFechaNac"];
                        DateTime now = DateTime.Now;
                        int years = now.Year - birthDate.Year;

                        if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                            --years;

                        LEdad.Text = years + " años";
                    }
                    LSexo.Text = reader["sexoId"].ToString()=="1" ? "F" : "M";
                    LAsegurador.Text = reader["entidad"].ToString();
                    LCarnet.Text = reader["pacCarne"].ToString();
                    LDireccion.Text = reader["pacDireccion"].ToString();
                    LBarrio.Text = reader["pacBarrio"].ToString();
                    LTelefono.Text = reader["pacTelefono"].ToString();
                    LMovil.Text = reader["pacCelular"].ToString();
                    LTipoPago.Text= reader["tipopago"].ToString();
                    // SELECT eEstId codigo,eEstDesc descripcion FROM dbo.admEstadoEstancia
                    // LEstancia.Text = reader[""].ToString();
                    LFamiliar.Text = reader["pacFamilarResponsable"].ToString();
                    LParentesco.Text = reader["pacParentesco"].ToString();

                    string cie1= reader["cieCodDx"].ToString();
                    string cie2=reader["cieCodDx_1"].ToString();
                    string cie3= reader["cieCodDx_2"].ToString();
                    cie1= GetCodigoCIE(cie1, conector);
                    cie2 =GetCodigoCIE(cie2, conector);
                    cie3= GetCodigoCIE(cie3, conector);
                    LCIE10.Text+= cie1;
                    if (cie2.Length > 0 && LCIE10.Text.Length > 0)
                        LCIE10.Text += "<br/>";
                    LCIE10.Text+= cie2;
                    if (cie3.Length > 0 && LCIE10.Text.Length > 0)
                        LCIE10.Text += "<br/>";
                    LCIE10.Text += cie3;
                }
                else
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
            }
        }
    }
    
    protected string GetCodigoCIE(string text, CConectorMS conector)
    {

        if (text.Length > 0)
        {
            string codigo = conector.QueryString("SELECT [cieCodDx]+' - '+ [cirDescripcion] FROM phdCIE10 WHERE cieCodDx='" + text + "'");
            if (codigo.Length > 0)
                return codigo;
        }
        return text;
    }

    protected void lnkelimMasivo_Click(object sender, EventArgs e)
    {
        CConectorMS conector=new CConectorMS();

        for(int i=0; i<GProgramacion.Rows.Count; i++) {
            CheckBox check= (CheckBox) GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if(check.Checked) {
                conector.Query("DELETE phdProgramacion where prgId=" + GProgramacion.DataKeys[i].Value.ToString());
            }
        }
        GProgramacion.DataBind();
    }

    protected void lnkNovedad_Click(object sender, EventArgs e)
    {
        string seleccionados = "";
        for (int i = 0; i < GProgramacion.Rows.Count; i++)
        {
            CheckBox check= (CheckBox) GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if (check.Checked)
            {
                if (seleccionados.Length > 0)
                    seleccionados += ",";
                seleccionados += GProgramacion.DataKeys[i].Value.ToString();
            }
        }
        if (seleccionados.Length == 0)
            return;
        UCNovedad.IdProgramaciones = seleccionados;
        UCNovedad.Visible = true;
    }
    protected void LNuevo_Click(object sender, EventArgs e)
    {
        UCProgramacion.Visible = true;
    }

    protected void UCProgramacion_AceptarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        GProgramacion.DataBind();
    }
    protected void UCProgramacion_CancelarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        UCProgramacion.IdProgramacion = "";
    }
    protected void GProgramacion_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GProgramacion.SelectedIndex = e.NewEditIndex;
        UCNovedad.IdProgramacion = GProgramacion.DataKeys[e.NewEditIndex].Value.ToString();
        UCNovedad.Visible = true;
        e.Cancel = true;
    }

    protected void UCNovedad_AceptarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        GProgramacion.DataBind();
    }
    protected void UCNovedad_CancelarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
    }

    protected void GProgramacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        UCProgramacion.IdProgramacion = GProgramacion.DataKeys[GProgramacion.SelectedIndex].Value.ToString();
        UCProgramacion.Visible = true;
    }
}
