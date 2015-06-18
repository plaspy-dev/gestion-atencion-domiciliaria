using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Collections.Specialized;
using System.Globalization;

public partial class eventos_programacion : System.Web.UI.Page
{
    [Serializable]
    public class Ambulancia {
        public string Codigo { get; set; }
        public string Tipo { get { return IdTipo=="1" ? "TAM" : "TAB"; } }
        public string Empresa { get; set; }
        public string IdTipo { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ambulancias"] = new List<Ambulancia>();
            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            if (Request.QueryString["id"] != null)
            {
                HIdEvento.Value = Request.QueryString["id"];
                GEventos_SelectedIndexChanged(null, null);
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
            Query query = new Query("programacion_evento");

            query["nombre"] = TNombre.Text;
            query["inicio"] = Query.GetMySQLDateFormat(TInicio.Text);
            query["fin"] = Query.GetMySQLDateFormat(TFin.Text);
            query["lugar"] = DLugar.SelectedValue;
            query["programa"] = DPrograma.SelectedValue;
            query["actividad"] = DActividad.SelectedValue;
            query["plan"] = DPlan.SelectedValue;
            query["horai"] = THInicio.Text;
            query["horaf"] = THFinal.Text;
            query["ambulanciasb"] = TAmbulanciasB.Text;
            query["ambulanciasm"] = TAmbulanciasM.Text;
            query["mec"] = TMECBajo.Text;
            query["responsable"] = DResponsable.SelectedValue;
            query["mec_complejo"]= TMECComplejo.Text;
            query["mec_medio"]= TMECMedio.Text;
            query["medicos"] = TMedicos.Text;
            query["auxiliares"] = TAuxiliares.Text;
            query["vmedico"] = TVMedicos.Text.Length==0 ? "" : decimal.Parse(TVMedicos.Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);
            query["vauxiliar"] = TVMedicos.Text.Length == 0 ? "" : decimal.Parse(TVAuxiliar.Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);
            query["vtab"] = TVMedicos.Text.Length == 0 ? "" : decimal.Parse(TVTAB.Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);
            query["vtam"] = TVMedicos.Text.Length == 0 ? "" : decimal.Parse(TVTAM.Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);

            if (HIdEvento.Value.Length == 0)
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HIdEvento.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id='" + HIdEvento.Value + "'")) == -1)
                    return;
            }
            if (conector.InsertModificacion(HIdEvento.Value) == -1)
                return;

            string[] querys = SPersonal.GetQuerys();
            if (querys != null)
            {
                for (int i = 0; i < querys.Length; i++)
                {
                    if (conector.QueryMod(querys[i].Replace("@programacion", HIdEvento.Value)) == -1)
                        return;
                }
            }

            List<Ambulancia> lista = (List<Ambulancia>)ViewState["ambulancias"];

            Query ambulancias = new Query("programacion_evento_ambulancia");

            if(conector.QueryMod(ambulancias.GetDelete("evento=" + Query.GetValor(HIdEvento.Value)))==-1)
                return;

            ambulancias["evento"] = HIdEvento.Value;

            foreach (Ambulancia info in lista) {

                ambulancias["codigo"]= info.Codigo;
                ambulancias["tipo"]= info.IdTipo;
                ambulancias["empresa"] = info.Empresa;

                if (conector.QueryMod(ambulancias.GetInsert()) == -1)
                    return;
            }

            conector.Commit();
        }
        ((MasterPageI)Master).SetResultado("Evento " + TNombre.Text + " editado.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GEventos_SelectedIndexChanged(object sender, EventArgs e)
    {
        BAceptar.Enabled = Usuario.GetUsuario().CanUpdate();
        using (CConector conector = new CConector())
        {
            Query query = new Query("programacion_evento");

            query += "id";
            query += "nombre";
            query += "inicio";
            query += "fin";
            query += "lugar";
            query += "programa";
            query += "actividad";
            query += "plan";
            query += "horai";
            query += "horaf";
            query += "ambulanciasb";
            query += "ambulanciasm";
            query += "mec";
            query += "mec_complejo";
            query += "mec_medio";
            query += "responsable";
            query += "medicos";
            query += "auxiliares";
            query += "vauxiliar";
            query += "vmedico";
            query += "vtab";
            query += "vtam";

            if (GEventos.SelectedDataKey != null && GEventos.SelectedDataKey.Value != null)
                HIdEvento.Value = GEventos.SelectedDataKey.Value.ToString();

            MySqlDataReader reader = conector.Query(query.GetSelect("id='" + HIdEvento.Value + "'"));
            if (reader != null && reader.Read())
            {
                HIdEvento.Value = reader["id"].ToString();
                TNombre.Text = reader["nombre"].ToString();
                TInicio.Text = Query.GetFromMySQLDate(reader["inicio"]);
                TFin.Text = Query.GetFromMySQLDate(reader["fin"]);
                conector.SelectInDropDown(DLugar, reader["lugar"], "SELECT nombre FROM varios WHERE id='" + reader["lugar"].ToString() + "'");
                Utilidades.SelectInDropDown(DPrograma, reader["programa"]);
                Utilidades.SelectInDropDown(DActividad, reader["actividad"]);
                Utilidades.SelectInDropDown(DPlan, reader["plan"]);
                THInicio.Text = reader["horai"].ToString();
                THFinal.Text = reader["horaf"].ToString();
                TAmbulanciasB.Text = reader["ambulanciasb"].ToString();
                TAmbulanciasM.Text = reader["ambulanciasm"].ToString();
                TMECBajo.Text = reader["mec"].ToString();
                TMECComplejo.Text = reader["mec_complejo"].ToString();
                TMECMedio.Text = reader["mec_medio"].ToString();
                DResponsable.SelectedValue = reader["responsable"].ToString();
                TMedicos.Text = reader["medicos"].ToString();
                TAuxiliares.Text= reader["auxiliares"].ToString();
                TVTAM.Text = reader["vtam"]==DBNull.Value ? "" : Convert.ToDecimal(reader["vtam"]).ToString(CultureInfo.InvariantCulture);
                TVTAB.Text = reader["vtab"] == DBNull.Value ? "" : Convert.ToDecimal(reader["vtab"]).ToString(CultureInfo.InvariantCulture);
                TVMedicos.Text = reader["vmedico"] == DBNull.Value ? "" : Convert.ToDecimal(reader["vmedico"]).ToString(CultureInfo.InvariantCulture);
                TVAuxiliar.Text = reader["vauxiliar"] == DBNull.Value ? "" : Convert.ToDecimal(reader["vauxiliar"]).ToString(CultureInfo.InvariantCulture);

                List<Ambulancia> lista = new List<Ambulancia>();

                Query ambulancias = new Query("programacion_evento_ambulancia");

                ambulancias += "tipo";
                ambulancias += "codigo";
                ambulancias += "empresa";

                reader= conector.Query(ambulancias.GetSelect("evento=" + Query.GetValor(HIdEvento.Value)));
                if (reader != null) {
                    while (reader.Read()) {

                        Ambulancia info = new Ambulancia();
                        info.IdTipo= reader["tipo"].ToString();
                        info.Codigo = reader["codigo"].ToString();
                        info.Empresa = reader["empresa"].ToString();
                        lista.Add(info);
                    }
                }

                GAmbulancias.DataSource = lista;
                GAmbulancias.DataBind();
                ViewState["ambulancias"] = lista;

                ((MasterPageI)Master).SetModificacion(HIdEvento.Value);
            }
            else
            {
                HIdEvento.Value = "";
            }
        }
    }

    protected void BMasPersonal_Click(object sender, EventArgs e)
    {
        Validate("personal");
        if (!IsValid)
            return;

        Funcionario info= Funcionario.GetFuncionario(TIdPersonal.Text);

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("idpersonal", TIdPersonal.Text);
        data.Add("personal", info.Nombres);
        data.Add("cargo", info.Cargo);
        data.Add("carId", info.CarId);
        data.Add("chaqueta", TChaqueta.Text);

        if (GPersonal.SelectedIndex == -1)
        {
            SPersonal.GetView().Insert(data, OnDataSourceOperationComplete);
        }
        else
        {
            data.Add("id", GPersonal.DataKeys[GPersonal.SelectedIndex].Value);

            IOrderedDictionary dataold = new OrderedDictionary();
            dataold.Add("personal", HttpUtility.HtmlDecode(GPersonal.SelectedRow.Cells[3].Text).Trim());
            dataold.Add("idpersonal", HttpUtility.HtmlDecode(GPersonal.SelectedRow.Cells[2].Text).Trim());
            dataold.Add("id", GPersonal.DataKeys[GPersonal.SelectedIndex].Value);

            SPersonal.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
        }
        GPersonal.SelectedIndex = -1;
        GPersonal.DataBind();

        TChaqueta.Text= TIdPersonal.Text = TPersonal.Text = "";
        TPersonal.Focus();
    }
    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }
    protected void GPersonal_SelectedIndexChanged(object sender, EventArgs e)
    {
        TPersonal.Text = HttpUtility.HtmlDecode(GPersonal.SelectedRow.Cells[3].Text).Trim();
        TIdPersonal.Text = HttpUtility.HtmlDecode(GPersonal.SelectedRow.Cells[2].Text).Trim();
        TChaqueta.Text = HttpUtility.HtmlDecode(GPersonal.SelectedRow.Cells[4].Text).Trim();
        TPersonal.Focus();
    }
    protected void GEventos_DataBound(object sender, EventArgs e)
    {
        for (int i = 0; i < GEventos.Rows.Count; i++)
        {
            if (GEventos.DataKeys[i].Value.ToString() == HIdEvento.Value)
            {
                GEventos.SelectedIndex = i;
                break;
            }
        }
    }
    protected void BMasAmbulancia_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        List<Ambulancia> lista = (List<Ambulancia>)ViewState["ambulancias"];
        
        Ambulancia item= lista.Find(x => x.Codigo == TCodigo.Text);
        if (item == null)
        {
            item = new Ambulancia();
            lista.Add(item);
        }

        item.Codigo = TCodigo.Text;
        item.IdTipo = DTipo.SelectedValue;
        item.Empresa = TEmpresa.Text;

        TEmpresa.Text = "";
        TCodigo.Text = "";
        DTipo.SelectedValue = "0";

        GAmbulancias.DataSource = lista;
        GAmbulancias.DataBind();
        ViewState["ambulancias"] = lista;
    }

    protected void GAmbulancias_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Ambulancia> lista = (List<Ambulancia>)ViewState["ambulancias"];
        Ambulancia info = lista.Find(x => x.Codigo == GAmbulancias.DataKeys[GAmbulancias.SelectedIndex].Values["Codigo"].ToString());
        if (info == null)
            return;
        
        TCodigo.Text = info.Codigo;
        TEmpresa.Text = info.Empresa;
        DTipo.SelectedValue = info.IdTipo;

        lista.Remove(info);

        GAmbulancias.SelectedIndex = -1;
        GAmbulancias.DataSource = lista;
        GAmbulancias.DataBind();
        ViewState["ambulancias"] = lista;
    }
}
