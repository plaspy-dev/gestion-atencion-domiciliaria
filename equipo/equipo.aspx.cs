using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class equipo_equipo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            CUsuario usuario= (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled= usuario.CanInsert();
            TNombre.Focus();
            if (!string.IsNullOrEmpty(Request.QueryString["eid"]))
            {
                using (CConector conector = new CConector())
                {
                    Query query = new Query("equipo");

                    query += "id";
                    query += "nombre";
                    query += "serial";
                    query += "placa";
                    query += "modelo";
                    query += "marca";
                    query += "ultimo_mantenimiento";
                    query += "proximo_mantenimiento";
                    query += "estado";
                    query += "observaciones";
                    query += "codigo";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["eid"])));
                    if (reader != null && reader.Read())
                    {
                        ViewState["id"] = reader["id"].ToString();

                        BAceptar.Enabled = usuario.CanUpdate();
                        BEliminar.Visible = usuario.CanDelete();
                        ((MasterPageI)Master).SetModificacion(ViewState["id"].ToString());

                        TNombre.Text = reader["nombre"].ToString();
                        TSerial.Text = reader["serial"].ToString();
                        TPlaca.Text = reader["placa"].ToString();
                        TModelo.Text = reader["modelo"].ToString();
                        TMarca.Text = reader["marca"].ToString();
                        TCodigo.Text = reader["codigo"].ToString();
                        TUltimoMantenimiento.Text = Query.GetFromMySQLDate(reader["ultimo_mantenimiento"]);
                        TProximoMantenimiento.Text = Query.GetFromMySQLDate(reader["proximo_mantenimiento"]);
                        TObservaciones.Text = reader["observaciones"].ToString();
                        Utilidades.SelectInDropDown(DEstado, reader["estado"]);

                        PPrestamo.Visible = true;
                        BPrestamo.Text = DEstado.SelectedValue == "1" ? "Asignar" : "Devolver";
                        
                        query = new Query("equipo_prestamo");

                        query += "id";
                        query += "fecha";
                        query += "estimado";
                        query += "paciente";
                        query += "funcionario";
                        query += "familiar";
                        query += "observaciones";
                        query += "pagare";
                        query += "devolucion";

                        List<Prestamo> prestamos = new List<Prestamo>();
                        reader = conector.Query(query.GetSelect("equipo=" + ViewState["id"].ToString()));
                        if (reader != null) {
                            while (reader.Read()) { 
                                
                                Prestamo info= new Prestamo(prestamos.Count);
                                info.IdPrestamo = reader["id"].ToString();
                                info.Fecha = (DateTime)reader["fecha"];
                                if (reader["estimado"] != DBNull.Value)
                                    info.Estimado = (DateTime)reader["estimado"];
                                info.IdPaciente = reader["paciente"].ToString();
                                info.IdFuncionario = reader["funcionario"].ToString();
                                info.Familiar = reader["familiar"].ToString();
                                info.Observaciones = reader["observaciones"].ToString();
                                info.Pagare = reader["pagare"].ToString()=="1";
                                if (reader["devolucion"] != DBNull.Value)
                                    info.Devolucion = (DateTime)reader["devolucion"];
                                prestamos.Add(info);
                            }
                        }

                        ViewState["prestamos"] = prestamos;
                        GPrestamos.DataSource = prestamos.Where(x => x.Visible).ToList();
                        GPrestamos.DataBind();
                    }
                }
            }
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id = (string)ViewState["id"];
            Query query = new Query("equipo");

            query["nombre"]= TNombre.Text;
            query["serial"]= TSerial.Text;
            query["placa"] =TPlaca.Text;
            query["modelo"] = TModelo.Text;
            query["marca"]= TMarca.Text;
            query["ultimo_mantenimiento"] = Query.GetMySQLDateFormat(TUltimoMantenimiento.Text);
            query["proximo_mantenimiento"] = Query.GetMySQLDateFormat(TProximoMantenimiento.Text);
            query["observaciones"]= TObservaciones.Text;
            query["codigo"] = TCodigo.Text;

            if (string.IsNullOrEmpty(id))
            {
                query["estado"] = "1";
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                    return;
            }

            if (conector.InsertModificacion(id) == -1)
                return;

            // agregamos los prestamos
            List<Prestamo> lista = (List<Prestamo>)ViewState["prestamos"];
            if (lista != null)
            {
                for (int i = 0; i < lista.Count; i++)
                {
                    query = new Query("equipo_prestamo");
                    if (lista[i].Visible)
                    {
                        query["fecha"] = Query.GetMySQLDateFormat(lista[i].Fecha);
                        query["estimado"] = lista[i].Estimado == null ? "" : Query.GetMySQLDateFormat(lista[i].Estimado.Value);
                        query["paciente"] = lista[i].IdPaciente;
                        query["funcionario"] = lista[i].IdFuncionario;
                        query["familiar"] = lista[i].Familiar;
                        query["observaciones"] = lista[i].Observaciones;
                        query["pagare"] = lista[i].Pagare ? "1" : "";
                        if (lista[i].Devolucion == null)
                            query["devolucion"] = Query.GetMySQLDateFormat(UCDevolucion.Fecha);

                        if (string.IsNullOrEmpty(lista[i].IdPrestamo))
                        {
                            query["equipo"] = id;
                            if (conector.QueryMod(query.GetInsert()) == -1)
                                return;
                        }
                        else
                        {
                            if (conector.QueryMod(query.GetUpdate("id=" + lista[i].IdPrestamo)) == -1)
                                return;
                        }
                    } else if(!string.IsNullOrEmpty(lista[i].IdPrestamo)) {
                        if (conector.QueryMod(query.GetDelete("id=" + lista[i].IdPrestamo)) == -1)
                            return;
                    }
                }
            }

            // actualizamos el estado
            if (!Prestamo.UpdateEstado(conector, id))
                return;

            conector.Commit();

            ((MasterPageI)Master).SetResultado("Equipo " + TNombre.Text + " editado.");
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            Query query = new Query("equipo");
            
            query["estado"] = "0";

            if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(ViewState["id"].ToString()))) == -1)
            {
                return;
            }
            ((MasterPageI)Master).SetResultado("Equipo " + TNombre.Text + " eliminado.");
        }
    }
    protected void GPrestamos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }

    protected void BAgregarPrestamo_Click(object sender, EventArgs e) {

        List<Prestamo> lista = (List<Prestamo>)ViewState["prestamos"];
        Prestamo info=null;
        if (GPrestamos.SelectedIndex != -1) {
            List<Prestamo> resultado= (from x in lista where x.IdTabla==(int)GPrestamos.SelectedDataKey.Value select x).ToList();
            if (resultado.Count > 0)
                info= resultado.First();
        }
        if (info == null)
        {
            info = new Prestamo(lista.Count);
            lista.Add(info);
        }
        UCPrestamo.Guardar(info);

        ViewState["prestamos"] = lista;
        GPrestamos.SelectedIndex = -1;
        GPrestamos.DataSource = lista.Where(x=> x.Visible).ToList();
        GPrestamos.DataBind();
    }

    protected void BPrestamo_Click(object sender, EventArgs e)
    {
        if (DEstado.SelectedValue == "1")
            UCPrestamo.Show((Prestamo)null);
        else UCDevolucion.Show();
    }

    protected void BCancelarPrestamo_Click(object sender, EventArgs e) {
        
        GPrestamos.SelectedIndex = -1;
    }

    protected void GPrestamos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Prestamo> lista = (List<Prestamo>)ViewState["prestamos"];
        List<Prestamo> resultado = (from x in lista where x.IdTabla == (int)GPrestamos.DataKeys[e.RowIndex].Value select x).ToList();
        if (resultado.Count > 0)
        {
            Prestamo info = resultado.First();
            info.Visible = false;

            ViewState["prestamos"] = lista;
            GPrestamos.SelectedIndex = -1;
            GPrestamos.DataSource = lista.Where(x => x.Visible).ToList();
            GPrestamos.DataBind();
        }
    }

    protected void GPrestamos_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Prestamo> lista = (List<Prestamo>)ViewState["prestamos"];
        Prestamo info = null;
        if (GPrestamos.SelectedIndex != -1)
        {
            List<Prestamo> resultado = (from x in lista where x.IdTabla == (int)GPrestamos.SelectedDataKey.Value select x).ToList();
            if (resultado.Count > 0)
                info = resultado.First();
        }
        UCPrestamo.Show(info);
    }

    protected void BAceptarDevolucion_Click(object sender, EventArgs e) { }
}
