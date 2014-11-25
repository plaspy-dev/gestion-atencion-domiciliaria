using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class equipo_prestamo : System.Web.UI.UserControl
{
    public event EventHandler BAceptarClicked = null;
    public event EventHandler BCancelarClicked = null;

    public void Show(Prestamo info)
    {
        TFecha.Text = "";
        TEstimado.Text = "";
        UCPaciente.IdPaciente = "";
        UCFuncionario.IdFuncionario = "";
        TFamiliar.Text = "";
        TObservaciones.Text = "";
        CPagare.Checked = false;
        ViewState["idPrestamo"] = null;

        if (info != null) { 

            ViewState["idPrestamo"] = info.IdPrestamo;
            TFecha.Text = Query.GetFromMySQLDate(info.Fecha);
            TEstimado.Text = Query.GetFromMySQLDate(info.Estimado);
            UCPaciente.IdPaciente = info.IdPaciente;
            UCFuncionario.IdFuncionario = info.IdFuncionario;
            TFamiliar.Text = info.Familiar;
            TObservaciones.Text = info.Observaciones;
            CPagare.Checked = info.Pagare;
        }
        PPrestamo.Visible = true;
        ScriptManager.RegisterStartupScript(PPrestamo, typeof(String), "prestamoDlg", "addDialog('#" + PPrestamo.ClientID + "', '#dPrestamo');", true);
    }

    public void Show(string id) { 

        if ((string)ViewState["idPrestamo"] != id)
        {
            ViewState["idPrestamo"]=null;
            
            TFecha.Text = "";
            TEstimado.Text = "";
            UCPaciente.IdPaciente = "";
            UCFuncionario.IdFuncionario = "";
            TFamiliar.Text = "";
            TObservaciones.Text = "";
            CPagare.Checked = false;

            if (string.IsNullOrEmpty(id))
            {
                BAceptar.Enabled = Usuario.GetInstance().CanInsert();
            }
            else
            {
                BAceptar.Enabled = Usuario.GetInstance().CanUpdate();
                Query query = new Query("equipo_prestamo");
                using (CConector conector = new CConector())
                {
                    query += "fecha";
                    query += "estimado";
                    query += "paciente";
                    query += "funcionario";
                    query += "familiar";
                    query += "observaciones";
                    query += "pagare";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + id));
                    if (reader != null && reader.Read())
                    {
                        ViewState["idPrestamo"] = id;

                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                        TEstimado.Text = Query.GetFromMySQLDate(reader["estimado"]);
                        UCPaciente.IdPaciente = reader["paciente"].ToString();
                        UCFuncionario.IdFuncionario = reader["funcionario"].ToString();
                        TFamiliar.Text = reader["familiar"].ToString();
                        TObservaciones.Text = reader["observaciones"].ToString();
                        CPagare.Checked = reader["pagare"].ToString() == "1";
                    }
                }
            }
        }
        PPrestamo.Visible = true;
        ScriptManager.RegisterStartupScript(PPrestamo, typeof(String), "prestamoDlg", "addDialog('#" + PPrestamo.ClientID + "', '#dPrestamo');", true);
    }
    public void Hide()
    {
        PPrestamo.Visible = false;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { 

        }
    }

    public Prestamo Guardar(Prestamo info) {

        info.Fecha= Convert.ToDateTime(TFecha.Text);
        if (TEstimado.Text.Length == 0)
            info.Estimado = null;
        else info.Estimado = Convert.ToDateTime(TEstimado.Text);
        info.IdPaciente= UCPaciente.IdPaciente;
        info.IdFuncionario = UCFuncionario.IdFuncionario;
        info.Familiar= TFamiliar.Text;
        info.Observaciones = TObservaciones.Text;
        info.Pagare = CPagare.Checked;

        return info;
    }

    public string Guardar(string idEquipo)
    {
        Query query = new Query("equipo_prestamo");

        query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
        query["estimado"] = Query.GetMySQLDateFormat(TEstimado.Text);
        query["paciente"] = UCPaciente.IdPaciente;
        query["funcionario"] = UCFuncionario.IdFuncionario;
        query["familiar"] = TFamiliar.Text;
        query["observaciones"] = TObservaciones.Text;
        query["pagare"] = CPagare.Checked ? "1" : "";

        if (string.IsNullOrEmpty((string)ViewState["idPrestamo"]))
        {
            query["equipo"] = idEquipo;
            return query.GetInsert();
        }
        return query.GetUpdate("id=" + ViewState["idPrestamo"].ToString());
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (BAceptarClicked != null)
            BAceptarClicked(sender, e);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        if (BCancelarClicked != null)
            BCancelarClicked(sender, e);
        Hide();
    }
}
