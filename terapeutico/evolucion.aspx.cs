using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.IO;

public partial class terapeutico_evolucion : System.Web.UI.Page
{
    public const int nMinutosTerapia=45;

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack) {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled = false;
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);
            UCFuncionario.IdFuncionario = usuario["personal"];
            TTA.Focus();
            // DTV.MinumunValue = DateTime.Now.AddDays(-2);
            DTV.MinumunValue = DateTime.Now.AddMonths(-1);
            DTV.MaximunValue = DateTime.Now.AddMinutes(1);
            DTV.Enabled = !usuario.CanUpdate();

            using(CConector conector= new CConector()) {
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    } else {
                        if (usuario.CanUpdate())
                            STipo.SelectParameters["canUpdate"].DefaultValue = "1";
                        DTipo.DataBind();
                        DTipo_SelectedIndexChanged(sender, e);

                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                        TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);

                        if (Request.QueryString["npdf"] == "1")
                            Title = CCDetallePaciente.Documento + " - " + CCDetallePaciente.Nombres.Replace("(Inactivo)", "");

                        CCDetallePaciente.Visible= 
                        PDatos.Visible = true;

                        BAceptar.Enabled = usuario.CanInsert();
                        UCFuncionario.ReadOnly = !usuario.CanAdmin();

                        if (!string.IsNullOrEmpty(Request.QueryString["evtid"]))
                        {
                            Query query = new Query("evolucion_terapeutivo");

                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "funcionario";
                            query += "fr";
                            query += "fc";
                            query += "ta";
                            query += "sesion";
                            query += "logros";
                            query += "plan";
                            query += "autorizacion";
                            query += "tipo";

                            MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["evtid"])));
                            if (reader != null && reader.Read())
                            {
                                if (reader["paciente"].ToString() != Request.QueryString["pid"]) 
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&evtid=" + Request.QueryString["pid"]);

                                DTV.Enabled = false;
                                BAceptar.Enabled = usuario.CanUpdate();
                                BEliminar.Visible = usuario.CanDelete();
                                ((MasterPageI)Master).SetModificacion(reader["id"].ToString());
                                ((MasterPageI)Master).Imprimir("evolucion.html");

                                ViewState["id"] = reader["id"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                LFinal.Text = Query.GetFromMySQLDate(((DateTime)reader["fecha"]).AddMinutes(nMinutosTerapia), true);
                                UCFuncionario.IdFuncionario = reader["funcionario"].ToString();
                                TNumero.Text = reader["sesion"].ToString();
                                TLogros.Text = reader["logros"].ToString();
                                TPlan.Text = reader["plan"].ToString();
                                TFR.Text = reader["fr"].ToString();
                                TFC.Text = reader["fc"].ToString();
                                TTA.Text = reader["ta"].ToString();
                                Utilidades.SelectInDropDown(DTipo, reader["autorizacion"].ToString() + ";" + reader["tipo"].ToString(), Procedimientos.GetNombreMedicamento(reader["tipo"].ToString()));


                                string file = Archivo.GetFileName("evolucion_apoyo", CCDetallePaciente.IdPaciente, reader["id"].ToString() + ".jpg");
                                if (File.Exists(file)) {
                                    HFoto.NavigateUrl = Archivo.GetURL("evolucion_apoyo", CCDetallePaciente.IdPaciente, reader["id"].ToString() + ".jpg");
                                } else {
                                    file = Archivo.GetFileName("evolucion_apoyo", CCDetallePaciente.IdPaciente, reader["id"].ToString() + ".pdf");
                                    if (File.Exists(file))
                                        HFoto.NavigateUrl = Archivo.GetURL("evolucion_apoyo", CCDetallePaciente.IdPaciente, reader["id"].ToString() + ".pdf");
                                }
                            }
                        }

                        PEvoluciones.Visible = GridUtils.GetRowsCount(GEvoluciones, LEvoluciones, "Evolución", "Evoluciones") > 0;
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e) {

        if (!IsValid)
            return;

        Query query = new Query("evolucion_terapeutivo");
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id = (string)ViewState["id"];

            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["fr"] = TFR.Text;
            query["fc"] = TFC.Text;
            query["ta"] = TTA.Text;
            query["sesion"] = TNumero.Text;
            query["logros"] = TLogros.Text;
            query["plan"] = TPlan.Text;
            string []valores= DTipo.SelectedValue.Split(';');
            query["autorizacion"] = valores[0];
            query["tipo"] = valores[1];
            

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id= res.ToString();

                // actualizamos la programacion con elID

                query = new Query("programacion");

                query["prestado_evolucion"] = id;

                if (conector.QueryMod(query.GetUpdate("DATE(programacion.prgFechaProg)={0} AND programacion.pacId={1} AND programacion.perId={2} AND prestado_evolucion IS NULL LIMIT 1"
                    , Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text, false)), Query.GetValor(CCDetallePaciente.IdPaciente), Query.GetValor(UCFuncionario.IdFuncionario))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            } else {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }
            if (conector.InsertModificacion(id)==-1) {
                LMensaje.Text = conector.LastError;
                return;
            }
            conector.Commit();
            if (FArchivo.HasFile) {
                string file = Archivo.GetFileName("evolucion_apoyo", CCDetallePaciente.IdPaciente, id + ".jpg");
                if (File.Exists(file))
                    File.Delete(file);
                file = Archivo.GetFileName("evolucion_apoyo", CCDetallePaciente.IdPaciente, id + ".pdf");
                if (File.Exists(file))
                    File.Delete(file);
                Directory.CreateDirectory(Path.GetDirectoryName(file));
                if(!FArchivo.FileName.ToLower().EndsWith(".pdf"))
                    file = Archivo.GetFileName("evolucion_apoyo", CCDetallePaciente.IdPaciente, id + ".jpg");
                FArchivo.SaveAs(file);
            }

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado("Se ha editado una evolución a " + CCDetallePaciente.Nombres);
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
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM evolucion_terapeutivo WHERE id=" + ViewState["id"].ToString()) == -1)
                return;
            if (conector.QueryMod("UPDATE programacion SET prestado_evolucion=NULL WHERE prestado_evolucion={0}", Query.GetValor(ViewState["id"].ToString()))==-1)
                return;
            conector.Commit();
            Response.Redirect(Request.Url.AbsolutePath);
        }
    }

    public void OnImprimir(object sender, EventArgs e) {

        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(UCFuncionario.IdFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(UCFuncionario.IdFuncionario)));
        }
    }
    protected void DTipo_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(DTipo.SelectedValue))
        {
            TNumero.Text = "";
            TPlan.Text = "";
            return;
        }

        using (CConector conector = new CConector())
        {
            TNumero.Text = "";
            string[] valores = DTipo.SelectedValue.Split(';');

            Query query = new Query("evolucion_terapeutivo");

            query["sesion"] = "sesion+1";
            query += "plan";

            MySqlDataReader reader = conector.Query(query.GetSelect("paciente={0} AND autorizacion={1} AND tipo={2} ORDER BY fecha DESC LIMIT 1", null
                , Query.GetValor(Request.QueryString["pid"])
                , Query.GetValor(valores[0]), Query.GetValor(valores[1])
                ));
            if (reader != null && reader.Read())
            {
                TNumero.Text = reader["sesion"].ToString();
                TPlan.Text = reader["plan"].ToString();
            }

            if (TNumero.Text.Length == 0)
            {
                query = new Query("valoracionat");
                query += "1";

                string resultado = conector.QueryString(
                    query.GetSelect("paciente={0} AND MONTH(inicio)={1} AND YEAR(inicio)={2} AND autorizacion={3} AND tipo={4} LIMIT 1", null
                        , Query.GetValor(Request.QueryString["pid"])
                        , DateTime.Now.Month, DateTime.Now.Year, Query.GetValor(valores[0]), Query.GetValor(valores[1])));

                TNumero.Text = string.IsNullOrEmpty(resultado) ? "1" : "2";
            }
        }
    }
}