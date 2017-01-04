using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.IO;

public partial class rh_funcionario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            CUsuario usuario = (CUsuario)CUsuario.GetInstance();

            string id = Request.QueryString["fid"];
            BAceptar.Enabled = usuario.CanInsert();
            TDocumento.Focus();

            if (!string.IsNullOrEmpty(id)) {

                using (CConector conector = new CConector()) {

                    Query query = new Query("rh");

                    query += "id";
                    query += "documento";
                    query += "apellidos";
                    query += "nombres";
                    query += "genero";
                    query += "ingreso";
                    query += "nacimiento";
                    query += "direccion";
                    query += "barrio";
                    query += "telefonos";
                    query += "celular";
                    query += "estado_civil";
                    query += "conyugue";
                    query += "contacto";
                    query += "contacto_telefono";
                    query += "parentesco";
                    query += "empresas";
                    query += "cargo";
                    query += "eps";
                    query += "arp";
                    query += "fop";
                    query += "terminacion";
                    query += "terminacion_motivo";
                    query += "digitalizacion";

                    MySqlDataReader reader= conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                    if (reader != null && reader.Read()) {

                        id = reader["id"].ToString();
                        ViewState["id"] =
                            SDocumentos.SelectParameters["funcionario"].DefaultValue= id;
                        ((MasterPageI)Master).SetModificacion(id);
                        BAceptar.Enabled = usuario.CanUpdate();

                        TDocumento.Text = reader["documento"].ToString();
                        TApellidos.Text = reader["apellidos"].ToString();
                        TNombres.Text = reader["nombres"].ToString();
                        DGenero.SelectedValue = reader["genero"].ToString();
                        TIngreso.Text = Query.GetFromMySQLDate(reader["ingreso"]);
                        TNacimiento.Text = Query.GetFromMySQLDate(reader["nacimiento"]);
                        TDireccion.Text = reader["direccion"].ToString();
                        TBarrio.Text = reader["barrio"].ToString();
                        TTelefonos.Text = reader["telefonos"].ToString();
                        TCelular.Text = reader["celular"].ToString();
                        DEstadoCivil.SelectedValue = reader["estado_civil"].ToString();
                        TConyugue.Text = reader["conyugue"].ToString();
                        TContacto.Text = reader["contacto"].ToString();
                        TTelContacto.Text = reader["contacto_telefono"].ToString();
                        TParentesco.Text = reader["parentesco"].ToString();
                        TEmpresas.Text = reader["empresas"].ToString();
                        DCargo.SelectedValue = reader["cargo"].ToString();
                        DEPS.SelectedValue = reader["eps"].ToString();
                        DARP.SelectedValue = reader["arp"].ToString();
                        DFOP.SelectedValue = reader["fop"].ToString();
                        TTerminacion.Text = Query.GetFromMySQLDate(reader["terminacion"]);
                        DTerminacion.SelectedValue = reader["terminacion_motivo"].ToString();
                        int digitalizacion = reader["digitalizacion"] as int? ?? 0;
                        if ((digitalizacion & 1) == 1)
                            ISello.ImageUrl = Files.GetURL(Files.Directorys.RHDocumentos, id, "sello.jpg");
                        if ((digitalizacion & 2) == 2)
                            IFirma.ImageUrl = Files.GetURL(Files.Directorys.RHDocumentos, id, "firma.jpg");
                        ViewState["digitalizacion"] = digitalizacion;

                        GDocumentos.DataBind();
                        DGenero.Focus();
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string id = (string)ViewState["id"];

            Query query = new Query("rh");

            query["documento"] = TDocumento.Text;
            query["apellidos"] = TApellidos.Text;
            query["nombres"] = TNombres.Text;
            query["genero"] = DGenero.SelectedValue;
            query["ingreso"] = Query.GetMySQLDateFormat(TIngreso.Text);
            query["nacimiento"] = Query.GetMySQLDateFormat(TNacimiento.Text);
            query["direccion"] = TDireccion.Text;
            query["barrio"] = TBarrio.Text;
            query["telefonos"] = TTelefonos.Text;
            query["celular"] = TCelular.Text;
            query["estado_civil"] = DEstadoCivil.SelectedValue;
            query["conyugue"] = TConyugue.Text;
            query["contacto"] = TContacto.Text;
            query["contacto_telefono"] = TTelContacto.Text;
            query["parentesco"] = TParentesco.Text;
            query["empresas"] = TEmpresas.Text;
            query["cargo"] = DCargo.SelectedValue;
            query["eps"] = DEPS.SelectedValue;
            query["arp"] = DARP.SelectedValue;
            query["fop"] = DFOP.SelectedValue;
            query["terminacion"] = Query.GetMySQLDateFormat(TTerminacion.Text);
            query["terminacion_motivo"] = DTerminacion.SelectedValue;

            int digitalizacion = ViewState["digitalizacion"] as int? ?? 0;
            if (FSello.HasFile)
            {
                FSello.SaveAs(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, "sello.jpg"));
                digitalizacion |= 1;
            }
            if (FFirma.HasFile)
            {
                FFirma.SaveAs(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, "firma.jpg"));
                digitalizacion |= 2;
            }
            query["digitalizacion"] = digitalizacion==0 ? "" : digitalizacion.ToString();

            if (string.IsNullOrEmpty(id)) {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("rh_documento");
            query["funcionario"] = id;

            foreach (GridViewRow row in GDocumentos.Rows) {

                string idDocumento = GDocumentos.DataKeys[row.RowIndex].Values["id"].ToString();
                query["documento"] = idDocumento;
                query["vencimiento"] = Query.GetMySQLDateFormat(((TextBox)row.FindControl("T")).Text);

                FileUpload file = (FileUpload)row.FindControl("F");
                if (file.HasFile) {
                    string extension = Path.GetExtension(file.FileName);
                    file.SaveAs(Files.GetFilePath(Files.Directorys.RHDocumentos, true, id, idDocumento + extension));
                    query["archivo"] = extension;
                }

                if (conector.QueryMod(query.GetInsertUpdate()) == -1) {

                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado("Funcionario editado");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public void OnValidaFileJPG(object sender, ServerValidateEventArgs e)
    {
        Files.OnValidaFileJPG(sender, e);
    }

    public void OnValidaFileJPGPDF(object sender, ServerValidateEventArgs e) {

        Files.OnValidaFileJPGPDF(sender, e);
    }

    protected void TDocumento_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(TDocumento.Text))
            return;

        using (CConector conector = new CConector()) {
            string id= conector.QueryString("SELECT id FROM rh WHERE documento=" + Query.GetValor(TDocumento.Text));
            if (!string.IsNullOrEmpty(id)) {
                if (id != (string)ViewState["id"]) {
                    Response.Redirect(Request.Url.AbsolutePath + "?fid=" + id);
                }
            }
        }
    }
}