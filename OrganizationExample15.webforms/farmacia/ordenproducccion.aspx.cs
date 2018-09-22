using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class farmacia_ordenproducccion : System.Web.UI.Page
{
    [Serializable]
    public class Medicamento
    {
        public int Index { get; set; }
        public string IdTabla { get; set; }
        public string IdMedicamento { get; set; }
        public string MedicamentoN { get; set; }
        public string Dosis { get; set; }
        public int Cantidad { get; set; }
        public int Dias { get; set; }
        public double Volumen { get; set; }
        public string Vencimiento { get; set; }
        public string Concentracion { get; set; }
        public string Lote { get; set; }
        public bool Deleted { get; set; }
        public Medicamento()
        {
            Index = -1;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            UCFuncionario.IdFuncionario = usuario["personal"];
            UCFuncionario.ReadOnly = !usuario.CanAdmin();

            using (CConector conector = new CConector())
            {
                string id = null;
                if (!string.IsNullOrEmpty(Request.QueryString["k"]))
                {
                    id = Crypt.DesencriptarDES(Request.QueryString["k"].Replace(" ", "+"), System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY"));
                    if (string.IsNullOrEmpty(id))
                        throw new HttpException(404, "Page not found");
                }
                if (string.IsNullOrEmpty(id))
                {
                    if (usuario.GetPermisos(Request.Url.AbsolutePath) == (int)Usuario.Permisos.Print) // es un usuario de solo impresion
                        throw new HttpException(404, "Page not found");
                    id = Request.QueryString["opid"];
                }
                if (!string.IsNullOrEmpty(id))
                {
                    Query query = new Query("ordenproduccion");

                    query += "id";
                    query += "fecha";
                    query += "paciente";
                    query += "proveedor";
                    query += "referenciabomba";
                    query += "realizadopor";
                    query += "observaciones";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(id)));
                    if (reader != null && reader.Read())
                    {

                        BAceptar.Enabled = usuario.CanUpdate();
                        GM.Columns[1].Visible = usuario.CanDelete();

                        id = reader["id"].ToString();
                        TNumero.Text = id;
                        ViewState["id"] = id;
                        ((MasterPageI)Master).SetModificacion(id);
                        ((MasterPageI)Master).Imprimir("ordenproduccion.html");

                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                        UCPaciente.IdPaciente = reader["paciente"].ToString();
                        TTerceroID.Text = reader["proveedor"].ToString();
                        Tercero tercero = new Tercero(reader["proveedor"].ToString());
                        TProveedor.Text = tercero.Nombre;
                        TBomba.Text = reader["referenciabomba"].ToString();
                        UCFuncionario.IdFuncionario = reader["realizadopor"].ToString();
                        TObservaciones.Text = reader["observaciones"].ToString();

                        query = new Query("ordenproduccion_medicamentos");

                        query += "id";
                        query += "medicamento";
                        query += "dosis";
                        query += "cantidad";
                        query += "dias";
                        query += "volumen";
                        query += "vence";
                        query += "lote";
                        query += "concentracion";

                        List<Medicamento> lista = new List<Medicamento>();
                        reader = conector.Query(query.GetSelect("orden={0}", null, Query.GetValor(id)));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                Medicamento info = new Medicamento();
                                Producto producto = new Producto(reader["medicamento"].ToString());

                                info.IdTabla = reader["id"].ToString();
                                info.IdMedicamento = producto.id;
                                info.MedicamentoN = producto.NombreCompleto;
                                info.Dosis = reader["dosis"].ToString();
                                info.Cantidad = (int)reader["cantidad"];
                                info.Dias = (int)reader["dias"];
                                info.Volumen = Convert.ToDouble(reader["volumen"]);
                                info.Vencimiento = Query.GetMySQLDateFormat((DateTime)reader["vence"]);
                                info.Lote = reader["lote"].ToString();
                                info.Concentracion = reader["concentracion"].ToString();
                                lista.Add(info);
                            }
                        }

                        int index = 0;
                        lista.ForEach(x => x.Index = index++);

                        ViewState["medicamentos"] = lista;
                        GM.DataSource = lista.Where(x => !x.Deleted);
                        GM.DataBind();

                        return;
                    }
                }

                TNumero.Text = conector.QueryString("SELECT IF(MAX(id),MAX(id)+1,1) FROM ordenproduccion");
            }

            BAceptar.Enabled = usuario.CanInsert();
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);
            TNumero.Focus();
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        if (GM.Rows.Count == 0)
        {
            LMessage.Text = "Por favor ingrese por lo menos un medicamento";
            return;
        }

        using (CConector conector = new CConector())
        {
            CUsuario usuario = (CUsuario)Usuario.GetInstance();
            string id = (string)ViewState["id"];
            bool nueva = false;

            Query query = new Query("ordenproduccion");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["paciente"] = UCPaciente.IdPaciente;
            query["proveedor"] = TTerceroID.Text;
            query["referenciabomba"] = TBomba.Text;
            query["realizadopor"] = UCFuncionario.IdFuncionario;
            query["observaciones"] = TObservaciones.Text;

            if (string.IsNullOrEmpty(id))
            {
                nueva = true;
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMessage.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                {
                    LMessage.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }


            List<Medicamento> lista = ViewState["medicamentos"] as List<Medicamento> ?? new List<Medicamento>();

            query = new Query("ordenproduccion_medicamentos");

            query["orden"] = id;

            foreach (Medicamento info in lista)
            {
                if (info.Deleted)
                {
                    if (!string.IsNullOrEmpty(info.IdTabla))
                    {
                        if (conector.QueryMod("DELETE FROM ordenproduccion_medicamentos WHERE id={0}", false, Query.GetValor(info.IdTabla)) == -1)
                        {
                            LMessage.Text = conector.LastError;
                            return;
                        }
                    }
                    continue;
                }
                query["medicamento"] = info.IdMedicamento;
                query["dosis"] = info.Dosis;
                query["cantidad"] = info.Cantidad;
                query["dias"] = info.Dias;
                query["volumen"] = info.Volumen;
                query["vence"] = info.Vencimiento;
                query["lote"] = info.Lote;
                query["concentracion"] = info.Concentracion;

                if (string.IsNullOrEmpty(info.IdTabla))
                {
                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMessage.Text = conector.LastError;
                        return;
                    }
                }
                else
                {
                    if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(info.IdTabla))) == -1)
                    {
                        LMessage.Text = conector.LastError;
                        return;
                    }
                }
            }



            try
            {
                Tercero tecero = new Tercero(TTerceroID.Text);

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("demo@example.invalid", "Compras OrganizationExample15");
                if (CUsuario.IsValidEmail(tecero.Email))
                { // no le enviamos correo al proveedor
                    mail.To.Add(tecero.Email);
#if DEBUG
                    mail.To.Clear();
                    mail.To.Add("demo@example.invalid");
#endif
                }
                // mail.Bcc.Add();

                mail.Subject = nueva ? "Nueva " : "Actualizada ";
                mail.Subject += "orden de producción No. " + id;
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.Normal;

                StringBuilder Contenido = new StringBuilder();
                using (StreamReader reader = new StreamReader(Server.MapPath("ordenproduccioncorreo.html")))
                {
                    Contenido = new StringBuilder(reader.ReadToEnd());
                    reader.Close();
                }

                Paciente paciente = Paciente.GetPaciente(UCPaciente.IdPaciente);

                Contenido = Contenido.Replace("$szDireccion$", paciente.Direccion)
                    .Replace("$TPaciente$", paciente.DocumentoYNombres.Replace("Inactivo - ", ""))
                    .Replace("$szTelefono$", paciente.Telefono)
                    .Replace("$szAsegurador$", paciente.NombreEntidad)
                    .Replace("$szBarrio$", paciente.Barrio)
                    ;

                Contenido = Utilidades.ReplaceContenido(Page.Controls, Contenido)
                    .Replace("../imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                    .Replace("../css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")))
                    .Replace("~/imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                    .Replace("~/css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")));

                mail.Body = Contenido.Replace("$szVinculo$", string.Format("{0}{1}?k={3}&pdf=1", ConfigurationManager.AppSettings["servidor"], Request.Url.AbsolutePath, id, HttpUtility.UrlEncode(Crypt.EncriptarDES(id, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY"))))).ToString();

                SmtpClient client = new SmtpClient();
                client.EnableSsl = client.Port == 587 || client.Port == 465;
                if (CUsuario.IsValidEmail(tecero.Email)) // no le enviamos correo al proveedor
                    client.Send(mail);

                // esta es la copia del correo
                mail.To.Clear();
                mail.To.Add(ConfigurationManager.AppSettings["ordenesdecompra:copia"]);
                mail.Body = Contenido.Replace("$szVinculo$", string.Format("{0}{1}?oci={2}&pdf=1", ConfigurationManager.AppSettings["servidor"], Request.Url.AbsolutePath, id)).ToString();
                client.Send(mail);
            }
            catch (Exception ex)
            {
                ((MasterPageI)Master).SetResultado(ex.Message);
                return;
            }


            ((MasterPageI)Master).SetResultado("Orden de producción " + id + " editada.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAdd_Click(object sender, EventArgs e)
    {
        PAM.Visible = true;
    }

    protected void BCM_Click(object sender, EventArgs e)
    {
        TProductoID.Text =
            TCantidad.Text =
            TDosis.Text =
            TDias.Text =
            TVolumen.Text =
            TVence.Text =
            TLote.Text =
            TConcentracion.Text =
        TProducto.Text = "";
        ViewState.Remove("idmedicamento");
        GM.SelectedIndex = -1;
        PAM.Visible = false;
    }

    protected void BAM_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        List<Medicamento> lista = ViewState["medicamentos"] as List<Medicamento> ?? new List<Medicamento>();
        Medicamento info = lista.Find(x => x.Index == ViewState["idmedicamento"] as int?) ?? new Medicamento();

        info.IdMedicamento = TProductoID.Text;
        info.MedicamentoN = TProducto.Text;
        info.Cantidad = Convert.ToInt32(TCantidad.Text);
        info.Dosis = TDosis.Text;
        info.Dias = Convert.ToInt32(TDias.Text);
        info.Volumen = Convert.ToDouble(TVolumen.Text, CultureInfo.InvariantCulture);
        info.Vencimiento = Query.GetMySQLDateFormat(TVence.Text);
        info.Concentracion = TConcentracion.Text;
        info.Lote = TLote.Text;

        if (info.Index == -1)
        {
            lista.Add(info);
            info.Index = lista.Count;
        }

        ViewState["medicamentos"] = lista;
        GM.DataSource = lista.Where(x => !x.Deleted);
        GM.DataBind();

        BCM_Click(sender, e);
    }

    protected void GM_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<Medicamento> lista = ViewState["medicamentos"] as List<Medicamento> ?? new List<Medicamento>();
        lista.Where(x => x.Index == e.Keys["Index"] as int?).ToList().ForEach(x => x.Deleted = true);

        ViewState["medicamentos"] = lista;
        GM.DataSource = lista.Where(x => !x.Deleted);
        GM.DataBind();
    }

    protected void GM_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Medicamento> lista = ViewState["medicamentos"] as List<Medicamento> ?? new List<Medicamento>();
        Medicamento info = lista.Find(x => x.Index == GM.SelectedDataKey["Index"] as int?);
        if (info != null)
        {
            ViewState["idmedicamento"] = info.Index;

            TProductoID.Text = info.IdMedicamento;
            TProducto.Text = info.MedicamentoN;
            TCantidad.Text = info.Cantidad.ToString();
            TDosis.Text = info.Dosis.ToString(CultureInfo.InvariantCulture);
            TDias.Text = info.Dias.ToString();
            TVolumen.Text = info.Volumen.ToString(CultureInfo.InvariantCulture);
            TVence.Text = Query.GetFromMySQLDate(Query.GetFromMySQLDate(info.Vencimiento));
            TLote.Text = info.Lote;
            TConcentracion.Text = info.Concentracion;

            PAM.Visible = true;
        }
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        // guardamos la impresion
        using (CConector conector = new CConector())
        {
            PrintEventArgs print = (PrintEventArgs)e;
            GM.Columns[0].Visible = false;
            GM.Columns[1].Visible = false;

            Paciente paciente = Paciente.GetPaciente(UCPaciente.IdPaciente);

            print.Contenido = print.Contenido.Replace("$szDireccion$", paciente.Direccion)
                .Replace("$TPaciente$", paciente.DocumentoYNombres.Replace("Inactivo - ", ""))
                .Replace("$szTelefono$", paciente.Telefono)
                .Replace("$szAsegurador$", paciente.NombreEntidad)
                .Replace("$szBarrio$", paciente.Barrio)
                ;
        }
    }
}