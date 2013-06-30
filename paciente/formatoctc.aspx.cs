using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.SqlClient;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class paciente_formatoctc : System.Web.UI.Page
{
    [Serializable]
    public class Medicamento
    {
        public int IdGrid { get; set; }
        public string Id { get; set; }
        public string Nombre { get; set; }
        public double Cantidad { get; set; }
        public string Tiempo { get; set; }
        public string Efecto { get; set; }
        public string Respuesta { get; set; }
        public string EfectosSecundarios { get; set; }

        public Medicamento(int idgrid)
        {
            IdGrid = idgrid;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled = false;
            BFecha.Enabled = false;
            BFormula.Visible = false;
            PFormulaciones.Visible = false;

            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            if (!string.IsNullOrEmpty(Request.QueryString["fcid"]))
            {
                using (CConector conectormy = new CConector())
                {
                    Query formulacion = new Query("formato_ctc");

                    formulacion += "paciente";
                    formulacion += "fecha";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("id=" + Query.GetValor(Request.QueryString["fcid"])));
                    if (readermysql != null && readermysql.Read())
                    {
                        Response.Redirect("~/paciente/formatoctc.aspx?pid=" + readermysql["paciente"].ToString() + "&f=" + string.Format("{0:d}", Convert.ToDateTime(readermysql["fecha"])));
                    }
                }
            }
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
                    BMasFormulacion.Enabled = usuario.CanInsert();
                    TFecha.Focus();
                    BFecha.Enabled = true;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;

                    using (CConectorMS conector = new CConectorMS())
                    using (CConector conectormy = new CConector())
                    {

                        TFecha.Text = Request.QueryString["f"];
                        if (TFecha.Text.Length == 0)
                            TFecha.Text = DateTime.Now.ToShortDateString();

                        Query formulacion = new Query("formato_ctc");

                        formulacion += "id";
                        formulacion += "fecha";
                        formulacion += "profesional";

                        MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "'"));
                        if (readermysql != null && readermysql.Read())
                        {
                            ((MasterPageI)Master).Imprimir("formatoctc.html");

                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasFormulacion.Enabled = usuario.CanInsert();

                            GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                            GFormulacion.Columns[1].Visible = usuario.CanDelete();

                            HIdFormulacion.Value = readermysql["id"].ToString();
                            TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                            ViewState["profesional"] = readermysql["profesional"].ToString();

                            List<Medicamento> medicamentos = new List<Medicamento>();

                            Query qmedicamentos = new Query("formato_ctc_items");

                            qmedicamentos += "id";
                            qmedicamentos += "nombre";
                            qmedicamentos += "cantidad";
                            qmedicamentos += "tiempo";
                            qmedicamentos += "efecto";
                            qmedicamentos += "respuesta";
                            qmedicamentos += "efecto_secundario";

                            readermysql = conectormy.Query(qmedicamentos.GetSelect("formato_ctc=" + HIdFormulacion.Value));
                            if (readermysql != null)
                            {
                                while (readermysql.Read())
                                {
                                    Medicamento info = new Medicamento(medicamentos.Count);
                                    info.Id = readermysql["id"].ToString();
                                    info.Cantidad = Convert.ToDouble(readermysql["cantidad"]);
                                    info.Nombre = readermysql["nombre"].ToString();
                                    info.Tiempo = readermysql["tiempo"].ToString();
                                    info.Efecto = readermysql["efecto"].ToString();
                                    info.Respuesta = readermysql["respuesta"].ToString();
                                    info.EfectosSecundarios = readermysql["efecto_secundario"].ToString();
                                    medicamentos.Add(info);
                                }
                            }

                            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
                            GFormulacion.DataSource = medicamentos;
                            GFormulacion.DataBind();

                            ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                        }
                        else
                        {

                            BFormula.Visible = conectormy.QueryString("SELECT id FROM formato_ctc WHERE paciente=" + CCDetallePaciente.IdPaciente + " LIMIT 1;").Length != 0;
                        }

                        GFormulaciones.DataBind();
                        LFormulaciones.Text = GFormulaciones.Rows.Count + " Formato";
                        LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "s";
                        PFormulaciones.Visible = GFormulaciones.Rows.Count > 0;
                    }
                }
            }
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);

        Medicamento info = null;
        if (GFormulacion.SelectedIndex != -1)
        {
            List<Medicamento> resultado = (from t in medicamentos
                                           where t.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                           select t).ToList();
            if (resultado.Count != 0)
                info = resultado.First();
        }
        if (info == null)
        {
            info = new Medicamento(medicamentos.Count);
            medicamentos.Add(info);
        }

        info.Nombre= TNombre.Text;
        info.Cantidad= Convert.ToDouble(TCantidad.Text,CultureInfo.InvariantCulture);
        info.Tiempo= TTiempo.Text;
        info.Efecto= TEfecto.Text;
        info.Respuesta= TRespuesta.Text;
        info.EfectosSecundarios= TEfectosSecundarios.Text;

        HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
        GFormulacion.SelectedIndex = -1;
        GFormulacion.DataSource = medicamentos;
        GFormulacion.DataBind();

        TNombre.Text= TCantidad.Text = TTiempo.Text= TEfecto.Text= TRespuesta.Text= TEfectosSecundarios.Text= "";
        TNombre.Focus();
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        }
        catch { }

        Query formulacion = new Query("formato_ctc");

        string szQuery;
        string mensaje;

        using (CConector conector = new CConector())
        {
            using (CConectorMS conectorMS = new CConectorMS())
            {
                conector.StartTransaction();
                conectorMS.StartTransaction();

                DateTime fecha = Convert.ToDateTime(TFecha.Text);

                formulacion["fecha"] = CConector.GetMySQLDateFormat(TFecha.Text);
                formulacion["profesional"] = CUsuario.GetUsuario()["personal"];
                formulacion["asegurador"] = CCDetallePaciente.AsegurdadorID;

                if (HIdFormulacion.Value.Length == 0)
                {
                    formulacion["paciente"] = CCDetallePaciente.IdPaciente;

                    szQuery = formulacion.GetInsert();
                    mensaje = CCDetallePaciente.Nombres + " ingresado";
                    int resultado = conector.QueryMod(szQuery, true);
                    if (resultado == -1)
                        return;
                    HIdFormulacion.Value = resultado.ToString();
                }
                else
                {
                    szQuery = formulacion.GetUpdate("id='" + HIdFormulacion.Value + "'");
                    mensaje = CCDetallePaciente.Nombres + " editado";
                    if (conector.QueryMod(szQuery) == -1)
                        return;
                }
                if (conector.InsertModificacion(HIdFormulacion.Value) == -1)
                    return;

                Query medicamento = new Query("formato_ctc_items");

                List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
                for (int i = 0; i < medicamentos.Count; i++)
                {


                    Medicamento info = medicamentos[i];

                    medicamento["nombre"] = info.Nombre;
                    medicamento["cantidad"] = info.Cantidad.ToString(CultureInfo.InvariantCulture);
                    medicamento["tiempo"] = info.Tiempo;
                    medicamento["efecto"] = info.Efecto;
                    medicamento["respuesta"] = info.Respuesta;
                    medicamento["efecto_secundario"] = info.EfectosSecundarios;

                    if (string.IsNullOrEmpty(info.Id))
                    {
                        medicamento["formato_ctc"] = HIdFormulacion.Value;
                        if (conector.QueryMod(medicamento.GetInsert()) == -1)
                            return;
                    }
                    else
                    {
                        if (conector.QueryMod(medicamento.GetUpdate("id=" + info.Id)) == -1)
                            return;
                    }
                }

                conector.Commit();
                conectorMS.Commit();
            }
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from info in medicamentos
                                       where info.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                       select info).ToList();

        if (resultado.Count != 0)
        {

            Medicamento info = resultado.First();

            TNombre.Text = info.Nombre;
            TCantidad.Text = info.Cantidad.ToString(CultureInfo.InvariantCulture);
            TTiempo.Text = info.Tiempo;
            TEfecto.Text = info.Efecto;
            TRespuesta.Text = info.Respuesta;
            TEfectosSecundarios.Text = info.EfectosSecundarios;
        }
    }


    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
        evento.Contenido = evento.Contenido.Replace("$Apellidos$", paciente.pApellido + " " + paciente.sApellido);
        evento.Contenido = evento.Contenido.Replace("$Nombres$", paciente.pNombre+ " " + paciente.sNombre);

        evento.Contenido = evento.Contenido.Replace("$contributivo$", paciente.tipopago=="POS" ? "X" : "_");
        evento.Contenido = evento.Contenido.Replace("$subsidiado$", paciente.tipopago == "POS" ? "_" : "X");

        string []fecha= TFecha.Text.Split('/');
        evento.Contenido = evento.Contenido.Replace("$dia$", fecha[0]);
        evento.Contenido = evento.Contenido.Replace("$mes$", fecha[1]);
        evento.Contenido = evento.Contenido.Replace("$ano$", fecha[2]);

        using(CConector conector=new CConector())
        using (CConectorMS conectorms = new CConectorMS())
        {
            string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
            string idmedico = conector.QueryString("SELECT usuario.personal FROM modificaciones LEFT JOIN usuario ON (usuario.id=modificaciones.usuario) WHERE modificaciones.id='" + HIdFormulacion.Value + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha LIMIT 1");
            Query query = new Query("admPersonalHS");

            query["szProfesional"] = "admPersonalHS.perDocumento";
            query["szMedico"] = "admPersonalHS.perNombre";
            query["szCargo"] = "admCargo.carDescripcion";

            SqlDataReader reader = conectorms.Query(query.GetSelect("perId=" + Query.GetValor(idmedico), " LEFT JOIN admCargo ON (admCargo.carId=admPersonalHS.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }

            query = new Query("ingreso_paciente");
            
            query += "id";
            query += "enfermedad_actual";

            MySqlDataReader myreader= conector.Query(query.GetSelect("paciente=" + paciente.Id));
            if (myreader != null && myreader.Read())
            {
                evento.Contenido = evento.Contenido.Replace("$hclinica$", myreader["id"].ToString());
                evento.Contenido = evento.Contenido.Replace("$enfermedad_actual$", myreader["enfermedad_actual"].ToString());
            }
        }


        int pos = evento.Contenido.IndexOf("<div");
        int posf = evento.Contenido.IndexOf("</div>");

        string contenidoreal = evento.Contenido.Substring(pos, posf - pos + 6);

        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        for (int i = medicamentos.Count-1; i >= 0; i--)
        {
            string contenido = i==0 ? evento.Contenido : contenidoreal;

            contenido = contenido.Replace("$Nombre$", medicamentos[i].Nombre);
            contenido = contenido.Replace("$Cantidad$", medicamentos[i].Cantidad.ToString());
            contenido = contenido.Replace("$Tiempo$", medicamentos[i].Tiempo);
            contenido = contenido.Replace("$Efecto$", medicamentos[i].Efecto);
            contenido = contenido.Replace("$Respuesta$", medicamentos[i].Respuesta);
            contenido = contenido.Replace("$EfectosSecundarios$", medicamentos[i].EfectosSecundarios);

            if (i == 0)
                evento.Contenido = contenido;
            else
                evento.Contenido = evento.Contenido.Insert(posf + 6, contenido);
        }
    }

    protected void BFormula_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string id = conector.QueryString("SELECT id FROM formato_ctc WHERE paciente=" + CCDetallePaciente.IdPaciente + " ORDER BY fecha DESC LIMIT 1;");
            if (id.Length != 0)
            {
                Query medicamento = new Query("formato_ctc_items");

                medicamento += "nombre";
                medicamento += "cantidad";
                medicamento += "tiempo";
                medicamento += "efecto";
                medicamento += "respuesta";
                medicamento += "efecto_secundario";

                MySqlDataReader reader = conector.Query(medicamento.GetSelect("formato_ctc=" + id));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        TNombre.Text = reader["nombre"].ToString();
                        TCantidad.Text = Convert.ToDouble(reader["cantidad"]).ToString(CultureInfo.InvariantCulture);
                        TTiempo.Text = reader["tiempo"].ToString();
                        TEfecto.Text = reader["efecto"].ToString();
                        TRespuesta.Text = reader["respuesta"].ToString();
                        TEfectosSecundarios.Text = reader["efecto_secundario"].ToString();

                        BMasFormulacion_Click(sender, e);
                    }
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formatoctc.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)));
    }

    protected void GFormulacion_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from t in medicamentos
                                       where t.IdGrid.ToString() == GFormulacion.DataKeys[e.RowIndex].Value.ToString()
                                       select t).ToList();
        if (resultado.Count != 0)
        {

            Medicamento info = resultado.First();
            if (!string.IsNullOrEmpty(info.Id))
            {
                using (CConector conector = new CConector())
                {
                    if (conector.QueryMod("DELETE FROM formato_ctc_items WHERE id=" + Query.GetValor(info.Id)) == -1)
                    {
                        LMensajeMedicamento.Text = conector.GetLastError();
                        return;
                    }
                }
            }

            medicamentos.Remove(info);
            for (int i = 0; i < medicamentos.Count; i++)
                medicamentos[i].IdGrid = i;

            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
            GFormulacion.SelectedIndex = -1;
            GFormulacion.DataSource = medicamentos;
            GFormulacion.DataBind();
        }
    }
}
