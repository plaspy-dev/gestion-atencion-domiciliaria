using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class eventos_pacientes : System.Web.UI.Page
{
    public class Evento {
        public static string GetEvento(string id) {
            using (CConector conector = new CConector()) {
                return conector.QueryString("SELECT nombre FROM programacion_evento WHERE id=" + Query.GetValor(id));
            }
        }
    }
    [Serializable]
    public class Atencion {
        public string Id { get; set; }
        public DateTime Fecha {get;set;}
        public string IdEvento {get;set;}
        public string NombreEvento { get { return Evento.GetEvento(IdEvento); } }
        public string CIE10 {get;set;}
        public string CIE10Descripcion { get { return Procedimientos.GetCodigoCIE(CIE10); } }
        public string Diagnostico {get;set;}
        public bool Remitido {get;set;}
        public string Ambulancia {get;set;}
        public string IPSRemision {get;set;}
        public string Acompanante { get; set; }
        public string TipoPaciente { get; set; }
        public string CodigoAmbulancia { get; set; }

        public bool Eliminado {get;set;}
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
            ViewState["atencion"] = new List<Atencion>();

            Usuario usuario = Usuario.GetUsuario();
            string documento = Request.QueryString["id"];
            TDocumento.Focus();
            if (documento != null)
            {
                BAceptar.Enabled = usuario.CanInsert();
                TDocumento.Text = documento;
                TNombres.Focus();

                using (CConector conector = new CConector())
                {
                    Query query = new Query("paciente_evento");

                    query += "nombres";
                    query += "apellidos";
                    query += "edad";

                    MySqlDataReader reader = conector.Query(query.GetSelect("documento='" + documento + "'"));
                    if (reader != null && reader.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();
                        GAtencion.Columns[0].Visible = usuario.CanUpdate();
                        GAtencion.Columns[1].Visible = usuario.CanDelete();

                        HDocumento.Value = documento;

                        TNombres.Text = reader["nombres"].ToString();
                        TApellidos.Text = reader["apellidos"].ToString();
                        TEdad.Text = reader["edad"].ToString();

                        Query atencion = new Query("atencion_paciente");

                        atencion += "id";
                        atencion += "fecha";
                        atencion += "evento";
                        atencion += "cie10";
                        atencion += "diagnostico";
                        atencion += "remitido";
                        atencion += "ambulancia";
                        atencion += "IPSremitida";
                        atencion += "acompanante";
                        atencion += "tipopaciente";
                        atencion += "codigo_ambulancia";

                        List<Atencion> lista = new List<Atencion>();

                        reader= conector.Query(atencion.GetSelect("paciente=" + Query.GetValor(documento)));
                        if (reader != null) {
                            while (reader.Read()) {
                                Atencion info = new Atencion();
                                
                                info.IdEvento = reader["evento"].ToString();
                                info.Fecha = (DateTime)reader["fecha"];
                                info.CIE10 = reader["cie10"].ToString();
                                info.Diagnostico = reader["diagnostico"].ToString();
                                info.Id = reader["id"].ToString();
                                info.Remitido = reader["remitido"].ToString() == "True";
                                info.Ambulancia = reader["ambulancia"].ToString();
                                info.IPSRemision = reader["IPSremitida"].ToString();
                                info.Acompanante = reader["acompanante"].ToString();
                                info.TipoPaciente = reader["tipopaciente"].ToString();
                                info.CodigoAmbulancia = reader["codigo_ambulancia"].ToString();
                                lista.Add(info);
                            }
                        }
                        GAtencion.DataSource = lista.Where(x=> !x.Eliminado);
                        GAtencion.DataBind();
                        ViewState["atencion"] = lista;

                        ((MasterPageI)Master).SetModificacion(documento);
                    }
                }
            }
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            Query query = new Query("paciente_evento");

            query["nombres"] = TNombres.Text;
            query["apellidos"] = TApellidos.Text;
            query["edad"] = TEdad.Text;

            if (HDocumento.Value.Length == 0)
            {

                query["documento"] = TDocumento.Text;
                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
                HDocumento.Value = TDocumento.Text;
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("documento='" + HDocumento.Value + "'")) == -1)
                    return;
            }
            if (conector.InsertModificacion(HDocumento.Value) == -1)
                return;

            List<Atencion> lista = (List<Atencion>)ViewState["atencion"];

            Query atencion = new Query("atencion_paciente");

            atencion["paciente"] = HDocumento.Value;

            foreach (Atencion info in lista) {

                if (info.Eliminado) {
                    if(conector.QueryMod(atencion.GetDelete("id=" + Query.GetValor(info.Id)))==-1)
                        return;
                    continue;
                }

                atencion["fecha"]= Query.GetMySQLDateFormat(info.Fecha, true);
                atencion["evento"]= info.IdEvento;
                atencion["cie10"]= info.CIE10;
                atencion["diagnostico"]= info.Diagnostico;
                atencion["remitido"]= info.Remitido ? "1" : "";
                atencion["ambulancia"]= info.Ambulancia;
                atencion["IPSremitida"]= info.IPSRemision;
                atencion["acompanante"] = info.Acompanante;
                atencion["tipopaciente"] = info.TipoPaciente;
                atencion["codigo_ambulancia"] = info.CodigoAmbulancia;

                if (info.Id.StartsWith("-")) { // no existe
                    if (conector.QueryMod(atencion.GetInsert()) == -1)
                        return;
                } else { 
                    if(conector.QueryMod(atencion.GetUpdate("id=" + Query.GetValor(info.Id)))==-1)
                        return;
                }
            }

            conector.Commit();
        }
        ((MasterPageI)Master).SetResultado(TNombres.Text + " Ingresado.");
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BMasAtencion_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(UAtencion, typeof(string), "fecha", "fecha_actual='" + TFecha.Text.Split(' ')[0] + "';", true);
        DAtencion.Visible = true;
    }

    protected void GAtencion_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Atencion> lista = (List<Atencion>)ViewState["atencion"];

        Atencion atencion= lista.Find(x => x.Id == GAtencion.SelectedDataKey.Values["id"].ToString());
        if (atencion == null)
            return;

        ViewState["atencion_id"] = atencion.Id;

        TFecha.Text= Query.GetFromMySQLDate(atencion.Fecha, true);
        Utilidades.SelectInDropDown(DEvento, atencion.IdEvento, atencion.NombreEvento);
        TCIE10Id.Text= atencion.CIE10;
        TCIE10.Text = atencion.CIE10Descripcion;
        TDiagnostico.Text= atencion.Diagnostico;
        CRemitido.Checked= atencion.Remitido;
        RAmbulancia.SelectedValue= atencion.Ambulancia;
        Utilidades.SelectInDropDown(DAmbulancia, atencion.CodigoAmbulancia, atencion.CodigoAmbulancia);
        
        TIPS.Text= atencion.IPSRemision;
        TAcompanante.Text = atencion.Acompanante;
        Utilidades.SelectInDropDown(DTipoPaciente, atencion.TipoPaciente);

        ScriptManager.RegisterClientScriptBlock(UAtencion, typeof(string), "fecha", "fecha_actual='" + TFecha.Text.Split(' ')[0] + "';", true);
        DAtencion.Visible = true;
    }

    protected void BAgregarA_Click(object sender, EventArgs e)
    {
        List<Atencion> lista = (List<Atencion>)ViewState["atencion"];

        Atencion atencion = null;
        string id = (string)ViewState["atencion_id"];
        if (!string.IsNullOrEmpty(id)) 
            atencion= lista.Find(x => x.Id == id);
        if (atencion == null)
        {
            atencion = new Atencion();
            atencion.Id = "-" + (lista.Count + 1);
            lista.Add(atencion);
        }

        atencion.Fecha = Convert.ToDateTime(TFecha.Text);
        atencion.IdEvento = DEvento.SelectedValue;
        atencion.CIE10 = TCIE10Id.Text;
        atencion.Diagnostico = TDiagnostico.Text;
        atencion.Remitido = CRemitido.Checked;
        atencion.Ambulancia = RAmbulancia.SelectedValue;
        atencion.IPSRemision = TIPS.Text;
        atencion.Acompanante = TAcompanante.Text;
        atencion.TipoPaciente = DTipoPaciente.SelectedValue;
        atencion.CodigoAmbulancia = DAmbulancia.SelectedValue;

        GAtencion.DataSource = lista.Where(x => !x.Eliminado);
        GAtencion.DataBind();
        ViewState["atencion"] = lista;

        BCancelarA_Click(sender, e);
    }

    protected void BCancelarA_Click(object sender, EventArgs e)
    {
        ViewState["atencion_id"] = null;

        TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
        TCIE10Id.Text = "";
        TCIE10.Text = "";
        TDiagnostico.Text = "";
        CRemitido.Checked = false;
        RAmbulancia.SelectedValue = "";
        TIPS.Text = "";
        TAcompanante.Text = "";
        DTipoPaciente.SelectedValue = "";
        DAmbulancia.DataBind();

        DAtencion.Visible = false;
        GAtencion.SelectedIndex = -1;
    }

    protected void GAtencion_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Atencion> lista = (List<Atencion>)ViewState["atencion"];
        e.Cancel=false;

        lista.FirstOrDefault(x=>x.Id==GAtencion.DataKeys[e.RowIndex].Values["id"].ToString()).Eliminado=true;

        GAtencion.DataSource = lista.Where(x => !x.Eliminado);
        GAtencion.DataBind();
        ViewState["atencion"] = lista;
    }

    protected void BActualizar_Click(object sender, EventArgs e)
    {

    }
}
