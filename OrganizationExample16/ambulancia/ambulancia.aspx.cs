using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class ambulancia_ambulancia : System.Web.UI.Page
{
    [Serializable]
    public class Ambulancia {
        [Serializable]
        public class Atributo {

            public string Tipo { get; set; }
            public string Nombre { get; set; }
            public string Observaciones { get; set; }
            public string Vencimiento { get; set; }
            public bool FileNew { get; set; }
            public string FileExt { get; set; }

            public bool IsEmpty {
                get {
                    return string.IsNullOrEmpty(Observaciones) && string.IsNullOrEmpty(Vencimiento);
                }
            }
        }

        public string Id { get; set; }
        public string Placa { get; set; }
        public string Propietario { get; set; }
        public List<Atributo> Atributos { get; set; }
        public bool Eliminado { get; set; }

        public Ambulancia(string id=null) {
            Id = id;
            InitAtributos();
        }

        public Ambulancia(List<Ambulancia> ambulancias) : this(GetNextID(ambulancias)) {
        }

        public static string GetNextID(List<Ambulancia> ambulancias) {

            int i = -(ambulancias.Count + 1);
            while (true)
            {
                if (!ambulancias.Exists(x => x.Id == i.ToString()))
                {
                    return i.ToString();
                }
                i--;
            }
        }

        public Ambulancia(string id, string placa, string propietario) :this(id) {
            Placa = placa;
            Propietario = propietario;
        }

        public List<Atributo> InitAtributos() {

            Atributos = new List<Atributo>();
            List<Varios> varios = Varios.Get(Varios.Tipos.AtributosAmbulancias);
            foreach (Varios info in varios) {
                Atributo attr = new Atributo();
                attr.Tipo= info.Id;
                attr.Nombre = info.Nombre;
                Atributos.Add(attr);
            }
            return Atributos;
        }

        public void SetAtributo(string tipo, string observaciones, string vencimiento, string filename, bool filenew) {

            Atributo info= Atributos.Find(x => x.Tipo == tipo);
            if (info != null) {
                info.Observaciones = observaciones;
                info.Vencimiento = vencimiento;
                info.FileExt = filename;
                info.FileNew = filenew;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            List<Ambulancia> ambulancias = new List<Ambulancia>();
            TNIT.Focus();

            List<Varios> varios= Varios.Get(Varios.Tipos.AtributosAmbulancias);

            string id = Request.QueryString["eid"];
            if (!string.IsNullOrEmpty(id)) {

                using (CConector conector = new CConector()) {

                    Query query = new Query("empresa");

                    query += "id";
                    query += "nit";
                    query += "nombre";
                    query += "representante";
                    query += "telefono";
                    query += "celular";
                    query += "descripcion_otros";
                    query += "codigo";

                    MySqlDataReader reader=conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                    if (reader != null && reader.Read()) {

                        id= reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(id);
                        ViewState["id"] = id;

                        TNIT.Text = reader["nit"].ToString();
                        TEmpresa.Text = reader["nombre"].ToString();
                        TRepresentanteLegal.Text = reader["representante"].ToString();
                        TTelefono.Text = reader["telefono"].ToString();
                        TCelular.Text = reader["celular"].ToString();
                        TOtros.Text = reader["descripcion_otros"].ToString();
                        TCodigo.Text = reader["codigo"].ToString();

                        SCapacidad.SelectParameters["empresa"].DefaultValue = id;
                        RCapacidad.DataBind();

                        query = new Query("ambulancia");

                        query += "id";
                        query += "placa";
                        query += "propietario";

                        reader = conector.Query(query.GetSelect("empresa=" + Query.GetValor(id)));
                        if (reader != null) {
                            while (reader.Read()) {
                                ambulancias.Add(new Ambulancia(reader["id"].ToString(), reader["placa"].ToString(), reader["propietario"].ToString()));
                            }
                        }

                        query = new Query("ambulancia_documento");

                        query += "documento";
                        query += "observaciones";
                        query += "vencimiento";

                        foreach (Ambulancia info in ambulancias) {

                            reader = conector.Query(query.GetSelect("ambulancia=" + Query.GetValor(info.Id)));
                            if (reader != null) {
                                while (reader.Read()) {
                                    string path= Files.GetFilePath(Files.Directorys.Ambulancia, true, info.Id);
                                    string file = null;
                                    try
                                    {
                                        file = Directory.GetFiles(path, reader["documento"].ToString() + ".*").FirstOrDefault();
                                        if (!string.IsNullOrEmpty(file))
                                            file = Path.GetExtension(file);
                                    } catch { }
                                    info.SetAtributo(reader["documento"].ToString(), reader["observaciones"].ToString(), Query.GetFromMySQLDate(reader["vencimiento"]), file, false);
                                }
                            }
                        }
                    }
                }
            }

            ViewState["ambulancias"] = ambulancias;
            GAmbulancias.DataSource = ambulancias.Where(x => !x.Eliminado);
            GAmbulancias.DataBind();

            GAtributos.DataSource = new Ambulancia().Atributos;
            GAtributos.DataBind();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e) {
        if (!IsValid)
            return;
        using (CConector conector = new CConector()) {

            conector.StartTransaction();
            string id = (string)ViewState["id"];
            Query query = new Query("empresa");

            query["nit"] = TNIT.Text;
            query["nombre"] = TEmpresa.Text;
            query["representante"] = TRepresentanteLegal.Text;
            query["telefono"] = TTelefono.Text;
            query["celular"] = TCelular.Text;
            query["descripcion_otros"] = TOtros.Text;
            query["codigo"] = TCodigo.Text;

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

            if (conector.InsertModificacion(id) == -1) {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("empresa_capacidad");

            if(conector.QueryMod(query.GetDelete("empresa=" + Query.GetValor(id)))==-1) {

                LMensaje.Text = conector.LastError;
                return;
            }

            query["empresa"] = id;

            for (int i = 0; i < RCapacidad.Items.Count; i++) {

                query["tipo"]= ((HiddenField)RCapacidad.Items[i].FindControl("H")).Value;
                string valor = ((TextBox)RCapacidad.Items[i].FindControl("T")).Text;
                if (string.IsNullOrEmpty(valor))
                    continue;
                query["valor"]= valor;

                if (conector.QueryMod(query.GetInsert()) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            query = new Query("ambulancia");
            query["empresa"] = id;

            
            List<Ambulancia> ambulancias = (List<Ambulancia>)ViewState["ambulancias"];

            Query atributo = new Query("ambulancia_documento");
                
            foreach (Ambulancia info in ambulancias) {
                if (info.Eliminado) {
                    if (conector.QueryMod(atributo.GetDelete("ambulancia=" + Query.GetValor(info.Id))) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(info.Id))) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    foreach (Ambulancia.Atributo attr in info.Atributos)
                    {
                        if (!string.IsNullOrEmpty(attr.FileExt)) {
                            try { File.Delete(attr.FileExt); } catch { }
                            try { File.Delete(Files.GetFilePath(Files.Directorys.Ambulancia, true, info.Id, attr.Tipo + Path.GetExtension(attr.FileExt))); } catch { }
                        }
                    }
                    continue;
                }

                string idAmbulancia = info.Id.StartsWith("-") ? null : info.Id;
                query["placa"] = info.Placa;
                query["propietario"] = info.Propietario;

                if (string.IsNullOrEmpty(idAmbulancia)) {
                    int res = conector.QueryMod(query.GetInsert());
                    if ( res == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                    idAmbulancia = res.ToString();
                } else {
                    if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(idAmbulancia))) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }

                if (conector.QueryMod(atributo.GetDelete("ambulancia=" + Query.GetValor(idAmbulancia))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                foreach (Ambulancia.Atributo attr in info.Atributos) {

                    if (attr.IsEmpty)
                        continue;

                    atributo["ambulancia"] = idAmbulancia;
                    atributo["documento"] = attr.Tipo;
                    atributo["observaciones"] = attr.Observaciones;
                    atributo["vencimiento"] = Query.GetMySQLDateFormat(attr.Vencimiento);

                    if (conector.QueryMod(atributo.GetInsert()) == -1) {

                        LMensaje.Text = conector.LastError;
                        return;
                    }

                    if (attr.FileNew) 
                        File.Move(attr.FileExt, Files.GetFilePath(Files.Directorys.Ambulancia, true, idAmbulancia, attr.Tipo + Path.GetExtension(attr.FileExt)));
                }
            }
            conector.Commit();
        }

        ((MasterPageI)Master).SetResultado("Se ha modificado la empresa " + TEmpresa.Text);
    }

    protected void BCancelar_Click(object sender, EventArgs e) {

        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAgregar_Click(object sender, EventArgs e) {

        if (!IsValid)
            return;

        CUsuario usuario= (CUsuario)CUsuario.GetInstance();
        List<Ambulancia> ambulancias = (List<Ambulancia>)ViewState["ambulancias"];
        string id = (string)ViewState["idAmbulancia"];

        Ambulancia info = string.IsNullOrEmpty(id) ? new Ambulancia(ambulancias) : ambulancias.Find(x=>x.Id==id);
        if (string.IsNullOrEmpty(id)) 
            ambulancias.Add(info);

        info.Placa = TPlaca.Text;
        info.Propietario = TPropietario.Text;

        for (int i = 0; i < GAtributos.Rows.Count; i++) {

            string filename = null;
            bool filenew = false;
            FileUpload file = ((FileUpload)GAtributos.Rows[i].FindControl("D"));
            if (file.HasFile)
            {
                filename = Path.Combine(Path.GetTempPath(), "ambulance", usuario.Id);
                Directory.CreateDirectory(filename);
                filename = Path.Combine(filename, DateTime.Now.ToString("yyyyMMddhhmmss_") + file.FileName);
                file.SaveAs(filename);
                filenew = true;
            } else {
                filename = (string)GAtributos.DataKeys[i].Values["FileExt"];
            }


            info.SetAtributo(GAtributos.DataKeys[i].Values["Tipo"].ToString()
                , ((TextBox)GAtributos.Rows[i].FindControl("T")).Text
                , ((TextBox)GAtributos.Rows[i].FindControl("F")).Text
                , filename, filenew);
        }

        ViewState["ambulancias"] = ambulancias;
        GAmbulancias.DataSource = ambulancias.Where(x => !x.Eliminado);
        GAmbulancias.DataBind();

        BCancelA_Click(sender, e);
    }

    protected void GAmbulancias_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Ambulancia> ambulancias = (List<Ambulancia>)ViewState["ambulancias"];

        Ambulancia info = ambulancias.Find(x => x.Id == GAmbulancias.SelectedDataKey.Values["Id"].ToString());

        ViewState["idAmbulancia"] = info.Id;
        TPlaca.Text = info.Placa;
        TPropietario.Text = info.Propietario;

        GAtributos.DataSource = info.Atributos;
        GAtributos.DataBind();

        ScriptManager.RegisterStartupScript(UA, UA.GetType(), "add", "$('#badd').click();", true);
    }

    protected void GAmbulancias_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Ambulancia> ambulancias = (List<Ambulancia>)ViewState["ambulancias"];

        Ambulancia info = ambulancias.Find(x => x.Id == e.Keys["Id"].ToString());
        info.Eliminado = true;
        if (info.Id.StartsWith("-"))
        {
            ambulancias.Remove(info);
            foreach (Ambulancia.Atributo attr in info.Atributos) {
                try { File.Delete(attr.FileExt); } catch { }
            }
        }

        ViewState["ambulancias"] = ambulancias;
        GAmbulancias.DataSource = ambulancias.Where(x => !x.Eliminado);
        GAmbulancias.DataBind();

        e.Cancel = true;
    }

    protected void BCancelA_Click(object sender, EventArgs e)
    {
        ViewState["idAmbulancia"] = null;
        TPlaca.Text = "";
        TPropietario.Text = "";

        Ambulancia info = new Ambulancia();

        GAmbulancias.SelectedIndex = -1;

        GAtributos.DataSource = info.Atributos;
        GAtributos.DataBind();
    }

    public void OnValidaFileJPGPDF(object sender, ServerValidateEventArgs e)
    {
        Files.OnValidaFileJPGPDF(sender, e);
    }
}
