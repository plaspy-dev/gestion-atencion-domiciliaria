using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;

public partial class auditoria_eventoa : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PEventos.Visible = false;
            if (Request.QueryString["eaid"] != null)
            {
                Query query = new Query("evento_adverso");
                CConector conector = new CConector();

                query+= "paciente";
                query+= "fecha";
                query+= "descripcion";
                query+= "otro";
                query+= "funcionario";
                query+= "observaciones";
                query += "id";

                MySqlDataReader reader= conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["eaid"])));
                if(reader!=null && reader.Read()) {

                    CUsuario usuario = CUsuario.GetUsuario();
                    HIdEvento.Value = reader["id"].ToString();
                    BAceptar.Enabled = usuario.CanUpdate();
                    PDatos.Visible = true;

                    CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                                        
                    TFecha.Text= CConector.GetFromMySQLDate(reader["fecha"]);
                    TDescripcion.Text= reader["descripcion"].ToString();
                    TOConsecuencia.Text= reader["otro"].ToString();
                    TProfesionalID.Text= reader["funcionario"].ToString();
                    TObservaciones.Text = reader["observaciones"].ToString();
                    BProfesional_Click(sender, e);

                    ((MasterPageI)Master).SetModificacion(HIdEvento.Value);
                }
            } else if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    CUsuario usuario = CUsuario.GetUsuario();
                    PDatos.Visible = true;
                    BAceptar.Enabled = usuario.CanInsert();

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Focus();
                }
            }
            GEventos.DataBind();
            LEventos.Text = GEventos.Rows.Count + " Evento";
            LEventos.Text += GEventos.Rows.Count == 1 ? "" : "s";
            PEventos.Visible = GEventos.Rows.Count > 0;
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        Query query = new Query("evento_adverso");
        CConector conector = new CConector();

        query["paciente"]= CCDetallePaciente.IdPaciente;
        query["fecha"]=CConector.GetMySQLDateFormat(TFecha.Text);
        query["descripcion"]=TDescripcion.Text;
        query["otro"]=TOConsecuencia.Text;
        query["funcionario"]=TProfesionalID.Text;
        query["observaciones"]=TObservaciones.Text;
        query["entidad"] = CCDetallePaciente.AsegurdadorID;

        if(HIdEvento.Value.Length==0) {

            int res = conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            HIdEvento.Value= res.ToString();
        } else {

            if (conector.QueryMod(query.GetUpdate("id=" + HIdEvento.Value)) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdEvento.Value) == -1)
            return;

        Query tipo = new Query("tipo_evento_adverso");
        if (conector.QueryMod(tipo.GetDelete("id=" + HIdEvento.Value)) == -1)
            return;
        tipo["evento"] = HIdEvento.Value;
        for(int i=0; i<DTipo.Items.Count; i++) {

            if(((CheckBox)DTipo.Items[i].FindControl("CTipo")).Checked) {

                tipo["tipo"] = DTipo.DataKeys[i].ToString();
                if (conector.QueryMod(tipo.GetInsert()) == -1)
                    return;
            }
        }

        Query consecuencias = new Query("consecuencias_evento_adverso");
        if (conector.QueryMod(consecuencias.GetDelete("id=" + HIdEvento.Value)) == -1)
            return;
        consecuencias["evento"] = HIdEvento.Value;
        for (int i = 0; i < DConsecuencias.Items.Count; i++)
        {
            if (((CheckBox)DConsecuencias.Items[i].FindControl("CTipo")).Checked)
            {
                consecuencias["consecuencia"] = DConsecuencias.DataKeys[i].ToString();
                if (conector.QueryMod(consecuencias.GetInsert()) == -1)
                    return;
            }
        }

        ((MasterPageI)Master).SetResultado("Evento adverso de " + CCDetallePaciente.Nombres + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BProfesional_Click(object sender, EventArgs e)
    {
        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT perNumeroTP,profNombre,perNombre FROM admPersonalHS "
            + " LEFT JOIN admProfesion ON (admProfesion.profId=admPersonalHS.profId)"
            + " WHERE perId=" + Query.GetValor(TProfesionalID.Text)
            );
        if(reader!=null && reader.Read()) {

            TProfesional.Text = reader["perNombre"].ToString();
            LTProfesional.Text= reader["perNumeroTP"].ToString();
            LProfesion.Text = reader["profNombre"].ToString();

            if (LTProfesional.Text.Length != 0)
            {
                LTProfesional.Text = "TP: " + LTProfesional.Text;
                if (LProfesion.Text.Length != 0)
                    LProfesion.Text += ", ";
            }
            
        } else {
            TProfesionalID.Text = "";
        }
    }

    protected void IIr_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/auditoria/eventoa.aspx?eaid=" + ((ImageButton)sender).CommandArgument);
    }
}