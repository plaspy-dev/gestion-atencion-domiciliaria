using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Text;
using System.IO;
using SDG.Componentes;

public partial class paciente_epicrisis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();
            if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);

                    BAceptar.Enabled = usuario.CanInsert();

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;
                }
                TFecha.Focus();

                CConectorMS conector = CConectorMS.GetConector();
                CConector conectormy = CConector.GetConector();

                Query epicrisis = new Query("epicrisis");

                epicrisis += "id";
                epicrisis += "fecha";
                epicrisis += "valoracion_inicial";
                epicrisis += "valoracion_final";
                epicrisis += "intervencion_propuesta";
                epicrisis += "intervencion_realizada";
                epicrisis += "logros";
                epicrisis += "observaciones";

                MySqlDataReader readermysql = conectormy.Query(epicrisis.GetSelect("paciente=" + CCDetallePaciente.IdPaciente));
                if (readermysql != null && readermysql.Read())
                {
                    ((MasterPageI)Master).Imprimir("epicrisis.html");
                    BAceptar.Enabled = usuario.CanUpdate();

                    HIdEpicrisis.Value = readermysql["id"].ToString();
                    TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                    TValoracionInicial.Text = readermysql["valoracion_inicial"].ToString();
                    TValoracionFinal.Text = readermysql["valoracion_final"].ToString();
                    TIntervencionPropuesta.Text = readermysql["intervencion_propuesta"].ToString();
                    TIntervencionRealizada.Text = readermysql["intervencion_realizada"].ToString();
                    TLogros.Text = readermysql["logros"].ToString();
                    TObservaciones.Text = readermysql["observaciones"].ToString();

                    ((MasterPageI)Master).SetModificacion(HIdEpicrisis.Value);
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query epicrisis = new Query("epicrisis");
        CConector conector = CConector.GetConector();
        string szQuery;
        string mensaje;

        epicrisis["fecha"]= CConector.GetDate(Convert.ToDateTime( TFecha.Text));
        epicrisis["valoracion_inicial"]= TValoracionInicial.Text;
        epicrisis["valoracion_final"]= TValoracionFinal.Text;
        epicrisis["intervencion_propuesta"]= TIntervencionPropuesta.Text;
        epicrisis["intervencion_realizada"]= TIntervencionRealizada.Text;
        epicrisis["logros"]= TLogros.Text;
        epicrisis["observaciones"]= TObservaciones.Text;
                
        if (HIdEpicrisis.Value.Length == 0)
        {
            epicrisis["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = epicrisis.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdEpicrisis.Value = resultado.ToString();
        }
        else
        {
            szQuery = epicrisis.GetUpdate("id='" + HIdEpicrisis.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdEpicrisis.Value) == -1)
            return;

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        Query query = new Query("phdPaciente");

        // SELECT perDocumento,perNombre FROM phdPaciente LEFT JOIN admPersonalHS ON (admPersonalHS.perId=phdPaciente.megId)

        query["categoria"] = "categoria";
        query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";
        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szMedico"] = "admPersonalHS.perNombre";

        CConectorMS conectorms = new CConectorMS();

        SqlDataReader reader = conectorms.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente, "LEFT JOIN admPersonalHS ON (admPersonalHS.perId=phdPaciente.megId)"));
        if (reader != null)
        {
            bool l = reader.Read();
            if (l)
            {
                evento.Contenido = evento.Contenido.Replace("$szCategoria$", new CConector().QueryString("SELECT nombre FROM varios WHERE id='" + reader["categoria"].ToString() + "' AND tipo=13"));
            }
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }
    }
}
