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
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            UCFuncionario.IdFuncionario = usuario["personal"];
            if (usuario.CanUpdate())
                STipo.SelectParameters["canUpdate"].DefaultValue = "1";

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
                    UCFuncionario.ReadOnly = !usuario.CanAdmin();

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;
                }
                TFecha.Focus();

                if (!string.IsNullOrEmpty(Request.QueryString["epid"]))
                {
                    using (CConector conectormy = new CConector())
                    {
                        Query epicrisis = new Query("epicrisis");

                        epicrisis += "id";
                        epicrisis += "fecha";
                        epicrisis += "valoracion_inicial";
                        epicrisis += "valoracion_final";
                        epicrisis += "intervencion_propuesta";
                        epicrisis += "intervencion_realizada";
                        epicrisis += "logros";
                        epicrisis += "observaciones";
                        epicrisis += "funcionario";
                        epicrisis += "tipo";

                        MySqlDataReader readermysql = conectormy.Query(epicrisis.GetSelect("id=" + Query.GetValor(Request.QueryString["epid"])));
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
                            UCFuncionario.IdFuncionario = readermysql["funcionario"].ToString();
                            Utilidades.SelectInDropDown(DTipo, readermysql["tipo"].ToString(), Procedimientos.GetNombreMedicamento(readermysql["tipo"].ToString()));

                            ((MasterPageI)Master).SetModificacion(HIdEpicrisis.Value);
                        }
                    }
                }
                PHistorial.Visible = GridUtils.GetRowsCount(GHistorial, LHistorial, "Epicrisis", "Epicrisis") > 0;
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
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;

            epicrisis["fecha"] = Query.GetMySQLDateFormat(Convert.ToDateTime(TFecha.Text));
            epicrisis["valoracion_inicial"] = TValoracionInicial.Text;
            epicrisis["valoracion_final"] = TValoracionFinal.Text;
            epicrisis["intervencion_propuesta"] = TIntervencionPropuesta.Text;
            epicrisis["intervencion_realizada"] = TIntervencionRealizada.Text;
            epicrisis["logros"] = TLogros.Text;
            epicrisis["observaciones"] = TObservaciones.Text;
            epicrisis["tipo"] = DTipo.SelectedValue;
            epicrisis["funcionario"] = UCFuncionario.IdFuncionario;

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
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        Query query = new Query("recurso_humano");

        query["szProfesional"] = "recurso_humano.perDocumento";
        query["szMedico"] = "recurso_humano.perNombre";
        query["szCargo"] = "cargo.carDescripcion";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(UCFuncionario.IdFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
        }
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM epicrisis WHERE id=" + HIdEpicrisis.Value) == -1)
                return;
            conector.Commit();
            ((MasterPageI)Master).SetResultado("Epicrisis eliminada " + CCDetallePaciente.Nombres);
        }
    }
}
