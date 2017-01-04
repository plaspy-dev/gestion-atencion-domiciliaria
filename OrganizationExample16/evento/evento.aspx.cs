using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class evento_evento : System.Web.UI.Page
{
    [Serializable]
    public class Cotizacion {
        public string Id { get; set; }
        public bool Eliminada { get; set; } 
        public string Fecha { get; set; }
        public string Respetado { get; set; }
        public string Senores { get; set; }
        public decimal? Valor { get; set; }
        public Cotizacion(string id=null) {
            Id = id;
        }
        public Cotizacion(List<Cotizacion> listado) : this(GetNextID(listado)) {
        }

        public static string GetNextID(List<Cotizacion> listado) {
            int i = -(listado.Count + 1);
            while (true)
            {
                if (!listado.Exists(x => x.Id == i.ToString()))
                {
                    return i.ToString();
                }
                i--;
            }
        }
    };

    [Serializable]
    public class Factura
    {
        public string Id { get; set; }
        public bool Eliminada { get; set; }
        public string Fecha { get; set; }
        public string Numero { get; set; }
        public decimal? Valor { get; set; }
        public Factura(string id = null) {
            Id = id;
        }
        public Factura(List<Factura> listado) : this(GetNextID(listado)) {
        }

        public static string GetNextID(List<Factura> listado)
        {
            int i = -(listado.Count + 1);
            while (true)
            {
                if (!listado.Exists(x => x.Id == i.ToString()))
                {
                    return i.ToString();
                }
                i--;
            }
        }
    }

    [Serializable]
    public class Requisicion
    {
        [Serializable]
        public class Servicio {
            public string Tipo { get; set; }
            public string Nombre { get; set; }
            public string Cantidad { get; set; }
            public string Horas { get; set; }
            public decimal? CUHora { get; set; }
            public bool IsEmpty {
                get {
                    return string.IsNullOrEmpty(Cantidad) && string.IsNullOrEmpty(Horas) && CUHora==null;
                }
            }
        }

        public string Id { get; set; }
        public bool Eliminada { get; set; }
        public string Fecha { get; set; }
        public List<Servicio> Servicios { get; set; }
        public Requisicion(string id = null) {
            Id = id;
            InitServicios();
        }

        public Requisicion(List<Requisicion> listado) : this(GetNextID(listado)) {
        }

        public List<Servicio> InitServicios()
        {
            Servicios = new List<Servicio>();
            List<Varios> varios = Varios.Get(Varios.Tipos.ServiciosRequisicion);
            foreach (Varios info in varios)
            {
                Servicio attr = new Servicio();
                attr.Tipo = info.Id;
                attr.Nombre = info.Nombre;
                Servicios.Add(attr);
            }
            return Servicios;
        }

        public void SetAtributo(string tipo, string cantidad, string horas, string costo)
        {
            Servicio info = Servicios.Find(x => x.Tipo == tipo);
            if (info != null)
            {
                info.Cantidad = cantidad;
                info.Horas = horas;
                info.CUHora = Utilidades.TryParseCurrency(costo, CultureInfo.InvariantCulture);
            }
        }

        public static string GetNextID(List<Requisicion> listado)
        {
            int i = -(listado.Count + 1);
            while (true)
            {
                if (!listado.Exists(x => x.Id == i.ToString()))
                {
                    return i.ToString();
                }
                i--;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            GServicios.DataSource = new Requisicion().Servicios;
            GServicios.DataBind();

            string id = Request.QueryString["eid"];
            if (!string.IsNullOrEmpty(id)) {

                using (CConector conector = new CConector())
                {
                    Query query = new Query("evento");

                    query += "id";
                    query += "nombre";
                    query += "inicio";
                    query += "fin";
                    query += "tipo";
                    query += "complejidad";
                    query += "plan";
                    query += "aforo";
                    query += "productor_nombre";
                    query += "productor_telefono";
                    query += "productor_contacto";
                    query += "productor_movil";
                    query += "productor_apellidos";
                    query += "empresario_nombre";
                    query += "empresario_telefono";
                    query += "empresario_contacto";
                    query += "empresario_apellidos";
                    query += "empresario_movil";
                    query += "pago_nombre";
                    query += "pago_telefono";
                    query += "pago_forma";
                    query += "recursos_otros";
                    query += "ubicacion";
                    query += "descripcion";

                    MySqlDataReader reader= conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                    if (reader != null && reader.Read()) {

                        ViewState["id"]= id= reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(id);

                        TNombre.Text= reader["nombre"].ToString();
                        DateTime date = (DateTime)reader["inicio"];
                        TInicio.Text = Query.GetFromMySQLDate(date);
                        THDesde.Text = date.ToString("HH:mm");
                        date = (DateTime)reader["fin"];
                        TFinal.Text = Query.GetFromMySQLDate(date);
                        THHasta.Text = date.ToString("HH:mm");
                        DTipo.SelectedValue = reader["tipo"].ToString();
                        DComplejidad.SelectedValue = reader["complejidad"].ToString();
                        DPlan.SelectedValue = reader["plan"].ToString();
                        TAforo.Text = reader["aforo"].ToString();
                        TDescripcion.Text = reader["descripcion"].ToString();
                        TUbicacion.Text = reader["ubicacion"].ToString();
                        TProductor.Text = reader["productor_nombre"].ToString();
                        TProductorT.Text = reader["productor_telefono"].ToString();
                        TProductorC.Text = reader["productor_contacto"].ToString();
                        TProductorA.Text = reader["productor_apellidos"].ToString();
                        TProductorM.Text = reader["productor_movil"].ToString();
                        TEmpresario.Text = reader["empresario_nombre"].ToString();
                        TEmpresarioT.Text = reader["empresario_telefono"].ToString();
                        TEmpresarioC.Text = reader["empresario_contacto"].ToString();
                        TEmpresarioA.Text = reader["empresario_apellidos"].ToString();
                        TEmpresarioM.Text = reader["empresario_movil"].ToString();
                        TResponsable.Text = reader["pago_nombre"].ToString();
                        TResponsableT.Text = reader["pago_telefono"].ToString();
                        DPago.SelectedValue = reader["pago_forma"].ToString();
                        TOtros.Text = reader["recursos_otros"].ToString();

                        SRecursos.SelectParameters["evento"].DefaultValue = id;
                        RRecursos.DataBind();


                        query = new Query("evento_cotizacion");

                        query += "id";
                        query += "fecha";
                        query += "respetado";
                        query += "senores";
                        query += "valor";

                        reader= conector.Query(query.GetSelect("evento=" + Query.GetValor(id)));
                        if (reader != null) {
                            List<Cotizacion> listado = new List<Cotizacion>();
                            while (reader.Read()) {
                                Cotizacion info = new Cotizacion(reader["id"].ToString());
                                info.Fecha = Query.GetFromMySQLDate(reader["fecha"]);
                                info.Respetado = reader["respetado"].ToString();
                                info.Senores = reader["senores"].ToString();
                                try { info.Valor = Convert.ToDecimal(reader["valor"]); } catch { }

                                listado.Add(info);
                            }

                            ViewState["cotizaciones"] = listado;
                            GCotizaciones.DataSource = listado.Where(x => !x.Eliminada);
                            GCotizaciones.DataBind();

                            string cotizacionid = Request.QueryString["cid"];
                            if (!string.IsNullOrEmpty(cotizacionid))
                            {

                                for (int i = 0; i < GCotizaciones.Rows.Count; i++)
                                {
                                    if (GCotizaciones.DataKeys[i].Values["Id"].ToString() == cotizacionid)
                                    {
                                        GCotizaciones.SelectedIndex = i;
                                        GCotizaciones_SelectedIndexChanged(sender, e);
                                        // Imprimimos esta cotizacion
                                        ((MasterPageI)Master).Imprimir("~/evento/cotizacion.htm");
                                        ((MasterPageI)Master)._ImprimirClicked += ImprimirClicked;
                                        break;
                                    }
                                }
                            }
                        }


                        query = new Query("evento_factura");

                        query += "id";
                        query += "fecha";
                        query += "numero";
                        query += "valor";

                        reader = conector.Query(query.GetSelect("evento=" + Query.GetValor(id)));
                        if (reader != null)
                        {
                            List<Factura> listado = new List<Factura>();
                            while (reader.Read())
                            {
                                Factura info = new Factura(reader["id"].ToString());
                                info.Fecha = Query.GetFromMySQLDate(reader["fecha"]);
                                info.Numero = reader["numero"].ToString();
                                try { info.Valor = Convert.ToDecimal(reader["valor"]); } catch { }

                                listado.Add(info);
                            }

                            ViewState["facturas"] = listado;
                            GFacturas.DataSource = listado.Where(x => !x.Eliminada);
                            GFacturas.DataBind();
                        }


                        query = new Query("evento_requisicion");

                        query += "id";
                        query += "fecha";

                        reader = conector.Query(query.GetSelect("evento=" + Query.GetValor(id)));
                        if (reader != null) {

                            List<Requisicion> listado = new List<Requisicion>();
                            while (reader.Read())
                            {
                                Requisicion info = new Requisicion(reader["id"].ToString());
                                info.Fecha = Query.GetFromMySQLDate(reader["fecha"]);

                                listado.Add(info);
                            }

                            query = new Query("evento_requisicion_servicio");

                            query += "tipo";
                            query += "cantidad";
                            query += "horas";
                            query += "chora";

                            foreach (Requisicion info in listado)
                            {
                                reader = conector.Query(query.GetSelect("requisicion=" + Query.GetValor(info.Id)));
                                if (reader != null) {
                                    while (reader.Read()) {
                                        info.SetAtributo(reader["tipo"].ToString()
                                            , reader["cantidad"].ToString()
                                            , reader["horas"].ToString()
                                            , reader["chora"].ToString()
                                            );
                                    }
                                }
                            }

                            ViewState["requisiciones"] = listado;
                            GRequisiciones.DataSource = listado.Where(x => !x.Eliminada);
                            GRequisiciones.DataBind();

                            string requisicionid = Request.QueryString["rid"];
                            if (!string.IsNullOrEmpty(requisicionid))
                            {

                                for (int i = 0; i < GRequisiciones.Rows.Count; i++)
                                {
                                    if (GRequisiciones.DataKeys[i].Values["Id"].ToString() == requisicionid)
                                    {
                                        GRequisiciones.SelectedIndex = i;
                                        GRequisiciones_SelectedIndexChanged(sender, e);
                                        // Imprimimos esta cotizacion
                                        ((MasterPageI)Master).Imprimir("~/evento/requisicion.html");
                                        ((MasterPageI)Master)._ImprimirClicked += ImprimirClicked;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private void ImprimirClicked(object sender, EventArgs e)
    {
        PrintEventArgs print= (PrintEventArgs)e;

        string cotizacionid = Request.QueryString["cid"];
        string requisicionid = Request.QueryString["rid"];

        if (!string.IsNullOrEmpty(cotizacionid))
        {

            List<Cotizacion> listado = ViewState["cotizaciones"] as List<Cotizacion>;
            Cotizacion info = listado.Find(x => x.Id == cotizacionid);


            DateTime fecha = DateTime.Parse(info.Fecha);
            string recursos = "";
            Varios pago = Varios.Get(DPago.SelectedValue);

            for (int i = 0; i < RRecursos.Items.Count; i++)
            {
                TextBox textbox = (TextBox)RRecursos.Items[i].FindControl("T");
                if (!string.IsNullOrEmpty(textbox.Text))
                {
                    Label label = (Label)RRecursos.Items[i].FindControl("L");
                    if (recursos.Length != 0)
                        recursos += ", ";
                    recursos += string.Format("{0} {1}", textbox.Text, label.Text);
                }
                if (TOtros.Text.Length > 0)
                {
                    recursos += " " + TOtros.Text;
                }
            }

            print.Contenido.Replace("$Fecha$", fecha.ToLongDateString())
                .Replace("$Respetado$", info.Respetado.Replace("\n", "<br/>"))
                .Replace("$Senores$", info.Senores.Replace("\n", "<br/>"))
                .Replace("$Valor$", info.Valor.Value.ToString("C"))
                .Replace("$Recursos$", recursos)
                .Replace("$FormaPago$", pago.Descripcion)
                // .Replace("$FechaVecimiento$", fecha.AddYears().ToShortDateString())
                ;
        } else if(!string.IsNullOrEmpty(requisicionid)) {

            decimal total = 0;
            for (int i = 0; i < GServicios.Rows.Count; i++) {
                try
                {
                    TextBox cu = (TextBox)GServicios.Rows[i].FindControl("CU");
                    TextBox t = (TextBox)GServicios.Rows[i].FindControl("T");
                    TextBox ch = (TextBox)GServicios.Rows[i].FindControl("CH");

                    int cantidad = Convert.ToInt32(((TextBox)GServicios.Rows[i].FindControl("C")).Text);
                    int horas = Convert.ToInt32(((TextBox)GServicios.Rows[i].FindControl("H")).Text);
                    int costohora = Convert.ToInt32(ch.Text);

                    ch.Text= string.Format("{0:C}", costohora);
                    cu.Text = string.Format("{0:C}", horas * costohora);
                    decimal subtotal = horas * costohora * cantidad;
                    t.Text= string.Format("{0:C}", subtotal);
                    total += subtotal;
                } catch { }
            }

            TRTotal.Text = string.Format("{0:C}", total);

            print.Contenido.Replace("$RequisicionId$", requisicionid)

                ;
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            string id = (string)ViewState["id"];
            Query query = new Query("evento");

            conector.StartTransaction();

            query["nombre"] = TNombre.Text;
            query["inicio"] = Query.GetMySQLDateFormat(TInicio.Text + " " + THDesde.Text, true);
            query["fin"] = Query.GetMySQLDateFormat(TFinal.Text + " " + THHasta.Text, true);
            query["tipo"] = DTipo.SelectedValue;
            query["complejidad"] = DComplejidad.SelectedValue;
            query["plan"] = DPlan.SelectedValue;
            query["aforo"] = TAforo.Text;
            query["descripcion"] = TDescripcion.Text;
            query["productor_nombre"] = TProductor.Text;
            query["productor_telefono"] = TProductorT.Text;
            query["productor_contacto"] = TProductorC.Text;
            query["productor_movil"] = TProductorM.Text;
            query["productor_apellidos"] = TProductorA.Text;
            query["empresario_nombre"] = TEmpresario.Text;
            query["empresario_telefono"] = TEmpresarioT.Text;
            query["empresario_contacto"] = TEmpresarioC.Text;
            query["empresario_movil"] = TEmpresarioM.Text;
            query["empresario_apellidos"] = TEmpresarioA.Text;
            query["pago_nombre"] = TResponsable.Text;
            query["pago_telefono"] = TResponsableT.Text;
            query["pago_forma"] = DPago.SelectedValue;
            query["ubicacion"] = TUbicacion.Text;
            query["recursos_otros"] = TOtros.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if(conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id)))==-1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if(conector.InsertModificacion(id)==-1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("evento_recursos");

            if (conector.QueryMod(query.GetDelete("evento=" + Query.GetValor(id))) == -1) {
                LMensaje.Text = conector.LastError;
                return;
            }

            query["evento"] = id;

            for (int i = 0; i < RRecursos.Items.Count; i++) {
                string valor = ((TextBox)RRecursos.Items[i].FindControl("T")).Text;
                if (string.IsNullOrEmpty(valor))
                    continue;
                query["tipo"]= ((HiddenField)RRecursos.Items[i].FindControl("H")).Value;
                query["valor"] = valor;
                if (conector.QueryMod(query.GetInsert()) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            query = new Query("evento_cotizacion");
            query["evento"] = id;

            List<Cotizacion> listado = ViewState["cotizaciones"] as List<Cotizacion> ?? new List<Cotizacion>();

            foreach (Cotizacion cotizacion in listado) {
                if (cotizacion.Eliminada) {
                    if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(cotizacion.Id))) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    continue;
                }
                query["fecha"] = Query.GetMySQLDateFormat(cotizacion.Fecha);
                query["respetado"] = cotizacion.Respetado;
                query["senores"] = cotizacion.Senores;
                query["valor"] = cotizacion.Valor;

                if (cotizacion.Id.StartsWith("-")) {
                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                } else if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(cotizacion.Id))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }


            query = new Query("evento_factura");
            query["evento"] = id;

            List<Factura> facturas = ViewState["facturas"] as List<Factura> ?? new List<Factura>();

            foreach (Factura factura in facturas)
            {
                if (factura.Eliminada)
                {
                    if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(factura.Id))) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    continue;
                }
                query["fecha"] = Query.GetMySQLDateFormat(factura.Fecha);
                query["numero"] = factura.Numero;
                query["valor"] = factura.Valor;

                if (factura.Id.StartsWith("-"))
                {
                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
                else if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(factura.Id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            query = new Query("evento_requisicion");
            query["evento"] = id;

            List<Requisicion> requisiciones = ViewState["requisiciones"] as List<Requisicion> ?? new List<Requisicion>();

            foreach (Requisicion requisicion in requisiciones)
            {
                if (requisicion.Eliminada)
                {
                    if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(requisicion.Id))) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    continue;
                }
                query["fecha"] = Query.GetMySQLDateFormat(requisicion.Fecha);
                string rid = requisicion.Id;

                if (requisicion.Id.StartsWith("-"))
                {
                    int res = conector.QueryMod(query.GetInsert(), true);
                    if (res == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    rid = res.ToString();
                }
                else if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(requisicion.Id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                Query servicios = new Query("evento_requisicion_servicio");

                if (conector.QueryMod(servicios.GetDelete("requisicion=" + Query.GetValor(rid))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                servicios["requisicion"] = rid;

                foreach (Requisicion.Servicio servicio in requisicion.Servicios) {

                    if (servicio.IsEmpty)
                        continue;

                    servicios["tipo"] = servicio.Tipo;
                    servicios["cantidad"] = servicio.Cantidad;
                    servicios["horas"] = servicio.Horas;
                    servicios["chora"] = servicio.CUHora;

                    if (conector.QueryMod(servicios.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado("Se ha editado " + TNombre.Text);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BCotizacionA_Click(object sender, EventArgs e)
    {
        string id= (string)ViewState["idc"];
        List<Cotizacion> listado= ViewState["cotizaciones"] as List<Cotizacion> ?? new List<Cotizacion>();
        Cotizacion info = null;
        if (string.IsNullOrEmpty(id))
        {
            info = new Cotizacion(listado);
            listado.Add(info);
        } else info = listado.Find(x => x.Id == id);

        info.Fecha = TCFecha.Text;
        info.Respetado = TCRespetado.Text;
        info.Senores = TCSeñores.Text;

        try { info.Valor = Utilidades.TryParseCurrency(TCValor.Text, CultureInfo.InvariantCulture); } catch { };

        ViewState["cotizaciones"] = listado;
        GCotizaciones.DataSource = listado.Where(x => !x.Eliminada);
        GCotizaciones.DataBind();
        BCotizacionC_Click(sender, e);
    }

    protected void BCotizacionC_Click(object sender, EventArgs e)
    {
        GCotizaciones.SelectedIndex = -1;
        TCFecha.Text = "";
        TCRespetado.Text = "";
        TCSeñores.Text = "";
        TCValor.Text = "";
        ViewState["idc"] = null;
    }

    protected void GCotizaciones_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Cotizacion> listado = ViewState["cotizaciones"] as List<Cotizacion> ?? new List<Cotizacion>();
        Cotizacion info = listado.Find(x=>x.Id==GCotizaciones.SelectedValue.ToString());
        if (info == null) 
            return;
        ViewState["idc"] = info.Id;
        TCFecha.Text = info.Fecha;
        TCRespetado.Text = info.Respetado;
        TCSeñores.Text = info.Senores;
        TCValor.Text = info.Valor==null ? "" : info.Valor.Value.ToString(CultureInfo.InvariantCulture);

        ScriptManager.RegisterStartupScript(UC, UC.GetType(), "add", "$('#bCotizacion').click();", true);
    }

    protected void GCotizaciones_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Cotizacion> listado = ViewState["cotizaciones"] as List<Cotizacion> ?? new List<Cotizacion>();

        Cotizacion info= listado.Find(x => x.Id == e.Keys["Id"].ToString());
        if (info.Id.StartsWith("-"))
            listado.Remove(info);
        else info.Eliminada = true;

        ViewState["cotizaciones"] = listado;
        GCotizaciones.DataSource = listado.Where(x => !x.Eliminada);
        GCotizaciones.DataBind();
        e.Cancel = true;
    }

    protected void GFacturas_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Factura> listado = ViewState["facturas"] as List<Factura> ?? new List<Factura>();
        Factura info = listado.Find(x => x.Id == GFacturas.SelectedValue.ToString());
        if (info == null)
            return;
        ViewState["idf"] = info.Id;
        TFFecha.Text = info.Fecha;
        TFNumero.Text = info.Numero;
        TFValor.Text = info.Valor == null ? "" : info.Valor.Value.ToString(CultureInfo.InvariantCulture);

        ScriptManager.RegisterStartupScript(UF, UF.GetType(), "add", "$('#bFactura').click();", true);
    }

    protected void GFacturas_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Factura> listado = ViewState["facturas"] as List<Factura> ?? new List<Factura>();

        Factura info = listado.Find(x => x.Id == e.Keys["Id"].ToString());
        if (info.Id.StartsWith("-"))
            listado.Remove(info);
        else info.Eliminada = true;

        ViewState["factura"] = listado;
        GFacturas.DataSource = listado.Where(x => !x.Eliminada);
        GFacturas.DataBind();
        e.Cancel = true;
    }

    protected void BFacturaA_Click(object sender, EventArgs e)
    {
        string id = (string)ViewState["idf"];
        List<Factura> listado = ViewState["facturas"] as List<Factura> ?? new List<Factura>();
        Factura info = null;
        if (string.IsNullOrEmpty(id))
        {
            info = new Factura(listado);
            listado.Add(info);
        }
        else info = listado.Find(x => x.Id == id);

        info.Fecha = TFFecha.Text;
        info.Numero = TFNumero.Text;

        try { info.Valor = Utilidades.TryParseCurrency(TFValor.Text, CultureInfo.InvariantCulture); } catch { };

        ViewState["facturas"] = listado;
        GFacturas.DataSource = listado.Where(x => !x.Eliminada);
        GFacturas.DataBind();
        BFacturaC_Click(sender, e);
    }

    protected void BFacturaC_Click(object sender, EventArgs e)
    {
        GFacturas.SelectedIndex = -1;
        TFFecha.Text = "";
        TFNumero.Text = "";
        TFValor.Text = "";
        ViewState["idf"] = null;
    }

    protected void GRequisiciones_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Requisicion> listado = ViewState["requisiciones"] as List<Requisicion> ?? new List<Requisicion>();
        Requisicion info = listado.Find(x => x.Id == GRequisiciones.SelectedValue.ToString());
        if (info == null)
            return;
        ViewState["idr"] = info.Id;
        TRFecha.Text = info.Fecha;
        GServicios.DataSource = info.Servicios;
        GServicios.DataBind();

        ScriptManager.RegisterStartupScript(UR, UR.GetType(), "addr", "$('#bRequisicion').click();", true);
    }

    protected void GRequisiciones_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Requisicion> listado = ViewState["requisiciones"] as List<Requisicion> ?? new List<Requisicion>();

        Requisicion info = listado.Find(x => x.Id == e.Keys["Id"].ToString());
        if (info.Id.StartsWith("-"))
            listado.Remove(info);
        else info.Eliminada = true;

        ViewState["requisiciones"] = listado;
        GRequisiciones.DataSource = listado.Where(x => !x.Eliminada);
        GRequisiciones.DataBind();
        e.Cancel = true;
    }

    protected void BRequisicionA_Click(object sender, EventArgs e)
    {
        string id = (string)ViewState["idr"];
        List<Requisicion> listado = ViewState["requisiciones"] as List<Requisicion> ?? new List<Requisicion>();
        Requisicion info = null;
        if (string.IsNullOrEmpty(id))
        {
            info = new Requisicion(listado);
            listado.Add(info);
        }
        else info = listado.Find(x => x.Id == id);

        info.Fecha = TRFecha.Text;

        for (int i = 0; i < GServicios.Rows.Count; i++)
        {
            info.SetAtributo(GServicios.DataKeys[i].Values["Tipo"].ToString()
                , ((TextBox)GServicios.Rows[i].FindControl("C")).Text
                , ((TextBox)GServicios.Rows[i].FindControl("H")).Text
                , ((TextBox)GServicios.Rows[i].FindControl("CH")).Text
                );
        }

        ViewState["requisiciones"] = listado;
        GRequisiciones.DataSource = listado.Where(x => !x.Eliminada);
        GRequisiciones.DataBind();
        BRequisicionC_Click(sender, e);
    }

    protected void BRequisicionC_Click(object sender, EventArgs e)
    {
        GRequisiciones.SelectedIndex = -1;
        TRFecha.Text = "";
        GServicios.DataSource = new Requisicion().Servicios;
        GServicios.DataBind();
        ViewState["idr"] = null;
    }
}
